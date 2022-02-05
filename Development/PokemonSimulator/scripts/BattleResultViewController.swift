//
//  BattleResultViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/02/18.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit
class BattleResultViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, GKMatchDelegate {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var BattleLog: UITextView!
    @IBOutlet weak var returnButton: UIButton!
    let AdMobID = "ca-app-pub-9204323547115751/8128183295"
    // Simulator ID
    let SIMULSTOR_ID = kGADSimulatorID
    
    // 実機テスト用 ID を入れる
    let DEVICE_TEST_ID = "aaaaaaaaaaaaaaaaa0123456789"
    
    
    let DeviceTest:Bool = false
    let SimulatorTest:Bool = true
    
    
    override func viewDidLoad() {
        
        if isGKMatch {
            generalMatch.disconnect()
            print("ok4")
        } else {
            generalSession.disconnect()
        }
       var bannerView: GADBannerView = GADBannerView()
         print("ok2")
        bannerView = GADBannerView(adSize:kGADAdSizeLargeBanner)
         print("ok2")
        bannerView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width,height: bannerView.frame.height)
         print("ok2")
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-9204323547115751/2251964689"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
         print("ok2")
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        // gadRequest.testDevices = ["12345678abcdefgh"]
        bannerView.load(gadRequest)
         print("ok2")
        self.view.addSubview(bannerView)
        
        print("ok2")
        let interstitial = GADInterstitial(adUnitID: AdMobID)
        
        let request = GADRequest()
        
        if(DeviceTest){
            request.testDevices = [DEVICE_TEST_ID]
            
        }else if SimulatorTest {
            request.testDevices = [SIMULSTOR_ID]
        }
        else{
            // AdMob
            print("AdMob本番")
        }
        
        interstitial.load(request);
        print("ok2")
        // 2秒間待たせる
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showAdMob(interstitial: interstitial)
        }
 
        print("ok2")
        BattleLog.text = resultBattleLog
        super.viewDidLoad()
        returnButton.layer.masksToBounds = true
        returnButton.layer.cornerRadius = 5.0
        returnButton.backgroundColor = UIColor.red
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.layer.borderWidth = 1.0
        returnButton.layer.borderColor = UIColor.black.cgColor
        BattleLog.layer.masksToBounds = true
        BattleLog.layer.cornerRadius = 5.0
        BattleLog.layer.borderWidth = 2.0
        if timeUpWin && !timeUpLose {
            result.text = "勝利"
            BattleLog.text = "相手のタイムアップです"
            BattleLog.layer.borderColor = UIColor.red.cgColor
        } else if timeUpLose  {
            result.text = "敗北"
            BattleLog.text = "タイムアップです"
            BattleLog.layer.borderColor = UIColor.blue.cgColor
        } else {
        if myHPList == [0,0,0] && rivalHPList == [0,0,0] {
            /*if resultData[22] < resultData[30]/10 && resultData[22] != 0{
                result.text = "勝利"
                BattleLog.layer.borderColor = UIColor.red.cgColor
            } else if resultData[23] < resultData[31]/10 && resultData[23] != 0 {
                result.text = "敗北"
                BattleLog.layer.borderColor = UIColor.blue.cgColor
            } else {
                if resultData[0] == 1 {
                    result.text = "敗北"
                    BattleLog.layer.borderColor = UIColor.blue.cgColor
                }
                if resultData[0] == 2 {
                    result.text = "勝利"
                    BattleLog.layer.borderColor = UIColor.red.cgColor
                }
                if resultData[0] == 3 {
                    if resultData[1] == 0 {
                        if resultData[19] == 0 {
                            result.text = "勝利"
                            BattleLog.layer.borderColor = UIColor.red.cgColor
                        } else {
                            result.text = "敗北"
                            BattleLog.layer.borderColor = UIColor.blue.cgColor
                        }
                    } else {
                        if resultData[18] == 0 {
                            result.text = "敗北"
                            BattleLog.layer.borderColor = UIColor.blue.cgColor
                        } else {
                            result.text = "勝利"
                            BattleLog.layer.borderColor = UIColor.red.cgColor
                        }
                    }
                }
            }*/
            result.text = "引き分け"
        } else if rivalHPList == [0,0,0] {
            result.text = "勝利"
            BattleLog.layer.borderColor = UIColor.red.cgColor
        } else if myHPList == [0,0,0] {
            result.text = "敗北"
            BattleLog.layer.borderColor = UIColor.blue.cgColor
        }
        }
        callSelfCount = 0
        
        waiting = false
        rivalWaiting = false
        battleRow = 0
        recievedData = [Int]()
        myBattlePokemonDataList = [[Int]]()
        selectedPartyData = [Int]()
        myBattlePartyData = [Int]()
        myPartyNameList = [String]()
        rivalPartyNameList = [String]()
        myWeaponNameList = [String]()
        rivalWeaponNameList = [String]()
        myBattlingPokemonName = String()
        myBattlingPokemonNumber = 0
        myWaitingPokemon1Number = 1
        myWaitingPokemon2Number = 2
        rivalBattlingPokemonNumber = 0
        oldMyBattlingPokemonNumber = 0
        choice = false
        isFromChanging = false
        isFromChangingDying = false
        myHPList = [Int]()
        myOriginHPList = [Int]()
        rivalHPList = [Int]()
        rivalOriginHPList = [Int]()
        myAttackDamage = 0
        rivalAttackDamage = 0
        print("ok3")
       
        isGKMatch = false
        // Do any additional setup after loading the view.
    }
    
    func showAdMob(interstitial: GADInterstitial){
        if (interstitial.isReady)
        {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
