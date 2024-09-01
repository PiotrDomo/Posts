//
//  Debugger.swift
//  Posts
//
//

import Foundation

protocol Debugger {
    func console(data: Data)
}

extension AddPostRequest: Debugger {
    func console(data: Data) {
        #if DEBUG
        do {
            let jsonData = try JSONSerialization.dictionary(data: data)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
        } catch {
            print("Failed to print json response")
        }
        #endif
    }
}

extension FetchPostsRequest: Debugger {
    func console(data: Data) {
        #if DEBUG
        do {
            let jsonData = try JSONSerialization.list(data: data)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
        } catch {
            print("Failed to print json response")
        }
        #endif
    }
}

extension JSONSerialization {
    static func list(data: Data) throws -> Data {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            return try JSONSerialization.data(withJSONObject: jsonObject!, options: .prettyPrinted)
        } catch let e {
            throw e
        }
    }
    
    static func dictionary(data: Data) throws -> Data {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return try JSONSerialization.data(withJSONObject: jsonObject!, options: .prettyPrinted)
        } catch let e {
            throw e
        }
    }
}
