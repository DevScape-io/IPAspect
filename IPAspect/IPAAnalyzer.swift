//
//  IPAAnalyzer.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//

import Foundation

enum IPAAnalyzerError: LocalizedError {
    case invalidIPA
    case provisioningProfileNotFound
    case unzipFailed
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidIPA:
            return "The selected file is not a valid IPA file."
        case .provisioningProfileNotFound:
            return "No provisioning profile found in the IPA."
        case .unzipFailed:
            return "Failed to extract IPA contents."
        case .parsingFailed:
            return "Failed to parse provisioning profile data."
        }
    }
}

actor IPAAnalyzer {
    
    func analyzeIPA(at url: URL) async throws -> IPAInfo {
        // Create temporary directory
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        // Extract IPA (it's a ZIP file)
        try await extractIPA(from: url, to: tempDir)
        
        // Find provisioning profile
        let provisioningProfile = try findProvisioningProfile(in: tempDir)
        
        // Parse provisioning profile
        let profileData = try parseProvisioningProfile(at: provisioningProfile)
        
        // Extract app icon
        let iconData = try? extractAppIcon(from: tempDir)
        
        // Create IPAInfo on the main actor since it's a SwiftData model
        let fileName = url.lastPathComponent
        let filePath = url.path
        
        return await MainActor.run {
            let ipaInfo = IPAInfo(fileName: fileName, filePath: filePath)
            
            // Update IPAInfo with parsed data
            ipaInfo.expirationDate = profileData.expirationDate
            ipaInfo.creationDate = profileData.creationDate
            ipaInfo.teamName = profileData.teamName
            ipaInfo.teamIdentifier = profileData.teamIdentifier
            ipaInfo.appBundleIdentifier = profileData.appBundleIdentifier
            ipaInfo.provisionedDevices = profileData.provisionedDevices
            ipaInfo.provisioningType = profileData.provisioningType
            ipaInfo.appIconData = iconData
            
            return ipaInfo
        }
    }
    
    private func extractIPA(from url: URL, to destination: URL) async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-q", url.path, "-d", destination.path]
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            throw IPAAnalyzerError.unzipFailed
        }
    }
    
    private func findProvisioningProfile(in directory: URL) throws -> URL {
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)
        
        while let file = enumerator?.nextObject() as? URL {
            if file.pathExtension == "mobileprovision" {
                return file
            }
        }
        
        throw IPAAnalyzerError.provisioningProfileNotFound
    }
    
    private func parseProvisioningProfile(at url: URL) throws -> ProvisioningProfileData {
        // Read the provisioning profile file
        let data = try Data(contentsOf: url)
        
        // Extract the plist from the provisioning profile
        // The mobileprovision file contains a CMS signature wrapper around a plist
        let plistData = try extractPlistFromProvisioningProfile(data: data)
        
        // Parse the plist
        guard let plist = try PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any] else {
            throw IPAAnalyzerError.parsingFailed
        }
        
        var profileData = ProvisioningProfileData()
        
        profileData.expirationDate = plist["ExpirationDate"] as? Date
        profileData.creationDate = plist["CreationDate"] as? Date
        profileData.teamName = plist["TeamName"] as? String
        
        if let teamIdentifiers = plist["TeamIdentifier"] as? [String], let first = teamIdentifiers.first {
            profileData.teamIdentifier = first
        }
        
        if let entitlements = plist["Entitlements"] as? [String: Any],
           let bundleId = entitlements["application-identifier"] as? String {
            // Remove team identifier prefix (e.g., "ABC123.com.example.app" -> "com.example.app")
            let components = bundleId.components(separatedBy: ".")
            if components.count > 1 {
                profileData.appBundleIdentifier = components.dropFirst().joined(separator: ".")
            } else {
                profileData.appBundleIdentifier = bundleId
            }
        }
        
        profileData.provisionedDevices = plist["ProvisionedDevices"] as? [String]
        
        // Determine provisioning type
        if let getTaskAllow = (plist["Entitlements"] as? [String: Any])?["get-task-allow"] as? Bool, getTaskAllow {
            profileData.provisioningType = "Development"
        } else if profileData.provisionedDevices != nil {
            profileData.provisioningType = "Ad Hoc"
        } else if let provisionedDevices = plist["ProvisionedDevices"] as? [String], provisionedDevices.isEmpty {
            profileData.provisioningType = "App Store"
        } else {
            profileData.provisioningType = "Enterprise"
        }
        
        return profileData
    }
    
    private func extractPlistFromProvisioningProfile(data: Data) throws -> Data {
        // The plist is embedded between specific markers in the provisioning profile
        // mobileprovision files contain binary CMS data, so we need to search for the XML markers in the raw data
        
        guard let startMarker = "<?xml".data(using: .utf8),
              let endMarker = "</plist>".data(using: .utf8) else {
            throw IPAAnalyzerError.parsingFailed
        }
        
        // Find the start position of the XML plist
        guard let startRange = data.range(of: startMarker) else {
            throw IPAAnalyzerError.parsingFailed
        }
        
        // Find the end position of the XML plist, searching from the start position
        guard let endRange = data.range(of: endMarker, in: startRange.lowerBound..<data.endIndex) else {
            throw IPAAnalyzerError.parsingFailed
        }
        
        // Extract the plist data including the end marker
        let plistData = data[startRange.lowerBound..<endRange.upperBound]
        
        return plistData
    }
    
    private func extractAppIcon(from directory: URL) throws -> Data? {
        // Find the .app bundle
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: [.isDirectoryKey])
        var appBundleURL: URL?
        
        while let file = enumerator?.nextObject() as? URL {
            if file.pathExtension == "app" {
                appBundleURL = file
                break
            }
        }
        
        guard let appBundle = appBundleURL else {
            return nil
        }
        
        // Try to find the app icon
        // Look for common icon file names and patterns
        let iconPatterns = [
            "AppIcon60x60@2x.png",
            "AppIcon60x60@3x.png",
            "AppIcon76x76@2x~ipad.png",
            "AppIcon83.5x83.5@2x~ipad.png",
            "Icon-60@2x.png",
            "Icon-60@3x.png",
            "Icon@2x.png",
            "Icon.png"
        ]
        
        // First, try to find the icon from Info.plist
        let infoPlistURL = appBundle.appendingPathComponent("Info.plist")
        if let infoPlistData = try? Data(contentsOf: infoPlistURL),
           let plist = try? PropertyListSerialization.propertyList(from: infoPlistData, format: nil) as? [String: Any] {
            
            // Check CFBundleIconFiles or CFBundleIcons
            if let iconFiles = plist["CFBundleIconFiles"] as? [String], let iconName = iconFiles.first {
                let iconURL = appBundle.appendingPathComponent(iconName)
                if let iconData = try? Data(contentsOf: iconURL) {
                    return iconData
                }
                // Try with .png extension
                let iconURLWithExt = appBundle.appendingPathComponent("\(iconName).png")
                if let iconData = try? Data(contentsOf: iconURLWithExt) {
                    return iconData
                }
            }
            
            // Check CFBundleIcons dictionary for iOS
            if let icons = plist["CFBundleIcons"] as? [String: Any],
               let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
               let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String] {
                // Use the last icon file (usually the largest)
                for iconName in iconFiles.reversed() {
                    for scale in ["@3x", "@2x", ""] {
                        let fileName = "\(iconName)\(scale).png"
                        let iconURL = appBundle.appendingPathComponent(fileName)
                        if let iconData = try? Data(contentsOf: iconURL) {
                            return iconData
                        }
                    }
                }
            }
        }
        
        // Fallback: search for common icon patterns
        for pattern in iconPatterns {
            let iconURL = appBundle.appendingPathComponent(pattern)
            if let iconData = try? Data(contentsOf: iconURL) {
                return iconData
            }
        }
        
        // Last resort: find any PNG file with "Icon" or "AppIcon" in the name
        if let iconEnumerator = FileManager.default.enumerator(at: appBundle, includingPropertiesForKeys: nil) {
            while let file = iconEnumerator.nextObject() as? URL {
                let fileName = file.lastPathComponent.lowercased()
                if file.pathExtension == "png" && (fileName.contains("icon") || fileName.contains("appicon")) {
                    if let iconData = try? Data(contentsOf: file) {
                        return iconData
                    }
                }
            }
        }
        
        return nil
    }
}

struct ProvisioningProfileData: Sendable {
    var expirationDate: Date?
    var creationDate: Date?
    var teamName: String?
    var teamIdentifier: String?
    var appBundleIdentifier: String?
    var provisionedDevices: [String]?
    var provisioningType: String?
}
