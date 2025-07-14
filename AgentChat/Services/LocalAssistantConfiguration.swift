//
//  LocalAssistantConfiguration.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class LocalAssistantConfiguration: ObservableObject {
    static let shared = LocalAssistantConfiguration()
    
    @Published var providers: [AssistantProvider] = []
    @Published var enabledProviders: Set<String> = []
    
    private init() {
        loadConfiguration()
    }
    
    func isProviderEnabled(_ agentType: AgentType) -> Bool {
        return enabledProviders.contains(agentType.rawValue)
    }
    
    func setProviderEnabled(_ agentType: AgentType, enabled: Bool) {
        if enabled {
            enabledProviders.insert(agentType.rawValue)
        } else {
            enabledProviders.remove(agentType.rawValue)
        }
        saveConfiguration()
    }
    
    func getProvider(for agentType: AgentType) -> AssistantProvider? {
        return providers.first { $0.type == agentType }
    }
    
    private func loadConfiguration() {
        // Load enabled providers
        if let data = UserDefaults.standard.data(forKey: "EnabledProviders"),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            enabledProviders = decoded
        } else {
            // Default enabled providers
            enabledProviders = Set(["openai", "anthropic"])
        }
        
        // Initialize default providers
        providers = [
            AssistantProvider(
                type: .openai,
                name: "OpenAI",
                baseURL: "https://api.openai.com/v1",
                models: ["gpt-4", "gpt-3.5-turbo", "gpt-4-turbo"]
            ),
            AssistantProvider(
                type: .anthropic,
                name: "Anthropic",
                baseURL: "https://api.anthropic.com/v1",
                models: ["claude-3-opus-20240229", "claude-3-sonnet-20240229", "claude-3-haiku-20240307"]
            ),
            AssistantProvider(
                type: .mistral,
                name: "Mistral",
                baseURL: "https://api.mistral.ai/v1",
                models: ["mistral-large-latest", "mistral-medium-latest", "mistral-small-latest"]
            ),
            AssistantProvider(
                type: .perplexity,
                name: "Perplexity",
                baseURL: "https://api.perplexity.ai",
                models: ["llama-3.1-sonar-large-128k-online", "llama-3.1-sonar-small-128k-online"]
            ),
            AssistantProvider(
                type: .n8n,
                name: "N8N",
                baseURL: "custom",
                models: N8NWorkflowManager.shared.workflows.map { $0.id }
            )
        ]
    }
    
    private func saveConfiguration() {
        if let encoded = try? JSONEncoder().encode(enabledProviders) {
            UserDefaults.standard.set(encoded, forKey: "EnabledProviders")
        }
    }
}