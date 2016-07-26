//
//  Chip.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 23/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

class Chip: UIView{
    
    private let CHIP_COLORS: [Int:String] = [2:"#EEE4DA",4:"#EDE0C8",8:"#F2B179",16:"#F59563",32:"#F67C5F",64:"#EB423F",128:"#F5D077",256:"#F3C62B",512:"#74B5DD",1024:"#5DA1E2",2048:"#007FC2"]
    
    private let APPEAR_ANIMATION_DELAY = 0.3
    private let TRANSLATE_ANIMATION_DELAY = 0.3
    
    private var numberLabel: UILabel = UILabel()
    
    private var _chipNumber: Int = 0
    private(set) var chipNumber: Int {
        get{
            return self._chipNumber
        }
        set{
            _chipNumber = newValue
            if newValue > 0{
                self.backgroundColor = UIColor.colorWithHex(CHIP_COLORS[newValue]!, alpha: 1)
                self.numberLabel.textColor = self.chipNumber == 2 || self.chipNumber == 4 ? UIColor.colorWithHex("#776E65", alpha: 1) : UIColor.colorWithHex("#ffffff", alpha: 1)
                self.numberLabel.text = newValue.description
            }
        }
    }
    var chipPosition: Int = -1
    
    init(view:UIView, number: Int, position: Int){
        super.init(frame: view.frame)
        self.chipNumber = number
        self.chipPosition = position
        
        if chipNumber > 0 {
            self.backgroundColor = UIColor.colorWithHex(CHIP_COLORS[self.chipNumber]! , alpha: 1)
            self.layer.cornerRadius = view.layer.cornerRadius
            
            self.numberLabel.frame = self.bounds
            self.numberLabel.textColor = self.chipNumber == 2 || self.chipNumber == 4 ? UIColor.colorWithHex("#776E65", alpha: 1) : UIColor.colorWithHex("#ffffff", alpha: 1)
            self.numberLabel.font = UIFont(name: "PingFangHK-Medium", size: 23)
            self.numberLabel.textAlignment = .Center
            self.numberLabel.text = number.description
            self.addSubview(self.numberLabel)
            
            self.transform = CGAffineTransformMakeScale(0, 0)
            UIView.animateWithDuration(APPEAR_ANIMATION_DELAY, animations: { 
                self.transform = CGAffineTransformMakeScale(1, 1)
            })
        }
    }
    
    convenience init(){
        self.init(view:UIView.init(frame: CGRect.zero), number: 0, position: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //** CLASS FUNCTIONS **//
    func moveChipToPosition(position:CGRect, number:Int) -> Void{
        UIView.animateWithDuration(TRANSLATE_ANIMATION_DELAY, animations: { 
                self.frame = position
            }) { (true) in
                self.chipNumber = number
        }
    }
    
    func moveChipToPosition(position:CGRect, disappear:Bool) -> Void{
        UIView.animateWithDuration(TRANSLATE_ANIMATION_DELAY, animations: { 
                self.frame = position
            }) { (true) in
                self.hidden = disappear
        }
    }
    
}
