//
//  ViewController.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/16.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import Gecco
import GameKit
import Foundation
import Spring
class ViewController: UIViewController,GKMatchDelegate {
   
   
    var match : GKMatch!
    var matchMaker = GKMatchmaker.shared()
    var matchStarted = Bool()
    var numberForDecide = 0
    var timer: Timer! // matching後に７秒間まつタイマー
    var timer2: Timer!//スタート後に20秒間待つ
    var timer3: Timer!//アニメーションの管理
    var time = 0
    var gkManager = GameKitManager.getInstance()
    let englishButton = SpringButton()
    let japaneseButton = SpringButton()
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var aniLabel1: UILabel!
    @IBOutlet weak var aniLabel2: UILabel!
    @IBOutlet weak var aniLabel3: UILabel!
    @IBOutlet weak var aniLabel4: UILabel!
    @IBOutlet weak var aniLabel5: UILabel!
    @IBOutlet weak var state: SpringLabel!
    @IBOutlet weak var myRate: UILabel!
    @IBOutlet weak var myRank: UILabel!
    @IBOutlet weak var animationView1: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var rankingButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    
    @IBAction func ranking(_ sender: UIButton) {
     gkManager.showLeaderboard(rootViewController: self)
    }
    
    
    func match(_ match: GKMatch,
               player playerID: String,
               didChange state: GKPlayerConnectionState) {
    print("親決め開始")
        numberForDecide = Int(arc4random_uniform(10000))
        print(numberForDecide)
        let data = NSData(bytes: &numberForDecide, length: MemoryLayout<NSInteger>.size)
        do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
        } catch {
        }
        var myInfo:[Int] = [rank,rate]
        for i in 0...1 {
            let data = NSData(bytes: &myInfo[i], length: MemoryLayout<NSInteger>.size)
            do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
    }
    func match(_: GKMatch, didReceive data: Data, fromRemotePlayer: GKPlayer) {
        DispatchQueue.main.async {
        let data = NSData(data: data)
        var yourData : NSInteger = 0
        data.getBytes(&yourData, length: data.length)
        count += 1
        if count == 1 {
            print(yourData,self.numberForDecide)
            if yourData > self.numberForDecide {
            isFirst = false
            
            } else if yourData < self.numberForDecide {
            isFirst = true
            
        } else {
                self.match.disconnect()
    }
             print("親決め完了")
            }
            if count == 2 {
                opInfo[0] = yourData
            }
            if  count == 3 {
                opInfo[1] = yourData
            }
            if isFirst && count == 3 {
                
                isMyTurn = true
                var resultDeck = shuffuleAndDistribute(numberList)
                for i in 0...4 {
                    myDeck.append(resultDeck[i])
                }
                for i in 0...4 {
                    yourDeck.append(resultDeck[i+5])
                }
                
                
                myDeck = sortColorCard(sortNumberCard(myDeck))
                yourDeck = sortColorCard(sortNumberCard(yourDeck))
                questionDeck = shuffuleAndDisplay(questionList)
                var sendData = [Int]()
                for i in 0...4 {
                    sendData.append(yourDeck[i].ID)
                }
                for i in 0...4 {
                    sendData.append(myDeck[i].ID)
                }
                for i in 0...20 {
                            sendData.append(questionDeck[i].ID)
                }
                for i in 0...30 {
                    let data = NSData(bytes: &sendData[i], length: MemoryLayout<NSInteger>.size)
                    do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                    } catch {
                    }
                }
                generalMatch = self.match
                self.timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.performSegue(withIdentifier: "startSegue", sender: self)
                }
                
            }
            
