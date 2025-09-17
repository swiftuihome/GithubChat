
//
//  GitHubChatView.swift
//  GithubChat
//
//  Created by devlink on 2025/9/16.
//

import SwiftUI

struct GitHubChatView: View {
    @State private var messages: [Message] = [
        Message(sender: "octocat", avatar: "octocat", content: "大家好！欢迎来到GitHub风格聊天界面。这个界面支持浅色和深色主题切换，并且没有侧边栏。", time: "14:32", isSent: false, hasCodeBlock: false),
        Message(sender: "youki", avatar: "YK", content: "这个设计看起来很棒！主题切换功能非常流畅，而且没有侧边栏让聊天区域更宽敞了。", time: "14:35", isSent: true, hasCodeBlock: false),
        Message(sender: "octocat", avatar: "octocat", content: "是的，这样布局更简洁，专注于聊天内容。我使用了CSS变量来实现主题切换，这样可以在浅色和深色主题之间平滑过渡。", time: "14:36", isSent: false, hasCodeBlock: false),
        Message(sender: "octocat", avatar: "octocat", content: "深色主题对夜间使用非常友好，而且符合GitHub的整体设计风格。简洁的布局让聊天体验更好了。", time: "14:38", isSent: false, hasCodeBlock: false),
        Message(sender: "youki", avatar: "YK", content: "我注意到消息气泡的颜色也会根据主题变化，这个细节做得很好！没有侧边栏的设计让界面更加简洁现代。", time: "14:40", isSent: true, hasCodeBlock: false),
        Message(sender: "octocat", avatar: "octocat", content: "我们还可以添加一些代码片段功能，就像GitHub那样：\n```swift\nfunc greetUser(username: String) {\n    print(\"Hello, \\(username)! Welcome to GitHub Chat.\")\n}\n```", time: "14:42", isSent: false, hasCodeBlock: true)
    ]
    
    @State private var newMessage = ""
    @State private var isDarkMode = false
    @State private var showTypingIndicator = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 聊天头部
            //headerView
            
            // 消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(messages) { message in
                            MessageView(message: message, isDarkMode: isDarkMode)
                                .padding(.bottom, 16)
                                .id(message.id)
                        }
                        
                        if showTypingIndicator {
                            TypingIndicatorView(isDarkMode: isDarkMode)
                                .padding(.top, 8)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
            }
            .background(GitHubTheme.backgroundColor(isDarkMode: isDarkMode))
            
            // 输入区域
            inputView
        }
        .background(GitHubTheme.secondaryBackgroundColor(isDarkMode: isDarkMode))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .padding(.bottom)
        .padding(.bottom)
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("GitHub Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        isDarkMode.toggle()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .foregroundColor(GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
                    .background(
                        Circle()
                            .fill(GitHubTheme.backgroundColor(isDarkMode: isDarkMode))
                    )
                    .overlay(
                        Circle()
                            .stroke(GitHubTheme.borderColor(isDarkMode: isDarkMode), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // 滚动到底部
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    // 头部视图
    private var headerView: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "message.fill")
                    .foregroundColor(GitHubTheme.primaryColor(isDarkMode: isDarkMode))
                
                Text("GitHub 团队讨论")
                    .font(.headline)
                    .foregroundColor(GitHubTheme.primaryColor(isDarkMode: isDarkMode))
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    
                    Text("3 人在线")
                        .font(.caption)
                        .foregroundColor(GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(GitHubTheme.secondaryBackgroundColor(isDarkMode: isDarkMode))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(GitHubTheme.borderColor(isDarkMode: isDarkMode)),
            alignment: .bottom
        )
    }
    
    // 输入视图
    private var inputView: some View {
        HStack(spacing: 12) {
            TextEditor(text: $newMessage)
                .padding(2)
                .frame(height: 42)
                .scrollContentBackground(.hidden)
                .background(GitHubTheme.inputBackgroundColor(isDarkMode: isDarkMode))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(GitHubTheme.borderColor(isDarkMode: isDarkMode), lineWidth: 1)
                )
                .foregroundColor(GitHubTheme.textColor(isDarkMode: isDarkMode))
            
            Button(action: sendMessage) {
                Text("发送")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(GitHubTheme.messageOutColor(isDarkMode: isDarkMode))
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(GitHubTheme.secondaryBackgroundColor(isDarkMode: isDarkMode))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(GitHubTheme.borderColor(isDarkMode: isDarkMode)),
            alignment: .top
        )
    }
    
    // 发送消息
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: Date())
        
        let message = Message(
            sender: "youki",
            avatar: "YK",
            content: newMessage,
            time: timeString,
            isSent: true,
            hasCodeBlock: false
        )
        
        withAnimation {
            messages.append(message)
            newMessage = ""
        }
        
        // 模拟回复
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let replyMessage = Message(
                sender: "octocat",
                avatar: "octocat",
                content: "收到你的消息了！这是自动回复。",
                time: formatter.string(from: Date()),
                isSent: false,
                hasCodeBlock: false
            )
            
            withAnimation {
                messages.append(replyMessage)
            }
        }
    }
}

