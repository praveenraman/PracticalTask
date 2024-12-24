//
//  AlbmTableViewCell.swift
//  Practical Task
//
//  Created by Praveen Kumar on 24/12/24.
//

import UIKit

class AlbmTableViewCell: UITableViewCell {

    @IBOutlet weak var almbTitle: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    var photoData = [PhotosData]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configeCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configeCollectionView(){
        self.photoCollection.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        photoCollection.collectionViewLayout = layout
        self.photoCollection.isPagingEnabled = true
        
    }
    
    func loadData(albumData: AlbumData, photoData: [PhotosData]){
        almbTitle.text = albumData.title?.localizedCapitalized ?? ""
        self.photoData = photoData
        photoCollection.reloadData()
    }
}

extension AlbmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as? PhotoCell else{
            return UICollectionViewCell()
        }
        cell.loadPoto(photo: photoData[indexPath.row])
        return cell
    }
}

extension AlbmTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3
        return CGSize(width: width, height: 200)
    }
}
