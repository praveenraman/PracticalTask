//
//  DataResponse.swift
//  AssignmentTest
//
//  Created by Praveen Kumar on 03/05/24.
//

import Foundation
import RealmSwift

struct DataResponse: Decodable {
    var photo: [PhotosData]
}

struct PhotosData: Decodable{
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
}

struct AlbumData: Decodable{
    var userId: Int?
    var id: Int?
    var title: String?
}

class Album: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var userId: Int?
    @Persisted var title: String?
}

class Photos: Object{
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var albumId: Int?
    @Persisted var title: String?
    @Persisted var url: String?
    @Persisted var thumbnailUrl: String?
    
}
