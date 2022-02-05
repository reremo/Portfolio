//
//  ViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/10/29.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class ViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var startBattle: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBAction func battleReady(_ sender: Any) {
        if partyNameList.count != 0 {
            performSegue(withIdentifier: "partySelectSegue", sender: self)
        } else {
            let alert = UIAlertController(title:"パーティが作成されてません", message: "先にパーティを作成してください", preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        
        
        
        
        
        
        startBattle.layer.masksToBounds = true
        startBattle.layer.cornerRadius = 20.0
        startBattle.backgroundColor = UIColor.red
        startBattle.setTitleColor(UIColor.white, for: .normal)
        startBattle.layer.borderColor = UIColor.black.cgColor
        startBattle.layer.borderWidth = 2.0

        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 20.0
        createButton.backgroundColor = UIColor.white
        createButton.setTitleColor(UIColor.red, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 2.0
        print("ビルドカウント",buildCount)
            buildCount = userDefaults.integer(forKey: "build")
       print("ビルドカウント",buildCount)
        if let list = userDefaults.array(forKey: "weaponName") {
        weaponNameList = list as! [String]
        weaponDataList = userDefaults.array(forKey: "weaponData") as! [[Int]]
            
            for i in 0...weaponDataList.count-1 {
                if weaponDataList[i].count == 4 {
                    weaponDataList[i].append(0)
                    weaponDataList[i].append(0)
                }
            }
        }
        if userDefaults.array(forKey: "weaponScore") != nil {
         weaponScoreList = userDefaults.array(forKey: "weaponScore") as! [Int]
        }
        if let list = userDefaults.array(forKey: "pokemonName") {
                pokemonNameList = list as! [String]
                pokemonDataList = userDefaults.array(forKey: "pokemonData") as! [[Int]]
            useWeaponNumberList = userDefaults.array(forKey: "useWeaponData") as! [Int]
        }
        if userDefaults.array(forKey: "pokemonScore") != nil {
            pokemonScoreList = userDefaults.array(forKey: "pokemonScore") as! [[Int]]
        }
        if let list = userDefaults.array(forKey: "partyName") {
                    partyNameList = list as! [String]
                    partyDataList = userDefaults.array(forKey: "partyData") as! [[Int]]
            usePokemonNumberList = userDefaults.array(forKey: "usePokemonData") as! [Int]
        }
        if userDefaults.array(forKey: "partyScore") != nil {
            partyScoreList = userDefaults.array(forKey: "partyScore") as! [[Int]]
        }
        if buildCount == 0 {
            print("初期設定実行")
            let exampleWeaponName = ["じしん","ドラゴンクロー","ハイドロポンプ","かえんほうしゃ","はどうだん","ラスターカノン","ドラゴンダイブ","りゅうのはどう","かみなり","だいもんじ","ふぶき","パワーウィップ","れいとうビーム","10まんボルト","コメットパンチ","ストーンエッジ","ヘドロウェーブ","なみのり","ムーンフォース","サイコキネシス","むしのさざめき","アクアテール","じゃれつく","あくのはどう","エナジーボール","かみくだく","シャドーボール"]
            let exampleWeaponData = [[100, 100, 7, 0, 0, 0],
                                     [80, 100, 10, 0, 0, 0],
                                     [110, 80, 16, 1, 0, 0],
                                     [90, 100, 15, 1, 0, 0],
                                     [90, 100, 3, 1, 0, 0],
                                     [80, 100, 12, 1, 0, 0],
                                     [100, 75, 10, 0, 0, 0],
                                     [85, 100, 10, 1, 0, 0],
                                     [110, 70, 8, 1, 0, 0],
                                     [110, 85, 15, 1, 0, 0],
                                     [110, 70, 5, 1, 0, 0],
                                     [120, 85, 4, 0, 0, 0],
                                     [90, 100, 5, 1, 0, 0],
                                     [90, 100, 8, 1, 0, 0],
                                     [100, 85, 12, 0, 0, 0],
                                     [100, 80, 1, 0, 0, 0],
                                     [95, 100, 9, 0, 0, 0],
                                     [90, 100, 16, 0, 0, 0],
                                     [95, 100, 14, 1, 0, 0],
                                     [90, 100, 2, 1, 0, 0],
                                     [90, 100, 17, 1, 0, 0],
                                     [90, 90, 16, 0, 0, 0],
                                     [90, 90, 14, 0, 0, 0],
                                     [80, 100, 0, 1, 0, 0],
                                     [80, 100, 4, 1, 0, 0],
                                     [80, 100, 0, 0, 0, 0],
                                     [80, 100, 6, 1, 0, 0]]
            let examplePokemonName = ["ガブリアス","ルカリオ","リザードン"]
            let examplePokemonData = [
                [0, 10, 7, 183, 150, 115, 100, 105, 122, 20, 26, 17, 11, 4, 0],
                [0, 3, 12, 145, 130, 90, 135, 90, 110, 19, 21, 0, 3, 1, 0],
                [0, 15, 13, 153, 104, 98, 129, 105, 120, 17, 19, 1, 26, 6, 0]]
            let examplePartyName = ["サンプル"]
            let examplePartyData = [[0, 1, 2, -1, -1, -1, -1]]
            buildCount += 1
            for i in 0...exampleWeaponData.count-1 {
                weaponNameList.insert(exampleWeaponName[i], at: 0)
                weaponDataList.insert(exampleWeaponData[i], at: 0)
            }
            for i in 0...examplePokemonName.count-1 {
                pokemonNameList.insert(examplePokemonName[i], at: 0)
                pokemonDataList.insert(examplePokemonData[i], at: 0)
            }
            for i in 0...examplePartyName.count-1 {
                partyNameList.insert(examplePartyName[i], at: 0)
                partyDataList.insert(examplePartyData[i], at: 0)
            }
            for j in 0...pokemonDataList.count-1 {
            for i in 0...3 {
                useWeaponNumberList.append(pokemonDataList[j][i+9])
            }
            }
            for j in 0...partyDataList.count-1 {
            for i in 0...5 {
                usePokemonNumberList.append(partyDataList[j][i])
            }
            }
            
            
            userDefaults.set(weaponScoreList, forKey: "weaponScore")
            userDefaults.set(pokemonScoreList, forKey: "pokemonScore")
            userDefaults.set(partyScoreList, forKey: "partyScore")
            userDefaults.set(weaponNameList, forKey: "weaponName")
            userDefaults.set(weaponDataList, forKey: "weaponData")
            userDefaults.set(useWeaponNumberList, forKey: "useWeaponData")
            userDefaults.set(pokemonNameList, forKey: "pokemonName")
            userDefaults.set(pokemonDataList, forKey: "pokemonData")
            userDefaults.set(usePokemonNumberList, forKey: "usePokemonData")
            userDefaults.set(partyNameList, forKey: "partyName")
            userDefaults.set(partyDataList, forKey: "partyData")
            
              userDefaults.set(buildCount, forKey: "build")
              userDefaults.synchronize()
        }
        if weaponDataList.count != weaponScoreList.count {
            weaponScoreList.removeAll()
            print("きたdgrhrsthr")
            for i in 0...weaponDataList.count-1 {
                var scoreA = 0
                var scoreB = 0
                scoreA = weaponDataList[i][0] + weaponDataList[i][1]
                if scoreA % 5 != 0 {
                    scoreA += 5 - (scoreA % 5)
                }
                var WP = weaponP
                if weaponDataList[i][5] == 21 {
                    if weaponDataList[i][3] == 1 {
                        WP[21] = 0
                    }
                }
                if weaponDataList[i][5] == 23 {
                    if weaponDataList[i][3] == 1 {
                        WP[23] = 0
                    }
                }
                if weaponDataList[i][5] == 24 {
                    if weaponDataList[i][3] == 0 {
                        WP[24] = 0
                    }
                    
                    scoreB = Int(Double(weaponDataList[i][1])/100.0 * Double(weaponDataList[i][4])/100.0 * Double(WP[weaponDataList[i][5]]))
                    if scoreB % 5 != 0 {
                        scoreB += 5 - (scoreB % 5)
                    }
                }
                
                weaponScoreList.append(scoreA+scoreB)
            }
        }
        if pokemonDataList.count != pokemonScoreList.count {
            pokemonScoreList.removeAll()
            for i in 0...pokemonDataList.count-1 {
                let h = pokemonDataList[i][3]
                let a = pokemonDataList[i][4]
                let b = pokemonDataList[i][5]
                let c = pokemonDataList[i][6]
                let d = pokemonDataList[i][7]
                let s = pokemonDataList[i][8]
                let habcds = reviseScore(h+a+b+c+d+s)
                 var w1 = 0
                 var w2 = 0
                 var w3 = 0
                 var w4 = 0
                if pokemonDataList[i][9] != -1 {
                 w1 = weaponScoreList[pokemonDataList[i][9]]
                }
                if pokemonDataList[i][10] != -1 {
                 w2 = weaponScoreList[pokemonDataList[i][10]]
                }
                    if pokemonDataList[i][11] != -1 {
                 w3 = weaponScoreList[pokemonDataList[i][11]]
                }
                if pokemonDataList[i][12] != -1 {
                 w4 = weaponScoreList[pokemonDataList[i][12]]
                }
                var formNumber = 0
                if h >= 150 {
                    formNumber += 100000
                }
                if a >= 150 {
                    formNumber += 10000
                }
                if b >= 150 {
                    formNumber += 1000
                }
                if c >= 150 {
                    formNumber += 100
                }
                if d >= 150 {
                    formNumber += 10
                }
                if s >= 150 {
                    formNumber += 1
                }
                var accept = 1
                if habcds+w1+w2+w3+w4 <= 2000 && (a >= 50 && c >= 50) && w1 <= 200 && w2 <= 200 && w3 <= 200 && w4 <= 200 && habcds <= 840 {
                    accept = 0
                }
                pokemonScoreList.append([habcds+w1+w2+w3+w4,formNumber,accept])
            }
        }
        if partyDataList.count != partyScoreList.count {
            partyScoreList.removeAll()
            for i in 0...partyDataList.count-1 {
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
                if partyDataList[i][0] != -1 {
                p1 = pokemonScoreList[partyDataList[i][0]][0]
                 check1 = pokemonScoreList[partyDataList[i][0]][2]
                }
                if partyDataList[i][1] != -1 {
                 p2 = pokemonScoreList[partyDataList[i][1]][0]
                 check2 = pokemonScoreList[partyDataList[i][1]][2]
                }
                if partyDataList[i][2] != -1 {
                 p3 = pokemonScoreList[partyDataList[i][2]][0]
                 check3 = pokemonScoreList[partyDataList[i][2]][2]
                }
                if partyDataList[i][3] != -1 {
                 p4 = pokemonScoreList[partyDataList[i][3]][0]
                 check4 = pokemonScoreList[partyDataList[i][3]][2]
                }
                if partyDataList[i][4] != -1 {
                 p5 = pokemonScoreList[partyDataList[i][4]][0]
                 check5 = pokemonScoreList[partyDataList[i][4]][2]
                }
                if partyDataList[i][5] != -1 {
                 p6 = pokemonScoreList[partyDataList[i][5]][0]
                 check6 = pokemonScoreList[partyDataList[i][5]][2]
                }
                let totalP = p1+p2+p3+p4+p5+p6
                var accept = 1
                if totalP <= 8000 && check1 == 0 && check2 == 0 && check3 == 0 && check4 == 0 && check5 == 0 && check6 == 0 {
                    accept = 0
                }
                partyScoreList.append([totalP,accept])
                userDefaults.set(partyScoreList, forKey: "partyScore")
            }
        }
        userDefaults.set(weaponScoreList, forKey: "weaponScore")
        userDefaults.set(pokemonScoreList, forKey: "pokemonScore")
        userDefaults.set(partyScoreList, forKey: "partyScore")
        userDefaults.set(weaponNameList, forKey: "weaponName")
        userDefaults.set(weaponDataList, forKey: "weaponData")
        userDefaults.set(useWeaponNumberList, forKey: "useWeaponData")
        userDefaults.set(pokemonNameList, forKey: "pokemonName")
        userDefaults.set(pokemonDataList, forKey: "pokemonData")
        userDefaults.set(usePokemonNumberList, forKey: "usePokemonData")
        userDefaults.set(partyNameList, forKey: "partyName")
        userDefaults.set(partyDataList, forKey: "partyData")
        
        userDefaults.set(buildCount, forKey: "build")
        userDefaults.synchronize()
        print(pokemonNameList,pokemonDataList,weaponNameList,weaponDataList)
        }
    // Do any additional setup after loading the view, typically from a nib.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

