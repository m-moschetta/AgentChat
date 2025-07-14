//
//  AddN8NWorkflowView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct AddN8NWorkflowView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var workflowManager = N8NWorkflowManager.shared
    
    @State private var workflowId = ""
    @State private var workflowName = ""
    @State private var workflowDescription = ""
    @State private var parameters: [WorkflowParameter] = []
    @State private var showingAddParameter = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Workflow Details") {
                    TextField("Workflow ID", text: $workflowId)
                    TextField("Name", text: $workflowName)
                    TextField("Description", text: $workflowDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Parameters") {
                    ForEach(parameters) { parameter in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(parameter.name)
                                    .font(.headline)
                                Spacer()
                                Text(parameter.type.displayName)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                            }
                            
                            if let defaultValue = parameter.defaultValue {
                                Text("Default: \(defaultValue)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            if parameter.required {
                                Text("Required")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteParameter)
                    
                    Button("Add Parameter") {
                        showingAddParameter = true
                    }
                }
            }
            .navigationTitle("Add N8N Workflow")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkflow()
                    }
                    .disabled(workflowId.isEmpty || workflowName.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingAddParameter) {
            AddParameterView { parameter in
                parameters.append(parameter)
            }
        }
    }
    
    private func deleteParameter(offsets: IndexSet) {
        parameters.remove(atOffsets: offsets)
    }
    
    private func saveWorkflow() {
        let workflow = N8NWorkflow(
            id: workflowId,
            name: workflowName,
            description: workflowDescription,
            parameters: parameters
        )
        
        workflowManager.addWorkflow(workflow)
        dismiss()
    }
}

struct AddParameterView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (WorkflowParameter) -> Void
    
    @State private var name = ""
    @State private var type = ParameterType.string
    @State private var required = false
    @State private var defaultValue = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Parameter Details") {
                    TextField("Parameter Name", text: $name)
                    
                    Picker("Type", selection: $type) {
                        ForEach(ParameterType.allCases, id: \.self) { paramType in
                            Text(paramType.displayName).tag(paramType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Toggle("Required", isOn: $required)
                    
                    TextField("Default Value (optional)", text: $defaultValue)
                }
            }
            .navigationTitle("Add Parameter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let parameter = WorkflowParameter(
                            name: name,
                            type: type,
                            required: required,
                            defaultValue: defaultValue.isEmpty ? nil : defaultValue
                        )
                        onSave(parameter)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddN8NWorkflowView()
}