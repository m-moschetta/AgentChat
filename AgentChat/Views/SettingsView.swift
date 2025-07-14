//
//  SettingsView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var configuration = LocalAssistantConfiguration.shared
    @State private var showingAPIKeyConfig = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("API Configuration") {
                    Button("Manage API Keys") {
                        showingAPIKeyConfig = true
                    }
                }
                
                Section("Providers") {
                    ForEach(AgentType.allCases, id: \.self) { agentType in
                        HStack {
                            Text(agentType.displayName)
                            Spacer()
                            Toggle("", isOn: binding(for: agentType))
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAPIKeyConfig) {
            APIKeyConfigView()
        }
    }
    
    private func binding(for agentType: AgentType) -> Binding<Bool> {
        Binding(
            get: { configuration.isProviderEnabled(agentType) },
            set: { configuration.setProviderEnabled(agentType, enabled: $0) }
        )
    }
}

#Preview {
    SettingsView()
}