// 预览
struct GitHubChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GitHubChatView()
        }
    }
}

// 消息视图
struct MessageView: View {
    let message: Message
    let isDarkMode: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isSent {
                Spacer()
            }
            
            if !message.isSent {
                AvatarView(avatar: message.avatar, isDarkMode: isDarkMode)
            }
            
            VStack(alignment: message.isSent ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 8) {
                    if message.isSent {
                        Text(message.time)
                            .font(.caption)
                            .foregroundColor(message.isSent ? .white.opacity(0.8) : GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
                        
                        Text(message.sender)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(message.isSent ? .white : GitHubTheme.textColor(isDarkMode: isDarkMode))
                    } else {
                        Text(message.sender)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(message.isSent ? .white : GitHubTheme.textColor(isDarkMode: isDarkMode))
                        
                        Text(message.time)
                            .font(.caption)
                            .foregroundColor(message.isSent ? .white.opacity(0.8) : GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
                    }
                }
                
                if message.hasCodeBlock, let codeContent = extractCode(from: message.content) {
                    Text(codeContent.0)
                        .foregroundColor(message.isSent ? .white : GitHubTheme.textColor(isDarkMode: isDarkMode))
                    
                    CodeBlockView(code: codeContent.1, isDarkMode: isDarkMode)
                } else {
                    Text(message.content)
                        .foregroundColor(message.isSent ? .white : GitHubTheme.textColor(isDarkMode: isDarkMode))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(message.isSent ? GitHubTheme.messageOutColor(isDarkMode: isDarkMode) : GitHubTheme.messageInColor(isDarkMode: isDarkMode))
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(message.isSent ? Color.clear : GitHubTheme.borderColor(isDarkMode: isDarkMode), lineWidth: 1)
            )
            
            if message.isSent {
                AvatarView(avatar: message.avatar, isDarkMode: isDarkMode)
            } else {
                Spacer()
            }
        }
    }
    
    // 提取代码块
    private func extractCode(from text: String) -> (String, String)? {
        let components = text.components(separatedBy: "```")
        guard components.count >= 3 else { return nil }
        return (components[0], components[1])
    }
}

// 头像视图
struct AvatarView: View {
    let avatar: String
    let isDarkMode: Bool
    let width: CGFloat
    
    init(avatar: String, isDarkMode: Bool, width: CGFloat = 40) {
        self.avatar = avatar
        self.isDarkMode = isDarkMode
        self.width = width
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(GitHubTheme.borderColor(isDarkMode: isDarkMode))
                .frame(width: width, height: width)
            
            Image(avatar)
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .clipShape(.circle)
                .foregroundColor(GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
        }
    }
}

// 代码块视图
struct CodeBlockView: View {
    let code: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(code)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(GitHubTheme.textColor(isDarkMode: isDarkMode))
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GitHubTheme.secondaryBackgroundColor(isDarkMode: isDarkMode))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(GitHubTheme.borderColor(isDarkMode: isDarkMode), lineWidth: 1)
        )
        .padding(.top, 8)
    }
}

