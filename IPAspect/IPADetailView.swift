//
//
//  IPADetailView.swift
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

import SwiftUI
import SwiftData
import AppKit

struct IPADetailView: View {
    let ipa: IPAInfo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                headerSection
                
                Divider()
                
                // Expiration Status
                expirationSection
                
                Divider()
                
                // Provisioning Details
                detailsSection
                
                if let devices = ipa.provisionedDevices, !devices.isEmpty {
                    Divider()
                    devicesSection(devices: devices)
                }
                
                Spacer(minLength: 24)
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .textBackgroundColor))
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Display app icon if available, otherwise show SF Symbol
                if let iconData = ipa.appIconData,
                   let nsImage = NSImage(data: iconData) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                } else {
                    Image(systemName: "doc.badge.gearshape")
                        .font(.system(size: 44))
                        .foregroundStyle(.blue.gradient)
                        .frame(width: 64, height: 64)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(ipa.fileName)
                        .font(.title.bold())
                    
                    Text("Analyzed \(ipa.analyzedDate, format: .dateTime)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var expirationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Provisioning Profile Status", systemImage: "checkmark.seal.fill")
                .font(.headline)
            
            if let expirationDate = ipa.expirationDate {
                VStack(spacing: 12) {
                    // Status Card
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: statusIcon)
                                Text(statusTitle)
                                    .font(.title3.bold())
                            }
                            .foregroundStyle(statusColor)
                            
                            if let days = ipa.daysUntilExpiration {
                                if days >= 0 {
                                    Text("\(days) days remaining")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("Expired \(abs(days)) days ago")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Expires")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(expirationDate, format: .dateTime)
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(statusColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(statusColor.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Progress bar
                    if let _ = ipa.creationDate, !ipa.isExpired {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Profile Lifetime")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text("\(Int(progress * 100))% elapsed")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            ProgressView(value: progress)
                                .tint(statusColor)
                        }
                    }
                }
            } else {
                Text("No expiration date found")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Profile Information", systemImage: "info.circle.fill")
                .font(.headline)
            
            VStack(spacing: 12) {
                if let teamName = ipa.teamName {
                    InfoRow(label: "Team Name", value: teamName, icon: "person.2.fill")
                }
                
                if let teamIdentifier = ipa.teamIdentifier {
                    InfoRow(label: "Team ID", value: teamIdentifier, icon: "number")
                }
                
                if let bundleId = ipa.appBundleIdentifier {
                    InfoRow(label: "Bundle ID", value: bundleId, icon: "app.badge")
                }
                
                if let provisioningType = ipa.provisioningType {
                    InfoRow(label: "Profile Type", value: provisioningType, icon: "doc.badge.gearshape")
                }
                
                if let creationDate = ipa.creationDate {
                    InfoRow(
                        label: "Created",
                        value: creationDate.formatted(date: .long, time: .shortened),
                        icon: "calendar.badge.plus"
                    )
                }
            }
        }
    }
    
    private func devicesSection(devices: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Provisioned Devices", systemImage: "iphone.badge.waveform")
                .font(.headline)
            
            Text("\(devices.count) device\(devices.count == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                ForEach(devices.prefix(10), id: \.self) { device in
                    HStack {
                        Image(systemName: "iphone")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        
                        Text(device)
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                        
                        Spacer()
                        
                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(device, forType: .string)
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.borderless)
                        .help("Copy device ID")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 6))
                }
                
                if devices.count > 10 {
                    Text("and \(devices.count - 10) more...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var statusIcon: String {
        if ipa.isExpired {
            return "xmark.circle.fill"
        } else if let days = ipa.daysUntilExpiration, days < 30 {
            return "exclamationmark.triangle.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        if ipa.isExpired {
            return .red
        } else if let days = ipa.daysUntilExpiration, days < 30 {
            return .orange
        } else {
            return .green
        }
    }
    
    private var statusTitle: String {
        if ipa.isExpired {
            return "Expired"
        } else if let days = ipa.daysUntilExpiration, days < 30 {
            return "Expiring Soon"
        } else {
            return "Valid"
        }
    }
    
    private var progress: Double {
        guard let expiration = ipa.expirationDate else {
            return 0
        }
        
        let now = Date()
        
        // If already expired, show 100%
        if now >= expiration {
            return 1.0
        }
        
        // Use a standard 365-day (1 year) reference period for all profiles
        // This ensures profiles with the same expiration date show the same progress
        let standardLifetime: TimeInterval = 365 * 24 * 60 * 60 // 1 year in seconds
        let timeRemaining = expiration.timeIntervalSince(now)
        let timeConsumed = standardLifetime - timeRemaining
        
        return min(max(timeConsumed / standardLifetime, 0), 1)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
                    .textSelection(.enabled)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    let sampleIPA = IPAInfo(fileName: "MyApp.ipa", filePath: "/path/to/app.ipa")
    sampleIPA.expirationDate = Date().addingTimeInterval(30 * 24 * 60 * 60) // 30 days
    sampleIPA.creationDate = Date().addingTimeInterval(-335 * 24 * 60 * 60) // 335 days ago
    sampleIPA.teamName = "Acme Corporation"
    sampleIPA.teamIdentifier = "ABC1234567"
    sampleIPA.appBundleIdentifier = "com.acme.myapp"
    sampleIPA.provisioningType = "Ad Hoc"
    sampleIPA.provisionedDevices = [
        "00008030-001234567890001E",
        "00008030-001234567890002E",
        "00008030-001234567890003E"
    ]
    
    return IPADetailView(ipa: sampleIPA)
        .frame(width: 600, height: 800)
}
