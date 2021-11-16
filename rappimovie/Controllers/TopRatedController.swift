//
//  TopRatedController.swift
//  rappimovie
//
//  Created by Cesar Guasca on 14/11/21.
//
import Foundation
import UIKit
import MotionToastView

class TopRatedController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    let movieApi:MovieApi = MovieApi()
    var categories: [Category] = []
    var actualPage: Int?
    let tools = Tools.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(actualPage == nil){
            tools.writingPageTopRated(1)
        }
        self.searchBar.delegate = self
        self.actualPage = tools.readingPageTopRated()
        self.initialView()
    }
    
    func initialView(){
        loadDataWS(inPage: actualPage!)
        //Looks for single or multiple taps
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            self.searchList(txtSearch: searchText)
            view.endEditing(true)
        } else {
            self.searchList(txtSearch: searchText)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func loadDataWS(inPage:Int){
        if Reachability.isConnectedToNetwork() {
            self.movieApi.listenerGetCategories = self
            self.movieApi.getTopRatedMovies(page: inPage)
        } else {
            self.MotionToast(message: "Offline Mode On", toastType: .warning, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
            self.loadList()
        }
    }
    
    func loadList(){
        // Aqui va el llamado a la lista y su carga
        let movies = ModelDB.getSingleton().getMoviesCategories(categoryId: 4)
        let generalList: CentralListController = self.children[0] as! CentralListController
        generalList.lstCentral = movies
        generalList.delegate = self
        generalList.collectionCentralList.reloadData()
        generalList.refreshControl.endRefreshing()
    }
    
    func searchList(txtSearch: String){
        // Aqui va el llamado a la lista y su carga
        let movies = ModelDB.getSingleton().getMoviesCategories(txtSearch, categoryId: 4)
        let generalList: CentralListController = self.children[0] as! CentralListController
        generalList.lstCentral = movies
        generalList.delegate = self
        generalList.collectionCentralList.reloadData()
        generalList.refreshControl.endRefreshing()
    }
}


extension TopRatedController: ListenerGetCategories {
    func successGetCategories(_ response: Category) {
        self.categories.append(response)
        ModelDB.getSingleton().deleteCategoriesMovies(page: self.actualPage!, categoryId: 4)
        var index = 1
        for movie in response.results {
            ModelDB.getSingleton().addMovie(obj: movie)
            ModelDB.getSingleton().addCategoriesMovies(page: self.actualPage!, movieId: movie.id, categoryId: 4, order: index)
            index += 1
        }
        
        DispatchQueue.main.async {
            self.loadList()
        }
    }
    
    func failureGetCategories(_ loginError: String) {
        print(loginError)
    }
}

extension TopRatedController: CentralListProtocol {
    func endListLoadMoreData() {
        self.actualPage! += 1
        self.loadDataWS(inPage: self.actualPage!)
    }
    
    func pullToRefresh() {
        if Reachability.isConnectedToNetwork() {
            self.actualPage! = 1
            tools.writingPageTopRated(1)
            ModelDB.getSingleton().deleteCategoriesMovies(page: 0, categoryId: 4)
        }
        loadDataWS(inPage: actualPage!)
    }
}