// 输入指示器视图(3个点依次显示)
struct TypingIndicatorView: View {
    let isDarkMode: Bool
    let width: CGFloat = 5
    @State private var animate = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("octocat 正在输入")
                .font(.caption)
                .foregroundColor(GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(GitHubTheme.secondaryTextColor(isDarkMode: isDarkMode))
                        .frame(width: width, height: width)
                        .opacity(animate ? 1 : 0.2) // 出现/消失
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3), // 依次错开
                            value: animate
                        )
                }
            }
            .padding(.leading, 4)
            .onAppear {
                animate = true
            }
            
            Spacer()
        }
    }
}

extension Color {
    // MARK: - 浅色主题颜色
    static let ghLightBg = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let ghLightSecondaryBg = Color(red: 246/255, green: 248/255, blue: 250/255)
    static let ghLightText = Color(red: 36/255, green: 41/255, blue: 46/255)
    static let ghLightBorder = Color(red: 225/255, green: 228/255, blue: 232/255)
    static let ghLightPrimary = Color(red: 3/255, green: 102/255, blue: 214/255)
    static let ghLightSecondaryText = Color(red: 106/255, green: 115/255, blue: 125/255)
    static let ghLightMessageIn = Color(red: 246/255, green: 248/255, blue: 250/255)
    static let ghLightMessageOut = Color(red: 3/255, green: 102/255, blue: 214/255)
    static let ghLightInputBg = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    // MARK: - 深色主题颜色
    static let ghDarkBg = Color(red: 13/255, green: 17/255, blue: 23/255)
    static let ghDarkSecondaryBg = Color(red: 22/255, green: 27/255, blue: 34/255)
    static let ghDarkText = Color(red: 240/255, green: 246/255, blue: 252/255)
    static let ghDarkBorder = Color(red: 48/255, green: 54/255, blue: 61/255)
    static let ghDarkPrimary = Color(red: 88/255, green: 166/255, blue: 255/255)
    static let ghDarkSecondaryText = Color(red: 139/255, green: 148/255, blue: 158/255)
    static let ghDarkMessageIn = Color(red: 33/255, green: 38/255, blue: 45/255)
    static let ghDarkMessageOut = Color(red: 31/255, green: 111/255, blue: 235/255)
    static let ghDarkInputBg = Color(red: 13/255, green: 17/255, blue: 23/255)
}

// 主题相关的颜色获取器
struct GitHubTheme {
    static func backgroundColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkBg : .ghLightBg
    }
    
    static func secondaryBackgroundColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkSecondaryBg : .ghLightSecondaryBg
    }
    
    static func textColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkText : .ghLightText
    }
    
    static func borderColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkBorder : .ghLightBorder
    }
    
    static func primaryColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkPrimary : .ghLightPrimary
    }
    
    static func secondaryTextColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkSecondaryText : .ghLightSecondaryText
    }
    
    static func messageInColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkMessageIn : .ghLightMessageIn
    }
    
    static func messageOutColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkMessageOut : .ghLightMessageOut
    }
    
    static func inputBackgroundColor(isDarkMode: Bool) -> Color {
        return isDarkMode ? .ghDarkInputBg : .ghLightInputBg
    }
}

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let avatar: String
    let content: String
    let time: String
    let isSent: Bool
    let hasCodeBlock: Bool
}


// ------------- 出版代码备份 -------------

