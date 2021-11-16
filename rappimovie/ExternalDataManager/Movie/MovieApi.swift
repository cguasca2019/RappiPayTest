//
//  MovieApi.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Network

open class MovieApi {
    let tools = Tools.shared
    let headers: HTTPHeaders = [
        .acceptEncoding("UTF-8"),
        .contentType("application/json"),
        .accept("application/json")
    ]
    
    var listenerGetCategories: ListenerGetCategories?
    var listenerGetTrailers: ListenerGetTrailers?
    
    func getPopularMovies(page: Int){
        let url = URL(string: tools.getUrlRequest() + "movie/popular?api_key=\(tools.getAppKey())&language=en-US&page=\(page)")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCategories?.failureGetCategories("json GETPOPULARMOVIES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Category.self, from: data)
                    self.listenerGetCategories?.successGetCategories(resp)
                }catch let jsonErr {
                    self.listenerGetCategories?.failureGetCategories("json GETPOPULARMOVIES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getNowPlayingMovies(page: Int){
        let url = URL(string: tools.getUrlRequest() + "movie/now_playing?api_key=\(tools.getAppKey())&language=en-US&page=\(page)")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCategories?.failureGetCategories("json GETNOWPLAYINGMOVIES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Category.self, from: data)
                    self.listenerGetCategories?.successGetCategories(resp)
                }catch let jsonErr {
                    self.listenerGetCategories?.failureGetCategories("json GETNOWPLAYINGMOVIES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getUpcomingMovies(page: Int){
        let url = URL(string: tools.getUrlRequest() + "movie/upcoming?api_key=\(tools.getAppKey())&language=en-US&page=\(page)")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCategories?.failureGetCategories("json GETUPCOMINGMOVIES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Category.self, from: data)
                    self.listenerGetCategories?.successGetCategories(resp)
                }catch let jsonErr {
                    self.listenerGetCategories?.failureGetCategories("json GETUPCOMINGMOVIES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getTopRatedMovies(page: Int){
        let url = URL(string: tools.getUrlRequest() + "movie/top_rated?api_key=\(tools.getAppKey())&language=en-US&page=\(page)")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCategories?.failureGetCategories("json GETUPCOMINGMOVIES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Category.self, from: data)
                    self.listenerGetCategories?.successGetCategories(resp)
                }catch let jsonErr {
                    self.listenerGetCategories?.failureGetCategories("json GETUPCOMINGMOVIES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getTrailers(movie: Int){
        let url = URL(string: tools.getUrlRequest() + "movie/\(movie)/videos?api_key=\(tools.getAppKey())&language=en-US")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetTrailers?.failureGetTrailers("json GETTRAILERS ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Trailer.self, from: data)
                    self.listenerGetTrailers?.successGetTrailers(resp)
                }catch let jsonErr {
                    self.listenerGetTrailers?.failureGetTrailers("json GETTRAILERS ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getSearchMovies(page: Int, query: String){
        
        let urlFormat: String = tools.getUrlRequest() + "search/movie?api_key=\(tools.getAppKey ())&language=en-US&page=\(page)&include_adult=true&query=\(query)"
        
        let urlString = urlFormat.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlString ?? "")
        
        print("URL METHOD", url!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCategories?.failureGetCategories("json GETSEARCHMOVIES ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Category.self, from: data)
                    self.listenerGetCategories?.successGetCategories(resp)
                }catch let jsonErr {
                    self.listenerGetCategories?.failureGetCategories("json GETSEARCHMOVIES ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
}
