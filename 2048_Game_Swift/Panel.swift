//
//  Panel.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 26/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

class Panel: UIView {
    
    private let SCORE = "BEST_SCORE"
    
    private var bestScoreText = UILabel()
    private var scoreText = UILabel()
    
    private var scoreNumber: Int = 0
    private var bestScoreNumber: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Get best score saved
        bestScoreNumber = NSUserDefaults.standardUserDefaults().integerForKey(SCORE)
        
        //** SCORE CONTENT **//
        let scoreContent = UIView(frame: CGRectMake(0,0,self.frame.size.width * 0.45,self.frame.size.height * 0.35))
        scoreContent.backgroundColor = UIColor.colorWithHex("#BBADA0", alpha: 1)
        scoreContent.layer.cornerRadius = 5
        scoreContent.center = CGPointMake(scoreContent.center.x + self.frame.size.width * 0.025, self.center.y)
        self.addSubview(scoreContent)
        
        let scoreTitle = UILabel(frame: CGRectMake(0,5,scoreContent.frame.size.width,17))
        scoreTitle.textColor = UIColor.colorWithHex("#EEE4DA", alpha: 1)
        scoreTitle.font = UIFont(name: "PingFangHK-Medium", size: 17)
        scoreTitle.text = "Score"
        scoreTitle.textAlignment = .Center
        scoreContent.addSubview(scoreTitle)
        
        scoreText.frame = CGRectMake(0, CGRectGetMaxY(scoreTitle.frame) + 8, scoreContent.frame.size.width, 25)
        scoreText.textColor = UIColor.colorWithHex("#FFFFFF", alpha: 1)
        scoreText.font = UIFont(name: "PingFangHK-Medium", size: 25)
        scoreText.text = "0"
        scoreText.textAlignment = .Center
        scoreContent.addSubview(scoreText)
        
        
        //** BEST SCORE CONTENT **//
        let bestScoreContent = UIView(frame: CGRectMake(self.center.x + self.frame.size.width * 0.025, 0, self.frame.size.width * 0.45, self.frame.size.height * 0.35))
        bestScoreContent.backgroundColor = UIColor.colorWithHex("#BBADA0", alpha: 1)
        bestScoreContent.layer.cornerRadius = 5
        bestScoreContent.center = CGPointMake(bestScoreContent.center.x, self.center.y)
        self.addSubview(bestScoreContent)
        
        let bestScoreTitle = UILabel(frame: CGRectMake(0,5,bestScoreContent.frame.size.width,17))
        bestScoreTitle.textColor = UIColor.colorWithHex("#EEE4DA", alpha: 1)
        bestScoreTitle.font = UIFont(name: "PingFangHK-Medium", size: 17)
        bestScoreTitle.text = "Best Score"
        bestScoreTitle.textAlignment = .Center
        bestScoreContent.addSubview(bestScoreTitle)
        
        bestScoreText.frame = CGRectMake(0, CGRectGetMaxY(bestScoreTitle.frame) + 8, bestScoreContent.frame.size.width, 25)
        bestScoreText.textColor = UIColor.colorWithHex("#FFFFFF", alpha: 1)
        bestScoreText.font = UIFont(name: "PingFangHK-Medium", size: 25)
        bestScoreText.text = bestScoreNumber.description
        bestScoreText.textAlignment = .Center
        bestScoreContent.addSubview(bestScoreText)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScore(score:Int){
        scoreNumber += score
        scoreText.text = scoreNumber.description
        if(scoreNumber > bestScoreNumber){
            bestScoreNumber = scoreNumber
            NSUserDefaults.standardUserDefaults().setInteger(bestScoreNumber, forKey: SCORE)
            bestScoreText.text = bestScoreNumber.description
        }
    }
    
    func resetScore(){
        scoreNumber = 0
        scoreText.text = "0"
    }
}