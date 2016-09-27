//
//  Five100px.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

struct Five100px {
  enum ImageSize: Int {
    case tiny = 1
    case small = 2
    case medium = 3
    case large = 4
    case xLarge = 5
  }
  
  enum Category: Int, CustomStringConvertible {
    case uncategorized = 0, celebrities, film, journalism, nude, blackAndWhite, stillLife, people, landscapes, cityAndArchitecture, abstract, animals, macro, travel, fashion, commercial, concert, sport, nature, performingArts, family, street, underwater, food, fineArt, wedding, transportation, urbanExploration
    
    var description: String {
      get {
        switch self {
        case .uncategorized: return "Uncategorized"
        case .celebrities: return "Celebrities"
        case .film: return "Film"
        case .journalism: return "Journalism"
        case .nude: return "Nude"
        case .blackAndWhite: return "Black And White"
        case .stillLife: return "Still Life"
        case .people: return "People"
        case .landscapes: return "Landscapes"
        case .cityAndArchitecture: return "City And Architecture"
        case .abstract: return "Abstract"
        case .animals: return "Animals"
        case .macro: return "Macro"
        case .travel: return "Travel"
        case .fashion: return "Fashion"
        case .commercial: return "Commercial"
        case .concert: return "Concert"
        case .sport: return "Sport"
        case .nature: return "Nature"
        case .performingArts: return "Performing Arts"
        case .family: return "Family"
        case .street: return "Street"
        case .underwater: return "Underwater"
        case .food: return "Food"
        case .fineArt: return "Fine Art"
        case .wedding: return "Wedding"
        case .transportation: return "Transportation"
        case .urbanExploration: return "Urban Exploration"
        }
      }
    }
  }
}

struct PhotoInfo {
  let id: Int
  let url: String
  
  var name: String?
  
  var favoritesCount: Int?
  var votesCount: Int?
  var commentsCount: Int?
  
  var highest: Float?
  var pulse: Float?
  var views: Int?
  var camera: String?
  var focalLength: String?
  var shutterSpeed: String?
  var aperture: String?
  var iso: String?
  var category: Five100px.Category?
  var taken: String?
  var uploaded: String?
  var desc: String?
  
  var username: String?
  var fullname: String?
  var userPictureURL: String?
  
  init(id: Int, url: String) {
    self.id = id
    self.url = url
  }
  
  init?(response: HTTPURLResponse, representation: Any) {
    let representation = representation as AnyObject
    guard let photoID = representation.value(forKeyPath: "photo.id") as? Int,
      let photoURL = representation.value(forKeyPath: "photo.image_url") as? String else { return nil }
    id = photoID
    url = photoURL
    
    favoritesCount = representation.value(forKeyPath: "photo.favorites_count") as? Int
    votesCount = representation.value(forKeyPath: "photo.votes_count") as? Int
    commentsCount = representation.value(forKeyPath: "photo.comments_count") as? Int
    highest = representation.value(forKeyPath: "photo.highest_rating") as? Float
    pulse = representation.value(forKeyPath: "photo.rating") as? Float
    views = representation.value(forKeyPath: "photo.times_viewed") as? Int
    camera = representation.value(forKeyPath: "photo.camera") as? String
    focalLength = representation.value(forKeyPath: "photo.focal_length") as? String
    shutterSpeed = representation.value(forKeyPath: "photo.shutter_speed") as? String
    aperture = representation.value(forKeyPath: "photo.aperture") as? String
    iso = representation.value(forKeyPath: "photo.iso") as? String
    taken = representation.value(forKeyPath: "photo.taken_at") as? String
    uploaded = representation.value(forKeyPath: "photo.created_at") as? String
    desc = representation.value(forKeyPath: "photo.description") as? String
    name = representation.value(forKeyPath: "photo.name") as? String
    
    username = representation.value(forKeyPath: "photo.user.username") as? String
    fullname = representation.value(forKeyPath: "photo.user.fullname") as? String
    userPictureURL = representation.value(forKeyPath: "photo.user.userpic_url") as? String
  }
}

extension PhotoInfo: Equatable {
  static func ==(lhs: PhotoInfo, rhs: PhotoInfo) -> Bool {
    return lhs.id == rhs.id
  }
}

extension PhotoInfo: Hashable {
  var hashValue: Int {
    return id
  }
}

struct Comment {
  let userFullname: String
  let userPictureURL: String
  let commentBody: String
  
  init?(JSON: AnyObject) {
    guard let fullname = JSON.value(forKeyPath: "user.fullname") as? String,
      let pictureURL = JSON.value(forKeyPath: "user.userpic_url") as? String,
      let body = JSON.value(forKeyPath: "body") as? String else { return nil }
    userFullname = fullname
    userPictureURL = pictureURL
    commentBody = body
  }
}
