//
//  PostsTests.swift
//  PostsTests
//
//  Created by Piotr Domowicz on 01.09.24.
//

import XCTest
@testable import Posts

final class ApiClientTests: XCTestCase {
    
    var mockApiClient: ApiClient!
    
    override func setUp() {
        super.setUp()
        mockApiClient = createMockApiClient()
    }
    
    override func tearDown() {
        mockApiClient = nil
        super.tearDown()
    }
    
    func createMockApiClient() -> ApiClient {
        // Define mock data and behavior for requestPosts
        let requestPosts: (FetchPostsRequest) async throws -> [Post] = { _ in
            return [
                Post(body: "Mock body 1", id: 1, title: "Mock title 1", userID: 1),
                Post(body: "Mock body 2", id: 2, title: "Mock title 2", userID: 2)
            ]
        }
        
        // Define mock data and behavior for addPost
        let addPost: (AddPostRequest) async throws -> Post = { request in
            return Post(body: request.body, id: 3, title: request.title, userID: request.userID)
        }
        
        // Create mock ApiClient with the defined behaviors
        return ApiClient(requestPosts: requestPosts, addPost: addPost)
    }
    
    func testFetchPosts() async {
        // When
        do {
            let posts = try await mockApiClient.requestPosts(FetchPostsRequest())
            
            // Then
            XCTAssertEqual(posts.count, 2, "Number of fetched posts should match")
            XCTAssertEqual(posts[0].id, 1, "First post ID should match")
            XCTAssertEqual(posts[0].title, "Mock title 1", "First post title should match")
            // Add more assertions as needed
        } catch {
            XCTFail("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    func testAddPost() async {
        // Given
        let newPostRequest = AddPostRequest(title: "New Post", body: "Body of new post", userID: 4)
        
        // When
        do {
            let addedPost = try await mockApiClient.addPost(newPostRequest)
            
            // Then
            XCTAssertEqual(addedPost.id, 3, "Added post ID should match")
            XCTAssertEqual(addedPost.title, "New Post", "Added post title should match")
            // Add more assertions as needed
        } catch {
            XCTFail("Error adding post: \(error.localizedDescription)")
        }
    }
}
