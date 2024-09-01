//
//  URLRequester.swift
//  Posts
//
//

import Foundation

protocol URLRequester {
    func urlRequest(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest
}

extension AddPostRequest: URLRequester {
    func urlRequest(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest {
        let data = try encoder.encode(self)
        let url = baseURL.appendingPathComponent("posts")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        return request
    }
}

extension FetchPostsRequest: URLRequester {
    func urlRequest(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest {
        let url = baseURL.appendingPathComponent("posts")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
