//
//  Endpoint.swift
//  imdbTop
//
//  Created by Vlada Kemskaya on 25.11.2022.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var queryItems: [String: String] { get set }
    var subpath: String { get set }
    var path: String { get set }
    var key: String { get set }
    
    func asURLRequest() -> URLRequest
}

extension Endpoint {
    func asURLRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host

        components.path = "\(subpath)/\(path)/\(key)/"

        if !queryItems.isEmpty {
            components.queryItems = queryItems.map(URLQueryItem.init)
        }

        guard let url = components.url else {
            fatalError("error")
        }
        return URLRequest(url: url)
    }
}
