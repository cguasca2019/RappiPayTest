//
//  ModelDB.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//
import Foundation
import FMDB

let instance = ModelDB()

class ModelDB {
    var dataBase: FMDatabase? = nil
    var tools: Tools = Tools.shared
    
    class func getSingleton() -> ModelDB {
        if (instance.dataBase == nil) {
            instance.dataBase = FMDatabase(path: Tools.getPath("rappimovie.sqlite"))
            print(Tools.getPath("rappimovie.sqlite"))
            instance.dataBase!.open()
            instance.dataBase!.shouldCacheStatements = false
        }
        return instance
    }
    
    func addCategoriesMovies(page: Int, movieId: Int, categoryId: Int, order: Int)  {
        let insertSQL = "INSERT INTO CategoriesMovies (page, movieId, category, ordercol) VALUES ( '\(page)', '\(movieId)', '\(categoryId)', '\(order)')"
        let result = instance.dataBase!.executeUpdate(insertSQL, withArgumentsIn: [])
        if !result {
            print("Error: \( instance.dataBase!.lastErrorMessage())")
        } else {
            print("CategoriesMovies insertado correctamente")
        }
    }
    
    func deleteCategoriesMovies(page: Int, categoryId: Int)  {
        let insertSQL = page == 0 ? "DELETE FROM CategoriesMovies WHERE category = '\(categoryId)'" : "DELETE FROM CategoriesMovies WHERE page = '\(page)' AND category = '\(categoryId)'"
        let result = instance.dataBase!.executeUpdate(insertSQL, withArgumentsIn: [])
        if !result {
            print("Error: \( instance.dataBase!.lastErrorMessage())")
        } else {
            print("CategoriesMovies limpiado correctamente")
        }
    }
    
    func addMovie(obj: Movie)  {
        let insertSQL = "INSERT INTO Movies (id, backdropPath, originalTitle, overview, popularity, posterPath, releaseDate, title, video, voteAverage, voteCount) VALUES ( '\(obj.id)', '\(obj.backdropPath ?? "")', '\(obj.originalTitle.replacingOccurrences(of: "'", with: "`"))', '\(obj.overview.replacingOccurrences(of: "'", with: "`"))', '\(obj.popularity)', '\(obj.posterPath ?? "")', '\(obj.releaseDate)', '\(obj.title.replacingOccurrences(of: "'", with: "`"))', '\(obj.video)', '\(obj.voteAverage)', '\(obj.voteCount)')"
        let result = instance.dataBase!.executeUpdate(insertSQL, withArgumentsIn: [])
        if !result {
            print("Error: \( instance.dataBase!.lastErrorMessage())")
        } else {
            print("Movie insertado correctamente")
        }
    }
    
    func getMoviesCategories(_ txtSearch:String = "", categoryId: Int) -> [Movie] {
        var resultSQL = "SELECT A.* FROM Movies AS A  INNER JOIN CategoriesMovies AS B ON A.id = B.movieId WHERE B.category = \(categoryId)"
        
        if(!txtSearch.isEmpty){
            resultSQL = resultSQL + " AND upper(A.title) LIKE  '%\(txtSearch.uppercased())%'"
        }
        
        resultSQL = resultSQL + " ORDER BY B.page ASC, B.ordercol ASC "
        
        let result: FMResultSet! = instance.dataBase!.executeQuery(resultSQL, withArgumentsIn: [])
        var movies: [Movie] = []
        if (result != nil) {
            while result.next() {
                var oMovie: Movie = Movie()
//                oMovie.adult = result.bool(forColumn: "adult")
                oMovie.backdropPath = result.string(forColumn: "backdropPath") ?? ""
                oMovie.id = Int(result.int(forColumn: "id"))
                //oMovie.originalLanguage = OriginalLanguage.en
                oMovie.originalTitle = result.string(forColumn: "originalTitle") ?? ""
                oMovie.overview = result.string(forColumn: "overview") ?? ""
                oMovie.popularity = result.double(forColumn: "popularity")
                oMovie.posterPath = result.string(forColumn: "posterPath") ?? ""
                oMovie.releaseDate = result.string(forColumn: "releaseDate") ?? ""
                oMovie.title = result.string(forColumn: "title") ?? ""
                oMovie.video = result.bool(forColumn: "video")
                oMovie.voteAverage = result.double(forColumn: "voteAverage")
                oMovie.voteCount = Int(result.int(forColumn: "voteCount"))
                movies.append(oMovie)
            }
        }
        return movies
    }
}
