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
}
