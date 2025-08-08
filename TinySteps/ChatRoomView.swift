//
//  ChatRoomView.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject var chatService: MockChatService
    let room: ChatRoom
    
    @State private var messageText = ""
    @State private var showingProfile = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(chatService.messages) { message in
                                    MessageBubble(
                                        message: message,
                                        isFromCurrentUser: message.senderId == chatService.currentUser?.id
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        .onChange(of: chatService.messages.count) { _, _ in
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(chatService.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    
                    // Message Input
                    VStack(spacing: 0) {
                        Divider()
    
                        
                        HStack(spacing: 12) {
                            // Profile Button with user's profile picture
                            Button(action: { showingProfile = true }) {
                                ProfilePictureComponent(profileImageData: UserDefaults.standard.data(forKey: "profileImageData") ?? Data(), size: 40, showBorder: true)
                            }
                            
                            // Message Input Field
                            HStack {
                                TextField("Type a message...", text: $messageText, axis: .vertical)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .focused($isTextFieldFocused)
                                    .lineLimit(1...4)
                                
                                Button(action: sendMessage) {
                                    Image(systemName: "paperplane.fill")
                                        .font(.title3)
                                        .foregroundColor(messageText.isEmpty ? .gray : .blue)
                                }
                                .disabled(messageText.isEmpty)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            .cornerRadius(25)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationTitle(room.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Leave") {
                        chatService.leaveRoom(room)
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text("\(room.participants.count) online")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
        .sheet(isPresented: $showingProfile) {
            UserProfileView(profile: chatService.currentUser)
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = ChatMessage(
            senderId: chatService.currentUser?.id ?? "user",
            senderName: chatService.currentUser?.name ?? "Dad",
            senderAvatar: chatService.currentUser?.avatar,
            content: messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        chatService.sendMessage(message, in: room)
        
        // Track message sent
        AnalyticsManager.shared.trackChatMessageSent(roomType: room.category.rawValue)
        
        messageText = ""
        isTextFieldFocused = false
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let isFromCurrentUser: Bool
    @AppStorage("profileImageData") private var profileImageData: Data = Data()
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isFromCurrentUser {
                    HStack {
                        Text(message.senderName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                    }
                }
                
                HStack {
                    if !isFromCurrentUser {
                        // Avatar for other users
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Message Content
                    VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 2) {
                        Text(message.content)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                isFromCurrentUser ? 
                                Color.blue : 
                                Color.clear
                            )
                            .cornerRadius(18)
                        
                        HStack(spacing: 4) {
                            Text(message.timestamp, style: .time)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                            
                            if isFromCurrentUser {
                                // Message Status Indicators
                                HStack(spacing: 2) {
                                    Image(systemName: message.status.icon)
                                        .font(.caption2)
                                        .foregroundColor(message.status.color)
                                }
                            }
                        }
                    }
                    
                    if isFromCurrentUser {
                        // Avatar for current user
                        ProfilePictureComponent(profileImageData: profileImageData, size: 32, showBorder: false)
                    }
                }
            }
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
}

struct UserProfileView: View {
    let profile: UserProfile?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    
                    // Profile Info
                    VStack(spacing: 16) {
                        Text(profile?.name ?? "Dad")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if let location = profile?.location {
                            HStack {
                                Image(systemName: "location")
                                    .foregroundColor(.white.opacity(0.7))
                                Text(location)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        if let babyAge = profile?.babyAge {
                            HStack {
                                Image(systemName: "baby")
                                    .foregroundColor(.white.opacity(0.7))
                                Text("Baby: \(babyAge)")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        if let interests = profile?.interests, !interests.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interests:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(interests, id: \.self) { interest in
                                        Text(interest)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                    
                                            .foregroundColor(.blue)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ChatRoomView(
        chatService: MockChatService(),
        room: ChatRoom(name: "Test Room", description: "Test", category: .general)
    )
} 