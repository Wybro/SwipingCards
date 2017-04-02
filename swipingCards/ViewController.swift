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
    @IBOutlet var regionView: RegionView!
    
    var animator: UIDynamicAnimator?
    
    var currentLocation: CGPoint?
    var attachment: UIAttachmentBehavior?
    
    var vertLock = false
    var horizLock = false
    
    let tileImages = [UIImage(named: "Blue"), UIImage(named: "Green"), UIImage(named: "Red"), UIImage(named: "Yellow")]
    
    let red = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let blue = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let green = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let yellow = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

    var origin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origin = tileView.center
        
        setupGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGame() {
        // Set the color & ID of each zone in region view
        regionView.topZone.backgroundColor = red
        regionView.rightZone.backgroundColor = blue
        regionView.bottomZone.backgroundColor = green
        regionView.leftZone.backgroundColor = yellow
        
        regionView.topZone.id = "red"
        regionView.rightZone.id = "blue"
        regionView.bottomZone.id = "green"
        regionView.leftZone.id = "yellow"
        
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
            if vertLock && abs(deltaY) > tileView.frame.width/5 {
                newPos.y = (deltaY > 0) ? self.view.frame.height + tileView.frame.height : -tileView.frame.height
                
                
            } else if horizLock && abs(deltaX) > tileView.frame.width/5 {
                newPos.x = (deltaX > 0) ? self.view.frame.width + tileView.frame.width : -tileView.frame.width
            } else {
            }
            
            UIView.animate(withDuration: 0.3, animations: {
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

}

