//
//
//  IPAExporter.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//
//  Copyright 2026 DevScape.io LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

struct IPAExporter {
    
    /// Export IPA analysis results to JSON format
    static func exportToJSON(ipas: [IPAInfo]) -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let exportData = ipas.map { ipa in
            ExportedIPA(
                fileName: ipa.fileName,
                filePath: ipa.filePath,
                analyzedDate: ipa.analyzedDate,
                expirationDate: ipa.expirationDate,
                creationDate: ipa.creationDate,
                teamName: ipa.teamName,
                teamIdentifier: ipa.teamIdentifier,
                appBundleIdentifier: ipa.appBundleIdentifier,
                provisioningType: ipa.provisioningType,
                isExpired: ipa.isExpired,
                daysUntilExpiration: ipa.daysUntilExpiration,
                provisionedDevicesCount: ipa.provisionedDevices?.count ?? 0,
                provisionedDevices: ipa.provisionedDevices,
                hasAppIcon: ipa.appIconData != nil
            )
        }
        
        guard let jsonData = try? encoder.encode(exportData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "[]"
        }
        
        return jsonString
    }
    
    /// Export IPA analysis results to CSV format
    static func exportToCSV(ipas: [IPAInfo]) -> String {
        var csv = "File Name,Bundle ID,Team Name,Team ID,Profile Type,Creation Date,Expiration Date,Status,Days Until Expiration,Has App Icon,Analyzed Date\n"
        
        let dateFormatter = ISO8601DateFormatter()
        
        for ipa in ipas {
            let fileName = escapeCSV(ipa.fileName)
            let bundleId = escapeCSV(ipa.appBundleIdentifier ?? "N/A")
            let teamName = escapeCSV(ipa.teamName ?? "N/A")
            let teamId = escapeCSV(ipa.teamIdentifier ?? "N/A")
            let profileType = escapeCSV(ipa.provisioningType ?? "N/A")
            let creationDate = ipa.creationDate.map { dateFormatter.string(from: $0) } ?? "N/A"
            let expirationDate = ipa.expirationDate.map { dateFormatter.string(from: $0) } ?? "N/A"
            let status = ipa.isExpired ? "Expired" : "Valid"
            let daysUntilExpiration = ipa.daysUntilExpiration.map { String($0) } ?? "N/A"
            let hasAppIcon = ipa.appIconData != nil ? "Yes" : "No"
            let analyzedDate = dateFormatter.string(from: ipa.analyzedDate)
            
            csv += "\(fileName),\(bundleId),\(teamName),\(teamId),\(profileType),\(creationDate),\(expirationDate),\(status),\(daysUntilExpiration),\(hasAppIcon),\(analyzedDate)\n"
        }
        
        return csv
    }
    
    /// Save export data to file
    static func saveToFile(content: String, suggestedFileName: String) {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = suggestedFileName
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.showsTagField = true
        
        // Set allowed file types based on extension
        let fileExtension = (suggestedFileName as NSString).pathExtension
        if !fileExtension.isEmpty {
            savePanel.allowedContentTypes = [.init(filenameExtension: fileExtension)].compactMap { $0 }
        }
        
        savePanel.begin { response in
            guard response == .OK, let url = savePanel.url else { return }
            
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
                
                // Show success notification in Notification Center
                let notification = NSUserNotification()
                notification.title = "Export Successful"
                notification.informativeText = "File saved to \(url.lastPathComponent)"
                notification.soundName = NSUserNotificationDefaultSoundName
                NSUserNotificationCenter.default.deliver(notification)
            } catch {
                // Show error alert
                let alert = NSAlert()
                alert.messageText = "Export Failed"
                alert.informativeText = "Failed to save file: \(error.localizedDescription)"
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }
    
    private static func escapeCSV(_ string: String) -> String {
        if string.contains(",") || string.contains("\"") || string.contains("\n") {
            return "\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return string
    }
}

// MARK: - Export Models

struct ExportedIPA: Codable {
    let fileName: String
    let filePath: String
    let analyzedDate: Date
    let expirationDate: Date?
    let creationDate: Date?
    let teamName: String?
    let teamIdentifier: String?
    let appBundleIdentifier: String?
    let provisioningType: String?
    let isExpired: Bool
    let daysUntilExpiration: Int?
    let provisionedDevicesCount: Int
    let provisionedDevices: [String]?
    let hasAppIcon: Bool
}
