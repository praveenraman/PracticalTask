//
//  PhotoCell.swift
//  Battlebucks
//
//  Created by Praveen Kumar on 16/10/24.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var img: ImageViewHandler!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 4.0
    }
    
    func loadPoto(photo: PhotosData){
        if let photoUrl = photo.url {
            img.loadAsyncFrom(url: photoUrl, placeholder:  UIImage(named: "User"))
        }
    }

}
