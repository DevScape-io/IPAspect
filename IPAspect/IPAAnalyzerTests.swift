//
//  IPAAnalyzerTests.swift
//  IPAspectTests
//
//  Created by Parker Howell on 12/30/25.
//

import XCTest
import AppKit
import SwiftData
@testable import IPAspect

final class IPAAnalyzerXCTests: XCTestCase {
    
    func testIPAInfoCreation() async throws {
        let ipa = IPAInfo(fileName: "TestApp.ipa", filePath: "/path/to/test.ipa")
        
        XCTAssertEqual(ipa.fileName, "TestApp.ipa")
        XCTAssertEqual(ipa.filePath, "/path/to/test.ipa")
        XCTAssertFalse(ipa.isExpired)
        XCTAssertNil(ipa.daysUntilExpiration)
    }
    
    func testExpiredProfile() async throws {
        let ipa = IPAInfo(fileName: "ExpiredApp.ipa", filePath: "/path/to/expired.ipa")
        ipa.expirationDate = Date().addingTimeInterval(-86400) // Yesterday
        
        XCTAssertTrue(ipa.isExpired)
        XCTAssertLessThan(ipa.daysUntilExpiration ?? 0, 0)
    }
    
    func testDaysUntilExpiration() async throws {
        let ipa = IPAInfo(fileName: "FutureApp.ipa", filePath: "/path/to/future.ipa")
        ipa.expirationDate = Date().addingTimeInterval(30 * 86400) // 30 days
        
        XCTAssertFalse(ipa.isExpired)
        let days = try XCTUnwrap(ipa.daysUntilExpiration)
        XCTAssertGreaterThanOrEqual(days, 29)
        XCTAssertLessThanOrEqual(days, 30)
    }
    
    func testJSONExport() async throws {
        let ipa1 = IPAInfo(fileName: "App1.ipa", filePath: "/path/to/app1.ipa")
        ipa1.teamName = "Test Team"
        ipa1.appBundleIdentifier = "com.test.app1"
        
        let ipa2 = IPAInfo(fileName: "App2.ipa", filePath: "/path/to/app2.ipa")
        ipa2.teamName = "Test Team 2"
        ipa2.appBundleIdentifier = "com.test.app2"
        
        let json = await IPAExporter.exportToJSON(ipas: [ipa1, ipa2])
        
        XCTAssertTrue(json.contains("App1.ipa"))
        XCTAssertTrue(json.contains("App2.ipa"))
        XCTAssertTrue(json.contains("com.test.app1"))
        XCTAssertTrue(json.contains("com.test.app2"))
        
        // Verify it's valid JSON
        let data = try XCTUnwrap(json.data(using: .utf8))
        _ = try JSONSerialization.jsonObject(with: data)
    }
    
    func testCSVExport() async throws {
        let ipa = IPAInfo(fileName: "TestApp.ipa", filePath: "/path/to/test.ipa")
        ipa.teamName = "Test Team"
        ipa.appBundleIdentifier = "com.test.app"
        ipa.provisioningType = "Development"
        
        let csv = await IPAExporter.exportToCSV(ipas: [ipa])
        
        XCTAssertTrue(csv.contains("File Name"))
        XCTAssertTrue(csv.contains("TestApp.ipa"))
        XCTAssertTrue(csv.contains("Test Team"))
        XCTAssertTrue(csv.contains("com.test.app"))
        XCTAssertTrue(csv.contains("Development"))
        
        // Verify header and at least one data row
        let lines = csv.components(separatedBy: "\n").filter { !$0.isEmpty }
        XCTAssertGreaterThanOrEqual(lines.count, 2)
    }
    
    func testCSVEscaping() async throws {
        let ipa = IPAInfo(fileName: "App,With,Commas.ipa", filePath: "/path/to/test.ipa")
        ipa.teamName = "Team \"Quoted\" Name"
        
        let csv = await IPAExporter.exportToCSV(ipas: [ipa])
        
        XCTAssertTrue(csv.contains("\"App,With,Commas.ipa\""))
        XCTAssertTrue(csv.contains("\"Team \"\"Quoted\"\" Name\""))
    }
}

final class ProvisioningProfileDataXCTests: XCTestCase {
    
    func testEmptyInitialization() async throws {
        let profileData = await ProvisioningProfileData()
        
        // Extract values before assertions to avoid main actor isolation issues
        let expirationDate = await profileData.expirationDate
        let teamName = await profileData.teamName
        let provisioningType = await profileData.provisioningType
        
        XCTAssertNil(expirationDate)
        XCTAssertNil(teamName)
        XCTAssertNil(provisioningType)
    }
}
