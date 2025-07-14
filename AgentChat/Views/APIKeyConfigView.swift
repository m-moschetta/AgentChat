//
//  APIKeyConfigView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct APIKeyConfigView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var apiKeys: [String: String] = [:]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private let providers = ["openai", "anthropic", "mistral", "perplexity", "n8n"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Keys"), footer: Text("API keys are stored securely in the Keychain")) {
                    ForEach(providers, id: \.self) { provider in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(provider.capitalized)
                                .font(.headline)
                            
                            SecureField("Enter API key", text: binding(for: provider))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if hasStoredKey(for: provider) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("API key saved")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Button("Remove") {
                                        removeKey(for: provider)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("API Keys")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAPIKeys()
                    }
                }
            }
        }
        .onAppear {
            loadAPIKeys()
        }
        .alert("API Keys", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func binding(for provider: String) -> Binding<String> {
        Binding(
            get: { apiKeys[provider] ?? "" },
            set: { apiKeys[provider] = $0 }
        )
    }
    
    private func hasStoredKey(for provider: String) -> Bool {
        do {
            return try KeychainService.shared.getAPIKey(for: provider) != nil
        } catch {
            return false
        }
    }
    
    private func loadAPIKeys() {
        for provider in providers {
            do {
                if let key = try KeychainService.shared.getAPIKey(for: provider) {
                    apiKeys[provider] = key
                }
            } catch {
                // Key not found or error loading
            }
        }
    }
    
    private func saveAPIKeys() {
        var savedCount = 0
        var errorCount = 0
        
        for (provider, key) in apiKeys {
            if !key.isEmpty {
                do {
                    try KeychainService.shared.saveAPIKey(key, for: provider)
                    savedCount += 1
                } catch {
                    errorCount += 1
                }
            }
        }
        
        if errorCount > 0 {
            alertMessage = "Failed to save \(errorCount) API key(s)"
        } else if savedCount > 0 {
            alertMessage = "Successfully saved \(savedCount) API key(s)"
        } else {
            alertMessage = "No changes to save"
        }
        
        showingAlert = true
        
        if errorCount == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        }
    }
    
    private func removeKey(for provider: String) {
        do {
            try KeychainService.shared.deleteAPIKey(for: provider)
            apiKeys[provider] = ""
            alertMessage = "API key for \(provider) removed"
            showingAlert = true
        } catch {
            alertMessage = "Failed to remove API key for \(provider)"
            showingAlert = true
        }
    }
}

#Preview {
    APIKeyConfigView()
}