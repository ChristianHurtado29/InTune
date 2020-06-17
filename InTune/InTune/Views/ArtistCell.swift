//
//  ArtistCell.swift
//  InTune
//
//  Created by Tiffany Obi on 6/4/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var postStatusLabel: UILabel!
    
    
    public func configureFavArtistCell(favArtist:FavoritedArtist){
        imageView.image = UIImage(systemName: "photo.fill")
        
        displayNameLabel.text = favArtist.favArtistName
        locationLabel.text = favArtist.favArtistLocation
        
    }
    
}