////
////  GitHubChatView.swift
////  GithubChat
////
////  Created by devlink on 2025/9/16.
////
//
//
//import SwiftUI
//
//struct Message: Identifiable {
//    let id = UUID()
//    let sender: String
//    let avatar: String
//    let content: String
//    let time: String
//    let isSent: Bool
//    let hasCodeBlock: Bool
//}
//
//struct GitHubChatView: View {
//    @State private var messages: [Message] = [
//        Message(sender: "octocat", avatar: "octocat", content: "大家好！欢迎来到GitHub风格聊天界面。这个界面支持浅色和深色主题切换，并且没有侧边栏。", time: "14:32", isSent: false, hasCodeBlock: false),
//        Message(sender: "youki", avatar: "YK", content: "这个设计看起来很棒！主题切换功能非常流畅，而且没有侧边栏让聊天区域更宽敞了。", time: "14:35", isSent: true, hasCodeBlock: false),
//        Message(sender: "octocat", avatar: "octocat", content: "是的，这样布局更简洁，专注于聊天内容。我使用了CSS变量来实现主题切换，这样可以在浅色和深色主题之间平滑过渡。", time: "14:36", isSent: false, hasCodeBlock: false),
//        Message(sender: "octocat", avatar: "octocat", content: "深色主题对夜间使用非常友好，而且符合GitHub的整体设计风格。简洁的布局让聊天体验更好了。", time: "14:38", isSent: false, hasCodeBlock: false),
//        Message(sender: "youki", avatar: "YK", content: "我注意到消息气泡的颜色也会根据主题变化，这个细节做得很好！没有侧边栏的设计让界面更加简洁现代。", time: "14:40", isSent: true, hasCodeBlock: false),
//        Message(sender: "octocat", avatar: "octocat", content: "我们还可以添加一些代码片段功能，就像GitHub那样：\n```swift\nfunc greetUser(username: String) {\n    print(\"Hello, \\(username)! Welcome to GitHub Chat.\")\n}\n```", time: "14:42", isSent: false, hasCodeBlock: true)
//    ]
//
//    @State private var newMessage = ""
//    @State private var isDarkMode = false
//    @State private var showTypingIndicator = true
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 聊天头部
//            headerView
//
//            // 消息列表
//            ScrollViewReader { proxy in
//                ScrollView {
//                    LazyVStack(spacing: 16) {
//                        ForEach(messages) { message in
//                            MessageView(message: message, isDarkMode: isDarkMode)
//                                .id(message.id)
//                        }
//
//                        if showTypingIndicator {
//                            TypingIndicatorView(isDarkMode: isDarkMode)
//                                .padding(.top, 8)
//                        }
//                    }
//                    .padding()
//                }
//                .onChange(of: messages.count) { _, _ in
//                    scrollToBottom(proxy: proxy)
//                }
//                .onAppear {
//                    scrollToBottom(proxy: proxy)
//                }
//            }
//            .background(isDarkMode ? Color(red: 13/255, green: 17/255, blue: 23/255) : Color.white)
//
//            // 输入区域
//            inputView
//        }
//        .background(isDarkMode ? Color(red: 13/255, green: 17/255, blue: 23/255) : Color(red: 246/255, green: 248/255, blue: 250/255))
//        .preferredColorScheme(isDarkMode ? .dark : .light)
//        .padding(.bottom)
//        .padding(.bottom)
//        .edgesIgnoringSafeArea(.bottom)
//    }
//
//    // 滚动到底部
//    private func scrollToBottom(proxy: ScrollViewProxy) {
//        if let lastMessage = messages.last {
//            withAnimation {
//                proxy.scrollTo(lastMessage.id, anchor: .bottom)
//            }
//        }
//    }
//
//    // 头部视图
//    private var headerView: some View {
//        HStack {
//            HStack(spacing: 10) {
//                Image(systemName: "message.fill")
//                    .foregroundColor(isDarkMode ? Color(red: 88/255, green: 166/255, blue: 255/255) : Color(red: 3/255, green: 102/255, blue: 214/255))
//
//                Text("GitHub 团队讨论")
//                    .font(.headline)
//                    .foregroundColor(isDarkMode ? Color(red: 88/255, green: 166/255, blue: 255/255) : Color(red: 3/255, green: 102/255, blue: 214/255))
//
//                HStack(spacing: 6) {
//                    Circle()
//                        .fill(Color.green)
//                        .frame(width: 8, height: 8)
//
//                    Text("3 人在线")
//                        .font(.caption)
//                        .foregroundColor(isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255))
//                }
//            }
//
//            Spacer()
//
//            Button(action: {
//                withAnimation {
//                    isDarkMode.toggle()
//                }
//            }) {
//                HStack(spacing: 8) {
//                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
//                    Text(isDarkMode ? "浅色模式" : "深色模式")
//                        .font(.caption)
//                }
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(isDarkMode ? Color(red: 22/255, green: 27/255, blue: 34/255) : Color.white)
//                .foregroundColor(isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255))
//                .cornerRadius(6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255), lineWidth: 1)
//                )
//            }
//        }
//        .padding()
//        .background(isDarkMode ? Color(red: 22/255, green: 27/255, blue: 34/255) : Color(red: 246/255, green: 248/255, blue: 250/255))
//        .overlay(
//            Rectangle()
//                .frame(height: 1)
//                .foregroundColor(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255)),
//            alignment: .bottom
//        )
//    }
//
//    // 输入视图
//    private var inputView: some View {
//        HStack(spacing: 12) {
//            TextEditor(text: $newMessage)
//                .frame(height: 42)
//                .background(isDarkMode ? Color(red: 13/255, green: 17/255, blue: 23/255) : Color.white)
//                .cornerRadius(6)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255), lineWidth: 1)
//                )
//                .foregroundColor(isDarkMode ? Color(red: 240/255, green: 246/255, blue: 252/255) : Color(red: 36/255, green: 41/255, blue: 46/255))
//
//            Button(action: sendMessage) {
//                Text("发送")
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 10)
//                    .background(isDarkMode ? Color(red: 31/255, green: 111/255, blue: 235/255) : Color(red: 3/255, green: 102/255, blue: 214/255))
//                    .cornerRadius(6)
//            }
//        }
//        .padding()
//        .background(isDarkMode ? Color(red: 22/255, green: 27/255, blue: 34/255) : Color(red: 246/255, green: 248/255, blue: 250/255))
//        .overlay(
//            Rectangle()
//                .frame(height: 1)
//                .foregroundColor(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255)),
//            alignment: .top
//        )
//    }
//
//    // 发送消息
//    private func sendMessage() {
//        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let timeString = formatter.string(from: Date())
//
//        let message = Message(
//            sender: "youki",
//            avatar: "YK",
//            content: newMessage,
//            time: timeString,
//            isSent: true,
//            hasCodeBlock: false
//        )
//
//        withAnimation {
//            messages.append(message)
//            newMessage = ""
//        }
//
//        // 模拟回复
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            let replyMessage = Message(
//                sender: "octocat",
//                avatar: "octocat",
//                content: "收到你的消息了！这是自动回复。",
//                time: formatter.string(from: Date()),
//                isSent: false,
//                hasCodeBlock: false
//            )
//
//            withAnimation {
//                messages.append(replyMessage)
//            }
//        }
//    }
//}
//
//// 消息视图
//struct MessageView: View {
//    let message: Message
//    let isDarkMode: Bool
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 12) {
//            if message.isSent {
//                Spacer()
//            }
//
//            if !message.isSent {
//                AvatarView(avatar: message.avatar, isDarkMode: isDarkMode)
//            }
//
//            VStack(alignment: message.isSent ? .trailing : .leading, spacing: 4) {
//                HStack(spacing: 8) {
//                    if message.isSent {
//                        Text(message.time)
//                            .font(.caption)
//                            .foregroundColor(message.isSent ? .white.opacity(0.8) : (isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255)))
//
//                        Text(message.sender)
//                            .font(.caption)
//                            .fontWeight(.semibold)
//                            .foregroundColor(message.isSent ? .white : (isDarkMode ? .white : .black))
//                    } else {
//                        Text(message.sender)
//                            .font(.caption)
//                            .fontWeight(.semibold)
//                            .foregroundColor(message.isSent ? .white : (isDarkMode ? .white : .black))
//
//                        Text(message.time)
//                            .font(.caption)
//                            .foregroundColor(message.isSent ? .white.opacity(0.8) : (isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255)))
//                    }
//                }
//
//                if message.hasCodeBlock, let codeContent = extractCode(from: message.content) {
//                    Text(codeContent.0)
//                        .foregroundColor(message.isSent ? .white : (isDarkMode ? .white : .black))
//
//                    CodeBlockView(code: codeContent.1, isDarkMode: isDarkMode)
//                } else {
//                    Text(message.content)
//                        .foregroundColor(message.isSent ? .white : (isDarkMode ? .white : .black))
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 12)
//            .background(message.isSent ? (isDarkMode ? Color(red: 31/255, green: 111/255, blue: 235/255) : Color(red: 3/255, green: 102/255, blue: 214/255)) : (isDarkMode ? Color(red: 33/255, green: 38/255, blue: 45/255) : Color(red: 246/255, green: 248/255, blue: 250/255)))
//            .cornerRadius(18)
//            .overlay(
//                RoundedRectangle(cornerRadius: 18)
//                    .stroke(message.isSent ? Color.clear : (isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255)), lineWidth: 1)
//            )
//
//            if message.isSent {
//                AvatarView(avatar: message.avatar, isDarkMode: isDarkMode)
//            } else {
//                Spacer()
//            }
//        }
//    }
//
//    // 提取代码块
//    private func extractCode(from text: String) -> (String, String)? {
//        let components = text.components(separatedBy: "```")
//        guard components.count >= 3 else { return nil }
//        return (components[0], components[1])
//    }
//}
//
//// 头像视图
//struct AvatarView: View {
//    let avatar: String
//    let isDarkMode: Bool
//    let width: CGFloat
//
//    init(avatar: String, isDarkMode: Bool, width: CGFloat = 40) {
//        self.avatar = avatar
//        self.isDarkMode = isDarkMode
//        self.width = width
//    }
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255))
//                .frame(width: width, height: width)
//
//            Image(avatar)
//                .resizable()
//                .scaledToFit()
//                .frame(width: width)
//                .foregroundColor(isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255))
//        }
//        .clipShape(.circle)
//    }
//}
//
//// 代码块视图
//struct CodeBlockView: View {
//    let code: String
//    let isDarkMode: Bool
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(code)
//                .font(.system(size: 14, design: .monospaced))
//                .foregroundColor(isDarkMode ? .white : .black)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 12)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(isDarkMode ? Color(red: 22/255, green: 27/255, blue: 34/255) : Color(red: 246/255, green: 248/255, blue: 250/255))
//        .cornerRadius(6)
//        .overlay(
//            RoundedRectangle(cornerRadius: 6)
//                .stroke(isDarkMode ? Color(red: 48/255, green: 54/255, blue: 61/255) : Color(red: 225/255, green: 228/255, blue: 232/255), lineWidth: 1)
//        )
//        .padding(.top, 8)
//    }
//}
//
//// 输入指示器视图
//struct TypingIndicatorView: View {
//    let isDarkMode: Bool
//
//    var body: some View {
//        HStack {
//            Text("octocat 正在输入")
//                .font(.caption)
//                .foregroundColor(isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255))
//
//            HStack(spacing: 4) {
//                ForEach(0..<3) { index in
//                    Circle()
//                        .fill(isDarkMode ? Color(red: 139/255, green: 148/255, blue: 158/255) : Color(red: 106/255, green: 115/255, blue: 125/255))
//                        .frame(width: 6, height: 6)
//                        .offset(y: typingAnimation(index: index) ? -5 : 0)
//                }
//            }
//            .padding(.leading, 4)
//
//            Spacer()
//        }
//    }
//
//    // 输入动画
//    private func typingAnimation(index: Int) -> Bool {
//        let animation = Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.2)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            withAnimation(animation) {}
//        }
//
//        return true
//    }
//}
//
//// 预览
//struct GitHubChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        GitHubChatView()
//    }
//}
