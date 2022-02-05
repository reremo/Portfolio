//
//  PokemonChangeViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/01/05.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class PokemonChangeViewController: UIViewController {
    @IBOutlet weak var BattlePokemon1: UIButton!
    @IBOutlet weak var BattlePokemon2: UIButton!
    @IBOutlet weak var BattlePokemon3: UIButton!
    @IBOutlet weak var BattleLog: UITextView!
    @IBOutlet weak var battlingHPLabel: UILabel!
    @IBOutlet weak var waiting1HPLabel: UILabel!
    @IBOutlet weak var waiting2HPLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var pokemon1Item: UILabel!
    @IBOutlet weak var pokemon2Item: UILabel!
    @IBOutlet weak var pokemon3Item: UILabel!
    @IBOutlet weak var pokemon1Ail: UILabel!
    @IBOutlet weak var pokemon2Ail: UILabel!
    @IBOutlet weak var pokemon3Ail: UILabel!
    @IBOutlet weak var timeLimit: UILabel!
    var timer: Timer!
    @IBAction func returnBattle(_ sender: Any) {
        if myHPList[myBattlingPokemonNumber] > 0 {
        if !waiting {
        self.performSegue(withIdentifier: "returnSegue", sender: self)
        }
    }
    }
    @IBAction func changePokemon(_ sender: UIButton) {
        if !waiting {
            if sender.currentTitle! != "-" {
                choice = false //こだわり解除
                myStatusData = [6,6,6,6,6]
              
        switch sender.currentTitle! {
        case myPartyNameList[myWaitingPokemon1Number]:
        //pokemonNameList[selectedPartyData[myBattlePartyData[myWaitingPokemon1Number]]]:
            myBattleData.removeAll()
                myBattleData =  myBattlePokemonDataList[myWaitingPokemon1Number] + [myWaitingPokemon1Number,myBattlingPokemonNumber]
            myBattleData[8] = myBattlePokemonDataList[myBattlingPokemonNumber][8] //交代前の素早さに置き換え
            myBattleData[3] = myHPList[myWaitingPokemon1Number] //現在のHPを反映
             myBattleData.remove(at: 14)
            myBattleData.remove(at: 13)
           
            myBattleData.append(myBattlePokemonDataList[myWaitingPokemon1Number][13])
            myBattleData.append(myAilmentList[myWaitingPokemon1Number])
            myBattleData.append(myBattlePokemonDataList[myBattlingPokemonNumber][13]) //交代前の道具
            myBattleData.append(myAilmentList[myBattlingPokemonNumber])//交代前の異常状態
                    if myHPList[myBattlingPokemonNumber] != 0 {
                        myBattleData = myBattleData + [6,6,6,6,6] + [-3]
                    } else {
                        myBattleData = myBattleData + [6,6,6,6,6] + [-5]
                        isFromChangingDying = true
                }
                print("交代",myBattleData)
            myPoisonCount = 0
                
            swap(&myBattlingPokemonNumber, &myWaitingPokemon1Number)
        case myPartyNameList[myWaitingPokemon2Number]:
        //pokemonNameList[selectedPartyData[myBattlePartyData[myWaitingPokemon2Number]]]:
            myBattleData.removeAll()
            myBattleData =  myBattlePokemonDataList[myWaitingPokemon2Number] +  [myWaitingPokemon2Number,myBattlingPokemonNumber]
            myBattleData[8] = myBattlePokemonDataList[myBattlingPokemonNumber][8]
            myBattleData[3] = myHPList[myWaitingPokemon2Number]
            myBattleData.remove(at: 14)
            myBattleData.remove(at: 13)
            
            myBattleData.append(myBattlePokemonDataList[myWaitingPokemon2Number][13])
            myBattleData.append(myAilmentList[myWaitingPokemon2Number])
            myBattleData.append(myBattlePokemonDataList[myBattlingPokemonNumber][13]) //交代前の道具
            myBattleData.append(myAilmentList[myBattlingPokemonNumber])//交代前の異常状態
            if myHPList[myBattlingPokemonNumber] != 0 {
                myBattleData = myBattleData + [6,6,6,6,6] + [-3]
            } else {
                myBattleData = myBattleData + [6,6,6,6,6] + [-5]
                isFromChangingDying = true
            }
             print("交代",myBattleData)
             myPoisonCount = 0
            swap(&myBattlingPokemonNumber, &myWaitingPokemon2Number)
        default:
            break
        }
            isFromChanging = true
        if waiting == false {
            waiting = true
        }
           
            self.performSegue(withIdentifier: "returnSegue", sender: self)
            
            }
        }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let min: Int = battleTimer / 60
        let sec: Int = battleTimer % 60
        var zero = ""
        if sec < 10 {
            zero = "0"
        }
        timeLimit.text = String(min)+":"+zero+String(sec)
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        if myHPList == [0,0,0] || rivalHPList == [0,0,0] {
            performSegue(withIdentifier: "result2Segue", sender: self)
        }
        BattleLog.text = battleLog
        BattleLog.layer.masksToBounds = true
        BattleLog.layer.cornerRadius = 10.0
        BattlePokemon1.layer.masksToBounds = true
        BattlePokemon1.layer.cornerRadius = 10.0
        BattlePokemon1.backgroundColor = UIColor.blue
        BattlePokemon1.setTitleColor(UIColor.white, for: .normal)
        BattlePokemon1.isEnabled = false
        BattlePokemon2.layer.masksToBounds = true
        BattlePokemon2.layer.cornerRadius = 10.0
        BattlePokemon2.backgroundColor = UIColor.blue
        BattlePokemon2.setTitleColor(UIColor.white, for: .normal)
        BattlePokemon3.layer.masksToBounds = true
        BattlePokemon3.layer.cornerRadius = 10.0
        BattlePokemon3.backgroundColor = UIColor.blue
        BattlePokemon3.setTitleColor(UIColor.white, for: .normal)
        returnButton.layer.masksToBounds = true
        returnButton.layer.cornerRadius = 10.0
        returnButton.backgroundColor = UIColor.red
        returnButton.setTitleColor(UIColor.white, for: .normal)
        pokemon1Ail.text = ailmentList[myAilmentList[myBattlingPokemonNumber]]
        pokemon2Ail.text = ailmentList[myAilmentList[myWaitingPokemon1Number]]
        pokemon3Ail.text = ailmentList[myAilmentList[myWaitingPokemon2Number]]
        
        switch myAilmentList[myBattlingPokemonNumber] {
        case 0:
            pokemon1Ail.backgroundColor = transeparent
        case 1:
            pokemon1Ail.backgroundColor = honoo
        case 2:
            pokemon1Ail.backgroundColor = denki
        case 3:
            pokemon1Ail.backgroundColor = kori
        case 4:
            pokemon1Ail.backgroundColor = doku
        case 5:
            pokemon1Ail.backgroundColor = doku
        case 6:
            pokemon1Ail.backgroundColor = mizu
        default:
            break
        }
        switch myAilmentList[myWaitingPokemon1Number] {
        case 0:
            pokemon2Ail.backgroundColor = transeparent
        case 1:
            pokemon2Ail.backgroundColor = honoo
        case 2:
            pokemon2Ail.backgroundColor = denki
        case 3:
            pokemon2Ail.backgroundColor = kori
        case 4:
            pokemon2Ail.backgroundColor = doku
        case 5:
            pokemon2Ail.backgroundColor = doku
        case 6:
            pokemon2Ail.backgroundColor = mizu
        default:
            break
        }
        switch myAilmentList[myWaitingPokemon2Number] {
        case 0:
            pokemon3Ail.backgroundColor = transeparent
        case 1:
            pokemon3Ail.backgroundColor = honoo
        case 2:
            pokemon3Ail.backgroundColor = denki
        case 3:
            pokemon3Ail.backgroundColor = kori
        case 4:
            pokemon3Ail.backgroundColor = doku
        case 5:
            pokemon3Ail.backgroundColor = doku
        case 6:
            pokemon3Ail.backgroundColor = mizu
        default:
            break
        }
        if myHPList[myBattlingPokemonNumber] == 0 {
            BattlePokemon1.isEnabled = false
            pokemon1Ail.text = "ひんし"
            pokemon1Ail.backgroundColor = UIColor.init(red: 184/255, green: 52/255, blue: 27/255, alpha: 255/255)
        }
        if myHPList[myWaitingPokemon1Number] == 0 {
            BattlePokemon2.isEnabled = false
            if myOriginHPList[myWaitingPokemon1Number] != 0 {
            pokemon2Ail.text = "ひんし"
            pokemon2Ail.backgroundColor = UIColor.init(red: 184/255, green: 52/255, blue: 27/255, alpha: 255/255)
            }
        }
        if myHPList[myWaitingPokemon2Number] == 0 {
            BattlePokemon3.isEnabled = false
            if myOriginHPList[myWaitingPokemon2Number] != 0 {
            pokemon3Ail.text = "ひんし"
            pokemon3Ail.backgroundColor = UIColor.init(red: 184/255, green: 52/255, blue: 27/255, alpha: 255/255)
            }
        }
        
        
        // BattlePokemon1.setTitle(safeCallArray(pokemonNameList, selectedPartyData[myBattlePartyData[myBattlingPokemonNumber]]), for: UIControlState.normal)
       //  BattlePokemon2.setTitle(safeCallArray(pokemonNameList, selectedPartyData[myBattlePartyData[myWaitingPokemon1Number]]), for: UIControlState.normal)
       //  BattlePokemon3.setTitle(safeCallArray(pokemonNameList, selectedPartyData[myBattlePartyData[myWaitingPokemon2Number]]), for: UIControlState.normal)
        BattlePokemon1.setTitle(myPartyNameList[myBattlingPokemonNumber], for: UIControlState.normal)
        BattlePokemon2.setTitle(myPartyNameList[myWaitingPokemon1Number], for: UIControlState.normal)
        BattlePokemon3.setTitle(myPartyNameList[myWaitingPokemon2Number], for: UIControlState.normal)
        
        if myPartyNameList[myBattlingPokemonNumber] != "-" {
        if myBattlePokemonDataList[myBattlingPokemonNumber][13] == 9 {
            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 10
        }
            pokemon1Item.text = safeCallArray(itemList,myBattlePokemonDataList[myBattlingPokemonNumber][13])
        if myBattlePokemonDataList[myBattlingPokemonNumber][13] == 10 {
            myBattlePokemonDataList[myBattlingPokemonNumber][13] = 9
        }
            battlingHPLabel.text! = String(myHPList[myBattlingPokemonNumber]) + " / " + String(myOriginHPList[myBattlingPokemonNumber])
        }
        
        
        if myPartyNameList[myWaitingPokemon1Number] != "-" {
       
        if myBattlePokemonDataList[myWaitingPokemon1Number][13] == 9 {
            myBattlePokemonDataList[myWaitingPokemon1Number][13] = 10
        }
             pokemon2Item.text = safeCallArray(itemList,myBattlePokemonDataList[myWaitingPokemon1Number][13])
        if myBattlePokemonDataList[myWaitingPokemon1Number][13] == 10 {
            myBattlePokemonDataList[myWaitingPokemon1Number][13] = 9
        }
            waiting1HPLabel.text! = String(myHPList[myWaitingPokemon1Number]) + " / " + String(myOriginHPList[myWaitingPokemon1Number])
        }
        
        
        if myPartyNameList[myWaitingPokemon2Number] != "-" {
        
        if myBattlePokemonDataList[myWaitingPokemon2Number][13] == 9 {
            myBattlePokemonDataList[myWaitingPokemon2Number][13] = 10
            }
            pokemon3Item.text = safeCallArray(itemList,myBattlePokemonDataList[myWaitingPokemon2Number][13])
            if myBattlePokemonDataList[myWaitingPokemon2Number][13] == 10 {
                myBattlePokemonDataList[myWaitingPokemon2Number][13] = 9
            }
            waiting2HPLabel.text! = String(myHPList[myWaitingPokemon2Number]) + " / " + String(myOriginHPList[myWaitingPokemon2Number])
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if myHPList == [0,0,0] || rivalHPList == [0,0,0] {
            performSegue(withIdentifier: "result2Segue", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
            
            performSegue(withIdentifier: "result3Segue", sender: self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
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
