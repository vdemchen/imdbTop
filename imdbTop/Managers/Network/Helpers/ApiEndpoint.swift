//
//  ApiEndpoint.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 25.11.2022.
//

import Foundation
struct ApiEndpoint: Endpoint {
    var host: String = ProjectSettings.apiHost
    var subpath: String = "/api"
    var key: String = ProjectSettings.apiKey
    var path: String
    var queryItems: [String : String]
    
    
    static func advancedSearch(quaryItems: [String: String]) -> ApiEndpoint {
        ApiEndpoint(path: "AdvancedSearch", queryItems: quaryItems)
    }
}

extension ApiEndpoint {
    init(path: String) {
        self.init(path: path, queryItems: [:])
    }
}
