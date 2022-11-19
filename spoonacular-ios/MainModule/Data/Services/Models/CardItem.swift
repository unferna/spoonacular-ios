//
//  CardItem.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 19/11/22.
//

import Foundation

struct CardItem: Codable {
    var id: String
    var title: String?
    var image: String?
    var imageType: String?
    var isSaved = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let stringId = try? container.decodeIfPresent(String.self, forKey: .id) {
            self.id = stringId
            
        } else {
            let intId = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
            self.id = String(intId)
        }
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.imageType = try container.decodeIfPresent(String.self, forKey: .imageType)
    }
    
    init(id: String, title: String?, image: String?, imageType: String?, isSaved: Bool = false) {
        self.id = id
        self.title = title
        self.image = image
        self.imageType = imageType
        self.isSaved = isSaved
    }
}
