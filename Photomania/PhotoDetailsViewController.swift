//
//  PhotoDetailsViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-08-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
  @IBOutlet weak var highestLabel: UILabel!
  @IBOutlet weak var pulseLabel: UILabel!
  @IBOutlet weak var viewsLabel: UILabel!
  @IBOutlet weak var cameraLabel: UILabel!
  @IBOutlet weak var focalLengthLabel: UILabel!
  @IBOutlet weak var shutterSpeedLabel: UILabel!
  @IBOutlet weak var apertureLabel: UILabel!
  @IBOutlet weak var isoLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var takenLabel: UILabel!
  @IBOutlet weak var uploadedLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  
  var photoInfo: PhotoInfo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: "dismiss")
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    view.addGestureRecognizer(tapGesture)
    
    highestLabel.text = NSString(format: "%.1f", photoInfo?.highest ?? 0) as String
    pulseLabel.text = NSString(format: "%.1f", photoInfo?.pulse ?? 0) as String
    viewsLabel.text = "\(photoInfo?.views ?? 0)"
    cameraLabel.text = photoInfo?.camera
    focalLengthLabel.text = photoInfo?.focalLength
    shutterSpeedLabel.text = photoInfo?.shutterSpeed
    apertureLabel.text = photoInfo?.aperture
    isoLabel.text = photoInfo?.iso
    categoryLabel.text = photoInfo?.category?.description
    takenLabel.text = photoInfo?.taken
    uploadedLabel.text = photoInfo?.uploaded
    descriptionLabel.text = photoInfo?.desc
  }
  
  func dismiss() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
