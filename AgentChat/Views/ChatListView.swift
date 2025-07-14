//
//  ChatListView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var chatService = ChatService()
    @State private var showingNewChat = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chatService.chats) { chat in
                    NavigationLink(destination: ChatDetailView(chat: chat, chatService: chatService)) {
                        ChatRowView(chat: chat)
                    }
                }
                .onDelete(perform: deleteChats)
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Settings") {
                        showingSettings = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Chat") {
                        showingNewChat = true
                    }
                }
            }
            .sheet(isPresented: $showingNewChat) {
                NewChatView(chatService: chatService)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            
            // Default view when no chat is selected
            Text("Select a chat to start")
                .foregroundColor(.secondary)
        }
    }
    
    private func deleteChats(offsets: IndexSet) {
        for index in offsets {
            chatService.deleteChat(chatService.chats[index])
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(chat.title)
                    .font(.headline)
                Spacer()
                Text(chat.agentType.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            if let lastMessage = chat.lastMessage {
                Text(lastMessage.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Text(chat.model)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let lastMessageTime = chat.lastMessageTime {
                    Text(lastMessageTime, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ChatListView()
}