//
//  PokemonPartyEditViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/02/26.
//  Copyright © 2018年 森居麗. All rights reserved.
//
import UIKit
import GoogleMobileAds
class PokemonPartyEditViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var partyName: UITextField!
    @IBOutlet weak var pokemon1: PickerKeyboard!
    @IBOutlet weak var pokemon2: PickerKeyboard!
    @IBOutlet weak var pokemon3: PickerKeyboard!
    @IBOutlet weak var pokemon4: PickerKeyboard!
    @IBOutlet weak var pokemon5: PickerKeyboard!
    @IBOutlet weak var pokemon6: PickerKeyboard!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var score5: UILabel!
    @IBOutlet weak var score6: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var create: UIButton!
    @IBAction func help(_ sender: Any) {
        let alert = UIAlertController(title:"パーティP", message: "ランダムマッチでの使用条件：パーティPが8000以下、全のポケモンが使用条件を満たしている、\n\nパーティP\n = ポケPの合計", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "了解", style: UIAlertActionStyle.cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    let AdMobID = "ca-app-pub-9204323547115751/8128183295"
    // Simulator ID
    let SIMULSTOR_ID = kGADSimulatorID
    
    // 実機テスト用 ID を入れる
    let DEVICE_TEST_ID = "aaaaaaaaaaaaaaaaa0123456789"
    
    
    let DeviceTest:Bool = false
    let SimulatorTest:Bool = true
    @IBAction func partyCreate(_ sender: Any) {
        if partyName.text != "" {
            partyNameList[infoParty] = partyName.text!
            var pokemonData = [pokemon1.selectedRow,pokemon2.selectedRow,pokemon3.selectedRow,pokemon4.selectedRow,pokemon5.selectedRow,pokemon6.selectedRow,-1]//-1は闇っぽけ
            pokemonData = deleteSame(pokemonData)
            for i in 0...5 {
                usePokemonNumberList[infoParty*6+i] = pokemonData[i]
            }
            partyDataList[infoParty] = pokemonData
            var p1 = 0
            var check1 = 0
            var p2 = 0
            var check2 = 0
            var p3 = 0
            var check3 = 0
            var p4 = 0
            var check4 = 0
            var p5 = 0
            var check5 = 0
            var p6 = 0
            var check6 = 0
            
            if pokemonData[0] != -1 {
                p1 = pokemonScoreList[pokemonData[0]][0]
                check1 = pokemonScoreList[pokemonData[0]][2]
            }
            if pokemonData[1] != -1 {
                p2 = pokemonScoreList[pokemonData[1]][0]
                check2 = pokemonScoreList[pokemonData[1]][2]
            }
            if pokemonData[2] != -1 {
                p3 = pokemonScoreList[pokemonData[2]][0]
                check3 = pokemonScoreList[pokemonData[2]][2]
            }
            if pokemonData[3] != -1 {
                p4 = pokemonScoreList[pokemonData[3]][0]
                 check4 = pokemonScoreList[pokemonData[3]][2]
            }
            if pokemonData[4] != -1 {
                p5 = pokemonScoreList[pokemonData[4]][0]
                 check5 = pokemonScoreList[pokemonData[4]][2]
            }
            if pokemonData[5] != -1 {
                p6 = pokemonScoreList[pokemonData[5]][0]
                 check6 = pokemonScoreList[pokemonData[5]][2]
            }
            let totalP = p1+p2+p3+p4+p5+p6
            var accept = 1
            if totalP <= 8000 && check1 == 0 && check2 == 0 && check3 == 0 && check4 == 0 && check5 == 0 && check6 == 0 {
                accept = 0
            }
             partyScoreList[infoParty] = [totalP,accept]
            userDefaults.set(partyScoreList, forKey: "partyScore")
            userDefaults.set(partyNameList, forKey: "partyName")
            userDefaults.set(partyDataList, forKey: "partyData")
            userDefaults.set( usePokemonNumberList, forKey: "usePokemonData")
            userDefaults.synchronize()
            print(pokemonData)
            performSegue(withIdentifier: "partyEditSegue", sender: self)
        } else {
            let alert = UIAlertController(title:"記入内容が不足しています", message: "確認してください", preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title: "戻る", style: UIAlertActionStyle.cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
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
        
        // 2秒間待たせる
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showAdMob(interstitial: interstitial)
        }
        
        
        create.layer.masksToBounds = true
        create.layer.cornerRadius = 5.0
        create.backgroundColor = UIColor.red
        create.setTitleColor(UIColor.white, for: .normal)
        create.layer.borderColor = UIColor.black.cgColor
        create.layer.borderWidth = 1.0
        pokemon1.data = pokemonNameList
        pokemon2.data = pokemonNameList
        pokemon3.data = pokemonNameList
        pokemon4.data = pokemonNameList
        pokemon5.data = pokemonNameList
        pokemon6.data = pokemonNameList
        partyName.text = partyNameList[infoParty]
        pokemon1.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][0])
        pokemon2.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][1])
        pokemon3.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][2])
        pokemon4.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][3])
        pokemon5.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][4])
        pokemon6.textStore =  safeCallArray(pokemonNameList, partyDataList[infoParty][5])
        pokemon1.selectedRow = partyDataList[infoParty][0]
        pokemon2.selectedRow = partyDataList[infoParty][1]
        pokemon3.selectedRow = partyDataList[infoParty][2]
        pokemon4.selectedRow = partyDataList[infoParty][3]
        pokemon5.selectedRow = partyDataList[infoParty][4]
        pokemon6.selectedRow = partyDataList[infoParty][5]
        if partyDataList[infoParty][0] != -1 {
        score1.text = "\(pokemonScoreList[partyDataList[infoParty][0]][0])"
        }
        if partyDataList[infoParty][1] != -1 {
        score2.text = "\(pokemonScoreList[partyDataList[infoParty][1]][0])"
        }
        if partyDataList[infoParty][2] != -1 {
        score3.text = "\(pokemonScoreList[partyDataList[infoParty][2]][0])"
        }
            if partyDataList[infoParty][3] != -1 {
        score4.text = "\(pokemonScoreList[partyDataList[infoParty][3]][0])"
            }
                if partyDataList[infoParty][4] != -1 {
        score5.text = "\(pokemonScoreList[partyDataList[infoParty][4]][0])"
                }
                    if partyDataList[infoParty][5] != -1 {
        score6.text = "\(pokemonScoreList[partyDataList[infoParty][5]][0])"
                    }
        totalScore.text = "\(partyScoreList[infoParty][0])"

        print("パーティ情報",partyNameList[infoParty],partyDataList[infoParty])
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        var p1 = 0
        var p2 = 0
        var p3 = 0
        var p4 = 0
        var p5 = 0
        var p6 = 0
        if pokemon1.textStore != "" && pokemon1.selectedRow != -1 {
            p1 = pokemonScoreList[pokemon1.selectedRow][0]
            score1.text = String(p1)
        }
        if pokemon2.textStore != "" && pokemon2.selectedRow != -1 {
            p2 = pokemonScoreList[pokemon2.selectedRow][0]
            score2.text = String(p2)
        }
        if pokemon3.textStore != "" && pokemon3.selectedRow != -1 {
            p3 = pokemonScoreList[pokemon3.selectedRow][0]
            score3.text = String(p3)
        }
        if pokemon4.textStore != "" && pokemon4.selectedRow != -1 {
            p4 = pokemonScoreList[pokemon4.selectedRow][0]
            score4.text = String(p4)
        }
        if pokemon5.textStore != "" && pokemon5.selectedRow != -1 {
            p5 = pokemonScoreList[pokemon5.selectedRow][0]
            score5.text = String(p5)
        }
        if pokemon6.textStore != "" && pokemon6.selectedRow != -1 {
            p6 = pokemonScoreList[pokemon6.selectedRow][0]
            score6.text = String(p6)
        }
        let totalP = p1+p2+p3+p4+p5+p6
        totalScore.text = String(totalP)
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

