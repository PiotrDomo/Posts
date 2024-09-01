//
//  ApiClientError.swift
//  Posts
//
//

import Foundation

public enum ApiClientError: Error {
    case undefined(Error?)
    case status(Int)
}
