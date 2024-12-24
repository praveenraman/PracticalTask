//
//  LocalDatabase.swift
//  Practical Task
//
//  Created by Praveen Kumar on 24/12/24.
//

import Foundation
import RealmSwift

struct LocalDatabase {

    func saveAlbumsToRealm( apiAlbums: [AlbumData]){
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
    
    func fetchAlbumsFromRealm(page: Int, pageSize: Int)->[AlbumData]{
        do {
            let startIndex = page * pageSize
            let realm = try Realm()
            let albums = realm.objects(Album.self)
                .sorted(byKeyPath: "id")
                .suffix(from: startIndex)
                .prefix(pageSize)
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
    
    func fetchPhotoFromRealm()->[PhotosData]{
        do {
            let realm = try Realm()
            let photo = realm.objects(Photos.self)
            let albArray = Array(photo) // Convert Results<Album> to [Album]
            
            let alm = albArray.map { albArray -> PhotosData in
                var data = PhotosData()
                data.id = albArray.id
                data.albumId = albArray.albumId
                data.title = albArray.title
                data.url = albArray.url
                data.thumbnailUrl = albArray.thumbnailUrl
                return data
            }
            return alm
        }catch{
            print("Error fetching albums from Realm: \(error.localizedDescription)")
            return []
        }
    }
}
