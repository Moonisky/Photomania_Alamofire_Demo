//
//  Five100px.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

enum BackendError: Error {
  case network(error: Error)
  case dataSerialization(error: Error)
  case jsonSerialization(error: Error)
  case objectSerialization(error: String)
  case imageSerialization(error: String)
}

protocol ResponseObjectSerializable {
  init?(response: HTTPURLResponse, representation: Any)
}

extension DataRequest {
  @discardableResult
  func responseObject<T: ResponseObjectSerializable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
    let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
      guard error == nil else { return .failure(BackendError.network(error: error!)) }
      
      let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
      let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
      
      guard case let .success(jsonObject) = result else {
        return .failure(BackendError.jsonSerialization(error: result.error!))
      }
      
      guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
        let reason = "Response object could not be serialized due to nil response."
        return .failure(BackendError.objectSerialization(error: reason))
      }
      
      return .success(responseObject)
    }
    
    return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
  }
}

extension DataRequest {
  static func imageResponseSerializer() -> DataResponseSerializer<UIImage> {
    return DataResponseSerializer { request, response, data, error in
      guard error == nil else { return .failure(BackendError.network(error: error!)) }

      let result = Request.serializeResponseData(response: response, data: data, error: nil)
      
      guard case let .success(validData) = result else {
        return .failure(BackendError.dataSerialization(error: result.error as! AFError))
      }
      
      guard let image = UIImage(data: validData, scale: UIScreen.main.scale) else {
        return .failure(BackendError.imageSerialization(error: "数据无法被序列化，因为接收到的数据为空"))
      }
      
      return .success(image)
    }
  }
  
  @discardableResult
  func responseImage(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UIImage>) -> Void) -> Self {
    return response(queue: queue, responseSerializer: DataRequest.imageResponseSerializer(), completionHandler: completionHandler)
  }
}

protocol ResponseCollectionSerializable {
  static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

extension DataRequest {
  @discardableResult
  func responseCollection<T: ResponseCollectionSerializable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
    let responseSerializer = DataResponseSerializer<[T]> {
      request, response, data, error in
      guard error == nil else { return .failure(BackendError.network(error: error!)) }
      
      let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
      let result = jsonSerializer.serializeResponse(request, response, data, nil)
      
      guard case let .success(jsonObject) = result else {
        return .failure(BackendError.jsonSerialization(error: result.error!))
      }
      
      guard let response = response else {
        let reason = "Response collection could not be serialized due to nil response."
        return .failure(BackendError.objectSerialization(error: reason))
      }
      
      return .success(T.collection(from: response, withRepresentation: jsonObject))
    }
    
    return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
  }
}

struct Five100px {
  
  enum Router: URLRequestConvertible {
    static let baseURLString = "https://api.500px.com/v1"
    static let consumerKey = "HVhSQ8stAClpTASwePsvjFurYn1P3wo7XMPLyWPt"
    
    case popularPhotos(Int)
    case photoInfo(Int, ImageSize)
    case comments(Int, Int)
    
    func asURLRequest() throws -> URLRequest {
      let result: (path: String, parameters: Parameters) = {
        switch self {
        case .popularPhotos(let page):
          let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
          return ("/photos", params)
        case .photoInfo(let photoID, let imageSize):
          let params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
          return ("/photos/\(photoID)", params)
        case .comments(let photoID, let commentsPage):
          let params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
          return ("/photos/\(photoID)/comments", params)
        }
      }()
      
      let url = try Router.baseURLString.asURL()
      let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
      
      return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
  }
  
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

extension PhotoInfo: ResponseObjectSerializable { }

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

extension Comment: ResponseCollectionSerializable {
  static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Comment] {
    var comments = [Comment]()
    
    guard let represences = (representation as AnyObject).value(forKey: "comments") as? [[String: Any]] else { return comments }
    represences.forEach {
      if let comment = Comment(JSON: $0 as AnyObject) {
        comments.append(comment)
      }
    }
    
    return comments
  }
}
