//
//  AppDelegate.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/16.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import Foundation
import GameKit
import GoogleMobileAds
import Firebase

var language = "english"
var Changelanguage = false
var isPractice = false
let userDefaults = UserDefaults.standard
var generalMatch = GKMatch()
var memoImage = UIImage()
var isFirst = false
var isDecide = false
var numberDeck = numberList
var questionDeck = questionList
var myDeck = [numberCard]()
var yourDeck = [numberCard]()
var myDeckData = [Int]()
var yourDeckData = [Int]()
var questionData = [Int]()
var key = 0
var key1 = 0
var yourKey = 0
var yourKey1 = 0
var yourTag = 0
var tag = 0
var yourKeyList = [Int]()
var yourAnswerList = [Int]()
var isMyTurn = false
var solutionNumber = 0
var count = 0
var yourNumberList = [-10,-10,-10,-10,-10]
var yourColorList = [-10,-10,-10,-10,-10]
var win = false
var lose = false
var player = GKLocalPlayer()
var isFound = false
var rate = 0
var rank = 0
var isTimeUp = false
var isOpTimeUp = false
var battleTimer = 90
var battleInfo = [0,0]
var isWin = false
var visitCount = 0
let rankList = ["C5","C4","C3","C2","C1","B5","B4","B3","B2","B1","A5","A4","A3","A2","A1","S5","S4","S3","S2","S1"]
let rankUpRateList = [0,1000,3000,5000,7000,10000,15000,20000,25000,35000,40000,45000,50000,55000,60000,70000,75000,80000,90000,100000]
var battleCount = 0
var winCount = 0
 var opInfo = [0,0]
struct numberCard {
    var ID : Int
    var number : Int
    var color : Int//0赤1青2緑
}
let red0 = numberCard(ID: 0, number: 0, color: 0)
let red1 = numberCard(ID: 1, number: 1, color: 0)
let red2 = numberCard(ID: 2, number: 2, color: 0)
let red3 = numberCard(ID: 3, number: 3, color: 0)
let red4 = numberCard(ID: 4, number: 4, color: 0)
let red6 = numberCard(ID: 5, number: 6, color: 0)
let red7 = numberCard(ID: 6, number: 7, color: 0)
let red8 = numberCard(ID: 7, number: 8, color: 0)
let red9 = numberCard(ID: 8, number: 9, color: 0)
let blue0 = numberCard(ID: 9, number: 0, color: 1)
let blue1 = numberCard(ID: 10, number: 1, color: 1)
let blue2 = numberCard(ID: 11, number: 2, color: 1)
let blue3 = numberCard(ID: 12, number: 3, color: 1)
let blue4 = numberCard(ID: 13, number: 4, color: 1)
let blue6 = numberCard(ID: 14, number: 6, color: 1)
let blue7 = numberCard(ID: 15, number: 7, color: 1)
let blue8 = numberCard(ID: 16, number: 8, color: 1)
let blue9 = numberCard(ID: 17, number: 9, color: 1)
let green1 = numberCard(ID: 18, number: 5, color: 2)
let green2 = numberCard(ID: 19, number: 5, color: 2)
let numberList = [red0,red1,red2,red3,red4,red6,red7,red8,red9,blue0,blue1,blue2,blue3,blue4,blue6,blue7,blue8,blue9,green1,green2]

