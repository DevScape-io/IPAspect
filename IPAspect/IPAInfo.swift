//
//  IPAInfo.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//

import Foundation
import SwiftData

@Model
final class IPAInfo {
    var fileName: String
    var filePath: String
    var analyzedDate: Date
    
    var expirationDate: Date?
    var creationDate: Date?
    var teamName: String?
    var teamIdentifier: String?
    var appBundleIdentifier: String?
    var provisionedDevices: [String]?
    var provisioningType: String?
    var appIconData: Data?
    
    var isExpired: Bool {
        guard let expiration = expirationDate else { return false }
        return expiration < Date()
    }
    
    var daysUntilExpiration: Int? {
        guard let expiration = expirationDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: expiration).day
    }
    
    init(fileName: String, filePath: String, analyzedDate: Date = Date()) {
        self.fileName = fileName
        self.filePath = filePath
        self.analyzedDate = analyzedDate
    }
}
