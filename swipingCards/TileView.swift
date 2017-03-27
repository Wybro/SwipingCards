//
//  TileView.swift
//  swipingCards
//
//  Created by Kyle Wybranowski on 3/26/17.
//  Copyright © 2017 com.Wybro. All rights reserved.
//

import UIKit

@IBDesignable class TileView: UIView {
    
    var view: UIView!
    @IBOutlet var tileImageView: UIImageView!
    
    // MARK: - Init
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    // MARK: - Setup
    
    func xibSetup() {
        view = loadViewFromNib()
     
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
     }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TileView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
