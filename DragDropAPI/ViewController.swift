//
//  ViewController.swift
//  DragDropAPI
//
//  Created by Harry Cao on 18/7/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(removeSubviews))
    
    self.view.addInteraction(UIDropInteraction(delegate: self))
    self.view.addInteraction(UIDragInteraction(delegate: self))
  }
  
  @objc func removeSubviews() {
    for subview in self.view.subviews {
      subview.removeFromSuperview()
    }
  }
  
  // Add a given UIImage to centerPoint
  func loadImage(_ image: UIImage, center: CGPoint) {
    let imageView = UIImageView(image: image)
    imageView.frame = CGRect(origin: .zero, size: image.size)
    imageView.center = center
    imageView.isUserInteractionEnabled = true
    self.view.addSubview(imageView)
  }
}

