//
//  ViewController.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 23/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TableDelegate {
    
    private let table = Table()
    private var panel: Panel? = nil
    private let gameWonView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHex("#FAF8EF", alpha: 1)
        
        table.delegate = self
        self.view.addSubview(table)
        
        panel = Panel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.table.frame.origin.y))
        self.view.addSubview(panel!)
        
        //** RESET BUTTON **//
        let resetBtn = UIButton(frame: CGRectMake(0,0,self.view.frame.size.width * 0.45, 45))
        resetBtn.backgroundColor = UIColor.colorWithHex("#EF5350", alpha: 1)
        resetBtn.layer.cornerRadius = 5
        resetBtn.center = CGPointMake(self.view.center.x, CGRectGetMaxY(table.frame) + resetBtn.frame.size.height / 2 + 20)
        resetBtn.setTitle("Reset", forState: .Normal)
        resetBtn.addTarget(self, action: #selector(resetBtnClick(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(resetBtn)
    }
    
    @objc func resetBtnClick(selector:UIButton){
        table.newGame()
        panel!.resetScore()
        gameWonView.removeFromSuperview()
    }
    
    func gameWon() {
        let blurEffect = UIBlurEffect(style: .Light)
        gameWonView.effect = blurEffect
        gameWonView.clipsToBounds = true
        gameWonView.layer.cornerRadius = self.table.layer.cornerRadius
        gameWonView.frame = self.table.frame
        self.view.addSubview(gameWonView)
        
        let gameWonLabel = UILabel(frame: CGRectMake(0,0,self.gameWonView.frame.size.width,self.gameWonView.frame.size.height))
        gameWonLabel.font = UIFont(name: "PingFangHK-Medium", size: 40)
        gameWonLabel.textAlignment = .Center
        gameWonLabel.textColor = UIColor.colorWithHex("#5DA1E2", alpha: 1)
        gameWonLabel.text = "You Win!"
        self.gameWonView.addSubview(gameWonLabel)
        
    }
    
    func setScore(score: Int) {
        panel!.setScore(score)
    }

}

