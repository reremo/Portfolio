//
//  BattleViewController.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/16.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import Gecco
import GameKit
import ACEDrawingView
import Spring
import LTMorphingLabel
class BattleViewController: UIViewController, GKMatchDelegate{
    @IBOutlet weak var card1: UILabel!
    @IBOutlet weak var card2: UILabel!
    @IBOutlet weak var card3: UILabel!
    @IBOutlet weak var card4: UILabel!
    @IBOutlet weak var card5: UILabel!
    @IBOutlet weak var questionPlus: SpringView!
    @IBOutlet weak var editView: SpringView!
    @IBOutlet weak var gameScreen: UIView!
    var visualEffectView = UIVisualEffectView()
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var opQuestionLabel: UILabel!
    @IBOutlet weak var commonAnswerLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitchMini!
    
    @IBOutlet weak var opCard1: UIButton!
    @IBOutlet weak var opCard2: UIButton!
    @IBOutlet weak var opCard3: UIButton!
    @IBOutlet weak var opCard4: UIButton!
    @IBOutlet weak var opCard5: UIButton!
    @IBOutlet weak var opAnswer1: UILabel!
    @IBOutlet weak var opAnswer2: UILabel!
    @IBOutlet weak var opAnswer3: UILabel!
    @IBOutlet weak var opAnswer4: UILabel!
    @IBOutlet weak var opAnswer5: UILabel!
    @IBOutlet weak var opChallengeView: UIView!
    @IBOutlet weak var challengeButton: SpringButton!
    
    @IBOutlet weak var informTurnView: SpringView!
    @IBOutlet weak var isFirstLabel: UILabel!
    @IBOutlet weak var myRank: SpringLabel!
    @IBOutlet weak var opRank: SpringLabel!
    @IBOutlet weak var ok1Button: SpringButton!
    
