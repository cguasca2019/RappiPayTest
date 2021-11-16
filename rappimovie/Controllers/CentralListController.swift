//
//  CentralListController.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation
import UIKit


class CentralListController: UIViewController {
    @IBOutlet weak var collectionCentralList: UICollectionView!
    var lstCentral: [Movie] = []
    let tools = Tools.shared
    var delegate: CentralListProtocol?
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialView()
    }
    
    func initialView(){
        self.collectionCentralList.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionCentralList.addSubview(refreshControl) // not required when using UITableViewController
        
        
    }
    
    func goDetails(oMovie: Movie, imagIn: UIImage?)  {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsController") as! MovieDetailsController
        secondVC.modalPresentationStyle = .custom
        secondVC.transitioningDelegate = self
        secondVC.movie = oMovie
        secondVC.img = imagIn
        
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.delegate?.pullToRefresh()
    }
}


extension CentralListController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lstCentral.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CentralListCell", for: indexPath as IndexPath) as! CentralListCell
        cell.imgMovie.roundCorners([.topLeft, .topRight], radius: 16)
        let movieSel = self.lstCentral[indexPath.row]
        cell.lblTitleMovie.text = movieSel.title
        cell.lblAprobation.text = String(movieSel.voteAverage * 10) + "%"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        let date = dateFormatter.date(from: movieSel.releaseDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM dd, yyyy"
        cell.lblReleaseDate.text = dateFormatter2.string(from: date ?? Date())
        
        cell.cncAprobation = cell.cncAprobation.setMultiplier(multiplier: movieSel.voteAverage == 0 ? 0.01 : movieSel.voteAverage / 10)
        
        if let posterPath = movieSel.posterPath {
            let url = URL(string: tools.getUrlImages() + posterPath)!
            CachedImages().loadData(url: url) { (data, error) in
                DispatchQueue.main.async {
                    if let dataOk = data {
                        cell.imgMovie.image = UIImage(data: dataOk)
                    }
                }
            }
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: 160.0, height: 322.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieSel = self.lstCentral[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? CentralListCell else {
                // couldn't get the cell for some reason
                return
            }
        self.goDetails(oMovie: movieSel, imagIn: cell.imgMovie.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! ReusableFooter
            footerView.btnSeeMore.addTarget(self, action: #selector(self.buttonTouched), for: .touchUpInside)
            return footerView

        default:

            assert(false, "Unexpected element kind")
        }
    }
    
    @objc func buttonTouched(sender:UIButton!){
        delegate?.endListLoadMoreData()
    }
    
}


extension CentralListController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
