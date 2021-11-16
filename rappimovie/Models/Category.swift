//
//  Category.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//
import Foundation

// MARK: - Welcome
struct Category: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
