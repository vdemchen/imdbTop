//
//  ListManager.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 25.11.2022.
//

import Combine
import Foundation

final class ListManager {
    // MARK: - Properties
    private let networkManager = NetworkManager()
    
    // MARK: - Methods
    func getTop250(_ fetchItems: Int) -> AnyPublisher<Movies, Error> {
        let quaryItems = [
            "groups": "top_250",
            "count": "\(fetchItems)",
            "sort": "user_rating"
        ]
       return  networkManager
            .makeRequest(method: .get, endpoint: ApiEndpoint.advancedSearch(quaryItems: quaryItems), body: nil)
            .eraseToAnyPublisher()
    }
    
    func searchMoviewForName(_ name: String) -> AnyPublisher<Movies, Error> {
        let quaryItems = [
            "groups": "top_250",
            "title": name,
            "sort": "alpha,asc"
        ]
        
        return networkManager
            .makeRequest(method: .get, endpoint: ApiEndpoint.advancedSearch(quaryItems: quaryItems), body: nil)
            .eraseToAnyPublisher()
    }
}
