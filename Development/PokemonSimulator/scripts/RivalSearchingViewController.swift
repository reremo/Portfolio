//
//  RivalSearchingViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/01/04.
//  Copyright © 2018年 森居麗. All rights reserved.
//
import UIKit
import MultipeerConnectivity
import GoogleMobileAds
import GameKit
import Foundation
class RivalSearchingViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate, GADBannerViewDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    
    
    @IBOutlet weak var selectedParty: PickerKeyboard!
    @IBOutlet weak var searching: UIButton!
    @IBOutlet weak var waiting: UIButton!
    @IBOutlet weak var matching: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var sessionState: UILabel!
    @IBOutlet weak var log: UILabel!
    @IBOutlet weak var help: UIButton!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    var count = 20
    var timer : Timer!
    @IBAction func stop(_ sender: Any) {
        self.assistant.stop()
        self.session.disconnect()
    }
    @IBAction func help(_ sender: Any) {
        let alert = UIAlertController(title:"マッチング手順", message: "I: Bluetoothマッチング\n\n1: パーティを選択\n\n2: いずれか一人が「検索」ボタンを、もう一人が「待機」ボタンを選択\n\n3: 「検索」　→　マッチングしたい人を選択して招待を送る　→　「Done」を選択\n\n「待機」　→　招待がきたら「accept」を選択\n\n4: マッチング完了\n\nII: GameCenterマッチング\n\n「GameCenterマッチング」", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "了解", style: UIAlertActionStyle.cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    let serviceType = "pokemonBattle"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    var wating = false
    var rivalWating = false
    var match : GKMatch!
    var matchMaker = GKMatchmaker.shared()
    var matchStarted = Bool()
    var searchMatch = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeLargeBanner)
        bannerView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width,height: bannerView.frame.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-9204323547115751/2251964689"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
       
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        
        
        
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        generalSession = self.session
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
        self.browser.delegate = self;
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        // tell the assistant to start advertising our fabulous chat
      
        selectedParty.data = partyNameList
        myPartyNameList = []
        rivalPartyNameList = []
        // ボタンの枠を丸くする.
        searching.layer.masksToBounds = true
        // コーナーの半径を設定する.
        searching.layer.cornerRadius = 5.0
        searching.backgroundColor = UIColor.red
        searching.setTitleColor(UIColor.white, for: .normal)
        waiting.layer.masksToBounds = true
        waiting.layer.cornerRadius = 5.0
        waiting.backgroundColor = UIColor.red
        waiting.setTitleColor(UIColor.white, for: .normal)
        
        matching.layer.masksToBounds = true
        matching.layer.cornerRadius = 5.0
        matching.backgroundColor = UIColor.red
        matching.setTitleColor(UIColor.white, for: .normal)
      
        selectedParty.layer.masksToBounds = true
        selectedParty.layer.cornerRadius = 5.0
        selectedParty.backgroundColor = UIColor.white
        selectedParty.layer.borderColor = UIColor.red.cgColor
        selectedParty.layer.borderWidth = 1.0
        returnButton.layer.masksToBounds = true
        returnButton.layer.cornerRadius = 5.0
        returnButton.backgroundColor = UIColor.red
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.layer.borderWidth = 2.0
        returnButton.layer.borderColor = UIColor.black.cgColor
        waitingView.stopAnimating()
        myBattlingPokemonNumber = 0
        myWaitingPokemon1Number = 1
        myWaitingPokemon2Number = 2
        rivalBattlingPokemonNumber = 0
        oldMyBattlingPokemonNumber = 0
        resultBattleLog.removeAll()
        myPartyNameList.removeAll()
        myWeaponNameList.removeAll()
        myBattlePartyData.removeAll()
        rivalPartyNameList.removeAll()
        rivalWeaponNameList.removeAll()
        rivalBattlePartyData.removeAll()
        rivalPartyWeaponNameList.removeAll()
        battleLog = ""
        recievedData.removeAll()
        help.isEnabled = true
        returnButton.isEnabled = true
        searching.isEnabled = true
        waiting.isEnabled = true
        selectedParty.isEnabled = true
        matching.isEnabled = true
        isFromChanging = false
        isFromChangingDying = false
        isGKMatch = false
        recievingCount = 0
        isDecide = false
        selectedParty.textStore = partyNameList[0]
        selectedParty.selectedRow = 0
        myAilmentList = [0,0,0]
        rivalAilmentList = [0,0,0]
        mySleepingCountList = [0,0,0]
        rivalSleepingCountList = [0,0,0]
        myPoisonCount = 0
        rivalPoisonCount = 0
        myStatusData = [6,6,6,6,6] 
        rivalStatusData = [6,6,6,6,6]
        myTypeData = []
        rivalTypeData = []
        battleTimer = 600
        timeUpWin = false
        timeUpLose = false
        disconnectWin = false
        disconnectLose = false
       
    }

    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        if selectedParty.textStore == "" {
           
        } else {
        isResponsible = false
        self.session.disconnect()
        self.assistant.stop()
            
       self.sessionState.text = ""
        self.present(self.browser, animated: true, completion: nil)
            myPartyNameList.removeAll()
            myWeaponNameList.removeAll()
            battleRow = selectedParty.selectedRow
            selectedPartyData = partyDataList[battleRow]
            if myPartyNameList.count <= 6 {
                for i in 0...5 {
                    myPartyNameList.append(safeCallArray(pokemonNameList, selectedPartyData[i]))
                }
                for i in 0...5 {
                    for j in 0...3 {
                        if selectedPartyData[i] != -1 {
                            myWeaponNameList.append(safeCallArray(weaponNameList, pokemonDataList[selectedPartyData[i]][9+j]))
                        } else if selectedPartyData[i] == -1 {
                            myWeaponNameList.append("-")
                        }
                    }
                }
                myPartyWeaponNameList = myPartyNameList+myWeaponNameList
                print(myPartyWeaponNameList)
        }
    }
    }
    @IBAction func waitingInvite(_ sender: Any) {
        if selectedParty.textStore == "" {
           
        } else {
        isResponsible = false
            self.sessionState.text = "待機中..."
        self.assistant.start()
        selectedParty.resignFirstResponder()
       selectedParty.isEnabled = false
            myPartyNameList.removeAll()
            myWeaponNameList.removeAll()
            battleRow = selectedParty.selectedRow
            selectedPartyData = partyDataList[battleRow]
            if myPartyNameList.count <= 6 {
                for i in 0...5 {
                    myPartyNameList.append(safeCallArray(pokemonNameList, selectedPartyData[i]))
                }
                for i in 0...5 {
                    for j in 0...3 {
                        if selectedPartyData[i] != -1 {
                            myWeaponNameList.append(safeCallArray(weaponNameList, pokemonDataList[selectedPartyData[i]][9+j]))
                        } else if selectedPartyData[i] == -1 {
                            myWeaponNameList.append("-")
                        }
                    }
                }
                myPartyWeaponNameList = myPartyNameList+myWeaponNameList
                print(myPartyWeaponNameList)
            }
        }
    }
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        self.help.isEnabled = false
        self.returnButton.isEnabled = false
        self.searching.isEnabled = false
        self.waiting.isEnabled = false
        self.selectedParty.isEnabled = false
        self.matching.isEnabled = false
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        isResponsible = true
        myPartyWeaponNameList.insert("deleeeeete", at: 0)
        myPartyWeaponNameList.append("oooooooook")
        for i in 0...31 {
            let myPartyWeaponNameData = myPartyWeaponNameList[i].data(using: String.Encoding.utf8)
            do{ try self.session.send(myPartyWeaponNameData!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch {
            }
        }
        myPartyWeaponNameList.removeLast()
        myPartyWeaponNameList.removeFirst()
        self.dismiss(animated: true, completion: nil)
        sessionState.text = "接続中..."
       // starting.isHidden = false
        selectedParty.isEnabled = false
    }
    
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        self.session.disconnect()
        self.dismiss(animated: true, completion: nil)
    }
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(_ session: MCSession, didReceive data: Data,
          fromPeer peerID: MCPeerID)  {
         DispatchQueue.main.async() {
            let data = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
            rivalPartyWeaponNameList.append(data! as String)
            if data! as String == "deleeeeete" {
                rivalPartyWeaponNameList.removeAll()
            }
            if data! as String == "oooooooook" {
                rivalPartyWeaponNameList.removeLast()
                if rivalPartyWeaponNameList.count == 30 {
              //  self.starting.isHidden = false
                self.sessionState.text = "接続完了"
                    self.waitingView.startAnimating()
                    self.help.isEnabled = false
                    self.returnButton.isEnabled = false
                    self.searching.isEnabled = false
                    self.waiting.isEnabled = false
                    self.selectedParty.isEnabled = false
                    self.matching.isEnabled = false
                     self.assistant.stop()
                    if myPartyWeaponNameList.count == 30 && rivalPartyWeaponNameList.count == 30 {
                        print(rivalPartyWeaponNameList)
                        for i in 0...5 {
                            rivalPartyNameList.append(rivalPartyWeaponNameList[i])
                        }
                        for i in 0...23 {
                            rivalWeaponNameList.append(rivalPartyWeaponNameList[i+6])
                        }
                        print("結果",myPartyNameList,rivalPartyNameList,myWeaponNameList,rivalWeaponNameList)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.performSegue(withIdentifier: "selectSegue", sender: self)
                        }
                    }
                    if !isResponsible {
                    myPartyWeaponNameList.insert("deleeeeete", at: 0)
                    myPartyWeaponNameList.append("oooooooook")
                    for i in 0...31 {
                        let myPartyWeaponNameData = myPartyWeaponNameList[i].data(using: String.Encoding.utf8)
                        do{ try self.session.send(myPartyWeaponNameData!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                        } catch {
                        }
                    }
                        myPartyWeaponNameList.removeLast()
                        myPartyWeaponNameList.removeFirst()
                        
                    }
                    
                    
                } else {
                    self.sessionState.text = "再度やり直してください"
                }
            }
        }
        
    }
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?, withError error: Error?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        
    }
    
    
    
    
    
    
    
    
    
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        print("ok1")
        self.match = match
        match.delegate = self
        print("ok2")
        myPartyWeaponNameList.insert("deleeeeete", at: 0)
        myPartyWeaponNameList.append("oooooooook")
        for i in 0...31 {
            let myPartyWeaponNameData = myPartyWeaponNameList[i].data(using: String.Encoding.utf8)
            do{ try match.sendData(toAllPlayers: myPartyWeaponNameData!, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
        print("文字情報送信完了")
        myPartyWeaponNameList.removeLast()
        myPartyWeaponNameList.removeFirst()
        self.dismiss(animated: true, completion: nil)
        self.help.isEnabled = false
        self.returnButton.isEnabled = false
        self.searching.isEnabled = false
        self.waiting.isEnabled = false
        self.selectedParty.isEnabled = false
        self.matching.isEnabled = false
        sessionState.text = "接続中..."
        selectedParty.isEnabled = false
    }
    
  
    
    func match(_ match: GKMatch,
                        player playerID: String,
                        didChange state: GKPlayerConnectionState) {
        print("ok1")
        self.match = match
        match.delegate = self
        print("ok2")
        myPartyWeaponNameList.insert("deleeeeete", at: 0)
        myPartyWeaponNameList.append("oooooooook")
        for i in 0...31 {
            let myPartyWeaponNameData = myPartyWeaponNameList[i].data(using: String.Encoding.utf8)
            do{ try match.sendData(toAllPlayers: myPartyWeaponNameData!, with: GKMatchSendDataMode.reliable)
            } catch {
            }
        }
        
        print("文字情報送信完了")
        myPartyWeaponNameList.removeLast()
        myPartyWeaponNameList.removeFirst()
      
        
    }
   
    
    @IBAction func connect(_ sender: Any) {
        if partyScoreList[selectedParty.selectedRow][1] == 0 {
        if selectedParty.textStore != "" {
            if !searchMatch {
                searchMatch = true
            selectedParty.resignFirstResponder()
            selectedParty.isEnabled = false
            self.help.isEnabled = false
            self.returnButton.isEnabled = false
            self.searching.isEnabled = false
            self.waiting.isEnabled = false
            self.selectedParty.isEnabled = false
            self.matching.isEnabled = false
            sessionState.text = "対戦相手を探しています"
            waitingView.startAnimating()
            selectedParty.isEnabled = false
            myPartyNameList.removeAll()
            myWeaponNameList.removeAll()
            numberForDecide = Int(arc4random_uniform(10000))
            recievingCount = 0
            battleRow = selectedParty.selectedRow
            selectedPartyData = partyDataList[battleRow]
            if myPartyNameList.count <= 6 {
                for i in 0...5 {
                    myPartyNameList.append(safeCallArray(pokemonNameList, selectedPartyData[i]))
                }
                
                for i in 0...5 {
                    for j in 0...3 {
                        if selectedPartyData[i] != -1 {
                            myWeaponNameList.append(safeCallArray(weaponNameList, pokemonDataList[selectedPartyData[i]][9+j]))
                        } else if selectedPartyData[i] == -1 {
                            myWeaponNameList.append("-")
                        }
                    }
                }
                
               
                myPartyWeaponNameList = myPartyNameList+myWeaponNameList
            }
                print("okthsr")
                var numberOfPokemon = 0
                for i in 0...6 {
                    if selectedPartyData[i] != -1 {
                        numberOfPokemon += 1
                    }
                }
                for i in 0...numberOfPokemon-1 {
                    for j in 0...1 {
                 myTypeData.append(pokemonDataList[selectedPartyData[i]][j+1])
                    }
                    if selectedPartyData[i] != -1 { myTypeData.append(pokemonScoreList[selectedPartyData[i]][1])
                    } else {
                        myTypeData.append(-1)
                    }
                }
                if 6 - numberOfPokemon > 0 {
                    for _ in 0...(6-numberOfPokemon)*3-1 {
                        myTypeData.append(-1)
                    }
                    
                }
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
          
        self.matchMaker.findMatch(for: request, withCompletionHandler: {(_ match: GKMatch?, _ error: Error?) -> Void in
            if error != nil {
                // Process the error.
            } else if match != nil {
                print("実行")
                self.sessionState.text = "対戦相手が見つかりました"
             
                self.match = match!
                 generalMatch = self.match
                // Use a retaining property to retain the match.
                generalMatch.delegate = self
                self.matchMaker.finishMatchmaking(for: generalMatch)
                if !self.matchStarted && match?.expectedPlayerCount == 0 {
                    self.matchStarted = true
                    // Insert game-specific code to begin the match.
                }
               
            }
        })
         }
        } else {
            help.isEnabled = true
            returnButton.isEnabled = true
            searching.isEnabled = true
            waiting.isEnabled = true
            selectedParty.isEnabled = true
            matching.isEnabled = true
            self.matchMaker.cancel()
            self.sessionState.text = ""
            waitingView.stopAnimating()
        }
        } else {
            let alert = UIAlertController(title:"参加条件を満たしていません", message: "パーティPが8000以下のパーティを選択してください", preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title: "了解", style: UIAlertActionStyle.cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        /*
        if selectedParty.textStore != "" {
            selectedParty.resignFirstResponder()
            selectedParty.isEnabled = false
            myPartyNameList.removeAll()
            myWeaponNameList.removeAll()
            numberForDecide = Int(arc4random_uniform(10000))
            recievingCount = 0
            battleRow = selectedParty.selectedRow
            selectedPartyData = partyDataList[battleRow]
            if myPartyNameList.count <= 6 {
                for i in 0...5 {
                    myPartyNameList.append(safeCallArray(pokemonNameList, selectedPartyData[i]))
                }
                for i in 0...5 {
                    for j in 0...3 {
                        if selectedPartyData[i] != -1 {
                            myWeaponNameList.append(safeCallArray(weaponNameList, pokemonDataList[selectedPartyData[i]][9+j]))
                        } else if selectedPartyData[i] == -1 {
                            myWeaponNameList.append("-")
                        }
                    }
                }
                myPartyWeaponNameList = myPartyNameList+myWeaponNameList
            }
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self
        if let aMmvc = mmvc {
            present(aMmvc, animated: true) {() -> Void in }
        }
        }
 */
     
    }


func match(_: GKMatch, didReceive data: Data, fromRemotePlayer: GKPlayer) {
    DispatchQueue.main.async() {
        recievingCount += 1
        if recievingCount <= 32 {
        let data = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
            print(data! as String)
            print(recievingCount)
        rivalPartyWeaponNameList.append(data! as String)
        if data! as String == "deleeeeete" {
            rivalPartyWeaponNameList.removeAll()
        }
        if data! as String == "oooooooook" {
            rivalPartyWeaponNameList.removeLast()
            if rivalPartyWeaponNameList.count == 30 {
                //  self.starting.isHidden = false
                self.sessionState.text = "接続完了"
                self.waitingView.startAnimating()
                self.help.isEnabled = false
                self.returnButton.isEnabled = false
                self.searching.isEnabled = false
                self.waiting.isEnabled = false
                self.selectedParty.isEnabled = false
                self.matching.isEnabled = false
                self.assistant.stop()
                if myPartyWeaponNameList.count == 30 && rivalPartyWeaponNameList.count == 30 {
                    isGKMatch = true
                    print(rivalPartyWeaponNameList)
                    for i in 0...5 {
                        rivalPartyNameList.append(rivalPartyWeaponNameList[i])
                    }
                    for i in 0...23 {
                        rivalWeaponNameList.append(rivalPartyWeaponNameList[i+6])
                    }
                    print("結果",myPartyNameList,rivalPartyNameList,myWeaponNameList,rivalWeaponNameList)
                    for i in 0...17 {
                        let data = NSData(bytes: &myTypeData[i], length: MemoryLayout<NSInteger>.size)
                        do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                        } catch {
                        }
                    }
                   
                    
                   print("文字情報受信完了")
                }
               
                
            } else {
                self.sessionState.text = "再度やり直してください"
            }
        }
        } else if recievingCount > 32 && recievingCount <= 50 {
            print(recievingCount)
            let data = NSData(data: data)
            var rivalData : NSInteger = 0
            data.getBytes(&rivalData, length: data.length)
            rivalTypeData.append(rivalData)
            if rivalTypeData.count == 18 {
                numberForDecide = Int(arc4random_uniform(10000))
                let data = NSData(bytes: &numberForDecide, length: MemoryLayout<NSInteger>.size)
                do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                } catch {
                }
            }
        } else {
            print("親決め開始")
            let data = NSData(data: data)
            var rivalData : NSInteger = 0
            data.getBytes(&rivalData, length: data.length)
            if rivalData > numberForDecide {
                isResponsible = false
                isDecide = true
            } else if rivalData < numberForDecide {
                isResponsible = true
                isDecide = true
            } else {
                numberForDecide = Int(arc4random_uniform(10000))
                let data = NSData(bytes: &numberForDecide, length: MemoryLayout<NSInteger>.size)
                do{ try  self.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
                } catch {
                }
            }
            if isDecide {
                generalMatch = self.match
                print("タイプ",rivalTypeData)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.performSegue(withIdentifier: "selectSegue", sender: self)
            }
            }
            
            
        }
    }
    
}
    @objc func updateElapsedTime() {
        count -= 1
        if count == 5 {
            matchMaker.cancel()
        }
        if count == 0 {
            timer.invalidate()
            help.isEnabled = true
            returnButton.isEnabled = true
            searching.isEnabled = true
            waiting.isEnabled = true
            selectedParty.isEnabled = true
            matching.isEnabled = true
            searchMatch = false
            self.matchMaker.cancel()
            self.sessionState.text = "対戦相手が見つかりませんでした"
            waitingView.stopAnimating()
            
           
        }
    }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
        if selectedParty.textStore != "" {
        score.text = "\(partyScoreList[selectedParty.selectedRow][0])"
        if partyScoreList[selectedParty.selectedRow][1] == 0 {
        score.backgroundColor = UIColor.red
        }
        }
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
