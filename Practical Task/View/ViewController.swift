//
//  ViewController.swift
//  Practical Task
//
//  Created by Praveen Kumar on 24/12/24.
//

import UIKit
import SVPullToRefresh
import RealmSwift


class ViewController: UIViewController {
    var currentStep: String?
    var albumData = [AlbumData]()
    var photoData = [PhotosData]()
    
    var currentPage = 0
    let pageSize = 4
    var isLoading = false
    
    @IBOutlet weak var listTable: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Photo Album"
        listTable.register(UINib(nibName: "AlbmTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbmTableViewCell")
        if NetworkManager.shared.isNetworkAvailable() {
            print("Internet connection available. Fetching data from API.")
            loadApiData()
        } else {
            print("No internet connection. Loading local data.")
            loadPage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }

    func loadPage(){
        guard !isLoading else { return }
        isLoading = true
        let newAlbums = LocalDatabase().fetchAlbumsFromRealm(page: currentPage, pageSize: pageSize)
        self.photoData = LocalDatabase().fetchPhotoFromRealm()
        if newAlbums.isEmpty{
            isLoading = false
            return
        }
        albumData.append(contentsOf: newAlbums)
        currentPage += 1
        isLoading = false
        listTable.reloadData()
    }
    
    func loadApiData(){
        DataManager().getAlbumResponse(url: "https://jsonplaceholder.typicode.com/albums"){ result in
            switch result {
            case .success(let data):
                self.albumData.removeAll()
                self.albumData = data
                self.loadPhotoData()
                LocalDatabase().saveAlbumsToRealm(apiAlbums: self.albumData)
                DispatchQueue.main.async{
                    self.listTable.reloadData()
                }
                if self.isLoading == true {
                    DispatchQueue.main.async{
                        self.listTable.infiniteScrollingView.stopAnimating()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    Common.showAlert(title: "Alert!", message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
    
    func loadPhotoData(){
        DataManager().getPhotoResponse(url: "https://jsonplaceholder.typicode.com/photos"){ result in
            switch result {
            case .success(let data):
                self.photoData.removeAll()
                for pData in data{
                    self.photoData.append(pData)
                }
                LocalDatabase().savePhotoToRealm(apiPhoto: self.photoData)
            case .failure(let error):
                DispatchQueue.main.async{
                    print(error)
                }
            }
        }
    }
    
    func photoByAlbum(albumData: AlbumData)->[PhotosData]{
        let filteredPhotos = self.photoData.filter { $0.albumId == albumData.id }
        return filteredPhotos
        
    }
    
    func saveAlbumsToRealm(apiAlbums: [AlbumData]){
        do {
            let realm = try Realm()
            try realm.write {
                let realmAlbums = apiAlbums.map { apiAlbum -> Album in
                    let album = Album()
                    album.id = apiAlbum.id
                    album.userId = apiAlbum.userId
                    album.title = apiAlbum.title
                    return album
                }
                realm.add(realmAlbums, update: .modified) // Update if primary key matches
            }
            print("Albums saved to Realm successfully.")
        } catch {
            print("Error saving albums to Realm: \(error.localizedDescription)")
        }
    }
    
    func savePhotoToRealm(apiPhoto: [PhotosData]){
        do {
            let realm = try Realm()
            try realm.write {
                let realmPhotos = apiPhoto.map { apiPhoto -> Photos in
                    let photo = Photos()
                    photo.id = apiPhoto.id
                    photo.albumId = apiPhoto.albumId
                    photo.title = apiPhoto.title
                    photo.url = apiPhoto.url
                    photo.thumbnailUrl = apiPhoto.thumbnailUrl
                    return photo
                }
                realm.add(realmPhotos, update: .modified) // Update if primary key matches
            }
            print("Photos saved to Realm successfully.")
        } catch {
            print("Error saving albums to Realm: \(error.localizedDescription)")
        }
    }
    
    func fetchAlbumsFromRealm() -> [AlbumData] {
        do {
            let realm = try Realm()
            let albums = realm.objects(Album.self)
            let albArray = Array(albums) // Convert Results<Album> to [Album]
            
            let alm = albArray.map { albArray -> AlbumData in
                var almData = AlbumData()
                almData.id = albArray.id
                almData.userId = albArray.userId
                almData.title = albArray.title
                return almData
            }
            return alm
        } catch {
            print("Error fetching albums from Realm: \(error.localizedDescription)")
            return []
        }
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTable.dequeueReusableCell(withIdentifier: "AlbmTableViewCell", for: indexPath) as? AlbmTableViewCell else{
            return UITableViewCell()
        }
        let photos = photoByAlbum(albumData: albumData[indexPath.row])
        cell.loadData(albumData: albumData[indexPath.row], photoData: photos)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if NetworkManager.shared.isNetworkAvailable(){
            print("Internet connection available. Fetching data from API.")
        } else {
            print("No internet connection. Loading local data.")
            if indexPath.row == albumData.count - 1 {
                loadPage()
            }
        }
    }
}
