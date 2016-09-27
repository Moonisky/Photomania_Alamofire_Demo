//
//  PhotoDetailsViewController.swift
//  Photomania
//
//  Created by Essan Parto on 2014-08-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
  @IBOutlet fileprivate weak var highestLabel: UILabel!
  @IBOutlet fileprivate weak var pulseLabel: UILabel!
  @IBOutlet fileprivate weak var viewsLabel: UILabel!
  @IBOutlet fileprivate weak var cameraLabel: UILabel!
  @IBOutlet fileprivate weak var focalLengthLabel: UILabel!
  @IBOutlet fileprivate weak var shutterSpeedLabel: UILabel!
  @IBOutlet fileprivate weak var apertureLabel: UILabel!
  @IBOutlet fileprivate weak var isoLabel: UILabel!
  @IBOutlet fileprivate weak var categoryLabel: UILabel!
  @IBOutlet fileprivate weak var takenLabel: UILabel!
  @IBOutlet fileprivate weak var uploadedLabel: UILabel!
  @IBOutlet fileprivate weak var descriptionLabel: UILabel!
  
  var photoInfo: PhotoInfo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    view.addGestureRecognizer(tapGesture)
    
    highestLabel.text = String(format: "%.1f", photoInfo?.highest ?? 0)
    pulseLabel.text = String(format: "%.1f", photoInfo?.pulse ?? 0)
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
  
  private dynamic func dismissController() {
    dismiss(animated: true, completion: nil)
  }
}
