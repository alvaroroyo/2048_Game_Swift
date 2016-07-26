//
//  Table.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 23/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import UIKit

protocol TableDelegate {
    func setScore(score:Int)
    func gameWon()
}

class Table: UIView {
    
    private let LEFT_MOVE = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    private let RIGHT_MOVE = [3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
    private let DOWN_MOVE = [12,8,4,0,13,9,5,1,14,10,6,2,15,11,7,3]
    private let UP_MOVE = [0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15]
    
    private var chipsPositions: Array<UIView> = Array<UIView>()
    private var chipsInGame: Array<Chip> = Array<Chip>()
    
    var delegate:TableDelegate! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 1...16{
            chipsInGame.append(Chip())
        }
        
        self.backgroundColor = UIColor.colorWithHex("#BBADA0", alpha: 1)
        
        self.layer.cornerRadius = self.frame.size.height * 0.025
        
        //** SET CHIP POSITIONS **//
        let surface: CGFloat = self.frame.size.width * self.frame.size.width
        
        let marginSurface: CGFloat = surface * 0.47
        
        let chipSurface = surface - marginSurface
        
        let chipWidth = sqrt(chipSurface / 16)
        
        let chipMargin = sqrt(marginSurface) / 13
        
        var marginY = chipMargin
        var marginX = chipMargin
        for i in 1...16{
            let chipPosition: UIView = UIView.init(frame: CGRectMake(marginX, marginY, chipWidth, chipWidth))
            chipPosition.backgroundColor = UIColor.colorWithHex("#CDC1B4", alpha: 1)
            chipPosition.layer.cornerRadius = chipPosition.frame.size.height * 0.05
            self.addSubview(chipPosition)
            
            chipsPositions.append(chipPosition)
            
            if i % 4 != 0{
                marginX = CGRectGetMaxX(chipPosition.frame) + chipMargin
            }else{
                marginX = chipMargin
                marginY = CGRectGetMaxY(chipPosition.frame) + chipMargin
            }
            
        }
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.addGestureRecognizer(swipeDown)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        addNewChip()
        addNewChip()
        
    }
    
    convenience init() {
        let screenSize = UIScreen.mainScreen().bounds
        let margin = screenSize.size.width * 0.025;
        self.init(frame:CGRectMake(margin, screenSize.height / 2 - ((screenSize.width - margin * 2) / 2) + 50, screenSize.width - margin * 2, screenSize.width - margin * 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //** CLASS FUNCTIONS **//
    func newGame() -> Void{
        for i in 0...15{
            self.chipsInGame[i].hidden = true
            self.chipsInGame[i] = Chip()
        }
        addNewChip()
        addNewChip()
    }
    
    private func getPosition() -> Int{
        
        var slots: Array<Int> = Array<Int>()
        
        for i in 0...15{
            if self.chipsInGame[i].chipNumber == 0 {
                slots.append(i)
            }
        }
        
        let random = Int(arc4random()) % slots.count
        
        return slots[random]
    }
    
    func addNewChip() -> Void{
        let position = getPosition()
        let random = Int(arc4random()) % 100
        let newChip: Chip = Chip(view: self.chipsPositions[position], number: random < 75 ? 2 : 4, position: position)
        self.addSubview(newChip)
        self.chipsInGame[position] = newChip
    }
    
    @objc private func swipeAction(sender:UISwipeGestureRecognizer) -> Void{
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Down:
            gameLogic(DOWN_MOVE)
            break
        case UISwipeGestureRecognizerDirection.Up:
            gameLogic(UP_MOVE)
            break
        case UISwipeGestureRecognizerDirection.Left:
            gameLogic(LEFT_MOVE)
            break
        case UISwipeGestureRecognizerDirection.Right:
            gameLogic(RIGHT_MOVE)
            break
            
        default: break
        }
    }
    
    private func gameLogic(direction:Array<Int>) -> Void{
        var column = 0
        
        var scorePoints = 0
        
        var lastPosition = -1
        
        var lastChip: Chip? = nil
        
        var movement = false
        
        //Start Logic
        for i in 0...15{
            var sum = false
            
            //True Index
            let e = direction[i]
            
            //Get chip for actual position
            let actualChip: Chip = self.chipsInGame[e]
            
            if(actualChip.chipNumber == 0 && lastPosition == -1){
                lastPosition = e
            }
            
            if lastChip != nil && lastChip!.chipNumber == actualChip.chipNumber && actualChip.chipNumber != 0 {
                sum = true
                movement = true
                    
                let moveTo = lastChip!.chipPosition
                    
                //Animations
                self.bringSubviewToFront(lastChip!)
                lastChip!.moveChipToPosition(self.chipsPositions[moveTo].frame, number: lastChip!.chipNumber * 2)
                actualChip.moveChipToPosition(self.chipsPositions[moveTo].frame, disappear: true)
                    
                //Set matrix
                self.chipsInGame[moveTo] = lastChip!
                if moveTo == lastPosition{
                    self.chipsInGame[lastChip!.chipPosition] = Chip()
                }
                lastChip!.chipPosition = moveTo
                self.chipsInGame[actualChip.chipPosition] = Chip()
                    
                //Set last position
                lastPosition = direction[direction.indexOf(moveTo)! + 1]
                    
                scorePoints = scorePoints + lastChip!.chipNumber * 2
                
                lastChip = nil
                    
                //Game won
                if actualChip.chipNumber * 2 == 2048 {
                    delegate.gameWon()
                }
            }else if actualChip.chipNumber != 0 && lastPosition != -1 {
                movement = true
                
                //Animation
                actualChip.moveChipToPosition(self.chipsPositions[lastPosition].frame, disappear: false)
                actualChip.chipPosition = lastPosition
                
                //Set matrix
                self.chipsInGame[lastPosition] = actualChip
                self.chipsInGame[e] = Chip()
                
                //Set last position
                lastPosition = direction[direction.indexOf(lastPosition)! + 1]
            }
            
            if (i + 1) % 4 == 0 {
                lastChip = nil
                lastPosition = -1
                column = column + 1
            }else if actualChip.chipNumber != 0 && !sum {
                lastChip = actualChip
            }
        }
        
        //Add score
        delegate.setScore(scorePoints)
        
        //New chip in table
        if movement {
            addNewChip()
        }
    }
    
}