//
//  IPAInfo.swift
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
