//
//  DataManager.swift
//  AssignmentTest
//
//  Created by Praveen Kumar on 03/05/24.
//

import Foundation

struct DataManager {
    
    func getPhotoResponse( url: String, completionHandle: @escaping(Result<[PhotosData], DemoError>) -> Void){
        guard let url = URL(string: url) else {
            return completionHandle(.failure(.BadUrl))
        }
        APIManager().getApiData(url: url, type: [PhotosData].self, completion: completionHandle)
    }
    
    func getAlbumResponse( url: String, completionHandle: @escaping(Result<[AlbumData], DemoError>) -> Void){
        guard let url = URL(string: url) else {
            return completionHandle(.failure(.BadUrl))
        }
        APIManager().getApiData(url: url, type: [AlbumData].self, completion: completionHandle)
    }
}
