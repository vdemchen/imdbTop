//
//  MovieModel.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 24.11.2022.
//

import Foundation
import UIKit

// MARK: - MovieModel
struct MovieModel: Codable, Hashable, Equatable {
    let id: String
    let image: String
    let title, description, runtimeStr, genres: String
    let genreList: [GenreList]
    let contentRating, imDBRating, imDBRatingVotes: String
    let metacriticRating: String?
    let plot, stars: String
    let starList: [StarList]
    
    enum CodingKeys: String, CodingKey {
        case id, image, title, description
        case runtimeStr, genres, genreList, contentRating
        case imDBRating = "imDbRating"
        case imDBRatingVotes = "imDbRatingVotes"
        case metacriticRating, plot, stars, starList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - GenreList
struct GenreList: Codable {
    let key, value: String
}

// MARK: - StarList
struct StarList: Codable {
    let id, name: String
}

typealias Movies = [MovieModel]
