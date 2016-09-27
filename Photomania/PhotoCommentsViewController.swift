//
//  PhotoCommentsViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-08-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCommentsViewController: UITableViewController {
  var photoID = 0
  var comments = [Comment]()
  
  // MARK: Life-Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50.0
    
    title = "Comments"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissController))
    
    Alamofire.request(Five100px.Router.comments(photoID, 1)).validate().responseCollection {
      (response: DataResponse<[Comment]>) in
      
      if let comments = response.result.value {
        self.comments = comments
      }
      
      self.tableView.reloadData()
    }
  }
  
  private dynamic func dismissController() {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - TableView
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? PhotoCommentTableViewCell else { return UITableViewCell() }
    
    cell.userFullnameLabel.text = comments[indexPath.row].userFullname
    cell.commentLabel.text = comments[indexPath.row].commentBody
    
    cell.userImageView.image = nil
    
    let imageURL = comments[indexPath.row].userPictureURL
    
    Alamofire.request(imageURL, method: .get).validate().responseImage {
      response in
      if let image = response.result.value, response.request?.url?.absoluteString == imageURL {
        cell.userImageView.image = image
      }
    }
  
    return cell
  }
}

class PhotoCommentTableViewCell: UITableViewCell {
  @IBOutlet fileprivate weak var userImageView: UIImageView!
  @IBOutlet fileprivate weak var commentLabel: UILabel!
  @IBOutlet fileprivate weak var userFullnameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    userImageView.layer.cornerRadius = 5.0
    userImageView.layer.masksToBounds = true
    
    commentLabel.numberOfLines = 0
  }
}