    @IBOutlet weak var vs: LTMorphingLabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var yourQuestionLabel: UILabel!
    @IBOutlet weak var opponentQuestionLabel: UILabel!
    @IBOutlet weak var yourDeckLabel: UILabel!
    @IBOutlet weak var closeLabel: UIButton!
    @IBOutlet weak var eraserLabel: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    
    @IBOutlet weak var timeLimit: UILabel!
    @IBOutlet weak var whoseTurn: UILabel!
    @IBOutlet weak var informView2: UIView!
    var timer: Timer!
    var timer2: Timer!
    var opTimer: Timer!
    var hidden = false//問題解決よう
    var battleTimer2 = 0
    var opBattleTimer = 0
    func challengeChack() {
         if yourNumberList.index(of: -10) == nil && yourColorList.index(of: -10) == nil {
            challengeButton.backgroundColor = UIColor.red
            //UIColor.init(red: 255/255, green: 80/255, blue: 24/255, alpha: 1.0)
         } else {
            challengeButton.backgroundColor = UIColor.white
        }
    }
    @IBAction func ok1(_ sender: UIButton) {
       
         if !isMyTurn {
            isMyTurn = true
         } else {
        self.challengeButton.isEnabled = true
            if questionDeck[0].questionText != "" {
        self.questionLabel1.isEnabled = true
            }
            if questionDeck[1].questionText != "" {
        self.questionLabel2.isEnabled = true
            }
            if questionDeck[2].questionText != "" {
        self.questionLabel3.isEnabled = true
            }
            if questionDeck[3].questionText != "" {
        self.questionLabel4.isEnabled = true
            }
            if questionDeck[4].questionText != "" {
        self.questionLabel5.isEnabled = true
            }
            if questionDeck[5].questionText != "" {
        self.questionLabel6.isEnabled = true
            }
        }
        myRank.isHidden = true
        opRank.isHidden = true
        vs.isHidden = true
        informTurnView.isHidden = true
        visualEffectView.isHidden = true
    upDateQuestionLabel()
    
        inform1.text = "Your Turn!"
        if language == "japanese" {
            inform1.text = "あなたのターン!"
        }
    }
    @IBAction func Challenge(_ sender: SpringButton) {
        if yourNumberList.index(of: -10) == nil && yourColorList.index(of: -10) == nil {
        tag = -1
        self.challengeButton.isEnabled = false
        self.questionLabel1.isEnabled = false
        self.questionLabel2.isEnabled = false
        self.questionLabel3.isEnabled = false
        self.questionLabel4.isEnabled = false
        self.questionLabel5.isEnabled = false
        self.questionLabel6.isEnabled = false
        whoseTurn.text = "Opponent Turn"
           
            opBattleTimer = 65
             opTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(opUpdateElapsedTime), userInfo: nil, repeats: true)
        informView2.backgroundColor = UIColor.red
            if timer != nil {
        timer.invalidate()
            }
            informView2.layer.removeAllAnimations()
            timeLimit.text = "1:00"
        var sendData = [-5]
        for i in 0...4 {
            sendData.append(yourNumberList[i])
        }
        for i in 0...4 {
            sendData.append(yourColorList[i])
        }
        sendData.append(-3)
        for i in 0...11
        {
            let data = NSData(bytes: &sendData[i], length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
         challengeButton.isEnabled = false
        } else {
            challengeButton.animation = "shake"
            challengeButton.animate()
        }
    }
    
   
    @IBAction func close(_ sender: Any) {
        editView.animation = "zoomOut"
        editView.animate()
        hidden = true
        opCard1.layer.borderWidth = 1
        opCard2.layer.borderWidth = 1
        opCard3.layer.borderWidth = 1
        opCard4.layer.borderWidth = 1
        opCard5.layer.borderWidth = 1
        
    }
    
    @IBAction func Lock(_ sender: UISwitch) {
        if sender.isOn == true {
            gameScroll.isScrollEnabled = false
            memoScroll.isScrollEnabled = false
            memo.lineWidth = 2
        } else {
            gameScroll.isScrollEnabled = true
             memoScroll.isScrollEnabled = true
            memo.lineWidth = 0
        }
    }
    @IBAction func eraser(_ sender: UISwitch) {
        if sender.isOn == true {
            memo.drawTool = ACEDrawingToolTypeEraser
            memo.lineWidth = 30
        } else {
            memo.drawTool = ACEDrawingToolTypePen
            memo.lineWidth = 2
        }
    }
    @IBAction func editNumber(_ sender: UIButton) {
        if tag > sender.tag && !editView.isHidden {
            editView.animation = "slideRight"
            editView.animate()
        }
        if tag < sender.tag && !editView.isHidden {
            editView.animation = "slideLeft"
            editView.animate()
        }
        if editView.isHidden || hidden {
            
            editView.animation = "zoomIn"
            editView.animate()
            editView.isHidden = false
        }
        hidden = false
     //   editView.isHidden = false
      //  editView.animation = "zoomIn"
       // editView.animate()
        tag = sender.tag
        opCard1.layer.borderWidth = 1
        opCard2.layer.borderWidth = 1
        opCard3.layer.borderWidth = 1
        opCard4.layer.borderWidth = 1
        opCard5.layer.borderWidth = 1
        sender.layer.borderWidth = 3
    }
    @IBAction func numberEdit(_ sender: UIButton) {
        switch tag {
        case 0:
            opCard1.setTitle("\(sender.tag)", for: .normal)
            if sender.tag == 5 {
                opCard1.backgroundColor = UIColor.green
                yourColorList[tag] = 2
            } else {
            if yourColorList[tag] == 2 {
                yourColorList[tag] = -10
                opCard1.backgroundColor = UIColor.white
            }
            }
        case 1:
            opCard2.setTitle("\(sender.tag)", for: .normal)
            if sender.tag == 5 {
                opCard2.backgroundColor = UIColor.green
                yourColorList[tag] = 2
            } else {
                if yourColorList[tag] == 2 {
                    yourColorList[tag] = -10
                    opCard2.backgroundColor = UIColor.white
                }
            }
        case 2:
            opCard3.setTitle("\(sender.tag)", for: .normal)
            if sender.tag == 5 {
                opCard3.backgroundColor = UIColor.green
                yourColorList[tag] = 2
            } else {
                if yourColorList[tag] == 2 {
                    yourColorList[tag] = -10
                    opCard3.backgroundColor = UIColor.white
                }
            }
        case 3:
            opCard4.setTitle("\(sender.tag)", for: .normal)
            if sender.tag == 5 {
                opCard4.backgroundColor = UIColor.green
                yourColorList[tag] = 2
            } else {
                if yourColorList[tag] == 2 {
                    yourColorList[tag] = -10
                    opCard4.backgroundColor = UIColor.white
                }
            }
        case 4:
            opCard5.setTitle("\(sender.tag)", for: .normal)
            if sender.tag == 5 {
                opCard5.backgroundColor = UIColor.green
                yourColorList[tag] = 2
            } else {
                if yourColorList[tag] == 2 {
                    yourColorList[tag] = -10
                    opCard5.backgroundColor = UIColor.white
                }
            }
        default:
            break
        }
        
        yourNumberList[tag] = sender.tag
        challengeChack()
    }
    @IBAction func colorEdit(_ sender: UIButton) {
        switch tag {
        case 0:
            if opCard1.currentTitle != "5" {
            if sender.tag == 0 {
            opCard1.backgroundColor = UIColor.red
            } else {
                opCard1.backgroundColor = UIColor.blue
            }
            }
        case 1:
            if opCard2.currentTitle != "5" {
            if sender.tag == 0 {
                opCard2.backgroundColor = UIColor.red
            } else {
                opCard2.backgroundColor = UIColor.blue
            }
            }
        case 2:
            if opCard3.currentTitle != "5" {
            if sender.tag == 0 {
                opCard3.backgroundColor = UIColor.red
            } else {
                opCard3.backgroundColor = UIColor.blue
            }
            }
        case 3:
            if opCard4.currentTitle != "5" {
            if sender.tag == 0 {
                opCard4.backgroundColor = UIColor.red
            } else {
                opCard4.backgroundColor = UIColor.blue
            }
            }
        case 4:
            if opCard5.currentTitle != "5" {
            if sender.tag == 0 {
                opCard5.backgroundColor = UIColor.red
            } else {
                opCard5.backgroundColor = UIColor.blue
            }
            }
        default:
            break
        }
      
        yourColorList[tag] = sender.tag
        challengeChack()
    }
    
    @IBOutlet weak var gameScroll: UIScrollView!
    @IBOutlet weak var memoScroll: UIScrollView!
    
    @IBOutlet weak var memo: ACEDrawingView!
    
    
  
    
    
    
    
    @IBAction func question(_ sender: UIButton) {
        key = 0
        key1 = 0
        tag = sender.tag
        resultPicture.isHidden = true
        resultText.isHidden = true
        switch tag {
        case 1:
            key = questionDeck[0].questionKey
        case 2:
            key = questionDeck[1].questionKey
        case 3:
            key = questionDeck[2].questionKey
        case 4:
            key = questionDeck[3].questionKey
        case 5:
            key = questionDeck[4].questionKey
        case 6:
            key = questionDeck[5].questionKey
        default:
            break
        }
        

        
        
        if key == 4 || key == 5 || key == 6 || key == 7 {
            left.isHidden = true
            right.isHidden = true
            if key == 4 {
            self.left.setTitle("1", for: .normal)
            self.right.setTitle("2", for: .normal)
            }
            if key == 5 {
                self.left.setTitle("3", for: .normal)
                self.right.setTitle("4", for: .normal)
            }
            if key == 6 {
                self.left.setTitle("6", for: .normal)
                self.right.setTitle("7", for: .normal)
            }
            if key == 7 {
                self.left.setTitle("8", for: .normal)
                self.right.setTitle("9", for: .normal)
            }
            self.questionPlus.isHidden = false
            self.questionPlus.animation = "zoomIn"
            left.isHidden = false
            right.isHidden = false
          questionPlus.animate()
        } else {
            gameScroll.isScrollEnabled = true
            memoScroll.isScrollEnabled = true
            lockSwitch.isOn = false
            UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
                self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
            }) { _ in
                self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
            }
            
            questionText.text = questionDeck[tag-1].questionText
            
            if questionDeck.count > 6 {
                questionDeck.swapAt(tag-1, 6)
                questionDeck.remove(at: 6)
            } else {
                questionDeck[tag-1] = questionnil
            }
            upDateQuestionLabel()
            whoseTurn.text = "Opponent Turn"
            
            opBattleTimer = 65
            opTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(opUpdateElapsedTime), userInfo: nil, repeats: true)
             informView2.backgroundColor = UIColor.red
            if timer != nil {
                timer.invalidate()
            }
            informView2.layer.removeAllAnimations()
            timeLimit.text = "1:00"
            var myKeyList = [-1,tag,key,key1]
            for i in 0...3 {
            let data = NSData(bytes: &myKeyList[i], length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
            }
            if key == 11 || key == 12 || key == 13 {
                var answerList = answer(key, key1, myDeck)
                answerList[0] = -4
                for i in 0...answerList.count-1 {
                    let data = NSData(bytes: &answerList[i], length: MemoryLayout<NSInteger>.size)
                    do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                    } catch {
                    }
                }
            }
            
            
        }
        self.challengeButton.isEnabled = false
        self.questionLabel1.isEnabled = false
        self.questionLabel2.isEnabled = false
        self.questionLabel3.isEnabled = false
        self.questionLabel4.isEnabled = false
        self.questionLabel5.isEnabled = false
        self.questionLabel6.isEnabled = false
        
        
    }
    @IBAction func left(_ sender: Any) {
        if key == 4 {
            key1 = 1
            questionText.text = "Where're 1s?"
            if language == "japanese" {
                questionText.text = "１はどこ？"
            }
        } else if key == 5 {
            key1 = 3
            questionText.text = "Where're 3s?"
            if language == "japanese" {
                questionText.text = "３はどこ？"
            }
        } else if key == 6 {
            key1 = 6
            questionText.text = "Where're 6s?"
            if language == "japanese" {
                questionText.text = "６はどこ？"
            }
        } else if key == 7 {
            key1 = 8
            questionText.text = "Where're 8s?"
            if language == "japanese" {
                questionText.text = "８はどこ？"
            }
        }
      
        if questionDeck.count > 6 {
            questionDeck.swapAt(tag-1, 6)
            questionDeck.remove(at: 6)
        } else {
            questionDeck[tag-1] = questionnil
        }
        upDateQuestionLabel()
        opBattleTimer = 65
        opTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(opUpdateElapsedTime), userInfo: nil, repeats: true)
        whoseTurn.text = "Opponent Turn"
       
         informView2.backgroundColor = UIColor.red
        if timer != nil {
            timer.invalidate()
        }
        informView2.layer.removeAllAnimations()
        timeLimit.text = "1:00"
        var myKeyList = [-1,tag,key,key1]
        for i in 0...3 {
            let data = NSData(bytes: &myKeyList[i], length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
        self.questionPlus.animation = "zoomOut"
        questionPlus.animate()
        gameScroll.isScrollEnabled = true
        memoScroll.isScrollEnabled = true
        lockSwitch.isOn = false

        UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
        }) { _ in
            self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
        }
        
    }
    @IBOutlet weak var left: UIButton!
    @IBAction func right(_ sender: Any) {
        if key == 4 {
            key1 = 2
            questionText.text = "Where're 2s?"
            if language == "japanese" {
                questionText.text = "２はどこ？"
            }
        } else if key == 5 {
            key1 = 4
            questionText.text = "Where're 4s?"
            if language == "japanese" {
                questionText.text = "４はどこ？"
            }
        } else if key == 6 {
            key1 = 7
            questionText.text = "Where're 7s?"
            if language == "japanese" {
                questionText.text = "７はどこ？"
            }
        } else if key == 7 {
            key1 = 9
            questionText.text = "Where're 9s?"
            if language == "japanese" {
                questionText.text = "９はどこ？"
            }
        }
        
        if questionDeck.count > 6 {
            questionDeck.swapAt(tag-1, 6)
            questionDeck.remove(at: 6)
        } else {
            questionDeck[tag-1] = questionnil
        }
        upDateQuestionLabel()
        whoseTurn.text = "Opponent Turn"
        if language == "japanese" {
            whoseTurn.text = "相手のターン"
        }
        opBattleTimer = 65
        opTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(opUpdateElapsedTime), userInfo: nil, repeats: true)
         informView2.backgroundColor = UIColor.red
        if timer != nil {
            timer.invalidate()
        }
        informView2.layer.removeAllAnimations()
        timeLimit.text = "1:00"
        var myKeyList = [-1,tag,key,key1]
        for i in 0...3
        {
            let data = NSData(bytes: &myKeyList[i], length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
        self.questionPlus.animation = "zoomOut"
        questionPlus.animate()
        gameScroll.isScrollEnabled = true
        memoScroll.isScrollEnabled = true
        lockSwitch.isOn = false

                UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
        }) { _ in
            self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
        }
       
    }
    @IBOutlet weak var right: UIButton!
    @IBOutlet weak var questionLabel1: UIButton!
    @IBOutlet weak var questionLabel2: UIButton!
    @IBOutlet weak var questionLabel3: UIButton!
    @IBOutlet weak var questionLabel4: UIButton!
    @IBOutlet weak var questionLabel5: UIButton!
    @IBOutlet weak var questionLabel6: UIButton!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var result1: UILabel!
    @IBOutlet weak var result2: UILabel!
    @IBOutlet weak var result3: UILabel!
    @IBOutlet weak var result4: UILabel!
    @IBOutlet weak var result5: UILabel!
    @IBOutlet weak var resultPicture: UIView!
    @IBOutlet weak var inform1: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if language == "japanese" {
            timeLimitLabel.text = "残り時間"
         noteLabel.text = "<メモ>"
            challengeButton.setTitle("チャレンジ", for: .normal)
            yourQuestionLabel.text = "あなたの質問"
            opponentQuestionLabel.text = "相手の質問"
            yourDeckLabel.text = "あなたの手札"
            closeLabel.setTitle("閉じる", for: .normal)
            eraserLabel.text = "消しゴム"
            lockLabel.text = "スクロール\nロック"
        }
        memo.lineWidth = 0
        generalMatch.delegate = self
        self.questionPlus.isHidden = true
        resultText.isHidden = true
        resultPicture.isHidden = true
        editView.isHidden = true
        opChallengeView.isHidden = true
        informTurnView.isHidden = true
        visualEffectView.isHidden = true
        myRank.isHidden = true
        opRank.isHidden = true
        vs.isHidden = true
        myRank.text = rankList[rank]
        opRank.text = rankList[opInfo[0]]
        myRank.animation = "squeezeRight"
        opRank.animation = "squeezeLeft"
        ok1Button.isHidden = true
        self.memo.lineWidth = 2
        let blurEffect = UIBlurEffect(style:.extraLight)
         visualEffectView = UIVisualEffectView(effect:blurEffect)
        visualEffectView.frame = self.gameScreen.frame
        self.gameScroll.addSubview(visualEffectView)
        
        inform1.text = "Opponent Turn!"
        if language == "japanese" {
            inform1.text = "相手のターン!"
        }
        if isFirst {
            isFirstLabel.text = "First"
            if language == "japanese" {
                isFirstLabel.text = "先手"
            }
        } else {
            isFirstLabel.text = "Second"
            if language == "japanese" {
                isFirstLabel.text = "後手"
            }
        }
        
        self.questionLabel1.isEnabled = false
        self.questionLabel2.isEnabled = false
        self.questionLabel3.isEnabled = false
        self.questionLabel4.isEnabled = false
        self.questionLabel5.isEnabled = false
        self.questionLabel6.isEnabled = false
        self.challengeButton.isEnabled = false
        if !isMyTurn {
            self.questionLabel1.isEnabled = false
            self.questionLabel2.isEnabled = false
            self.questionLabel3.isEnabled = false
            self.questionLabel4.isEnabled = false
            self.questionLabel5.isEnabled = false
            self.questionLabel6.isEnabled = false
             whoseTurn.text = "Opponent Turn"
            if language == "japanese" {
                whoseTurn.text = "相手のターン"
            }
             informView2.backgroundColor = UIColor.red
            timeLimit.text = "1:00"
        } else {
            timeLimit.text = "1:30"
            informTurnView.isHidden = false
            visualEffectView.isHidden = false
            whoseTurn.text = "Your Turn"
            if language == "japanese" {
                whoseTurn.text = "自分のターン"
            }
            inform1.text = "Your Turn!"
            if language == "japanese" {
                inform1.text = "あなたのターン！"
            }
             informView2.backgroundColor = UIColor.blue
           
        }
        
            self.informTurnView.isHidden = false
        visualEffectView.isHidden = false

            self.informTurnView.animation = "fadeInUp"
            self.informTurnView.animate()
        
        
        func upDateLabel(_ label : UILabel, _ order : Int) {
        label.text = "\(myDeck[order].number)"
        switch myDeck[order].color {
        case 0:
            label.backgroundColor = UIColor.red
        case 1:
            label.backgroundColor = UIColor.blue
        case 2:
            label.backgroundColor = UIColor.green
        default:
            break
        }
        }
        upDateLabel(card1, 0)
        upDateLabel(card2, 1)
        upDateLabel(card3, 2)
        upDateLabel(card4, 3)
        upDateLabel(card5, 4)
        upDateQuestionLabel()
        // Do any additional setup after loading the view.
    }
    func upDateQuestionLabel() {
        print(questionData)
       
            switch tag {
            case 1:
               UIView.transition(with: questionLabel1, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel1.setTitle(questionDeck[0].questionText, for: .normal)
                })
            case 2:
               UIView.transition(with: questionLabel2, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel2.setTitle(questionDeck[1].questionText, for: .normal)
                })
            case 3:
               UIView.transition(with: questionLabel3, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel3.setTitle(questionDeck[2].questionText, for: .normal)
                })
            case 4:
               UIView.transition(with: questionLabel4, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel4.setTitle(questionDeck[3].questionText, for: .normal)
                })
            case 5:
               UIView.transition(with: questionLabel5, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel5.setTitle(questionDeck[4].questionText, for: .normal)
                })
            case 6:
               UIView.transition(with: questionLabel6, duration: 1.0, options: [.transitionFlipFromBottom], animations: { self.questionLabel6.setTitle(questionDeck[5].questionText, for: .normal)
                })
            default:
                break
                
            }
        
        self.questionLabel1.setTitle(questionDeck[0].questionText, for: .normal)
        if questionDeck[0].questionKey == 12 || questionDeck[0].questionKey == 13 || questionDeck[0].questionKey == 11 {
            questionLabel1.backgroundColor = UIColor.cyan
        } else {
            questionLabel1.backgroundColor = UIColor.white
        }
        
        self.questionLabel2.setTitle(questionDeck[1].questionText, for: .normal)
        if questionDeck[1].questionKey == 12 || questionDeck[1].questionKey == 13 || questionDeck[1].questionKey == 11 {
            questionLabel2.backgroundColor = UIColor.cyan
        } else {
            questionLabel2.backgroundColor = UIColor.white
        }
        
        self.questionLabel3.setTitle(questionDeck[2].questionText, for: .normal)
        if questionDeck[2].questionKey == 12 || questionDeck[2].questionKey == 13 || questionDeck[2].questionKey == 11 {
            questionLabel3.backgroundColor = UIColor.cyan
        } else {
            questionLabel3.backgroundColor = UIColor.white
        }
        
        self.questionLabel4.setTitle(questionDeck[3].questionText, for: .normal)
        if questionDeck[3].questionKey == 12 || questionDeck[3].questionKey == 13 || questionDeck[3].questionKey == 11 {
            questionLabel4.backgroundColor = UIColor.cyan
        } else {
            questionLabel4.backgroundColor = UIColor.white
        }
        
        self.questionLabel5.setTitle(questionDeck[4].questionText, for: .normal)
        if questionDeck[4].questionKey == 12 || questionDeck[4].questionKey == 13 || questionDeck[4].questionKey == 11 {
            questionLabel5.backgroundColor = UIColor.cyan
        } else {
            questionLabel5.backgroundColor = UIColor.white
        }
        
        self.questionLabel6.setTitle(questionDeck[5].questionText, for: .normal)
        if questionDeck[5].questionKey == 12 || questionDeck[5].questionKey == 13 || questionDeck[5].questionKey == 11 {
            questionLabel6.backgroundColor = UIColor.cyan
        } else {
            questionLabel6.backgroundColor = UIColor.white
        }
            
      
        
    }
    
    func match(_: GKMatch, didReceive data: Data, fromRemotePlayer: GKPlayer) {
        let data = NSData(data: data)
        var yourData : NSInteger = 0
        data.getBytes(&yourData, length: data.length)
        print(yourData)
        if yourData == -1 {
            solutionNumber = 1
        } else if yourData == -2 {
            solutionNumber = 2
        } else if yourData == -4 {
            solutionNumber = 3
        } else if yourData == -5 {
            solutionNumber = 4
        } else if yourData == -6 {
            solutionNumber = 5
        } else if yourData == -7 {
            solutionNumber = 6
        }
        if solutionNumber == 1 {//質問内容が送られてきたとき
            print("質問受信開始")
          
        yourKeyList.append(yourData)
            if yourKeyList.count == 4 {
                print("質問受信完了")
                
                yourTag = yourKeyList[1]
                tag = yourKeyList[1]
         yourKey = yourKeyList[2]
         yourKey1 = yourKeyList[3]
                  print(questionList[yourKey],"質問！")
        yourKeyList.removeAll()
                commonAnswerLabel.isHidden = true
            if yourKey == 4 || yourKey == 5 || yourKey == 6 || yourKey == 7 {
               
            opQuestionLabel.text = "Where're \(yourKey1)?"
                if language == "japanese" {
                    opQuestionLabel.text = "\(yourKey1)はどこ？"
                }
            } else {
                opQuestionLabel.text = questionList[yourKey].questionText
            }
            if questionDeck.count > 6 {
                questionDeck.swapAt(yourTag-1, 6)
                questionDeck.remove(at: 6)
            } else {
                questionDeck[tag-1] = questionnil
                }
                if opTimer != nil {
                    opTimer.invalidate()
                }
                whoseTurn.text = "Your Turn"
                if language == "japanese" {
                    whoseTurn.text = "自分のターン"
                }
                informView2.backgroundColor = UIColor.blue
                isMyTurn = true
                battleTimer = 60
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
           var answerList = answer(yourKey, yourKey1, myDeck)
                print("answer",answerList)
            for i in 0...answerList.count-1 {
            let data = NSData(bytes: &answerList[i], length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
                }
            informTurnView.isHidden = false
                visualEffectView.isHidden = false

                informTurnView.animation = "fadeInUp"
                informTurnView.animate()
            
            }
        } else if solutionNumber == 2 {//答えが返された時
            print("回答受信開始")
            yourAnswerList.append(yourData)
            if yourData == -3 {
                print("回答受信完了")
                print(yourAnswerList,"答え！")
                yourAnswerList.removeLast()
                opChallengeView.isHidden = true
                commonAnswerLabel.isHidden = true
            upDateResult(yourAnswerList)
                
                yourAnswerList.removeAll()
               
            }
        } else if solutionNumber == 3 {
            yourAnswerList.append(yourData)
            if yourData == -3 {
                print(yourAnswerList,"共有！")
                 opChallengeView.isHidden = true
            if yourAnswerList[1] == 13 {
                if yourAnswerList[2] == 1 {
                   commonAnswerLabel.text = "Yes"
                    if language == "japanese" {
                        commonAnswerLabel.text = "はい"
                    }
                } else {
                    commonAnswerLabel.text = "No"
                    if language == "japanese" {
                        commonAnswerLabel.text = "いいえ"
                    }
                }
            } else {
            commonAnswerLabel.text = "\(yourAnswerList[2])"
            }
                yourAnswerList.removeAll()
            commonAnswerLabel.isHidden = false
            }
        } else if solutionNumber == 4 {
             tag = -1
            inform1.text = "Opponent Challenge!"
            if language == "japanese" {
                inform1.text = "相手のチャレンジ！"
            }
            isMyTurn = true
            yourAnswerList.append(yourData)
            if yourData == -3 {
            
                var yourAnswerNumberList = [Int]()
                var yourAnswerColorList = [Int]()
                for i in 1...5 {
                    yourAnswerNumberList.append(yourAnswerList[i])
                }
                for i in 6...10 {
                    yourAnswerColorList.append(yourAnswerList[i])
                }
                opAnswer1.text = "\(yourAnswerNumberList[0])"
                opAnswer2.text = "\(yourAnswerNumberList[1])"
                opAnswer3.text = "\(yourAnswerNumberList[2])"
                opAnswer4.text = "\(yourAnswerNumberList[3])"
                opAnswer5.text = "\(yourAnswerNumberList[4])"
                if yourAnswerColorList[0] == 0 {
                opAnswer1.backgroundColor = UIColor.red
                } else if yourAnswerColorList[0] == 1 {
                    opAnswer1.backgroundColor = UIColor.blue
                } else if yourAnswerColorList[0] == 2 {
                    opAnswer1.backgroundColor = UIColor.green
                }
                if yourAnswerColorList[1] == 0 {
                    opAnswer2.backgroundColor = UIColor.red
                } else if yourAnswerColorList[1] == 1 {
                    opAnswer2.backgroundColor = UIColor.blue
                } else if yourAnswerColorList[1] == 2 {
                    opAnswer2.backgroundColor = UIColor.green
                }
                if yourAnswerColorList[2] == 0 {
                    opAnswer3.backgroundColor = UIColor.red
                } else if yourAnswerColorList[2] == 1 {
                    opAnswer3.backgroundColor = UIColor.blue
                } else if yourAnswerColorList[2] == 2 {
                    opAnswer3.backgroundColor = UIColor.green
                }
                if yourAnswerColorList[3] == 0 {
                    opAnswer4.backgroundColor = UIColor.red
                } else if yourAnswerColorList[3] == 1 {
                    opAnswer4.backgroundColor = UIColor.blue
                } else if yourAnswerColorList[3] == 2 {
                    opAnswer4.backgroundColor = UIColor.green
                }
                if yourAnswerColorList[4] == 0 {
                    opAnswer5.backgroundColor = UIColor.red
                } else if yourAnswerColorList[4] == 1 {
                    opAnswer5.backgroundColor = UIColor.blue
                } else if yourAnswerColorList[4] == 2 {
                    opAnswer5.backgroundColor = UIColor.green
                }
                commonAnswerLabel.isHidden = true
                opQuestionLabel.text = "Opponent Challenge!!"
                if language == "japanese" {
                    opQuestionLabel.text = "相手のチャレンジ！！"
                }
                opChallengeView.isHidden = false
                if opTimer != nil {
                    opTimer.invalidate()
                }
                whoseTurn.text = "Your Turn"
                if language == "japanese" {
                    whoseTurn.text = "あなたのターン"
                }
                informView2.backgroundColor = UIColor.blue
                battleTimer = 60
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
                gameScroll.isScrollEnabled = true
                memoScroll.isScrollEnabled = true
                lockSwitch.isOn = false

                UIView.animate(withDuration: 1.0, delay: 0.0,  animations: {
                    self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 1450-self.gameScroll.frame.size.height)
                }) { _ in
                    self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 1450-self.gameScroll.frame.size.height)
                }
             
                print(yourAnswerNumberList,yourAnswerColorList)
                print([myDeck[0].number,myDeck[1].number,myDeck[2].number,myDeck[3].number,myDeck[4].number],[myDeck[0].color,myDeck[1].color,myDeck[2].color,myDeck[3].color,myDeck[4].color])
                if yourAnswerNumberList == [myDeck[0].number,myDeck[1].number,myDeck[2].number,myDeck[3].number,myDeck[4].number] && yourAnswerColorList == [myDeck[0].color,myDeck[1].color,myDeck[2].color,myDeck[3].color,myDeck[4].color] {
                   lose = true
                } else {
                    informTurnView.isHidden = false
                    visualEffectView.isHidden = false

                }
                
                informTurnView.isHidden = false
                visualEffectView.isHidden = false

                informTurnView.animation = "zoomIn"
                informTurnView.animate()
                print(lose)
                var sendData = [-6]
                if lose {
                    sendData.append(0)
                } else {
                    sendData.append(1)
                }
                sendData.append(-3)
                for i in 0...2 {
                let data = NSData(bytes: &sendData[i], length: MemoryLayout<NSInteger>.size)
                do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                } catch {
                }
            }
                yourAnswerList.removeAll()
            if (win || lose) && isFirst {
                memoImage = memo.image
                if timer != nil {
                    timer.invalidate()
                }
                if opTimer != nil {
                    opTimer.invalidate()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.performSegue(withIdentifier: "resultSegue", sender: self)
                }
            }
                if lose && !isFirst {
                   
                    questionDeck[0] = questionnil
                    questionDeck[1] = questionnil
                    questionDeck[2] = questionnil
                    questionDeck[3] = questionnil
                    questionDeck[4] = questionnil
                    questionDeck[5] = questionnil
                    questionLabel1.isEnabled = false
                    questionLabel2.isEnabled = false
                    questionLabel3.isEnabled = false
                    questionLabel4.isEnabled = false
                    questionLabel5.isEnabled = false
                    questionLabel6.isEnabled = false
                    UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat,.autoreverse], animations: {
                        self.informView2.backgroundColor = UIColor.white
                    }, completion: nil)
                }
                
            }
        } else if solutionNumber == 5 {
            yourAnswerList.append(yourData)
            if yourData == -3 {
                if yourAnswerList[1] == 0 {
                    gameScroll.isScrollEnabled = true
                    memoScroll.isScrollEnabled = true
                    lockSwitch.isOn = false

                    UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
                        self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
                    }) { _ in
                        self.gameScroll.contentOffset = CGPoint.init(x: 0, y: 640)
                    }
              
                    win = true
                }
                print(yourAnswerList)
                if win {
                    resultPicture.isHidden = true
                    questionText.text = "Your Challenge is..."
                    resultText.text = "successful!!"
                    if language == "japanese" {
                        questionText.text = "あなたのチャレンジは..."
                        resultText.text = "成功！！"
                    }
                    inform1.text = "Succeeded"
                    if language == "japanese" {
                        inform1.text = "成功"
                    }
                    informTurnView.isHidden = false
                    visualEffectView.isHidden = false

                    resultText.isHidden = false
                    if !isFirst {
                         memoImage = memo.image
                        if timer != nil {
                            timer.invalidate()
                        }
                        if opTimer != nil {
                            opTimer.invalidate()
                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {//勝ちor引き分け
                        self.performSegue(withIdentifier: "resultSegue", sender: self)
                    }
                    }
                } else {
                    resultPicture.isHidden = true
                        questionText.text = "Your Challenge is..."
                    inform1.text = "Failed"
                    if language == "japanese" {
                    inform1.text = "失敗"
                    }
                    informTurnView.isHidden = false
                    visualEffectView.isHidden = false

                    resultText.text = "failed"
                    if language == "japanese" {
                        questionText.text = "あなたのチャレンジは..."
                        resultText.text = "失敗"
                    }

                    resultText.isHidden = false
                    if lose {
                         memoImage = memo.image
                        if timer != nil {
                            timer.invalidate()
                        }
                        if opTimer != nil {
                            opTimer.invalidate()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {//負け
                            self.performSegue(withIdentifier: "resultSegue", sender: self)                    }
                    }
                }
                yourAnswerList.removeAll()
            }
        } else if solutionNumber == 6 {
            isOpTimeUp = true
            memoImage = memo.image
            if timer != nil {
                timer.invalidate()
            }
            if opTimer != nil {
                opTimer.invalidate()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.performSegue(withIdentifier: "resultSegue", sender: self)                    }
             yourAnswerList.removeAll()
        }
    }
    func upDateResult(_ answer: [Int]) {
        let key = answer[1]
        var ans = [Int]()
        if answer.count > 2 {
        for i in 2...answer.count-1 {
            ans.append(answer[i])
        }
        }
        
        switch key {
        case 0:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 1:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 2:
            upDateResultSub(ans)
        case 3:
            upDateResultSub(ans)
        case 4:
            upDateResultSub(ans)
        case 5:
            upDateResultSub(ans)
        case 6:
            upDateResultSub(ans)
        case 7:
            upDateResultSub(ans)
        case 8:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 9:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 10:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 11:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 12:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 13:
            if ans[0] == 1 {
            resultText.text = "Yes"
                if language == "japanese" {
                    resultText.text = "はい"
                }
            } else {
                 resultText.text = "No"
                if language == "japanese" {
                    resultText.text = "いいえ"
                }
            }
            resultText.isHidden = false
        case 14:
            upDateResultSub(ans)
        case 15:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 16:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 17:
             upDateResultSub(ans)
        case 18:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 19:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        case 20:
            resultText.text = "\(ans[0])"
            resultText.isHidden = false
        default:
            break
        }
    }
    func upDateResultSub(_ ans:[Int]) {
        if ans.count == 0 {
            resultText.text = "never a one"
            if language == "japanese" {
                resultText.text = "１つもない"
            }
            resultText.isHidden = false
           
        } else {
            if ans.index(of: 0) != nil {
                result1.text = "↑"
                
            } else {
                result1.text = ""
            }
            if ans.index(of: 1) != nil {
                result2.text = "↑"
                
            } else {
                result2.text = ""
            }
            if ans.index(of: 2) != nil {
                result3.text = "↑"
                
            } else {
                result3.text = ""
            }
            if ans.index(of: 3) != nil {
                result4.text = "↑"
                
            } else {
                result4.text = ""
            }
            if ans.index(of: 4) != nil {
                result5.text = "↑"
                
            } else {
                result5.text = ""
            }
           
            resultPicture.isHidden = false
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func updateElapsedTime() {
        print(battleTimer)
        battleTimer -= 1
        let min: Int = battleTimer / 60
        let sec: Int = battleTimer % 60
        var zero = ""
        if sec < 10 {
            zero = "0"
        }
        if battleTimer <= 10 {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.informView2.backgroundColor = UIColor.cyan
            
        }, completion: nil)
        }
         timeLimit.text = String(min)+":"+zero+String(sec)
        if battleTimer == 0 {
            if timer != nil {
                timer.invalidate()
            }
            timeLimit.text = "0:00"
            isTimeUp = true
            memoImage = memo.image
            var sendData = -7
            let data = NSData(bytes: &sendData, length: MemoryLayout<NSInteger>.size)
            do{ try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } catch {
            }
            if timer != nil {
                timer.invalidate()
            }
            if opTimer != nil {
                opTimer.invalidate()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.performSegue(withIdentifier: "resultSegue", sender: self)                    }
        }
    }
    @objc func updateElapsedTime2() {
        battleTimer2 += 1
        if battleTimer2 == 1 {
            myRank.isHidden = false
            self.myRank.animate()
        } else if battleTimer2 == 2 {
            opRank.isHidden = false
            self.opRank.animate()
        } else if battleTimer2 == 3 {
            vs.isHidden = false
            self.vs.morphingEffect = .burn
            vs.text = "vs"
        } else if battleTimer2 == 6 {
            ok1Button.isHidden = false
            ok1Button.animation = "zoomIn"
            ok1Button.animate()
            if isFirst {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            } else {
                opBattleTimer = 95
                opTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(opUpdateElapsedTime), userInfo: nil, repeats: true)
            }
            timer2.invalidate()
        }
    }
     @objc func opUpdateElapsedTime() {
        opBattleTimer -= 1
        if opBattleTimer == 0 {
            if timer != nil {
                timer.invalidate()
            }
            if opTimer != nil {
                opTimer.invalidate()
            }
            isOpTimeUp = true
            memoImage = memo.image
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.performSegue(withIdentifier: "resultSegue", sender: self)                    }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        timer2 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(updateElapsedTime2), userInfo: nil, repeats: true)
       
    }
    func match(_ match: GKMatch,
               player playerID: String,
               didChange state: GKPlayerConnectionState) {
        isOpTimeUp = true
         memoImage = memo.image
        if timer != nil {
          timer.invalidate()
        }
        if opTimer != nil {
            opTimer.invalidate()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "resultSegue", sender: self)                    }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
