//
//  PhotoBrowserCollectionViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-08-20.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var photos = Set<PhotoInfo>()
  
  private let refreshControl = UIRefreshControl()
  
  private let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
  private let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
  
  // MARK: Life-cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    Alamofire.request("https://api.500px.com/v1/photos", method: .get, parameters: ["consumer_key": "HVhSQ8stAClpTASwePsvjFurYn1P3wo7XMPLyWPt"]).responseJSON {
      response in
      guard let JSON = response.result.value else { return }
      guard let photoJsons = (JSON as AnyObject).value(forKey: "photos") as? [NSDictionary] else { return }
      
      photoJsons.forEach {
        guard let nsfw = $0["nsfw"] as? Bool,
          let id = $0["id"] as? Int,
          let url = $0["image_url"] as? String,
          nsfw == false else { return }
        self.photos.insert(PhotoInfo(id: id, url: url))
      }
      
      self.collectionView?.reloadData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: CollectionView
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellIdentifier, for: indexPath) as? PhotoBrowserCollectionViewCell else { return UICollectionViewCell() }
    
    let photoInfo = photos[photos.index(photos.startIndex, offsetBy: indexPath.item)]
    
    Alamofire.request(photoInfo.url, method: .get).response {
      dataResponse in
      guard let data = dataResponse.data else { return }
      let image = UIImage(data: data)
      cell.imageView.image = image
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, for: indexPath)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ShowPhoto", sender: photos[photos.index(photos.startIndex, offsetBy: indexPath.item)].id)
  }
  
  // MARK: Helper
  
  private func setupView() {
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    guard let collectionView = collectionView else { return }
    let layout = UICollectionViewFlowLayout()
    let itemWidth = (view.bounds.width - 2) / 3
    layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    layout.minimumInteritemSpacing = 1
    layout.minimumLineSpacing = 1
    layout.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 100)
    
    collectionView.collectionViewLayout = layout
    
    let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
    titleLabel.text = "Photomania"
    titleLabel.textColor = .white
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    navigationItem.titleView = titleLabel
    
    collectionView.register(PhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
    collectionView.register(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
    
    refreshControl.tintColor = .white
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView.addSubview(refreshControl)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? PhotoViewerViewController, let id = sender as? Int, segue.identifier == "ShowPhoto" {
      destination.photoID = id
      destination.hidesBottomBarWhenPushed = true
    }
  }
  
  private dynamic func handleRefresh() {
    
  }
}

fileprivate class PhotoBrowserCollectionViewCell: UICollectionViewCell {
  fileprivate let imageView = UIImageView()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(white: 0.1, alpha: 1.0)
    
    imageView.frame = bounds
    addSubview(imageView)
  }
}

fileprivate class PhotoBrowserCollectionViewLoadingCell: UICollectionReusableView {
  fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    spinner.startAnimating()
    spinner.center = center
    addSubview(spinner)
  }
}
