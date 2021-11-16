//
//  CentralListCell.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation
import UIKit
class CentralListCell: UICollectionViewCell {
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblTitleMovie: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblAprobation: UILabel!
    @IBOutlet weak var cncAprobation: NSLayoutConstraint!
}
