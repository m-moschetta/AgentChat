//
//  N8NWorkflow.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

struct N8NWorkflow: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let parameters: [WorkflowParameter]
    
    init(id: String, name: String, description: String, parameters: [WorkflowParameter] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.parameters = parameters
    }
}

struct WorkflowParameter: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: ParameterType
    let required: Bool
    let defaultValue: String?
    
    init(name: String, type: ParameterType, required: Bool = false, defaultValue: String? = nil) {
        self.name = name
        self.type = type
        self.required = required
        self.defaultValue = defaultValue
    }
}

enum ParameterType: String, CaseIterable, Codable {
    case string = "string"
    case number = "number"
    case boolean = "boolean"
    case array = "array"
    
    var displayName: String {
        switch self {
        case .string:
            return "Text"
        case .number:
            return "Number"
        case .boolean:
            return "Boolean"
        case .array:
            return "Array"
        }
    }
}

class N8NWorkflowManager: ObservableObject {
    static let shared = N8NWorkflowManager()
    
    @Published var workflows: [N8NWorkflow] = []
    
    private init() {
        loadWorkflows()
    }
    
    func addWorkflow(_ workflow: N8NWorkflow) {
        workflows.append(workflow)
        saveWorkflows()
    }
    
    func removeWorkflow(_ workflow: N8NWorkflow) {
        workflows.removeAll { $0.id == workflow.id }
        saveWorkflows()
    }
    
    func getWorkflow(by id: String) -> N8NWorkflow? {
        return workflows.first { $0.id == id }
    }
    
    private func saveWorkflows() {
        if let encoded = try? JSONEncoder().encode(workflows) {
            UserDefaults.standard.set(encoded, forKey: "N8NWorkflows")
        }
    }
    
    private func loadWorkflows() {
        if let data = UserDefaults.standard.data(forKey: "N8NWorkflows"),
           let decoded = try? JSONDecoder().decode([N8NWorkflow].self, from: data) {
            workflows = decoded
        }
    }
}