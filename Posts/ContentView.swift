//
//  ContentView.swift
//  Posts
//
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.apiClient) private var apiClient
    
    @State var posts: [Post]?
    
    var body: some View {
        Group {
            VStack {
                if let posts {
                    List {
                        ForEach(posts) { i in
                            Text("\(i.title)")
                        }
                    }
                }
            }
        }
        .task {
            await loadPosts()
        }
    }
    
    func loadPosts() async {
        do {
            posts = try await apiClient.requestPosts(.init())
        } catch {
            print(error)
        }
    }
}
