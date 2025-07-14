//
//  N8NService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class N8NService {
    private let workflowManager = N8NWorkflowManager.shared
    
    func sendMessage(_ message: String, model: String) async throws -> String {
        guard let workflow = workflowManager.getWorkflow(by: model) else {
            throw ChatServiceError.invalidResponse
        }
        
        guard let baseURL = try KeychainService.shared.getAPIKey(for: "n8n_url"),
              let apiKey = try KeychainService.shared.getAPIKey(for: "n8n") else {
            throw ChatServiceError.invalidAPIKey
        }
        
        let url = "\(baseURL)/webhook/\(workflow.id)"
        
        let request = N8NRequest(
            message: message,
            parameters: workflow.parameters.reduce(into: [String: String]()) { result, param in
                result[param.name] = param.defaultValue ?? ""
            }
        )
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let response = jsonObject["response"] as? String {
                return response
            } else if let responseString = String(data: data, encoding: .utf8) {
                return responseString
            } else {
                throw ChatServiceError.invalidResponse
            }
        } catch {
            throw ChatServiceError.networkError(error)
        }
    }
}

struct N8NRequest: Codable {
    let message: String
    let parameters: [String: String]
}