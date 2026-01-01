//
//
//  ContentView.swift
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
import UniformTypeIdentifiers
import AppKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \IPAInfo.analyzedDate, order: .reverse) private var analyzedIPAs: [IPAInfo]
    
    @Binding var fileURLToOpen: URL?
    
    @State private var selectedIPA: IPAInfo?
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    private let analyzer = IPAAnalyzer()
    
    var body: some View {
        NavigationSplitView {
            sidebarContent
        } detail: {
            detailContent
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: fileURLToOpen) { oldValue, newValue in
            if let url = newValue {
                analyzeIPA(at: url)
                fileURLToOpen = nil // Reset after handling
            }
        }
    }
    
    private var sidebarContent: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "doc.badge.gearshape")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue.gradient)
                    .padding(.top, 24)
                
                Text("IPAspect")
                    .font(.title2.bold())
                
                Text("Analyze IPA provisioning profiles")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .dropDestination(for: URL.self) { urls, _ in
                if let url = urls.first,
                   url.pathExtension.lowercased() == "ipa" {
                    analyzeIPA(at: url)
                    return true
                }
                return false
            }
            
            Divider()
            
            // List of analyzed IPAs
            if analyzedIPAs.isEmpty {
                emptyStateView
            } else {
                List(selection: $selectedIPA) {
                    ForEach(analyzedIPAs) { ipa in
                        IPAListRow(ipa: ipa)
                            .tag(ipa)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteIPA(ipa)
                                    }
                                } label: {
                                    VStack {
                                        Spacer()
                                        Image(systemName: "trash.fill")
                                            .font(.title2)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .contentShape(Rectangle())
                                }
                                .tint(.red)
                            }
                            .contextMenu {
                                Button {
                                    selectedIPA = ipa
                                } label: {
                                    Label("View Details", systemImage: "doc.text.magnifyingglass")
                                }
                                
                                Button {
                                    showInFinder(ipa)
                                } label: {
                                    Label("Show in Finder", systemImage: "folder")
                                }
                                
                                Button {
                                    exportMessage(for: ipa)
                                } label: {
                                    Label("Export Message", systemImage: "doc.on.clipboard")
                                }
                                
                                Divider()
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteIPA(ipa)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete(perform: deleteIPAs)
                }
                .listStyle(.sidebar)
                .safeAreaPadding(.top, 12)
            }
        }
        .navigationSplitViewColumnWidth(min: 280, ideal: 320)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: selectIPA) {
                    Label("Analyze IPA", systemImage: "plus.circle.fill")
                }
                .disabled(isAnalyzing)
                .keyboardShortcut("o", modifiers: .command)
            }
            
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button("Export as JSON...") {
                        exportAsJSON()
                    }
                    .disabled(analyzedIPAs.isEmpty)
                    
                    Button("Export as CSV...") {
                        exportAsCSV()
                    }
                    .disabled(analyzedIPAs.isEmpty)
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .disabled(analyzedIPAs.isEmpty)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No IPAs Analyzed")
                .font(.title3.bold())
            
            Text("Click the + button to analyze your first IPA file")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var detailContent: some View {
        if isAnalyzing {
            VStack(spacing: 16) {
                ProgressView()
                    .controlSize(.large)
                Text("Analyzing IPA...")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let selectedIPA {
            IPADetailView(ipa: selectedIPA)
        } else {
            VStack(spacing: 16) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 64))
                    .foregroundStyle(.tertiary)
                
                Text("Select an IPA to view details")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Button("Analyze IPA") {
                    selectIPA()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func selectIPA() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "ipa")].compactMap { $0 }
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.message = "Select an IPA file to analyze"
        
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            analyzeIPA(at: url)
        }
    }
    
    private func analyzeIPA(at url: URL) {
        isAnalyzing = true
        
        Task {
            do {
                let ipaInfo = try await analyzer.analyzeIPA(at: url)
                
                await MainActor.run {
                    modelContext.insert(ipaInfo)
                    selectedIPA = ipaInfo
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isAnalyzing = false
                }
            }
        }
    }
    
    private func deleteIPAs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(analyzedIPAs[index])
            }
        }
    }
    
    private func deleteIPA(_ ipa: IPAInfo) {
        modelContext.delete(ipa)
        if selectedIPA?.id == ipa.id {
            selectedIPA = nil
        }
    }
    
    private func showInFinder(_ ipa: IPAInfo) {
        let url = URL(fileURLWithPath: ipa.filePath)
        
        // Check if the file exists
        if FileManager.default.fileExists(atPath: ipa.filePath) {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        } else {
            errorMessage = "The IPA file could not be found at: \(ipa.filePath)"
            showError = true
        }
    }
    
    private func exportMessage(for ipa: IPAInfo) {
        let appName = ipa.fileName.replacingOccurrences(of: ".ipa", with: "")
        let bundleID = ipa.appBundleIdentifier ?? "Unknown Bundle ID"
        
        var expirationText: String
        if let expirationDate = ipa.expirationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            expirationText = formatter.string(from: expirationDate)
            
            if ipa.isExpired {
                expirationText += " (Expired)"
            } else if let days = ipa.daysUntilExpiration {
                expirationText += " (\(days) days remaining)"
            }
        } else {
            expirationText = "No expiration date"
        }
        
        let message = """
        App: \(appName)
        Bundle ID: \(bundleID)
        Expiration: \(expirationText)
        """
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message, forType: .string)
    }
    
    private func exportAsJSON() {
        let json = IPAExporter.exportToJSON(ipas: analyzedIPAs)
        let fileName = "ipa-analysis-\(Date().formatted(date: .numeric, time: .omitted)).json"
        IPAExporter.saveToFile(content: json, suggestedFileName: fileName)
    }
    
    private func exportAsCSV() {
        let csv = IPAExporter.exportToCSV(ipas: analyzedIPAs)
        let fileName = "ipa-analysis-\(Date().formatted(date: .numeric, time: .omitted)).csv"
        IPAExporter.saveToFile(content: csv, suggestedFileName: fileName)
    }
}

struct IPAListRow: View {
    let ipa: IPAInfo
    
    var body: some View {
        HStack(spacing: 12) {
            // App Icon
            if let iconData = ipa.appIconData, let nsImage = NSImage(data: iconData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                    )
            } else {
                Image(systemName: "doc.badge.gearshape")
                    .font(.system(size: 32))
                    .foregroundStyle(statusColor.gradient)
                    .frame(width: 48, height: 48)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(ipa.fileName)
                    .font(.headline)
                    .lineLimit(1)
                
                if let expirationDate = ipa.expirationDate {
                    HStack(spacing: 4) {
                        Image(systemName: statusIcon)
                            .font(.caption2)
                        
                        Text(statusText)
                            .font(.caption)
                    }
                    .foregroundStyle(statusColor)
                }
                
                Text(ipa.analyzedDate, format: .relative(presentation: .named))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var statusIcon: String {
        if ipa.isExpired {
            return "exclamationmark.triangle.fill"
        } else if let days = ipa.daysUntilExpiration, days < 30 {
            return "clock.badge.exclamationmark"
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
    
    private var statusText: String {
        if ipa.isExpired {
            return "Expired"
        } else if let days = ipa.daysUntilExpiration {
            return "Expires in \(days) days"
        } else {
            return "No expiration"
        }
    }
}

#Preview {
    ContentView(fileURLToOpen: .constant(nil))
        .modelContainer(for: IPAInfo.self, inMemory: true)
}
