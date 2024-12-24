//
//  AppUrls.swift
//  DogBreed
//
//  Created by Praveen Kumar on 09/07/24.
//

import Foundation

//https://jsonplaceholder.typicode.com/photos

class Urls {
    
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    class func photosUrl() -> String {
        return baseURL + "/photos"
    }
}
