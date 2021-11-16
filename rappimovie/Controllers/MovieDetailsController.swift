//
//  MovieDetailsController.swift
//  rappimovie
//
//  Created by Cesar Guasca on 13/11/21.
//

import Foundation
import UIKit
import youtube_ios_player_helper_swift
import MotionToastView

class MovieDetailsController: UIViewController {
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var imgGradient: UIImageView!
    @IBOutlet weak var vwPlayButton: UIView!
    @IBOutlet weak var lblTitleMovie: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var lblOverviewCns: NSLayoutConstraint!
    let movieApi:MovieApi = MovieApi()
    var movie: Movie?
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialView()
    }
    
    func initialView(){
        self.playerView.alpha = 0
        self.imgBanner.alpha = 1
        self.imgGradient.alpha = 1
        self.vwPlayButton.alpha = 1
        self.lblOverviewCns.constant = -128
        if let movie = movie {
            self.lblTitleMovie.text = movie.title
            self.lblOverview.text = movie.overview
            self.lblVote.text = "Vote: \(movie.voteAverage)/10 Total: \(movie.voteCount)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
            let date = dateFormatter.date(from: movie.releaseDate)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMM dd, yyyy"
            self.lblDate.text = dateFormatter2.string(from: date ?? Date())
        }
        
        if let imgOp = img {
            self.imgBanner.image = imgOp
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnShowTriller(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if let movie = movie {
                self.movieApi.listenerGetTrailers = self
                self.movieApi.getTrailers(movie: movie.id)
            }
        } else {
            self.MotionToast(message: "No internet connection", toastType: .warning, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
        }
    }

}

extension MovieDetailsController: ListenerGetTrailers {
    func successGetTrailers(_ response: Trailer) {
        if(response.results.count > 0) {
            let arr = response.results.filter({ $0.site == "YouTube" && $0.official && $0.type == "Trailer"}).first
            if let trailer = arr {
                DispatchQueue.main.async {
                    self.playerView.alpha = 1
                    self.imgBanner.alpha = 0
                    self.imgGradient.alpha = 0
                    self.vwPlayButton.alpha = 0
                    self.lblOverviewCns.constant = -250
                    let loadSucessfull = self.playerView.load(videoId: trailer.key)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                        if(loadSucessfull){
                            self.playerView.playVideo()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.MotionToast(message: "Trailer not found", toastType: .info, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.MotionToast(message: "Trailer not found", toastType: .info, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
            }
        }
    }
    
    func failureGetTrailers(_ loginError: String) {
        print(loginError)
        DispatchQueue.main.async {
            self.MotionToast(message: "No internet connection", toastType: .warning, duration: .short, toastStyle: .style_vibrant, toastGravity: .top, toastCornerRadius: 8, pulseEffect: true)
        }
    }
}