            if count > 3 {
               print(count)
                if myDeckData.count < 5 {
                 myDeckData.append(yourData)
                } else if yourDeckData.count < 5 {
                    yourDeckData.append(yourData)
                } else {
                    questionData.append(yourData)
                }
                print(myDeckData.count,questionData.count)
                if questionData.count == 21 {
                    
                    for i in 0...4 {
                    myDeck.append(numberList[myDeckData[i]])
                    }
                    for i in 0...4 {
                        yourDeck.append(numberList[yourDeckData[i]])
                    }
                    
                    for i in 0...20 {
                    questionDeck.append(questionList[questionData[i]])
                    }
                    
                    generalMatch = self.match
                    self.timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.performSegue(withIdentifier: "startSegue", sender: self)
                    }
                }
            }
        
    }
    }
    
    @IBOutlet weak var connectButton: SpringButton!
    @IBAction func connect(_ sender: SpringButton) {
        if player.isAuthenticated {
            if language == "japanese" {
                for i in 0...20 {
                    questionList[i].questionText = questionJapaneseTextList[i]
                }
            }
         timer2 = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(updateElapsedTime2), userInfo: nil, repeats: false)
        connectButton.isEnabled = false
        rankingButton.isEnabled = false
            detailButton.isEnabled = false
         state.text = "Searching..."
            if language == "japanese" {
                self.state.text = "検索中..."
            }
     state.animation = "flash"
       state.animate()
        
        animationView1.center.x = 850
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn], animations: {
            self.connectButton.alpha = 0
            self.rankingButton.alpha = 0
            self.detailButton.alpha = 0
        }, completion: nil)

        UIView.animateKeyframes(withDuration: 5.0, delay: 0.0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.animationView1.center.x -= 350.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.35, animations: {
                self.animationView1.center.x -= 350.0
            })
        }, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        self.matchMaker.findMatch(for: request, withCompletionHandler: {(_ match: GKMatch?, _ error: Error?) -> Void in
            if error != nil {
                // Process the error.
            } else if match != nil {
                print("実行")
                self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.reMatch), userInfo: nil, repeats: false)
               isFound = true
                self.state.text = "Found Match!"
                if language == "japanese" {
                    self.state.text = "対戦相手が見つかった!"
                }

                self.timer2.invalidate()
                self.state.animation = "shake"
                self.state.animate()
                self.match = match!
                generalMatch = self.match
                // Use a retaining property to retain the match.
                generalMatch.delegate = self
                self.matchMaker.finishMatchmaking(for: generalMatch)
                if !self.matchStarted && match?.expectedPlayerCount == 0 {
                    self.matchStarted = true
                }
                
            }
        })
        } else {
            connectButton.animation = "shake"
            connectButton.animate()
        }
    }
    @objc func eButtonEvent(_ sender: UIButton) {
        englishButton.animation = "zoomOut"
        japaneseButton.animation = "zoomOut"
        englishButton.animate()
        japaneseButton.animate()
        Changelanguage = false
        language = "english"
        userDefaults.set(language, forKey: "language")
        userDefaults.synchronize()
    }
    @objc func jButtonEvent(_ sender: UIButton) {
        englishButton.animation = "zoomOut"
        japaneseButton.animation = "zoomOut"
        englishButton.animate()
        japaneseButton.animate()
        Changelanguage = false
         language = "japanese"
        if rankUpRateList[rank+1] - rate == 0 {
            nextLabel.text = "Rank Up Battle"
            if language == "japanese" {
                nextLabel.text = "ランクアップバトル"
            }
        } else if rankUpRateList[rank] - rate == 0 && rate != 0 {
            nextLabel.text = "Rank Down Battle"
            if language == "japanese" {
                nextLabel.text = "ランクダウンバトル"
            }
        } else {
            nextLabel.text = "Next Rank:\(rankUpRateList[rank+1] - rate)"
            if language == "japanese" {
                nextLabel.text = "次のランクまで:\(rankUpRateList[rank+1] - rate)"
            }
        }

        userDefaults.set(language, forKey: "language")
        userDefaults.synchronize()
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if Changelanguage {
        englishButton.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
        japaneseButton.frame = CGRect.init(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
            
            
            englishButton.setTitleColor(UIColor.init(red: 134/255, green: 242/255, blue: 217/255, alpha: 1.0), for: .normal)
            englishButton.backgroundColor = UIColor.white
            japaneseButton.setTitleColor( UIColor.init(red: 255/255, green: 99/255, blue: 130/255, alpha: 1.0), for: .normal)
            japaneseButton.backgroundColor = UIColor.white
        englishButton.addTarget(self, action: #selector(eButtonEvent(_:)), for:.touchUpInside)
        japaneseButton.addTarget(self, action: #selector(jButtonEvent(_:)), for:.touchUpInside)
      englishButton.setTitle("English", for: .normal)
        japaneseButton.setTitle("日本語", for: .normal)
        englishButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        japaneseButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        self.view.addSubview(englishButton)
        self.view.addSubview(japaneseButton)
        }
      if userDefaults.array(forKey: "battleInfo") != nil {
            battleInfo = userDefaults.array(forKey: "battleInfo") as! [Int]
        }
        if userDefaults.string(forKey: "language") != nil {
            language = userDefaults.string(forKey: "language")!
        }
       
   print("きてる")
        rate = battleInfo[1]
        rank = battleInfo[0]
        //rate = 1000
        if rate < rankUpRateList[rank] || rate > rankUpRateList[rank+1] {
            for i in 0...rankUpRateList.count-2 {
                if rate > rankUpRateList[i] && rate <= rankUpRateList[i+1] {
                    rank = i
                }
            }
        }
         gkManager.reportScore(point: rate)
        battleTimer = 90
        isWin = false
        myRate.text = "\(rate)"
        myRank.text = "\(rankList[rank])"
        if rankUpRateList[rank+1] - rate == 0 {
            nextLabel.text = "Rank Up Battle"
            if language == "japanese" {
                nextLabel.text = "ランクアップバトル"
            }
        } else if rankUpRateList[rank] - rate == 0 && rate != 0 {
            nextLabel.text = "Rank Down Battle"
            if language == "japanese" {
                nextLabel.text = "ランクダウンバトル"
            }
        } else {
        nextLabel.text = "Next Rank:\(rankUpRateList[rank+1] - rate)"
            if language == "japanese" {
                nextLabel.text = "次のランクまで:\(rankUpRateList[rank+1] - rate)"
            }
        }
        isFirst = false
        isDecide = false
        numberDeck.removeAll()
        questionDeck.removeAll()
        myDeck.removeAll()
        yourDeck.removeAll()
        myDeckData.removeAll()
        yourDeckData.removeAll()
        questionData.removeAll()
        yourKeyList.removeAll()
        yourAnswerList.removeAll()
        yourNumberList = [-10,-10,-10,-10,-10]
        yourColorList = [-10,-10,-10,-10,-10]
        count = 0
        isMyTurn = false
        win = false
        lose = false
        isFound = false
        isWin = false
        isTimeUp = false
        isOpTimeUp = false
       detailButton.isEnabled = true
        rankingButton.isEnabled = true
        connectButton.isEnabled = true
     print("きてる")
        timer3 = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(animationV), userInfo: nil, repeats: true)
        print("きてる")
        
      
       /* let randamX:[CGFloat] = [400,350,385,485,673,456,563,654,420,623]
       let randamY:[CGFloat] = [230,532,401,]*/
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    @objc func animationV() {
      
        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.02, relativeDuration: 0.04, animations: {
                self.aniLabel1.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.06, relativeDuration: 0.04, animations: {
                self.aniLabel1.center.y -= 10.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.05, animations: {
                self.aniLabel2.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.05, animations: {
                self.aniLabel2.center.y -= 10.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.05, animations: {
                self.aniLabel3.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.05, animations: {
                self.aniLabel3.center.y -= 10.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.05, animations: {
                self.aniLabel4.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.05, animations: {
                self.aniLabel4.center.y -= 10.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.05, animations: {
                self.aniLabel5.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.05, animations: {
                self.aniLabel5.center.y -= 10.0
            })
        }, completion: nil)
    }
    @objc func updateElapsedTime2() {
        if !isFound {
            connectButton.isEnabled = true
            rankingButton.isEnabled = true
            detailButton.isEnabled = true
            state.text = "not found..."
            if language == "japanese" {
                state.text = "接続失敗"
            }
            connectButton.alpha = 1
            rankingButton.alpha = 1
            detailButton.alpha = 1
            connectButton.animate()
                timer2.invalidate()
            matchMaker.cancel()
            animationView1.layer.removeAllAnimations()
            }
        }
    @objc func reMatch() {
        isFirst = false
        isDecide = false
        numberDeck.removeAll()
        questionDeck.removeAll()
        myDeck.removeAll()
        yourDeck.removeAll()
        myDeckData.removeAll()
        questionData.removeAll()
        yourKeyList.removeAll()
        yourAnswerList.removeAll()
        yourNumberList = [-10,-10,-10,-10,-10]
        yourColorList = [-10,-10,-10,-10,-10]
        count = 0
        isMyTurn = false
        win = false
        lose = false
        isFound = false
        isWin = false
        isTimeUp = false
        isOpTimeUp = false
        animationView1.layer.removeAllAnimations()
        connectButton.isEnabled = true
        rankingButton.isEnabled = true
        detailButton.isEnabled = true
        state.text = "failed to connect"
        if language == "japanese" {
            state.text = "接続失敗"
        }
        connectButton.alpha = 1
        rankingButton.alpha = 1
        detailButton.alpha = 1
        connectButton.animate()
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

