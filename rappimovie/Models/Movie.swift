//
//  Movie.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation
import UIKit
// MARK: - Movie
struct Movie: Codable {
    var adult: Bool
    var backdropPath: String?
    var genreIDS: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle, overview: String
    var popularity: Double
    var posterPath: String?
    var releaseDate, title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(){
        self.adult = false
        self.backdropPath = ""
        self.genreIDS = []
        self.id = 0
        self.originalLanguage = ""
        self.originalTitle = ""
        self.overview = ""
        self.popularity = 0.0
        self.posterPath = ""
        self.releaseDate = ""
        self.title = ""
        self.video = false
        self.voteAverage = 0.0
        self.voteCount = 0
    }
}
