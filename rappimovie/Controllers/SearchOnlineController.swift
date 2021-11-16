//
//  SearchOnlineController.swift
//  rappimovie
//
//  Created by Cesar Guasca on 14/11/21.
//

import Foundation
import UIKit

class SearchOnlineController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vwNoDataFound: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    
    var movies: [Movie] = []
    let movieApi:MovieApi = MovieApi()
    let tools = Tools.shared
    var pageNumber = 1
    var strSearch = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialView()
    }
    
    func initialView(){
        searchBar.delegate = self
        //Looks for single or multiple taps
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let searchGif = UIImage.gifImageWithName("search")
        self.imgSearch.image = searchGif
        
        self.tblSearch.alpha = 0
        self.vwNoDataFound.alpha = 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            view.endEditing(true)
            self.strSearch = searchBar.text ?? ""
            self.tblSearch.alpha = 0
            self.vwNoDataFound.alpha = 1
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.pageNumber = 1
        self.movies = []
        if(searchBar.text != ""){
            self.strSearch = searchBar.text ?? ""
            if Reachability.isConnectedToNetwork() {
                self.movieApi.listenerGetCategories = self
                self.movieApi.getSearchMovies(page: pageNumber, query: searchBar.text!)
            } else {
                self.MotionToast(message: "No internet connection", toastType: .warning, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
            }
        } else {
            self.tblSearch.alpha = 0
            self.vwNoDataFound.alpha = 1
        }
        
        view.endEditing(true)
    }
    
    func goDetails(oMovie: Movie, imagIn: UIImage?)  {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsController") as! MovieDetailsController
        secondVC.modalPresentationStyle = .custom
        secondVC.transitioningDelegate = self
        secondVC.movie = oMovie
        secondVC.img = imagIn
        
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func seeMore(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            self.pageNumber += 1
            self.movieApi.listenerGetCategories = self
            self.movieApi.getSearchMovies(page: pageNumber, query: self.strSearch)
        } else {
            self.MotionToast(message: "No internet connection", toastType: .warning, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchOnlineController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.movies.count == 0){
            self.tblSearch.alpha = 0
            self.vwNoDataFound.alpha = 1
        } else {
            self.tblSearch.alpha = 1
            self.vwNoDataFound.alpha = 0
        }
        
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchOnlineCell", for: indexPath as IndexPath) as! SearchOnlineCell
        let movieSel = movies[indexPath.row]
        cell.lblTitleMovie.text = movieSel.title
        cell.lblOverviewMovie.text = movieSel.overview
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        let date = dateFormatter.date(from: movieSel.releaseDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM dd, yyyy"
        cell.lblDateMovie.text = dateFormatter2.string(from: date ?? Date())
        if let posterPath = movieSel.posterPath {
            let url = URL(string: tools.getUrlImages() + posterPath)!
            cell.imgMovie.load(url: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieSel = self.movies[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchOnlineCell else {
                // couldn't get the cell for some reason
                return
            }
        self.goDetails(oMovie: movieSel, imagIn: cell.imgMovie.image)
    }
}

extension SearchOnlineController: ListenerGetCategories {
    func successGetCategories(_ response: Category) {
        if(self.movies.count > 0){
            self.movies += response.results
        } else {
            self.movies = response.results
        }
        
        DispatchQueue.main.async {
            self.tblSearch.reloadData()
        }
    }
    
    func failureGetCategories(_ loginError: String) {
        print(loginError)
    }
}

extension SearchOnlineController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
