//
//  IPAspectTests.swift
//  IPAspectTests
//
//  Created by Parker Howell on 12/30/25.
//

import Testing
import Foundation
@testable import IPAspect

@Suite("IPA Analyzer Tests")
struct IPAAnalyzerTests {
    
    @Test("IPA Info model creates correctly")
    func testIPAInfoCreation() async throws {
        let ipa = IPAInfo(fileName: "TestApp.ipa", filePath: "/path/to/test.ipa")
        
        #expect(ipa.fileName == "TestApp.ipa")
        #expect(ipa.filePath == "/path/to/test.ipa")
        #expect(ipa.isExpired == false)
        #expect(ipa.daysUntilExpiration == nil)
    }
    
    @Test("IPA Info correctly identifies expired profiles")
    func testExpiredProfile() async throws {
        let ipa = IPAInfo(fileName: "ExpiredApp.ipa", filePath: "/path/to/expired.ipa")
        ipa.expirationDate = Date().addingTimeInterval(-86400) // Yesterday
        
        #expect(ipa.isExpired == true)
        #expect(ipa.daysUntilExpiration ?? 0 < 0)
    }
    
    @Test("IPA Info correctly calculates days until expiration")
    func testDaysUntilExpiration() async throws {
        let ipa = IPAInfo(fileName: "FutureApp.ipa", filePath: "/path/to/future.ipa")
        ipa.expirationDate = Date().addingTimeInterval(30 * 86400) // 30 days
        
        #expect(ipa.isExpired == false)
        let days = try #require(ipa.daysUntilExpiration)
        #expect(days >= 29 && days <= 30) // Allow for slight timing differences
    }
    
    @Test("Export to JSON produces valid output")
    func testJSONExport() async throws {
        let ipa1 = IPAInfo(fileName: "App1.ipa", filePath: "/path/to/app1.ipa")
        ipa1.teamName = "Test Team"
        ipa1.appBundleIdentifier = "com.test.app1"
        
        let ipa2 = IPAInfo(fileName: "App2.ipa", filePath: "/path/to/app2.ipa")
        ipa2.teamName = "Test Team 2"
        ipa2.appBundleIdentifier = "com.test.app2"
        
        let json = IPAExporter.exportToJSON(ipas: [ipa1, ipa2])
        
        #expect(json.contains("App1.ipa"))
        #expect(json.contains("App2.ipa"))
        #expect(json.contains("com.test.app1"))
        #expect(json.contains("com.test.app2"))
        
        // Verify it's valid JSON
        let data = try #require(json.data(using: .utf8))
        _ = try JSONSerialization.jsonObject(with: data)
    }
    
    @Test("Export to CSV produces valid output")
    func testCSVExport() async throws {
        let ipa = IPAInfo(fileName: "TestApp.ipa", filePath: "/path/to/test.ipa")
        ipa.teamName = "Test Team"
        ipa.appBundleIdentifier = "com.test.app"
        ipa.provisioningType = "Development"
        
        let csv = IPAExporter.exportToCSV(ipas: [ipa])
        
        #expect(csv.contains("File Name"))
        #expect(csv.contains("TestApp.ipa"))
        #expect(csv.contains("Test Team"))
        #expect(csv.contains("com.test.app"))
        #expect(csv.contains("Development"))
        
        // Verify header and at least one data row
        let lines = csv.components(separatedBy: "\n").filter { !$0.isEmpty }
        #expect(lines.count >= 2)
    }
    
    @Test("CSV escaping handles special characters")
    func testCSVEscaping() async throws {
        let ipa = IPAInfo(fileName: "App,With,Commas.ipa", filePath: "/path/to/test.ipa")
        ipa.teamName = "Team \"Quoted\" Name"
        
        let csv = IPAExporter.exportToCSV(ipas: [ipa])
        
        #expect(csv.contains("\"App,With,Commas.ipa\""))
        #expect(csv.contains("\"Team \"\"Quoted\"\" Name\""))
    }
}

@Suite("Provisioning Profile Data Tests")
struct ProvisioningProfileDataTests {
    
    @Test("Provisioning profile data initializes empty")
    func testEmptyInitialization() async throws {
        let profileData = ProvisioningProfileData()
        
        #expect(profileData.expirationDate == nil)
        #expect(profileData.teamName == nil)
        #expect(profileData.provisioningType == nil)
    }
}