func shuffuleAndDistribute(_ deck : [numberCard]) -> [numberCard] {
    var resultDeck = deck
   
    for _ in 0...100 {
        let randomNumber = Int(arc4random_uniform(20))
       let removedCard = resultDeck[randomNumber]
        resultDeck.remove(at: randomNumber)
        resultDeck.append(removedCard)
    }
    print("ここから",resultDeck,"ここまで")
   
    return resultDeck
}
func sortNumberCard(_ deck : [numberCard]) -> [numberCard] {
    var resultDeck = deck
    var change = true
  
    var deckNumberList = [Int]()
    for i in 0...4 {
        deckNumberList.append(deck[i].number)
    }
    while change {
        change = false
    for i in 0...3 {
        if deckNumberList[i] > deckNumberList[i+1] {
            print("ナンバーチェンジ")
            deckNumberList.swapAt(i, i+1)
            resultDeck.swapAt(i, i+1)
            change = true
        }
    }
    }
    return resultDeck
}
func sortColorCard(_ deck : [numberCard]) -> [numberCard] {
    var deckColorList = [Int]()
    var resultDeck = deck
    var deckNumberList = [Int]()
    for i in 0...4 {
        deckNumberList.append(deck[i].number)
    }
    for i in 0...4 {
        deckColorList.append(deck[i].color)
    }
        for i in 0...3 {
            if deckNumberList[i] == deckNumberList[i+1] && deckNumberList[i] != 5 {
                if deckColorList[i] == 1 {
                    print( deckNumberList[i],"カラーチェンジ")
                    deckColorList.swapAt(i, i+1)
                    resultDeck.swapAt(i, i+1)
                }
            }
        }
    return resultDeck
    
}
struct questionCard {
     var ID : Int
    var questionText : String
    var questionKey : Int
}
var qt1 = "奇数は何枚？"
var qt2 = "偶数は何枚？"
var qt3 = "連番はどこ？"
var qt4 = "５はどこ？"
var qt5 = "１や２はどこ？"
var qt6 = "３や４はどこ？"
var qt7 = "６や７はどこ？"
var qt8 = "８や９はどこ？"
var qt9 = "真ん中３枚の合計は？"
var qt10 = "最初の３枚の合計は？"
var qt11 = "最後の３枚の合計は？"
var qt12 = "最大と最小の差は？"
var qt13 = "全てのカードの合計は？"
var qt14 = "真ん中のカードは５以上？"
var qt15 = "０はどこ？"
var qt16 = "赤は何枚？"
var qt17 = "青は何枚？"
var qt18 = "隣り合う同じ色はどこ？"
var qt19 = "赤の合計は？"
var qt20 = "青の合計は？"
var qt21 = "同じ数字は何組？"
let questionJapaneseTextList = [qt1,qt2,qt3,qt4,qt5,qt6,qt7,qt8,qt9,qt10,qt11,qt12,qt13,qt14,qt15,qt16,qt17,qt18,qt19,qt20,qt21]
var question1 = questionCard(ID: 0, questionText:"How many odd cards?",questionKey:0)
var question2 = questionCard(ID: 1, questionText:"How many even cards?",questionKey:1)
var question3 = questionCard(ID: 2, questionText:"Where're serial number cards?",questionKey:2)
var question4 = questionCard(ID: 3, questionText:"Where're 5s?",questionKey:3)
var question5 = questionCard(ID: 4, questionText:"Where're 1s or 2s?",questionKey:4)
var question6 = questionCard(ID: 5, questionText:"Where're 3s or 4s?",questionKey:5)
var question7 = questionCard(ID: 6, questionText:"Where're 6s or 7s?",questionKey:6)
var question8 = questionCard(ID: 7, questionText:"Where're 8s or 9s?",questionKey:7)
var question9 = questionCard(ID: 8, questionText:"What's the total of the middle 3 cards?",questionKey:8)
var question10 = questionCard(ID: 9, questionText:"What's the total of the first 3 cards?",questionKey:9)
var question11 = questionCard(ID: 10, questionText:"What's the total of the end 3 cards?",questionKey:10)
var question12 = questionCard(ID: 11, questionText:"[C] What's the value of max - min?",questionKey:11)
var question13 = questionCard(ID: 12, questionText:"[C] What's total of all cards?",questionKey:12)
var question14 = questionCard(ID: 13, questionText:"[C] Is the middle card greater than 4?",questionKey:13)
var question15 = questionCard(ID: 14, questionText:"Where are 0s?",questionKey:14)
var question16 = questionCard(ID: 15, questionText:"How many red cards?",questionKey:15)
var question17 = questionCard(ID: 16, questionText:"How many blue cards?",questionKey:16)
var question18 = questionCard(ID: 17, questionText:"Where are sequence same color?",questionKey:17)
var question19 = questionCard(ID: 18, questionText:"What's the total of red cards?",questionKey:18)
var question20 = questionCard(ID: 19, questionText:"What's the total of blue cards?",questionKey:19)
var question21 = questionCard(ID: 20, questionText:"How many pairs of same number?",questionKey:20)
var questionnil = questionCard(ID: -1, questionText:"",questionKey:-1)
var questionList = [question1,question2,question3,question4,question5,question6,question7,question8,question9,question10,question11,question12,question13,question14,question15,question16,question17,question18,question19,question20,question21]
func shuffuleAndDisplay(_ deck : [questionCard]) -> [questionCard] {
    var resultDeck = deck
    
    for _ in 0...100 {
        let randomNumber = Int(arc4random_uniform(UInt32(resultDeck.count)))
        let removedCard = resultDeck[randomNumber]
        resultDeck.remove(at: randomNumber)
        resultDeck.append(removedCard)
    }
    print("こちらは",resultDeck)
    return resultDeck
}


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}
func answer(_ key: Int,_ key1: Int,_ deck: [numberCard]) -> [Int] {
     var answer = [-2,key]
    switch key {
    case 0:
        var count = 0
        for i in 0...4 {
           
            if deck[i].number % 2 == 1 {
                count += 1
            }
        }
        answer.append(count)
        
    case 1:
        var count = 0
        for i in 0...4 {
            
            if deck[i].number % 2 == 0 {
                count += 1
            }
        }
        answer.append(count)
        
    case 2:
        var count = [Int]()
        for i in 0...3 {
            if deck[i].number+1 == deck[i+1].number {
                if count.index(of: i) == nil {
                count.append(i)
                count.append(i+1)
                } else if count.index(of: i) != nil {
                    count.append(i+1)
                }
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 3:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == 5 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 4:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == key1 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
        
    case 5:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == key1 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 6:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == key1 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 7:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == key1 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 8:
        var count = 0
        for i in 1...3 {
            count += deck[i].number
        }
        answer.append(count)
        
    case 9:
        var count = 0
        for i in 0...2 {
            count += deck[i].number
        }
        answer.append(count)
        
    case 10:
        var count = 0
        for i in 2...4 {
            count += deck[i].number
        }
        answer.append(count)
        
    case 11:
        let count = deck[4].number-deck[0].number
        answer.append(count)
        
    case 12:
        var count = 0
        for i in 0...4 {
            count += deck[i].number
        }
        answer.append(count)
        
    case 13:
        var count = 0
        if deck[2].number >= 5 {
            count = 1
        }
        answer.append(count)
        
    case 14:
        var count = [Int]()
        for i in 0...4 {
            if deck[i].number == 0 {
                count.append(i)
            }
        }
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
        
    case 15:
        var count = 0
        for i in 0...4 {
            if deck[i].color == 0 {
                count += 1
            }
        }
        answer.append(count)
        
    case 16:
        var count = 0
        for i in 0...4 {
            if deck[i].color == 1 {
                count += 1
            }
        }
        answer.append(count)
        
    case 17:
        var count = [Int]()
        for i in 0...3 {
            if deck[i].color == deck[i+1].color {
                if count.index(of: i) == nil {
                    count.append(i)
                    count.append(i+1)
                } else if count.index(of: i) != nil {
                    count.append(i+1)
                }
                }
            }
        
        if count.count > 0 {
        for i in 0...count.count-1 {
            answer.append(count[i])
        }
        }
    case 18:
        var count = 0
        for i in 0...4 {
            if deck[i].color == 0 {
                count += deck[i].number
            }
        }
        answer.append(count)
        
    case 19:
        var count = 0
        for i in 0...4 {
            if deck[i].color == 1 {
                count += deck[i].number
            }
        }
        answer.append(count)
        
    case 20:
        var count = 0
        for i in 0...3 {
            if deck[i].number == deck[i+1].number {
                count += 1
            }
        }
        answer.append(count)
    default:
        break
    }
    answer.append(-3)
    return answer
}





func rateCal() {
    let gap = opInfo[0] - rank
    var dR = 0
    
    if isWin {
        if gap > 4 {
            dR += 150
        }
        if gap < 5,gap > 1 {
            dR += 130
        }
        if gap > -2,gap < 2 {
            dR += 100
        }
        if gap > -5,gap < -1 {
            dR += 70
        }
        if gap < -4  {
            dR += 50
        }
        if rank >= 0, rank < 5 {
            dR *= 3
        }
        if rank >= 5, rank < 15 {
            dR *= 2
        }
        if rankUpRateList[rank+1] - rate < dR {
            dR = rankUpRateList[rank+1] - rate
        }
    } else {
        if gap > 4 {
            dR -= 30
        }
        if gap < 5,gap > 1 {
            dR -= 30
        }
        if gap > -2,gap < 2 {
            dR -= 50
        }
        if gap > -5,gap < -1 {
            dR -= 70
        }
        if gap < -4  {
            dR -= 100
        }
        if rank >= 0, rank < 5 {
            dR *= 1
        }
        if rank >= 5, rank < 10 {
            dR *= 2
        }
        if rank >= 10, rank < 15 {
            dR *= 3
        }
        if rank >= 15, rank < 20 {
            dR *= 3
        }
        if rankUpRateList[rank] - rate >
            dR {
            dR = rankUpRateList[rank] - rate
        }
       
    }
    rate += dR
    print("gap",dR)
    if rate < 0 {
        rate = 0
    }
   battleInfo = [rank,rate]
    userDefaults.set(battleInfo, forKey: "battleInfo")
    userDefaults.synchronize()
}


class UISwitchMini: UISwitch {
    @IBInspectable var dispSize: CGSize = CGSize(width: 51.0, height: 31.0) //iOS10での標準サイズをいれている
    override func awakeFromNib() {
        super.awakeFromNib()
        let scaleX: CGFloat = dispSize.width / self.bounds.size.width
        let scaleY: CGFloat = dispSize.height / self.bounds.size.height
        print("[bounds:\(NSStringFromCGRect(self.bounds))] [frame:\(NSStringFromCGRect(self.frame))]")
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        print("[bounds:\(NSStringFromCGRect(self.bounds))] [frame:\(NSStringFromCGRect(self.frame))]")
    }
}



func getTopViewController() -> UIViewController? {
    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        var topViewControlelr: UIViewController = rootViewController
        
        while let presentedViewController = topViewControlelr.presentedViewController {
            topViewControlelr = presentedViewController
        }
        
        return topViewControlelr
    } else {
        return nil
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9204323547115751~6409215707")
       FirebaseApp.configure()
        if let presentView = window?.rootViewController {
            let target = presentView
             player = GKLocalPlayer.localPlayer()
            player.authenticateHandler = {(viewController, error) -> Void in
                if ((viewController) != nil) {
                    print("GameCenter Login: Not Logged In > Show GameCenter Login")
                    
                    target.present(viewController!, animated: true, completion: nil);
                } else {
                    print("GameCenter Login: Log In")
                    
                    if (error == nil){
                        print("LoginAuthentication: Success")
                        
                    } else {
                        print("LoginAuthentication: Failed")
                    }
                }
            }
        }
        let userDefault = UserDefaults.standard
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        userDefault.register(defaults: dict)
        
        // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            Changelanguage = true
        }
        

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("break")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("enterBackground")
        if let topViewController = getTopViewController() as? BattleViewController {
      
            if rankUpRateList[rank] == rate && rate != 0 {
                rank -= 1
                battleInfo = [rank,rate]
                userDefaults.set(battleInfo, forKey: "battleInfo")
                userDefaults.synchronize()
            }
             rateCal()
            isTimeUp = true
            if topViewController.timer != nil {
           topViewController.timer.invalidate()
            }
            if topViewController.opTimer != nil {
                topViewController.opTimer.invalidate()
            }
            topViewController.performSegue(withIdentifier: "timeUpSegue", sender: self)
        }
        
        
        generalMatch.disconnect()
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if userDefaults.array(forKey: "battleInfo") != nil {
            battleInfo = userDefaults.array(forKey: "battleInfo") as! [Int]
        }
        print(battleInfo)
        rate = battleInfo[1]
        rank = battleInfo[0]
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

