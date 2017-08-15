//
//  VC+Drag.swift
//  DragDropAPI
//
//  Created by Harry Cao on 18/7/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

extension ViewController: UIDragInteractionDelegate {
  
  /**
   Get called first when we lift an item
   -> Return the list of items to be drag
   */
  func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    print("dragInteraction itemsForBeginning")
    let liftPoint = session.location(in: self.view)
    guard
      let liftImageView = self.view.hitTest(liftPoint, with: nil) as? UIImageView,
      let liftImage = liftImageView.image
    else {
      fatalError("can't get UIImage from liftPoint")
    }
    
    let itemProvider = NSItemProvider(object: liftImage)
    
    let dragItem = UIDragItem(itemProvider: itemProvider)
    /* Use `localObject` to attach additional information to
     * this drag item, visible only inside the app that started the drag.
     */
    dragItem.localObject = liftImageView
    
    return [dragItem]
  }
  
  
  /**
   Get called after itemForBeginning
   -> Rrturn a presentation of the target item (they are 2 different objects)
   */
  func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
    print("dragInteraction previewForLifting")
    
    /* Use `localObject` to attach additional information to
     * this drag item, visible only inside the app that started the drag.
     */
    guard let previewView = item.localObject as? UIView else {
      fatalError("can't get previewView at liftPoint")
    }
    
    return UITargetedDragPreview(view: previewView)
  }
  
  /**
   Get called after previewForBeginning
   -> While lifting, animate other things (like dim down the target view)
   NOTE: use animator.addAnimation and animator.addCompletion
   */
  func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
    print("dragInteraction willAnimateLiftWith")
    animator.addCompletion { position in
      if position == .end {
        for item in session.items {
          guard let liftImageView = item.localObject as? UIView else { return }
          liftImageView.alpha = 0.5
        }
      }
    }
  }
  
  /**
   Get called if the drag get cancelled (go to a cannceled View or go out of screen)
   HERE: we light up the target view again.
   */
  func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
    print("dragInteraction willAnimateCancelWith")
    guard let liftImageView = item.localObject as? UIView else { return }
    liftImageView.alpha = 1
  }
  
  /**
   Get called after willAnimatedDropWith: it means when the session done
   -> We check if the operation is not .move, we light up the target view again.
   */
  func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
    print("dragInteraction willEndWith")
    if operation != .move {
      for item in session.items {
        guard let liftImageView = item.localObject as? UIView else { return }
        liftImageView.alpha = 1
      }
    }
  }
}
