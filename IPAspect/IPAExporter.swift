//
//  IPAExporter.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//

import Foundation
import AppKit

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
                provisionedDevices: ipa.provisionedDevices
            )
        }
        
        guard let jsonData = try? encoder.encode(exportData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "{}"
        }
        
        return jsonString
    }
    
    /// Export IPA analysis results to CSV format
    static func exportToCSV(ipas: [IPAInfo]) -> String {
        var csv = "File Name,Bundle ID,Team Name,Team ID,Profile Type,Creation Date,Expiration Date,Status,Days Until Expiration,Analyzed Date\n"
        
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
            let analyzedDate = dateFormatter.string(from: ipa.analyzedDate)
            
            csv += "\(fileName),\(bundleId),\(teamName),\(teamId),\(profileType),\(creationDate),\(expirationDate),\(status),\(daysUntilExpiration),\(analyzedDate)\n"
        }
        
        return csv
    }
    
    /// Save export data to file
    static func saveToFile(content: String, suggestedFileName: String) {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = suggestedFileName
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        
        savePanel.begin { response in
            guard response == .OK, let url = savePanel.url else { return }
            
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to save file: \(error)")
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
}
