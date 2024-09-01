//
//  ApiClient.swift
//  Posts
//
//

import SwiftUI

public struct ApiClientKey: EnvironmentKey {
    public static let defaultValue: ApiClient = .live(environment: .production)
}

public extension EnvironmentValues {
    var apiClient: ApiClient {
        get { self[ApiClientKey.self] }
        set { self[ApiClientKey.self ] = newValue}
    }
}

public actor ApiClient {
    public enum Environment {
        case production
        case staging
        case develop
        
        var url: URL {
            switch self {
            case .production:
                /* Replace with a Production base url */
                return URL(string: "https://jsonplaceholder.typicode.com")!
            case .staging:
                /* Replace with a Staging base url */
                return URL(string: "https://jsonplaceholder.typicode.com")!
            case .develop:
                /* Replace with a Develop base url */
                return URL(string: "https://jsonplaceholder.typicode.com")!
            }
        }
    }
    
    public init(
        requestPosts: @escaping (FetchPostsRequest) async throws -> [Post],
        addPost: @escaping (AddPostRequest) async throws -> Post
    ) {
        self.requestPosts = requestPosts
        self.addPost = addPost
    }
    
    public var requestPosts: (FetchPostsRequest) async throws -> [Post]
    public var addPost: (AddPostRequest) async throws -> Post
    
    static func handle <Success: Decodable>(
        baseURL: URL,
        urlSession: URLSession,
        decoder: JSONDecoder,
        encoder: JSONEncoder,
        requestID: UUID,
        requester: URLRequester,
        debugger: Debugger? = nil
    ) async throws -> Success {
        
        let request = try requester.urlRequest(
            baseURL: baseURL,
            encoder: encoder
        )
        
        let element: (data: Data, urlResponse: URLResponse) = try await urlSession.data(for: request)
        
        // Print JSON to the console in a readable format for debugging.
        debugger?.console(data: element.data)
        
        if let response = element.urlResponse as? HTTPURLResponse, response.statusCode != 200 {
            throw ApiClientError.status(response.statusCode)
        }
        
        do {
            let response = try decoder.decode(Success.self, from: element.data)
            return response
        } catch let e {
            print(e)
            throw ApiClientError.undefined(e)
        }
    }
    
    public static func live(
        environment: Environment,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        jsonEncoder: JSONEncoder = .init(),
        buildUUID: @escaping () -> UUID = { UUID() }
    ) -> Self {
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return .init(
            requestPosts: {
                try await handle(
                    baseURL: environment.url,
                    urlSession: urlSession,
                    decoder: jsonDecoder,
                    encoder: jsonEncoder,
                    requestID: buildUUID(),
                    requester: $0,
                    debugger: $0
                )
            },
            addPost: {
                try await handle(
                    baseURL: environment.url,
                    urlSession: urlSession,
                    decoder: jsonDecoder,
                    encoder: jsonEncoder,
                    requestID: buildUUID(),
                    requester: $0,
                    debugger: $0
                )
            }
        )
    }
}
