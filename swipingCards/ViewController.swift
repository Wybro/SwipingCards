//
//  ViewController.swift
//  swipingCards
//
//  Created by Kyle Wybranowski on 3/26/17.
//  Copyright © 2017 com.Wybro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tileImageView: UIImageView!
    @IBOutlet var tileView: TileView!
    
    var animator: UIDynamicAnimator?
    
    var currentLocation: CGPoint?
    var attachment: UIAttachmentBehavior?
    
    var vertLock = false
    var horizLock = false
    
    let tileImages = [UIImage(named: "Blue"), UIImage(named: "Green"), UIImage(named: "Red"), UIImage(named: "Yellow")]

    var origin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origin = tileView.center
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let gravity = UIGravityBehavior(items: [tileImageView!])
        let vector = CGVector(dx: 0.0, dy: 1.0)
        gravity.gravityDirection = vector
        
        let collision = UICollisionBehavior(items: [tileImageView!])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        animator?.addBehavior(collision)
        animator?.addBehavior(gravity)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func panTile(_ sender: UIPanGestureRecognizer) {
        
        let tile = sender.view!
        let point = sender.translation(in: view)
        
        let deltaX = point.x
        let deltaY = point.y
        // Check which delta larger
        if abs(deltaX) > abs(deltaY) {
            if !vertLock {
                horizLock = true
                tile.center = CGPoint(x: view.center.x + point.x, y: origin.y)
            } else {
                tile.center = CGPoint(x: view.center.x, y: origin.y + point.y)
            }
        }
        
        // Move based on largest delta
        else {
            if !horizLock {
                vertLock = true
                tile.center = CGPoint(x: view.center.x, y: origin.y + point.y)
            } else {
                tile.center = CGPoint(x: view.center.x + point.x, y: origin.y)
            }
        }
        
        if deltaX == 0 {
            horizLock = false
        }
        if deltaY == 0 {
            vertLock = false
        }
        
    
        
        
        // Gesture ended
        if sender.state == UIGestureRecognizerState.ended {
            
            var newPos: CGPoint = self.origin
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.prepare()
//            generator.impactOccurred()
            
            // Check locks -- if locked, use position of tile
            if vertLock && abs(deltaY) > tileView.frame.width/4 {
                print("vert")
                newPos.y = origin.y + tile.center.y * 3 * deltaY/abs(deltaY)
                
            } else if horizLock && abs(deltaX) > tileView.frame.width/4 {
                print("horiz")
                newPos.x = origin.x + tile.center.x * 3 * deltaX/abs(deltaX)
            } else {
                print("else")
            }
            
            // Move horizontally
//            if  abs(deltaX) > abs(deltaY) && abs(deltaX) > tileView.frame.width/4  {
//                print("Far enough horiz")
//                newPos.x = origin.x + deltaX * 3
//                
//            }
//            // Move vertically
//            else if abs(deltaY) > abs(deltaX) && abs(deltaY) > tileView.frame.height/4 {
//                print("Far enough vert")
//                newPos.y = origin.y + deltaY * 3
//            }
            
            
            
            UIView.animate(withDuration: 0.4, animations: {
                tile.center = newPos
            }, completion: { (success) in
                // TODO: custom zone view (half of screen)
                if !self.view.bounds.contains(tile.frame) {
                   tile.center = self.origin
                    let rand = Int(arc4random_uniform(4))
                    let tileImage = self.tileImages[rand]
                    self.tileView.tileImageView.image = tileImage
                    
                    self.vertLock = false
                    self.horizLock = false
                    
                }

            })
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let theTouch = touches.first {
            currentLocation = theTouch.location(in: self.view)
            
            if tileImageView.frame.contains(currentLocation!) {
            
            attachment = UIAttachmentBehavior(item: tileImageView!,
                                              attachedToAnchor: currentLocation!)
            
            animator?.addBehavior(attachment!)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            
            currentLocation = theTouch.location(in: self.view)
            attachment?.anchorPoint = currentLocation!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if attachment != nil {
        animator?.removeBehavior(attachment!)
        }
    }

}

