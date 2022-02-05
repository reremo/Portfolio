//
//  BattleViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/01/05.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GameKit
class BattleViewController: UIViewController, MCSessionDelegate,GKMatchDelegate {
    @IBOutlet weak var opponentPokemon: UILabel!
    @IBOutlet weak var fitghtingPokemon: UILabel!
    @IBOutlet weak var BattleLog: UITextView!
    @IBOutlet weak var Log: UILabel!
    @IBOutlet weak var weapon1: UIButton!
    @IBOutlet weak var weapon2: UIButton!
    @IBOutlet weak var weapon3: UIButton!
    @IBOutlet weak var weapon4: UIButton!
    @IBOutlet weak var pokemonChange: UIButton!
    @IBOutlet weak var HPLabel: UILabel!
    @IBOutlet weak var myAilmentLabel: UILabel!
    @IBOutlet weak var rivalAilmentLabel: UILabel!
    @IBOutlet weak var segueButton: UIButton!
    @IBOutlet weak var myHPBar: UIProgressView!
    @IBOutlet weak var rivalHPBar: UIProgressView!
    @IBOutlet weak var BattleView: UIView!
    @IBOutlet weak var weaponView: UIView!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    @IBOutlet weak var timeLimit: UILabel!
    var timer: Timer = Timer()
    @IBAction func changeSegue(_ sender: Any) {
        if !waiting {
            performSegue(withIdentifier: "changeSegue", sender: self)
        }
    }
    @IBAction func weaponDecide(_ sender: UIButton) {
        if !waiting {
            
        if sender.currentTitle! != "-" {
           
            if choice && sender.currentTitle! != searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], choiceNumber) {
                Log.text = "こだわっている"
            } else {
        switch sender.currentTitle! {
            case searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1):buttonFunction(1)
            case searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2):buttonFunction(2)
            case searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3):buttonFunction(3)
            case searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4):buttonFunction(4)
            default: break
        }
            buttonIsOn(false)
            if waiting == false {
                waiting = true
            }
            if waiting && rivalWaiting {
                if isResponsible {
                
                 resultData = battleSystem(myBattleData, rivalBattleData)
                    print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"",resultData[24],"タスキ",resultData[25],resultData[26],"オボン",resultData[27])
                    myHPList[myBattlingPokemonNumber] = resultData[4]
                    rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                    myAilmentList[myBattlingPokemonNumber] = resultData[32]
                    rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                 print("sendResult",resultData)
                    sendClear()
                    for i in 0...resultData.count-1 {
                        let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                        do {
                            if isGKMatch {
                                try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                            } else {
                                try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                            }
                            } catch {
                                }
                    }
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    updateScene()
                    /*
                    HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                    fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                    opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                    rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                   myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                    weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                    weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                    weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                    weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
 */
                    if resultData[26] != 0 {//オボン消費の処理
                        myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                    }
                    BattleLog.text = createBattleLog(resultData)
                    if resultData[5] != 0 {
                    buttonIsOn(true)
                    }
                    waiting = false
                    rivalWaiting = false
                    myBattleData.removeAll()
                    rivalBattleData.removeAll()
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                            }
                }
            }
        }
    }
}
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("isResponsible",isResponsible)
        if !isGKMatch {
            generalSession.delegate = self
        } else {
            generalMatch.delegate = self
        }
        let min: Int = battleTimer / 60
        let sec: Int = battleTimer % 60
        var zero = ""
        if sec < 10 {
            zero = "0"
        }
        timeLimit.text = String(min)+":"+zero+String(sec)
        myHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        rivalHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        myHPBar.layer.masksToBounds = true
        myHPBar.layer.cornerRadius = 3.0
        rivalHPBar.layer.masksToBounds = true
        rivalHPBar.layer.cornerRadius = 3.0
        BattleLog.layer.masksToBounds = true
        BattleLog.layer.cornerRadius = 10.0
        BattleView.layer.masksToBounds = true
        BattleView.layer.cornerRadius = 10.0
        weaponView.layer.masksToBounds = true
        weaponView.layer.cornerRadius = 10.0
        weapon1.layer.masksToBounds = true
        weapon1.layer.cornerRadius = 10.0
        weapon1.setTitleColor(UIColor.black, for: .normal)
        weapon1.layer.borderWidth = 10.0
        weapon1.layer.borderColor = UIColor.white.cgColor
        weapon2.layer.masksToBounds = true
        weapon2.layer.cornerRadius = 10.0
        weapon2.setTitleColor(UIColor.black, for: .normal)
         weapon2.layer.borderWidth = 10.0
        weapon2.layer.borderColor = UIColor.white.cgColor
        weapon3.layer.masksToBounds = true
        weapon3.layer.cornerRadius = 10.0
        weapon3.setTitleColor(UIColor.black, for: .normal)
         weapon3.layer.borderWidth = 10.0
        weapon3.layer.borderColor = UIColor.white.cgColor
        weapon4.layer.masksToBounds = true
        weapon4.layer.cornerRadius = 10.0
        weapon4.setTitleColor(UIColor.black, for: .normal)
         weapon4.layer.borderWidth = 10.0
        weapon4.layer.borderColor = UIColor.white.cgColor
        pokemonChange.layer.masksToBounds = true
        pokemonChange.layer.cornerRadius = 10.0
        pokemonChange.backgroundColor = UIColor.blue
        pokemonChange.setTitleColor(UIColor.white, for: .normal)
        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
        BattleLog.text = battleLog
        if !isFromChanging {
             timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            print(myHPList,"ここ！！！",myBattlingPokemonNumber)
            weapon1.layer.borderColor = UIColor.white.cgColor
            weapon2.layer.borderColor = UIColor.white.cgColor
            weapon3.layer.borderColor = UIColor.white.cgColor
            weapon4.layer.borderColor = UIColor.white.cgColor
            updateScene()
            /*
        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
            myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
            rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
            myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
            rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
            setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
            setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
            weapon1.layer.borderColor = UIColor.white.cgColor
            weapon2.layer.borderColor = UIColor.white.cgColor
            weapon3.layer.borderColor = UIColor.white.cgColor
            weapon4.layer.borderColor = UIColor.white.cgColor
            
            if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
            }
            if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
            }
            if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
            }
            if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
            }
            weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
 */
        } else if isFromChanging {
            sendClear()
            isFromChanging = false
            weapon1.layer.masksToBounds = true
            weapon1.layer.cornerRadius = 10.0
          
            weapon2.layer.masksToBounds = true
            weapon2.layer.cornerRadius = 10.0
          
            weapon3.layer.masksToBounds = true
            weapon3.layer.cornerRadius = 10.0
       
            weapon4.layer.masksToBounds = true
            weapon4.layer.cornerRadius = 10.0
         
            pokemonChange.layer.masksToBounds = true
            pokemonChange.layer.cornerRadius = 10.0
            pokemonChange.backgroundColor = UIColor.blue
            pokemonChange.setTitleColor(UIColor.white, for: .normal)
                for i in 0...myBattleData.count-1 {
                    let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
                    do {
                        if isGKMatch {
                            try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                        } else {
                            try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                        }
                    } catch {
                    }
                }
            weapon1.layer.borderColor = UIColor.white.cgColor
            weapon2.layer.borderColor = UIColor.white.cgColor
            weapon3.layer.borderColor = UIColor.white.cgColor
            weapon4.layer.borderColor = UIColor.white.cgColor
            updateScene()
            /*
            HPLabel.text! = String(myHPList[oldMyBattlingPokemonNumber]) + " / " + String(myOriginHPList[oldMyBattlingPokemonNumber])
            fitghtingPokemon.text = myPartyNameList[oldMyBattlingPokemonNumber]
            opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
            myAilmentLabel.text = ailmentList[myAilmentList[oldMyBattlingPokemonNumber]]
            rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
            weapon1.setTitle(searchWeaponName(myBattlePartyData[oldMyBattlingPokemonNumber], 1), for: UIControlState.normal)
            weapon2.setTitle(searchWeaponName(myBattlePartyData[oldMyBattlingPokemonNumber], 2), for: UIControlState.normal)
            weapon3.setTitle(searchWeaponName(myBattlePartyData[oldMyBattlingPokemonNumber], 3), for: UIControlState.normal)
            weapon4.setTitle(searchWeaponName(myBattlePartyData[oldMyBattlingPokemonNumber], 4), for: UIControlState.normal)
            weapon1.layer.borderColor = UIColor.white.cgColor
            weapon2.layer.borderColor = UIColor.white.cgColor
            weapon3.layer.borderColor = UIColor.white.cgColor
            weapon4.layer.borderColor = UIColor.white.cgColor
            if myBattlePokemonDataList[oldMyBattlingPokemonNumber][9] != -1 {
                weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[oldMyBattlingPokemonNumber][9]][2]].cgColor
            }
            if myBattlePokemonDataList[oldMyBattlingPokemonNumber][10] != -1 {
                weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[oldMyBattlingPokemonNumber][10]][2]].cgColor
            }
            if myBattlePokemonDataList[oldMyBattlingPokemonNumber][11] != -1 {
                weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[oldMyBattlingPokemonNumber][11]][2]].cgColor
            }
            if myBattlePokemonDataList[oldMyBattlingPokemonNumber][12] != -1 {
                weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[oldMyBattlingPokemonNumber][12]][2]].cgColor
            }
*/
            if isFromChangingDying {
                isFromChangingDying = false
                if !draw {
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    updateScene()
                    /*
                HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                    rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                        weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                        weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                        weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                        weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                    }
*/
                battleLog += "<交代>自分は\(myPartyNameList[myBattlingPokemonNumber])を繰り出した\n\n"
                
                BattleLog.text = battleLog
                waiting = false
                rivalWaiting = false
                setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                } else {
                    buttonIsOn(false)//共倒れなら待て
                }
            } else {
                buttonIsOn(false)//ただの交代なら待て
            }
            if waiting && rivalWaiting {
                if isResponsible {
                    resultData = battleSystem(myBattleData, rivalBattleData)
                    print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"",resultData[24],"タスキ",resultData[25],resultData[26],"オボン",resultData[27])
                    sendClear()
                    for i in 0...resultData.count-1 {
                        let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                        do {
                            if isGKMatch {
                                try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                            } else {
                                try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                            }
                        } catch {
                        }
                    }
                    
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    updateScene()
                    /*
                    HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                    fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                    opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                    rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                    myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                    weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                    weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                    weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                    weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                        weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                        weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                        weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                        weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                    }
*/
                    if resultData[26] != 0 {//オボン消費の処理
                        myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                    }
                    BattleLog.text = createBattleLog(resultData)
                    if resultData[5] != 0 {
                    buttonIsOn(true)
                    }
                    waiting = false
                    rivalWaiting = false
                    myBattleData.removeAll()
                    rivalBattleData.removeAll()
                 //   resultData.removeAll()
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                }
            }
            oldMyBattlingPokemonNumber = myBattlingPokemonNumber
            isFromChanging = false
        }
    
        // Do any additional setup after loading the view.
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.sync {
            
            let data = NSData(data: data)
            var rivalData : NSInteger = 0
            data.getBytes(&rivalData, length: data.length)
            print(rivalData)
            rivalBattleData.append(rivalData)
            
            
            if rivalData == -6 {
                rivalBattleData.removeAll()
            }
            
            
            else if rivalData == -2 {
                if rivalWaiting == false {
                    rivalWaiting = true
                }
                if !isResponsible {
                    rivalBattleData.removeAll()
                    print("resset",rivalBattleData)
                }
                print("receive",rivalBattleData)
                if waiting && rivalWaiting {
                    if isResponsible {
                        resultData = battleSystem(myBattleData, rivalBattleData)
                        print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"",resultData[24],"タスキ",resultData[25],resultData[26],"オボン",resultData[27])
                        myHPList[myBattlingPokemonNumber] = resultData[4]
                        rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                        myAilmentList[myBattlingPokemonNumber] = resultData[32]
                        rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                        print("sendResult",resultData)
                        sendClear()
                        for i in 0...resultData.count-1 {
                            let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                            do {
                                if isGKMatch {
                                    try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                                } else {
                                    try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                                }
                            } catch {
                            }
                        }
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        updateScene()
                        /*
                        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                        myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                        rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                        myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                        rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                        weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                            weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                            weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                            weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                            weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                        }
 */
                        if resultData[26] != 0 {//オボン消費の処理
                            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                        }
                        BattleLog.text = createBattleLog(resultData)
                        if resultData[5] != 0 {
                        buttonIsOn(true)
                        }
                        waiting = false
                        rivalWaiting = false
                        myBattleData.removeAll()
                        rivalBattleData.removeAll()
                     //   resultData.removeAll()
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                    } else {
                        rivalBattleData.removeAll()
                        print("resset",rivalBattleData)
                    }
                }
            }
            
            
            else if rivalData == -3 {
                if rivalWaiting == false {
                    rivalWaiting = true
                }
                
                print(rivalBattleData)
                rivalBattlingPokemonNumber = rivalBattleData[13]
                rivalStatusData = [6,6,6,6,6]
              /*  if waiting {
                if !isResponsible {
                    sendClear()
                    for i in 0...myBattleData.count-1 {
                        let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
                        do {
                            try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                        } catch {
                        }
                    }
                    rivalBattleData.removeAll()
                    myBattleData.removeAll()
                    waiting = false
                    rivalWaiting = false
                    print("resset",rivalBattleData)
                    }
                } else {
                    if !isResponsible {
                        rivalBattleData.removeAll()
                    }
                }
                */
                if waiting && rivalWaiting {
                    if isResponsible {
                        
                        resultData = battleSystem(myBattleData, rivalBattleData)
                        print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"")
                        myHPList[myBattlingPokemonNumber] = resultData[4]
                        rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                        myAilmentList[myBattlingPokemonNumber] = resultData[32]
                        rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                        print("sendResult",resultData)
                        sendClear()
                        for i in 0...resultData.count-1 {
                            let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                            do {
                                if isGKMatch {
                                    try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                                } else {
                                    try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                                }
                            } catch {
                            }
                        }
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        updateScene()
                        /*
                        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                        myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                        rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                        myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                        rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                        weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                            weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                            weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                            weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                            weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                        }
*/
                        if resultData[26] != 0 {//オボン消費の処理
                            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                        }
                        BattleLog.text = createBattleLog(resultData)
                        if resultData[5] != 0 {
                        buttonIsOn(true)
                        }
                        waiting = false
                        rivalWaiting = false
                        myBattleData.removeAll()
                        rivalBattleData.removeAll()
                      //  resultData.removeAll()
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                    } else {
                        rivalBattleData.removeAll()
                        print("resset",rivalBattleData)
                    }
                }
            }
                
                
                
                
            else if rivalData == -4 {
                
                
                 resultData = rivalBattleData
                print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"")
                rivalBattlingPokemonNumber = rivalBattleData[6]
                if resultData[0] == 1 {
                    resultData[0] = 2
                } else if resultData[0] == 2 {
                    resultData[0] = 1
                }
                if resultData[1] == 0 {
                    resultData[1] = 1
                } else if resultData[1] == 1 {
                    resultData[1] = 0
                }
                var a = resultData[2]
                var b = resultData[3]
                var c = resultData[4]
                var d = resultData[5]
                var e = resultData[6]
                var f = resultData[7]
                var g = resultData[8]
                var h = resultData[9]
                var i = resultData[10]
                var j = resultData[11]
                var k = resultData[12]
                var l = resultData[13]
                var m = resultData[14]
                var n = resultData[15]
                var o = resultData[16]
                var p = resultData[17]
                var q = resultData[18]
                var r = resultData[19]
                var x = resultData[20]
                var y = resultData[21]
                var z = resultData[22]
                var aa = resultData[23]
                var ab = resultData[24]
                var ac = resultData[25]
                var ad = resultData[26]
                var ae = resultData[27]
                var af = resultData[28]
                var ag = resultData[29]
                var ah = resultData[30]
                var ai = resultData[31]
                var aj = resultData[32]
                var ak = resultData[33]
                var al = resultData[34]
                var am = resultData[35]
                var an = resultData[36]
                var ao = resultData[37]
                var ap = resultData[38]
                var aq = resultData[39]
                var ar = resultData[40]
                var at = resultData[41]
                var au = resultData[42]
                var av = resultData[43]
                var aw = resultData[44]
                var ax = resultData[45]
                var ay = resultData[46]
                var az = resultData[47]
                var ba = resultData[48]
                var bb = resultData[49]
                swap(&a, &b)
                swap(&c, &d)
                swap(&e, &g)
                swap(&f, &h)
                swap(&i, &j)
                swap(&k, &l)
                swap(&m, &n)
                swap(&o, &p)
                swap(&q, &r)
                swap(&x, &y)
                swap(&z, &aa)
                swap(&ab, &ac)
                swap(&ad, &ae)
                swap(&af, &ag)
                swap(&ah, &ai)
                swap(&aj, &ak)
                swap(&al, &am)
                swap(&an, &ao)
                swap(&ap, &aq)
                swap(&ar, &at)
                swap(&au, &av)
                swap(&aw, &ax)
                swap(&ay, &az)
                swap(&ba, &bb)
                resultData[2] = a //元々の体力
                resultData[3] = b
                resultData[4] = c //自分の残り体力
                resultData[5] = d
                resultData[6] = e //自分のバトリング番号
                resultData[7] = f //自分の元々のバトリング番号
                resultData[8] = g
                resultData[9] = h
                resultData[10] = i //自分の技
                resultData[11] = j //相手の技
                resultData[12] = k //自分の攻撃がヒット
                resultData[13] = l //
                resultData[14] = m //自分の急所ヒット
                resultData[15] = n //
                resultData[16] = o //自分の攻撃の相性
                resultData[17] = p
                resultData[18] = q //自分のataetaダメージ
                resultData[19] = r
                resultData[20] = x //自分の持ち物
                resultData[21] = y
                resultData[22] = z //いのちのたまダメージ
                resultData[23] = aa
                resultData[24] = ab // 1なら自分の襷発動
                resultData[25] = ac
                resultData[26] = ad // オボン
                resultData[27] = ae
                resultData[28] = af //食べ残し
                resultData[29] = ag
                resultData[30] = ah //元々の体力
                resultData[31] = ai
                resultData[32] = aj //自分の状態異常
                resultData[33] = ak
                resultData[34] = al //やけどダメージ
                resultData[35] = am
                resultData[36] = an//痺れたら１
                resultData[37] = ao
                resultData[38] = ap//氷溶けたら１凍っていれば２
                resultData[39] = aq
                resultData[40] = ar//毒ダメ
                resultData[41] = at
                resultData[42] = au//起きたら１寝ていれば２
                resultData[43] = av
                resultData[44] = aw//0ならサブが発動
                resultData[45] = ax
                resultData[46] = ay//攻撃が発動すれば１
                resultData[47] = az
                resultData[48] = ba//攻撃後に表示するメッセージ
                resultData[49] = bb
                myHPList[myBattlingPokemonNumber] = resultData[4]
                rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                myAilmentList[myBattlingPokemonNumber] = resultData[32]
                rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                if resultData[4] == 0 {
                    performSegue(withIdentifier: "changeSegue", sender: self)
                }
                weapon1.layer.borderColor = UIColor.white.cgColor
                weapon2.layer.borderColor = UIColor.white.cgColor
                weapon3.layer.borderColor = UIColor.white.cgColor
                weapon4.layer.borderColor = UIColor.white.cgColor
                updateScene()
                /*
                HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                weapon1.layer.borderColor = UIColor.white.cgColor
                weapon2.layer.borderColor = UIColor.white.cgColor
                weapon3.layer.borderColor = UIColor.white.cgColor
                weapon4.layer.borderColor = UIColor.white.cgColor
                if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                    weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                    weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                    weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                    weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                }
*/
                if resultData[26] != 0 {//オボン消費の処理
                    myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                }
                BattleLog.text = createBattleLog(resultData)
                if resultData[5] != 0 {
                buttonIsOn(true)
                }
                waiting = false
                rivalWaiting = false
                myBattleData.removeAll()
                rivalBattleData.removeAll()
              //  resultData.removeAll()
                print(myPartyNameList[myBattlingPokemonNumber])
                
                setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
            } else if rivalData == -5 {
                rivalPoisonCount = 0
                rivalStatusData = [6,6,6,6,6]
                if draw {
                    rivalBattlingPokemonNumber = rivalBattleData[13]
                    sendClear()
                    if myBattleData.count != 0 {
                        draw = false
                    for i in 0...myBattleData.count-1 {
                        let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
                        do {
                            if isGKMatch {
                                try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                            } else {
                                try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                            }
                        } catch {
                        }
                    }
                     buttonIsOn(true)
                    }
                    updateScene()
                    /*
                    HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                    fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                    opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                    rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                    myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                    weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                    weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                    weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                    weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                    if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                        weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                        weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                        weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                        weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                    }
                    */
                    battleLog += "<交代>自分は\(myPartyNameList[myBattlingPokemonNumber])を繰り出した\n\n"
                    
                    BattleLog.text = battleLog
                    waiting = false
                    rivalWaiting = false
               //     myBattleData.removeAll()
                    rivalBattleData.removeAll()
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                    
                } else {
                print("死に出し",rivalBattleData)
                battleLog += "<交代>相手は\(rivalPartyNameList[rivalBattleData[13]])を繰り出した\n\n"
                
                BattleLog.text = battleLog
                buttonIsOn(true)
                waiting = false
                rivalWaiting = false
                rivalBattlingPokemonNumber = rivalBattleData[13]
                opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                }
            }
        }
    }
    
    
    
    
    
    
    
    func match(_: GKMatch, didReceive data: Data, fromRemotePlayer: GKPlayer) {
      //  DispatchQueue.main.sync {
            
            let data = NSData(data: data)
            var rivalData : NSInteger = 0
            data.getBytes(&rivalData, length: data.length)
            print(rivalData)
            rivalBattleData.append(rivalData)
            
            
            if rivalData == -6 {
                rivalBattleData.removeAll()
            }
                
                
            else if rivalData == -2 {
                if rivalWaiting == false {
                    rivalWaiting = true
                }
                if !isResponsible {
                    rivalBattleData.removeAll()
                    print("resset",rivalBattleData)
                }
                print("receive",rivalBattleData)
                if waiting && rivalWaiting {
                    if isResponsible {
                        resultData = battleSystem(myBattleData, rivalBattleData)
                        print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"",resultData[24],"タスキ",resultData[25],resultData[26],"オボン",resultData[27])
                        myHPList[myBattlingPokemonNumber] = resultData[4]
                        rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                        myAilmentList[myBattlingPokemonNumber] = resultData[32]
                        rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                        print("sendResult",resultData)
                        sendClear()
                        for i in 0...resultData.count-1 {
                            let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                            do {
                                if isGKMatch {
                                    try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                                } else {
                                    try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                                }
                            } catch {
                            }
                        }
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        updateScene()
                        /*
                        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                        myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                        rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                        myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                        rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                        weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                            weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                            weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                            weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                            weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                        }
                        */
                        if resultData[26] != 0 {//オボン消費の処理
                            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                        }
                        BattleLog.text = createBattleLog(resultData)
                        if resultData[5] != 0 {
                            buttonIsOn(true)
                        }
                        waiting = false
                        rivalWaiting = false
                        myBattleData.removeAll()
                        rivalBattleData.removeAll()
                        //   resultData.removeAll()
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                    } else {
                        rivalBattleData.removeAll()
                        print("resset",rivalBattleData)
                    }
                }
            }
                
                
            else if rivalData == -3 {
                if rivalWaiting == false {
                    rivalWaiting = true
                }
                
                print(rivalBattleData)
                rivalBattlingPokemonNumber = rivalBattleData[13]
                /*  if waiting {
                 if !isResponsible {
                 sendClear()
                 for i in 0...myBattleData.count-1 {
                 let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
                 do {
                 try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                 } catch {
                 }
                 }
                 rivalBattleData.removeAll()
                 myBattleData.removeAll()
                 waiting = false
                 rivalWaiting = false
                 print("resset",rivalBattleData)
                 }
                 } else {
                 if !isResponsible {
                 rivalBattleData.removeAll()
                 }
                 }
                 */
                if waiting && rivalWaiting {
                    if isResponsible {
                        
                        resultData = battleSystem(myBattleData, rivalBattleData)
                        print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"")
                        myHPList[myBattlingPokemonNumber] = resultData[4]
                        rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                        myAilmentList[myBattlingPokemonNumber] = resultData[32]
                        rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                        print("sendResult",resultData)
                        sendClear()
                        for i in 0...resultData.count-1 {
                            let data = NSData(bytes: &resultData[i], length: MemoryLayout<NSInteger>.size)
                            do {
                                if isGKMatch {
                                    try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                                } else {
                                    try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                                }
                            } catch {
                            }
                        }
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        updateScene()
                        /*
                        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                        myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                        rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                        myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                        rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                        weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                        weapon1.layer.borderColor = UIColor.white.cgColor
                        weapon2.layer.borderColor = UIColor.white.cgColor
                        weapon3.layer.borderColor = UIColor.white.cgColor
                        weapon4.layer.borderColor = UIColor.white.cgColor
                        if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                            weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                            weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                            weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                        }
                        if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                            weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                        }
                        */
                        if resultData[26] != 0 {//オボン消費の処理
                            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                        }
                        BattleLog.text = createBattleLog(resultData)
                        if resultData[5] != 0 {
                            buttonIsOn(true)
                        }
                        waiting = false
                        rivalWaiting = false
                        myBattleData.removeAll()
                        rivalBattleData.removeAll()
                        //  resultData.removeAll()
                        setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                    } else {
                        rivalBattleData.removeAll()
                        print("resset",rivalBattleData)
                    }
                }
            }
                
                
                
                
            else if rivalData == -4 {
                
                
                resultData = rivalBattleData
                print("receiveResult",resultData[2],"元々の体力",resultData[3],"元々の相手体力",resultData[4],"自分の残り体力",resultData[5],"相手の残り体力",resultData[6],"自分のバトリング番号",resultData[7],"自分の元々のバトリング番号",resultData[8],"相手のバトリング番号",resultData[9],"相手の元々のバトリング番号",resultData[10],"自分の技",resultData[11],"相手の技",resultData[12],"自分の攻撃がヒット",resultData[13],"",resultData[14],"自分の急所ヒット",resultData[15],"",resultData[16],"自分の攻撃の相性",resultData[17],"",resultData[18],"自分のataetaダメージ",resultData[19],"",resultData[20],"自分の持ち物",resultData[21],"",resultData[22],"いのちのたまダメージ",resultData[23],"")
                rivalBattlingPokemonNumber = rivalBattleData[6]
                if resultData[0] == 1 {
                    resultData[0] = 2
                } else if resultData[0] == 2 {
                    resultData[0] = 1
                }
                if resultData[1] == 0 {
                    resultData[1] = 1
                } else if resultData[1] == 1 {
                    resultData[1] = 0
                }
                var a = resultData[2]
                var b = resultData[3]
                var c = resultData[4]
                var d = resultData[5]
                var e = resultData[6]
                var f = resultData[7]
                var g = resultData[8]
                var h = resultData[9]
                var i = resultData[10]
                var j = resultData[11]
                var k = resultData[12]
                var l = resultData[13]
                var m = resultData[14]
                var n = resultData[15]
                var o = resultData[16]
                var p = resultData[17]
                var q = resultData[18]
                var r = resultData[19]
                var x = resultData[20]
                var y = resultData[21]
                var z = resultData[22]
                var aa = resultData[23]
                var ab = resultData[24]
                var ac = resultData[25]
                var ad = resultData[26]
                var ae = resultData[27]
                var af = resultData[28]
                var ag = resultData[29]
                var ah = resultData[30]
                var ai = resultData[31]
                var aj = resultData[32]
                var ak = resultData[33]
                var al = resultData[34]
                var am = resultData[35]
                var an = resultData[36]
                var ao = resultData[37]
                var ap = resultData[38]
                var aq = resultData[39]
                var ar = resultData[40]
                var at = resultData[41]
                var au = resultData[42]
                var av = resultData[43]
                var aw = resultData[44]
                var ax = resultData[45]
                var ay = resultData[46]
                var az = resultData[47]
                var ba = resultData[48]
                var bb = resultData[49]
                swap(&a, &b)
                swap(&c, &d)
                swap(&e, &g)
                swap(&f, &h)
                swap(&i, &j)
                swap(&k, &l)
                swap(&m, &n)
                swap(&o, &p)
                swap(&q, &r)
                swap(&x, &y)
                swap(&z, &aa)
                swap(&ab, &ac)
                swap(&ad, &ae)
                swap(&af, &ag)
                swap(&ah, &ai)
                swap(&aj, &ak)
                swap(&al, &am)
                swap(&an, &ao)
                swap(&ap, &aq)
                swap(&ar, &at)
                swap(&au, &av)
                swap(&aw, &ax)
                swap(&ay, &az)
                swap(&ba, &bb)
                resultData[2] = a //元々の体力
                resultData[3] = b
                resultData[4] = c //自分の残り体力
                resultData[5] = d
                resultData[6] = e //自分のバトリング番号
                resultData[7] = f //自分の元々のバトリング番号
                resultData[8] = g
                resultData[9] = h
                resultData[10] = i //自分の技
                resultData[11] = j //相手の技
                resultData[12] = k //自分の攻撃がヒット
                resultData[13] = l //
                resultData[14] = m //自分の急所ヒット
                resultData[15] = n //
                resultData[16] = o //自分の攻撃の相性
                resultData[17] = p
                resultData[18] = q //自分のataetaダメージ
                resultData[19] = r
                resultData[20] = x //自分の持ち物
                resultData[21] = y
                resultData[22] = z //いのちのたまダメージ
                resultData[23] = aa
                resultData[24] = ab // 1なら自分の襷発動
                resultData[25] = ac
                resultData[26] = ad // オボン
                resultData[27] = ae
                resultData[28] = af //食べ残し
                resultData[29] = ag
                resultData[30] = ah //元々の体力
                resultData[31] = ai
                resultData[32] = aj //自分の状態異常
                resultData[33] = ak
                resultData[34] = al //やけどダメージ
                resultData[35] = am
                resultData[36] = an//痺れたら１
                resultData[37] = ao
                resultData[38] = ap//氷溶けたら１凍っていれば２
                resultData[39] = aq
                resultData[40] = ar//毒ダメ
                resultData[41] = at
                resultData[42] = au//起きたら１寝ていれば２
                resultData[43] = av
                resultData[44] = aw//0ならサブが発動
                resultData[45] = ax
                resultData[46] = ay//攻撃が発動すれば１
                resultData[47] = az
                resultData[48] = ba//攻撃後に表示するメッセージ
                resultData[49] = bb
                myHPList[myBattlingPokemonNumber] = resultData[4]
                rivalHPList[rivalBattlingPokemonNumber] = resultData[5]
                myAilmentList[myBattlingPokemonNumber] = resultData[32]
                rivalAilmentList[rivalBattlingPokemonNumber] = resultData[33]
                if resultData[4] == 0 {
                    performSegue(withIdentifier: "changeSegue", sender: self)
                }
                weapon1.layer.borderColor = UIColor.white.cgColor
                weapon2.layer.borderColor = UIColor.white.cgColor
                weapon3.layer.borderColor = UIColor.white.cgColor
                weapon4.layer.borderColor = UIColor.white.cgColor
                updateScene()
                /*
                HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                weapon1.layer.borderColor = UIColor.white.cgColor
                weapon2.layer.borderColor = UIColor.white.cgColor
                weapon3.layer.borderColor = UIColor.white.cgColor
                weapon4.layer.borderColor = UIColor.white.cgColor
                if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                    weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                    weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                    weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                }
                if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                    weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                }
                */
                if resultData[26] != 0 {//オボン消費の処理
                    myBattlePokemonDataList[myBattlingPokemonNumber][13] = 0
                }
                BattleLog.text = createBattleLog(resultData)
                if resultData[5] != 0 {
                    buttonIsOn(true)
                }
                waiting = false
                rivalWaiting = false
                myBattleData.removeAll()
                rivalBattleData.removeAll()
                //  resultData.removeAll()
                print(myPartyNameList[myBattlingPokemonNumber])
                
                setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
            } else if rivalData == -5 {
                rivalPoisonCount = 0
                if draw {
                    rivalBattlingPokemonNumber = rivalBattleData[13]
                    
                    sendClear()
                    if myBattleData.count != 0 {
                    draw = false
                    for i in 0...myBattleData.count-1 {
                        let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
                        do {
                            if isGKMatch {
                                try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                            } else {
                                try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
                            }
                        } catch {
                        }
                    }
                        buttonIsOn(true)
                    }
                    weapon1.layer.borderColor = UIColor.white.cgColor
                    weapon2.layer.borderColor = UIColor.white.cgColor
                    weapon3.layer.borderColor = UIColor.white.cgColor
                    weapon4.layer.borderColor = UIColor.white.cgColor
                    updateScene()
                    /*
                    HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
                    fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
                    opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
                    rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
                    myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                    weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
                    weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
                    weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
                    weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
                  if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
                        weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
                        weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
                        weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
                    }
                    if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
                        weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
                    }
 */
                    battleLog += "<交代>自分は\(myPartyNameList[myBattlingPokemonNumber])を繰り出した\n\n"
                    
                    BattleLog.text = battleLog
                    waiting = false
                    rivalWaiting = false
                   // myBattleData.removeAll()
                    rivalBattleData.removeAll()
                    setProgress(progressView: myHPBar, progress: myHPRate, animated: true)
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: true)
                } else {
                    print("死に出し",rivalBattleData)
                    battleLog += "<交代>相手は\(rivalPartyNameList[rivalBattleData[13]])を繰り出した\n\n"
                    
                    BattleLog.text = battleLog
                    buttonIsOn(true)
                    waiting = false
                    rivalWaiting = false
                    rivalBattlingPokemonNumber = rivalBattleData[13]
                    opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
                    rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
                    setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
                }
            }
        //}
    }
    
    
    func setProgress(progressView: UIProgressView, progress: Float, animated: Bool) {
        CATransaction.setCompletionBlock {
            NSLog("finish animation")
        }
        progressView.setProgress(progress, animated: animated)
        NSLog("begin animation")
        if progress > 0.5 {
        progressView.progressTintColor = UIColor.green
        } else if progress <= 0.2 {
            progressView.progressTintColor = UIColor.red
        } else {
            progressView.progressTintColor = UIColor.yellow
        }
    }
    func createcreateBattleLogSub1(_ doAttack: Int,_ damage: Int,_ isHit: Int,_ isCritical: Int,_ compatibility: Int) {
        if isHit == 0 {
            if isCritical == 0 && compatibility != 0 && damage != 0 {
                battleLog += "急所に当たった\n"
                

            }
            if compatibility == 0 && doAttack == 1{
                battleLog += "効果はないようだ\n"
                

            } else if compatibility == 1 {
                if damage != 0 {
                battleLog += "効果はいまひとつのようだ\n"
                }

            } else if compatibility == 3 {
                if damage != 0 {
                battleLog += "効果は抜群だ\n"
                }

            }
        } else {
            battleLog += "しかし攻撃は外れた\n"
            

        }
    }
    func beforeAttackLog(_ MorR: String,_ poke: Int,_ para: Int,_ melt: Int,_ wake: Int) {
        if MorR == "M" {
        if para == 1 {
             battleLog += "自分の\(myPartyNameList[poke])はしびれてうごけない\n"
        }
        if melt == 1 {
             battleLog += "自分の\(myPartyNameList[poke])のこおりがとけた\n"
        } else if melt == 2 {
            battleLog += "自分の\(myPartyNameList[poke])はこおってうごけない\n"
        }
            if wake == 1 {
                battleLog += "自分の\(myPartyNameList[poke])はめをさました\n"
            } else if wake == 2 {
                battleLog += "自分の\(myPartyNameList[poke])はぐうぐうねむっている\n"
            }
        } else if MorR == "R" {
            if para == 1 {
                battleLog += "相手の\(rivalPartyNameList[poke])はしびれてうごけない\n"
            }
            if melt == 1 {
                battleLog += "相手の\(rivalPartyNameList[poke])のこおりがとけた\n"
            } else if melt == 2 {
                battleLog += "相手の\(rivalPartyNameList[poke])はこおってうごけない\n"
            }
            if wake == 1 {
                battleLog += "相手の\(rivalPartyNameList[poke])はめをさました\n"
            } else if wake == 2 {
                battleLog += "相手の\(rivalPartyNameList[poke])はぐうぐうねむっている\n"
            }
        }
    }
    func afterAttackLog(_ MorR: String,_ poke: Int,_ sub: Int,_ ail: Int) {
        if MorR == "M" {
            if sub == 0 {
                switch ail {
                case 1:
                 battleLog += "自分の\(myPartyNameList[poke])はやけどをおった\n"
                case 2:
                    battleLog += "自分の\(myPartyNameList[poke])はしびれた\n"
                case 3:
                    battleLog += "自分の\(myPartyNameList[poke])はこおりついた\n"
                case 4:
                    battleLog += "自分の\(myPartyNameList[poke])はどくをあびた\n"
                case 5:
                    battleLog += "自分の\(myPartyNameList[poke])はもうどくをあびた\n"
                case 6:
                    battleLog += "自分の\(myPartyNameList[poke])は眠ってしまった\n"
                    default:
                    break
                
                }
            }
        }
        if MorR == "R" {
            if sub == 0 {
                switch ail {
                case 1:
                    battleLog += "相手の\(rivalPartyNameList[poke])はやけどをおった\n"
                case 2:
                    battleLog += "相手の\(rivalPartyNameList[poke])はしびれた\n"
                case 3:
                    battleLog += "相手の\(rivalPartyNameList[poke])はこおりついた\n"
                case 4:
                    battleLog += "相手の\(rivalPartyNameList[poke])はどくをあびた\n"
                case 5:
                    battleLog += "相手の\(rivalPartyNameList[poke])はもうどくをあびた\n"
                case 6:
                    battleLog += "相手の\(rivalPartyNameList[poke])は眠ってしまった\n"
                default:
                    break
                    
                }
            }
        }
    }
    func afterAttackLog2(_ MorR:String,_ massage: Int) {
        var person1 = ""
        var person2 = ""
        if MorR == "M" {
            person1 = "自分"
            person2 = "相手"
        } else if MorR == "R" {
            person2 = "自分"
            person1 = "相手"        }
        
            if massage > 6 && massage < 36 {
            switch massage {
            case 7:battleLog += person1 + "の攻撃は上がった\n"
            case 8:battleLog += person1 + "の攻撃はぐーんと上がった\n"
            case 9:battleLog += person1 + "の防御は上がった\n"
            case 10:battleLog += person1 + "の防御はぐーんと上がった\n"
            case 11:battleLog += person1 + "の特攻は上がった\n"
            case 12:battleLog += person1 + "の特攻はぐーんと上がった\n"
            case 13:battleLog += person1 + "の特防は上がった\n"
            case 14:battleLog += person1 + "の特防はぐーんと上がった\n"
            case 15:battleLog += person1 + "の素早さは上がった\n"
            case 16:battleLog += person1 + "の素早さはぐーんと上がった\n"
            case 17:battleLog += person1 + "の攻撃と防御は上がった\n"
            case 18:battleLog += person1 + "の攻撃と素早さは上がった\n"
            case 19:battleLog += person1 + "の特攻と特防は上がった\n"
            case 20:battleLog += person1 + "の防御と特防は上がった\n"
            case 21:battleLog += person1 + "の攻撃と防御は上がった\n"
            case 22:battleLog += person1 + "の防御と特防は上がった\n"
            case 23:battleLog += person1 + "の攻撃はがくっと下がった\n"
            case 24:battleLog += person1 + "の特攻はがくっと下がった\n"
            case 25:battleLog += person1 + "の素早さは下がった\n"
            case 26:battleLog += person2 + "の攻撃は下がった\n"
            case 27:battleLog += person2 + "の攻撃はがくっと下がった\n"
            case 28:battleLog += person2 + "の防御は下がった\n"
            case 29:battleLog += person2 + "の防御はがくっと下がった\n"
            case 30:battleLog += person2 + "の特攻は下がった\n"
            case 31:battleLog += person2 + "の特攻はがくっと下がった\n"
            case 32:battleLog += person2 + "の特防は下がった\n"
            case 33:battleLog += person2 + "の特防はがくっと下がった\n"
            case 34:battleLog += person2 + "の素早さは下がった\n"
            case 35:battleLog += person2 + "の素早さはがくっと下がった\n"
            default:break
        }
        }
    }
    func createBattleLog(_ D: [Int]) -> String{
        battleLog = ""
        callSelfCount += 1
        battleLog += "<<\(callSelfCount)ターン目>>\n"
        

        if D[0] == 0 {
            
            if D[1] == 0 {
                battleLog += "<交代>自分は\(myPartyNameList[D[7]])を\n\(myPartyNameList[D[6]])に交代\n\n"
                

                battleLog += "<交代>相手は\(rivalPartyNameList[D[9]])を\n\(rivalPartyNameList[D[8]])に交代\n\n"
                

            } else {
                battleLog += "<交代>相手は\(rivalPartyNameList[D[9]])を\n\(rivalPartyNameList[D[8]])に交代\n\n"
                

                battleLog += "<交代>自分は\(myPartyNameList[D[7]])を\n\(myPartyNameList[D[6]])に交代\n\n"
                

            }
        }
        
        
        
        else if D[0] == 1 {
            battleLog += "<交代>自分は\(myPartyNameList[D[7]])を\n\(myPartyNameList[D[6]])に交代\n\n"
            beforeAttackLog("R", D[8], D[37], D[39], D[43])
            if D[47] == 1 {
            battleLog += "<攻撃> 相手の\(rivalPartyNameList[D[8]])の\(rivalWeaponNameList[D[11]])\n\n"
            }
            if D[19] != 0 {
            battleLog += "\(D[19])ダメージ\n\n"
            }
            createcreateBattleLogSub1(D[47], D[19], D[13], D[15], D[17])
            afterAttackLog("M", D[6], D[45], D[32])
            afterAttackLog2("R", D[49])
            if D[26] != 0 && D[2] - D[19] < D[30]/2 {
                battleLog += "自分の\(myPartyNameList[D[6]])はオボンのみで\(D[26])回復した\n"
            }
            if D[24] == 1 {
                battleLog += "\(myPartyNameList[D[6]])はきあいのタスキでもちこたえた\n"
            }
            if D[21] == 4 && D[13] == 0 && D[23] != 0 { //いのたま
                battleLog += "\(rivalPartyNameList[D[8]])はいのちが削られた\n"
                battleLog += "\(D[23])ダメージ\n\n"
            }
            
            if D[4] == 0 {
                battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                if D[5] == 0 {
                    battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                    draw = true
                    if rivalHPList == [0,0,0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "resultSegue", sender: self)
                        }
                    }
                    
                }
                
                if myHPList == [0,0,0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "resultSegue", sender: self)
                    }
                } else {
                    
                    
                    print("ok3")
                    performSegue(withIdentifier: "changeSegue", sender: self)
                    print("ok4")
                }
            }
        }
        
        
        
        
        else if D[0] == 2 {
            battleLog += "<交代>相手は\(rivalPartyNameList[D[9]])を\n\(rivalPartyNameList[D[8]])に交代\n\n"
            beforeAttackLog("M", D[6], D[36], D[38], D[42])
            if D[46] == 1 {
            battleLog += "<攻撃> 自分の\(myPartyNameList[D[6]])の\(myWeaponNameList[D[10]])\n"
            }
             if D[18] != 0 {
            battleLog += "\(D[18])ダメージ\n\n"
            }

            createcreateBattleLogSub1(D[46], D[18], D[12], D[14], D[16])
            afterAttackLog("R", D[8], D[44], D[33])
             afterAttackLog2("M", D[48])
            if D[27] != 0 && D[3] - D[18] < D[31]/2 {
                battleLog += "相手の\(rivalPartyNameList[D[8]])はオボンのみで\(D[27])回復した\n"
            }
            if D[25] == 1 {//タスキ
                battleLog += "\(rivalPartyNameList[D[8]])はきあいのタスキでもちこたえた\n"
            }
            if D[20] == 4 && D[12] == 0 && D[22] != 0{ //いのたま
                battleLog += "\(myPartyNameList[D[6]])はいのちが削られた\n"
                battleLog += "\(D[22])ダメージ\n\n"
            }
            if D[5] == 0 {
                battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                if D[4] == 0 {
                    battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                    draw = true
                    if myHPList == [0,0,0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "resultSegue", sender: self)
                        }
                    } else {
                      
                        
                        print("ok")
                        performSegue(withIdentifier: "changeSegue", sender: self)
                        print("ok1")
                    }
                }
                
                
                if rivalHPList == [0,0,0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "resultSegue", sender: self)
                    }
                } else {
                   
                    
                    
                    waiting = true
                    buttonIsOn(false)
                }
            } else if D[4] == 0 {
                battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                draw = true
                if myHPList == [0,0,0] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSegue(withIdentifier: "resultSegue", sender: self)
                    }
                } else {
                   
                    
                    print("ok1")
                    performSegue(withIdentifier: "changeSegue", sender: self)
                    print("ok1")
                }
            }

        }
        
        
        
        
        
        else if D[0] == 3 {
            
            
            
            
            
            if D[1] == 0 {
                beforeAttackLog("M", D[6], D[36], D[38], D[42])
                if D[46] == 1 {
                    battleLog += "<攻撃> 自分の\(myPartyNameList[D[6]])の\(myWeaponNameList[D[10]])\n"
                }
                 if D[18] != 0 {
                battleLog += "\(D[18])ダメージ\n\n"
                }

                createcreateBattleLogSub1(D[46], D[18], D[12], D[14], D[16])
                afterAttackLog("R", D[8], D[44], D[33])
                  afterAttackLog2("M", D[48])
                if D[27] != 0 && D[3] - D[18] < D[31]/2 {
                    battleLog += "相手の\(rivalPartyNameList[D[8]])はオボンのみで\(D[27])回復した\n"
                }
                if D[25] == 1 {//タスキ
                    battleLog += "\(rivalPartyNameList[D[8]])はきあいのタスキでもちこたえた\n"
                }
                if D[20] == 4 && D[12] == 0 && D[22] != 0{ //いのたま
                    battleLog += "\(myPartyNameList[D[6]])はいのちが削られた\n"
                    battleLog += "\(D[22])ダメージ\n\n"
                }
                if D[5] == 0 {
                    battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                    if D[4] == 0 {
                        battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                        draw = true
                        if myHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                            
                            
                            print("ok1")
                            performSegue(withIdentifier: "changeSegue", sender: self)
                        print("ok2")
                        }
                    if rivalHPList == [0,0,0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "resultSegue", sender: self)
                        }
                        }
                    } else {
                        if rivalHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                  
                        

                    waiting = true
                    buttonIsOn(false)
                    }
                    }
                } else {
                    if D[2] == D[22] { //自分の元々の体力が珠ダメ
                        battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                        beforeAttackLog("R", D[8], D[37], D[39], D[43])
                        if D[47] == 1 {
                            battleLog += "<攻撃> 相手の\(rivalPartyNameList[D[8]])の\(rivalWeaponNameList[D[11]])\n"
                            battleLog += "しかしうまく決まらなかった\n"
                        }
                        
                        if myHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                            
                            
                            print("ok1")
                            performSegue(withIdentifier: "changeSegue", sender: self)
                            print("ok1")
                        }
                    } else {
                        beforeAttackLog("R", D[8], D[37], D[39], D[43])
                        if D[47] == 1 {
                            battleLog += "<攻撃> 相手の\(rivalPartyNameList[D[8]])の\(rivalWeaponNameList[D[11]])\n"
                        }
                        
                     if D[19] != 0 {
                    battleLog += "\(D[19])ダメージ\n\n"
                    }
                    
                    createcreateBattleLogSub1(D[47], D[19], D[13], D[15], D[17])
                        afterAttackLog("M", D[6], D[45], D[32])
                         afterAttackLog2("R", D[49])
                        if D[26] != 0 && D[2] - D[19] < D[30]/2 {//オボン
                            battleLog += "自分の\(myPartyNameList[D[6]])はオボンのみで\(D[26])回復した\n"
                        }
                        if D[24] == 1 {//タスキ
                            battleLog += "\(myPartyNameList[D[6]])はきあいのタスキでもちこたえた\n"
                        }
                    if D[21] == 4 && D[13] == 0 && D[23] != 0{ //いのたま
                        battleLog += "\(rivalPartyNameList[D[8]])はいのちが削られた\n"
                        battleLog += "\(D[23])ダメージ\n\n"
                    }
                    }
                if D[4] == 0 {
                    battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                    if D[5] == 0 {
                        battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                        draw = true
                        if rivalHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                        
                            
                            
                            waiting = true
                            buttonIsOn(false)
                        }
                    }

                    if myHPList == [0,0,0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "resultSegue", sender: self)
                        }
                    } else {
                  
                        
print("ok1")
                    performSegue(withIdentifier: "changeSegue", sender: self)
                        print("ok1")
                    }
                }
                }
            }
            
            
            
            
            
            
            else {
                beforeAttackLog("R", D[8], D[37], D[39], D[43])
                if D[47] == 1 {
                    battleLog += "<攻撃> 相手の\(rivalPartyNameList[D[8]])の\(rivalWeaponNameList[D[11]])\n"
                }
                
                 if D[19] != 0 {
                battleLog += "\(D[19])ダメージ\n\n"
                }

                createcreateBattleLogSub1(D[47], D[19], D[13], D[15], D[17])
                afterAttackLog("M", D[6], D[45], D[32])
                 afterAttackLog2("R", D[49])
                if D[26] != 0 && D[2] - D[19] < D[30]/2 {
                    battleLog += "自分の\(myPartyNameList[D[6]])はオボンのみで\(D[26])回復した\n"
                }
                if D[24] == 1 {
                    battleLog += "\(myPartyNameList[D[6]])はきあいのタスキでもちこたえた\n"
                }
                if D[21] == 4 && D[13] == 0 && D[23] != 0 { //いのたま
                    battleLog += "\(rivalPartyNameList[D[8]])はいのちが削られた\n"
                    battleLog += "\(D[23])ダメージ\n\n"
                }
                if D[4] == 0 {
                    battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                    if D[5] == 0 {
                        battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                        draw = true
                        if rivalHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                      
                            
                            
                            waiting = true
                            buttonIsOn(false)
                        }
                    }

                    if myHPList == [0,0,0] {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSegue(withIdentifier: "resultSegue", sender: self)
                        }
                    } else {
                
                        
print("ok1")
                     performSegue(withIdentifier: "changeSegue", sender: self)
                        print("ok1")
                    }
                } else {
                    if D[3] == D[23] {//相手の元々の体力が全て珠ダメだとしたら
                        battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                        beforeAttackLog("M", D[6], D[36], D[38], D[42])
                        if D[46] == 1 {
                            battleLog += "<攻撃> 自分の\(myPartyNameList[D[6]])の\(myWeaponNameList[D[10]])\n"
                        
                        battleLog += "しかしうまく決まらなかった\n"
                        }
                        if rivalHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                           
                            
                            
                            waiting = true
                            buttonIsOn(false)
                        }
                    } else {
                        beforeAttackLog("M", D[6], D[36], D[38], D[42])
                        if D[46] == 1 {
                            battleLog += "<攻撃> 自分の\(myPartyNameList[D[6]])の\(myWeaponNameList[D[10]])\n"
                        }
                     if D[18] != 0 {
                    battleLog += "\(D[18])ダメージ\n\n"
                    }
                    createcreateBattleLogSub1(D[46], D[18], D[12], D[14], D[16])
                        afterAttackLog("R", D[8], D[44], D[33])
                          afterAttackLog2("M", D[48])
                        if D[27] != 0 && D[3] - D[18] < D[31]/2 {
                            battleLog += "相手の\(rivalPartyNameList[D[8]])はオボンのみで\(D[27])回復した\n"
                        }
                        if D[25] == 1 {//タスキ
                            battleLog += "\(rivalPartyNameList[D[8]])はきあいのタスキでもちこたえた\n"
                        }
                    if D[20] == 4 && D[12] == 0 && D[22] != 0 { //いのたま
                        battleLog += "\(myPartyNameList[D[6]])はいのちが削られた\n"
                        battleLog += "\(D[22])ダメージ\n\n"
                    }
                    }
                    
                    if D[5] == 0 && D[3] != D[23] {
                        battleLog += "<瀕死>相手の\(rivalPartyNameList[D[8]])は倒れた\n"
                        if D[4] == 0 {
                            battleLog += "<瀕死>自分の\(myPartyNameList[D[6]])は倒れた\n"
                            draw = true
                            if myHPList == [0,0,0] {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.performSegue(withIdentifier: "resultSegue", sender: self)
                                }
                            } else {
                               
                                
                                print("ok1")
                                performSegue(withIdentifier: "changeSegue", sender: self)
                                print("ok1")
                            }
                        }

                        if rivalHPList == [0,0,0] {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.performSegue(withIdentifier: "resultSegue", sender: self)
                            }
                        } else {
                   
                            

                        waiting = true
                        buttonIsOn(false)
                            }
                    }
                }
            }
        }
        if D[28] != 0 {
            battleLog += "自分の\(myPartyNameList[D[6]])はたべのこしで\(D[28])回復した\n\n"
        }
        if D[29] != 0 {
            battleLog += "相手の\(rivalPartyNameList[D[8]])はたべのこしで\(D[29])回復した\n\n"
        }
        if D[40] != 0 {
            battleLog += "自分の\(myPartyNameList[D[6]])はどくで\(D[40])ダメージを受けた\n\n"
            if D[26] != 0 && D[2] - D[19] - D[40] < D[30]/2 {
                battleLog += "自分の\(myPartyNameList[D[6]])はオボンのみで\(D[26])回復した\n\n"
            }
            
        }
        if D[41] != 0 {
            battleLog += "相手の\(rivalPartyNameList[D[8]])はどくで\(D[41])ダメージを受けた\n\n"
            if D[27] != 0 && D[3] - D[18] - D[41] < D[31]/2 {
                battleLog += "相手の\(rivalPartyNameList[D[8]])はオボンのみで\(D[27])回復した\n\n"
            }
        }
        if D[34] != 0 {
            battleLog += "自分の\(myPartyNameList[D[6]])はやけどで\(D[34])ダメージを受けた\n\n"
            if D[26] != 0 && D[2] - D[19] - D[40] < D[30]/2 {
                battleLog += "自分の\(myPartyNameList[D[6]])はオボンのみで\(D[26])回復した\n\n"
            }
        }
        if D[35] != 0 {
            battleLog += "相手の\(rivalPartyNameList[D[8]])はやけどで\(D[35])ダメージを受けた\n\n"
            if D[27] != 0 && D[3] - D[18] - D[41] < D[31]/2 {
                battleLog += "相手の\(rivalPartyNameList[D[8]])はオボンのみで\(D[27])回復した\n\n"
            }
        }
        if D[4] == 0 {
            performSegue(withIdentifier: "changeSegue", sender: self)
        }
        resultBattleLog += battleLog
        return battleLog
    }
    func buttonIsOn(_ isOn: Bool) {
        weapon1.isEnabled = isOn
        weapon2.isEnabled = isOn
        weapon3.isEnabled = isOn
        weapon4.isEnabled = isOn
        segueButton.isEnabled = isOn
        if isOn {
        Log.text = "行動を選択してください"
            waitingView.stopAnimating()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        } else {
            Log.text = "通信待機中..."
            waitingView.startAnimating()
            timer.invalidate()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    func updateScene() {
        HPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
        fitghtingPokemon.text = myPartyNameList[myBattlingPokemonNumber]
        opponentPokemon.text = rivalPartyNameList[rivalBattlingPokemonNumber]
        myAilmentLabel.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
        rivalAilmentLabel.text = ailmentList[rivalAilmentList[rivalBattlingPokemonNumber]]
        
        switch myAilmentList[myBattlingPokemonNumber] {
        case 0:
            myAilmentLabel.backgroundColor = transeparent
        case 1:
            myAilmentLabel.backgroundColor = honoo
        case 2:
            myAilmentLabel.backgroundColor = denki
        case 3:
            myAilmentLabel.backgroundColor = kori
        case 4:
            myAilmentLabel.backgroundColor = doku
        case 5:
            myAilmentLabel.backgroundColor = doku
        case 6:
            myAilmentLabel.backgroundColor = mizu
        default:
            break
        }
        switch rivalAilmentList[rivalBattlingPokemonNumber] {
        case 0:
            rivalAilmentLabel.backgroundColor = transeparent
        case 1:
            rivalAilmentLabel.backgroundColor = honoo
        case 2:
            rivalAilmentLabel.backgroundColor = denki
        case 3:
            rivalAilmentLabel.backgroundColor = kori
        case 4:
            rivalAilmentLabel.backgroundColor = doku
        case 5:
            rivalAilmentLabel.backgroundColor = doku
        case 6:
            rivalAilmentLabel.backgroundColor = mizu
        default:
            break
        }
        myHPRate = Float(myHPList[myBattlingPokemonNumber])/Float(myOriginHPList[myBattlingPokemonNumber])
        rivalHPRate = Float(rivalHPList[rivalBattlingPokemonNumber])/Float(rivalOriginHPList[rivalBattlingPokemonNumber])
        setProgress(progressView: myHPBar, progress: myHPRate, animated: false)
        setProgress(progressView: rivalHPBar, progress: rivalHPRate, animated: false)
        weapon1.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 1), for: UIControlState.normal)
        weapon2.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 2), for: UIControlState.normal)
        weapon3.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 3), for: UIControlState.normal)
        weapon4.setTitle(searchWeaponName(myBattlePartyData[myBattlingPokemonNumber], 4), for: UIControlState.normal)
        if myBattlePokemonDataList[myBattlingPokemonNumber][9] != -1 {
            weapon1.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][9]][2]].cgColor
        }
        if myBattlePokemonDataList[myBattlingPokemonNumber][10] != -1 {
            weapon2.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][10]][2]].cgColor
        }
        if myBattlePokemonDataList[myBattlingPokemonNumber][11] != -1 {
            weapon3.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][11]][2]].cgColor
        }
        if myBattlePokemonDataList[myBattlingPokemonNumber][12] != -1 {
            weapon4.layer.borderColor = colorList[weaponDataList[myBattlePokemonDataList[myBattlingPokemonNumber][12]][2]].cgColor
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func updateElapsedTime() {
        battleTimer -= 1
        let min: Int = battleTimer / 60
        let sec: Int = battleTimer % 60
        var zero = ""
        if sec < 10 {
            zero = "0"
        }
        timeLimit.text = String(min)+":"+zero+String(sec)
        if battleTimer == 0 {
            timer.invalidate()
             timeUpLose = true
             performSegue(withIdentifier: "resultSegue", sender: self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        waitingView.stopAnimating()
    }
  func match(_ match: GKMatch,
               player playerID: String,
               didChange state: GKPlayerConnectionState) {
        print("相手はさようなら")
       timeUpWin = true
   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         self.performSegue(withIdentifier: "resultSegue", sender: self)
    }
    }
 
}
