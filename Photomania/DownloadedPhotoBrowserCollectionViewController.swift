//
//  DownloadedPhotoBrowserCollectionViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-01.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

class DownloadedPhotoBrowserCollectionViewController: UICollectionViewController {
  var downloadedPhotoURLs = [URL]()
  private let DownloadedPhotoBrowserCellIdentifier = "DownloadedPhotoBrowserCell"
  
  // MARK: Life-Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.bounds.width, height: 200.0)
    
    guard let collectionView = collectionView else { return }
    collectionView.collectionViewLayout = layout
    
    collectionView.register(DownloadedPhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: DownloadedPhotoBrowserCellIdentifier)
    
    let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 30.0))
    titleLabel.text = "Photomania"
    titleLabel.textColor = .white
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    navigationItem.titleView = titleLabel
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
      let urls = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
      
      downloadedPhotoURLs = urls
      collectionView?.reloadData()
    } catch let error as NSError {
      print(error)
    }
  }
  
  // MARK: CollectionView
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return downloadedPhotoURLs.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadedPhotoBrowserCellIdentifier, for: indexPath) as? DownloadedPhotoBrowserCollectionViewCell,
      let localFileData = FileManager.default.contents(atPath: downloadedPhotoURLs[indexPath.item].path)
      else { return UICollectionViewCell() }
    
    let image = UIImage(data: localFileData, scale: UIScreen.main.scale)
    
    cell.imageView.image = image
    
    return cell
  }
}

class DownloadedPhotoBrowserCollectionViewCell: UICollectionViewCell {
  fileprivate let imageView = UIImageView()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(imageView)
    imageView.frame = bounds
    imageView.contentMode = .scaleAspectFit
  }
}
