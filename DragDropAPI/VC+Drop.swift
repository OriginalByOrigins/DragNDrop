//
//  VC+Drop.swift
//  DragDropAPI
//
//  Created by Harry Cao on 18/7/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

extension ViewController: UIDropInteractionDelegate {
  /**
   Get called first when the the delegate detect a drop session
   -> Determine we recieve certain type of object
   */
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    print("dropInteraction canHandle")
    return session.canLoadObjects(ofClass: UIImage.self)
  }
  
  /**
   Get called right after canHandle
   */
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
    print("dropInteraction sessionDidEnter")
  }
  
  /**
   Get called everytime we move the drag items arround
   -> Return a drop proposal to determine if the type of operation
   */
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    let operation: UIDropOperation
    
    if session.localDragSession == nil {
      // From another app
      operation = .copy
    } else {
      operation = .move
    }
    
    return UIDropProposal(operation: operation)
  }
  
  /**
   Perform the drop
   -> get the image from item and add it to the dropPoint
   */
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    print("dropInteraction preformDrop")
    
    for item in session.items {
      item.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
        if error != nil {
          fatalError("can't load NSItemProviderReading")
        }
        
        let dropPoint = session.location(in: self.view)
        guard let image = object as? UIImage else {
          fatalError("can't load image from NSItemProviderReading")
        }
        
        DispatchQueue.main.async {
          self.loadImage(image, center: dropPoint)
        }
      })
    }
  }
  
  /**
   Get called after call performDrop
   -> animate something with the drop animation
   HERE: -> we check if the item has a localObject(drag from current App) -> we remove the localObject (old view) from its superView
   */
  func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
    print("dropInteraction willAnimateDropWith")
    guard let imageView = item.localObject as? UIView else { return }
    imageView.removeFromSuperview()
  }
}
