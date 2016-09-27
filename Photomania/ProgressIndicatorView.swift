//
//  ProgressIndicatorView.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-01.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
  override class var layerClass : AnyClass {
    return CAShapeLayer.classForCoder()
  }
  
  let labelLayer = CATextLayer()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    guard let layer = self.layer as? CAShapeLayer else { fatalError("The layer of Progress Indicator View isn't the CAShapreLayer") }
    
    let path = CGPath(ellipseIn: bounds, transform: nil)
    
    layer.path = path
    layer.strokeColor = UIColor.white.cgColor
    layer.lineWidth = 5.0
    layer.strokeEnd = 0.0
    layer.fillColor = UIColor(white: 0.5, alpha: 0.7).cgColor
    
    layer.addSublayer(labelLayer)
    labelLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: 50.0)
    labelLayer.position = layer.position
    labelLayer.alignmentMode = kCAAlignmentCenter
    labelLayer.string = "0%"
  }
  
  var progress: Float = 0.0 {
    willSet {
      guard let layer = self.layer as? CAShapeLayer else { fatalError("The layer of Progress Indicator View isn't the CAShapreLayer") }
      labelLayer.string = String(format: "%.0f%%", newValue * 100)
      layer.strokeEnd = CGFloat(newValue)
    }
  }
}
