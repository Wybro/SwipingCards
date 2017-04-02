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
    @IBOutlet var scoreLabel: UILabel!
    
    var animator: UIDynamicAnimator?
    
    var currentLocation: CGPoint?
    var attachment: UIAttachmentBehavior?
    
    var vertLock = false
    var horizLock = false
    var score = 0
    
    let tileColors = ["Red", "Blue", "Green", "Yellow"]
    let tileImages = [UIImage(named: "Blue"), UIImage(named: "Green"), UIImage(named: "Red"), UIImage(named: "Yellow")]
    
    let red = UIColor(red: 254/255, green: 95/255, blue: 85/255, alpha: 1)
    let blue = UIColor(red: 112/255, green: 214/255, blue: 255/255, alpha: 1)
    let green = UIColor(red: 35/255, green: 206/255, blue: 107/255, alpha: 1)
    let yellow = UIColor(red: 233/255, green: 255/255, blue: 112/255, alpha: 1)

    var origin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        origin = tileView.center
        
        setupGame()
        
        scoreLabel.text = "\(score)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGame() {
        // Set the color & ID of each zone in region view
        regionView.topZone.view.backgroundColor = red
        regionView.rightZone.view.backgroundColor = blue
        regionView.bottomZone.view.backgroundColor = green
        regionView.leftZone.view.backgroundColor = yellow
        
        regionView.topZone.id = "Red"
        regionView.rightZone.id = "Blue"
        regionView.bottomZone.id = "Green"
        regionView.leftZone.id = "Yellow"
        
        // Initial value
        tileView.id = "Blue"
        
    }
    
    func selectNewTile() {
        let rand = Int(arc4random_uniform(4))
        print("rand: ", rand)
        let tileColor = self.tileColors[rand]
        let tileImage = UIImage(named: tileColor)
        self.tileView.tileImageView.image = tileImage
        self.tileView.id = tileColor
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
        
//        if abs(deltaX) <= 10 && abs(deltaY) > abs(deltaX) {
//            horizLock = false
//            vertLock = true
//            tile.center.x = origin.x
//            
//        }
//        if abs(deltaY) <= 10 &&  abs(deltaX) > abs(deltaY) {
//            vertLock = false
//            horizLock = true
//            tile.center.y = origin.y
//        }
        
        if deltaX == 0 {
            horizLock = false
        }
        if deltaY == 0 {
            vertLock = false
        }

        // Gesture ended
        if sender.state == UIGestureRecognizerState.ended {
            var newPos: CGPoint = self.origin
            
            // Check locks -- if locked, use position of tile
            if vertLock && abs(deltaY) > tileView.frame.width/5 {
                newPos.y = (deltaY > 0) ? self.view.frame.height + tileView.frame.height : -tileView.frame.height
                if deltaY > 0 {
                    // bottomZone
                    if regionView.bottomZone.id == tileView.id {
                        score += 1
                        print("Good")
                    } else {
                        score -= 1
                        print("Bad")
                    }
                } else {
                    // topZone
                    if regionView.topZone.id == tileView.id {
                        score += 1
                        print("Good")
                    } else {
                        score -= 1
                        print("Bad")
                    }
                }
                
            } else if horizLock && abs(deltaX) > tileView.frame.width/5 {
                newPos.x = (deltaX > 0) ? self.view.frame.width + tileView.frame.width : -tileView.frame.width
                if deltaX > 0 {
                    // rightZone
                    if regionView.rightZone.id == tileView.id {
                        score += 1
                        print("Good")
                    } else {
                        score -= 1
                        print("Bad")
                    }
                } else {
                    // leftZone
                    if regionView.leftZone.id == tileView.id {
                        score += 1
                        print("Good")
                    } else {
                        score -= 1
                        print("Bad")
                    }
                }
            } else {
            }
//            scoreLabel.text = "\(score)"

            print("newPos: ", newPos)
            UIView.animate(withDuration: 0.3, animations: {
                tile.center = newPos
            }, completion: { (success) in
                // TODO: custom zone view (half of screen)
                if !self.view.bounds.contains(tile.frame) {
                   tile.center = self.origin
//                    self.selectNewTile()
                    let rand = Int(arc4random_uniform(4))
//                    print("rand: ", rand)
                    let tileColor = self.tileColors[rand]
                    let tileImage = UIImage(named: tileColor)
                    self.tileView.tileImageView.image = tileImage
                    self.tileView.id = tileColor
                    
                    self.vertLock = false
                    self.horizLock = false
                }

            })
            
        }
    }

}

