//
//  ProgressIndicatorView.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-01.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
  override class func layerClass() -> AnyClass {
    return CAShapeLayer.classForCoder()
  }
  
  let labelLayer = CATextLayer()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let layer = self.layer as! CAShapeLayer
    
    let path = CGPathCreateWithEllipseInRect(self.bounds, nil)
    
    layer.path = path
    layer.strokeColor = UIColor.whiteColor().CGColor
    layer.lineWidth = 5.0
    layer.strokeEnd = 0.0
    layer.fillColor = UIColor(white: 0.5, alpha: 0.7).CGColor
    
    layer.addSublayer(labelLayer)
    labelLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 50.0)
    labelLayer.position = layer.position
    labelLayer.alignmentMode = kCAAlignmentCenter
    labelLayer.string = "0%"
  }
  
  var progress: Float = 0.0 {
    willSet {
      let layer = self.layer as! CAShapeLayer
      labelLayer.string = NSString(format: "%.0f%%", newValue * 100)
      layer.strokeEnd = CGFloat(newValue)
    }
  }
}
