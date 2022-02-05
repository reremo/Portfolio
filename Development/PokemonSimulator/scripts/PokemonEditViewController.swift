//
//  PokemonEditViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2018/02/26.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonEditViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var pokemonName: UITextField!
    @IBOutlet weak var pokemonH: UITextField!
    @IBOutlet weak var pokemonA: UITextField!
    @IBOutlet weak var pokemonB: UITextField!
    @IBOutlet weak var pokemonC: UITextField!
    @IBOutlet weak var pokemonD: UITextField!
    @IBOutlet weak var pokemonS: UITextField!
    @IBOutlet weak var pokemonType: PickerKeyboard!
    @IBOutlet weak var pokemonType2: PickerKeyboard!
    @IBOutlet weak var weapon1: PickerKeyboard!
    @IBOutlet weak var weapon2: PickerKeyboard!
    @IBOutlet weak var weapon3: PickerKeyboard!
    @IBOutlet weak var weapon4: PickerKeyboard!
    @IBOutlet weak var item: PickerKeyboard!
    @IBOutlet weak var statusScore: UILabel!
    @IBOutlet weak var w1Score: UILabel!
    @IBOutlet weak var w2Score: UILabel!
    @IBOutlet weak var w3Score: UILabel!
    @IBOutlet weak var w4Score: UILabel!
    @IBOutlet weak var weaponTotalScore: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var create: UIButton!
    @IBAction func help(_ sender: Any) {
        let alert = UIAlertController(title:"ポケP", message: "ランダムマッチでの使用条件：ポケPが1600以下、ステータスの合計Pが840以下、全ての技Pが200以下、\n\nポケP\n = (ステータスの合計)の５の倍数切り上げ\n＋\n技Pの合計", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "了解", style: UIAlertActionStyle.cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func createPokemon(_ sender: UIButton) {
        if pokemonName.text != "" && pokemonH.text != "" &&
            pokemonA.text != "" && pokemonB.text != "" && pokemonC.text != "" && pokemonD.text != "" && pokemonS.text != "" && (pokemonType.textStore != "" || pokemonType2.textStore != "") && (weapon1.textStore != "" || weapon2.textStore != "" || weapon3.textStore != "" || weapon4.textStore != "") {
            var h = Int(pokemonH.text!)!
            if h == 0 {
                h = 1
            }
            var a = Int(pokemonA.text!)!
            if a == 0 {
                a = 1
            }
            var b = Int(pokemonB.text!)!
            if b == 0 {
                b = 1
            }
            var c = Int(pokemonC.text!)!
            if c == 0 {
                c = 1
            }
            var d = Int(pokemonD.text!)!
            if d == 0 {
                d = 1
            }
            var s = Int(pokemonS.text!)!
            if s == 0 {
                s = 1
            }
            var typeData = [pokemonType.selectedRow,pokemonType2.selectedRow]
            typeData = deleteSame(typeData)
            if pokemonType2.selectedRow == 17 {
                typeData[1] = -1
            }
            var weaponData = [weapon1.selectedRow,weapon2.selectedRow,weapon3.selectedRow,weapon4.selectedRow]
            weaponData = deleteSame(weaponData)
            var itemSelectedRow = item.selectedRow //ゴツメ回避用
            if item.selectedRow == 9 {
                itemSelectedRow = 10
            }
            for i in 0...3 {
                useWeaponNumberList[infoPokemon*4+i] = weaponData[i]
            }
            pokemonNameList[infoPokemon] = pokemonName.text!
            pokemonDataList[infoPokemon] = [0,typeData[0],typeData[1],h,a,b,c,d,s,weaponData[0],weaponData[1],weaponData[2],weaponData[3],itemSelectedRow,0]
            // 0は特性分
            print(typeData)
            let habcds = reviseScore(h+a+b+c+d+s)
            statusScore.text = String(habcds)
            var w1 = 0
            var w2 = 0
            var w3 = 0
            var w4 = 0
            if weaponData[0] != -1 {
                w1 = weaponScoreList[weaponData[0]]
                w1Score.text = String(weaponScoreList[weaponData[0]])
            }
            if weaponData[1] != -1 {
                w2 = weaponScoreList[weaponData[1]]
                w2Score.text = String(weaponScoreList[weaponData[1]])
            }
            if weaponData[2] != -1 {
                w3 = weaponScoreList[weaponData[2]]
                w3Score.text = String(weaponScoreList[weaponData[2]])
            }
            if weaponData[3] != -1 {
                w4 = weaponScoreList[weaponData[3]]
                w4Score.text = String(weaponScoreList[weaponData[3]])
            }
            weaponTotalScore.text = String(w1+w2+w3+w4)
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
            let gap = habcds+w1+w2+w3+w4 - pokemonScoreList[infoPokemon][0]
            for i in 0...partyDataList.count-1 {
                for j in 0...5 {
                    if partyDataList[i][j] == infoPokemon {
                        partyScoreList[i][0] += gap
                        if habcds+w1+w2+w3+w4 > 1600 {
                            partyScoreList[i][1] = 1
                        }
                        if partyScoreList[i][0] > 8000 {
                            partyScoreList[i][1] = 1
                        }
                        func dataCheck(_ a: Int)->Bool {
                            var b = false
                            if partyDataList[i][a] == -1 {
                                b = true
                            } else {
                                if pokemonScoreList[partyDataList[i][a]][0] <= 1600 {
                                    b = true
                                }
                            }
                            return b
                        }
                        if partyScoreList[i][0] <= 8000 && dataCheck(0) && dataCheck(1) && dataCheck(2) && dataCheck(3) && dataCheck(4) && dataCheck(5) {
                            print("原因２")
                            partyScoreList[i][1] = 0
                    }
                }
            }
            }
             pokemonScoreList[infoPokemon] = [habcds+w1+w2+w3+w4,formNumber,accept]
            userDefaults.set(pokemonScoreList, forKey: "pokemonScore")
            userDefaults.set(pokemonNameList, forKey: "pokemonName")
            userDefaults.set(pokemonDataList, forKey: "pokemonData")
            userDefaults.set(useWeaponNumberList, forKey: "useWeaponData")
            userDefaults.synchronize()
            performSegue(withIdentifier: "pokemonEditSegue", sender: self)
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
        
        
        
        self.pokemonH.keyboardType = UIKeyboardType.numberPad
        self.pokemonA.keyboardType = UIKeyboardType.numberPad
        self.pokemonB.keyboardType = UIKeyboardType.numberPad
        self.pokemonC.keyboardType = UIKeyboardType.numberPad
        self.pokemonD.keyboardType = UIKeyboardType.numberPad
        self.pokemonS.keyboardType = UIKeyboardType.numberPad
        create.layer.masksToBounds = true
        create.layer.cornerRadius = 5.0
        create.backgroundColor = UIColor.red
        create.setTitleColor(UIColor.white, for: .normal)
        create.layer.borderColor = UIColor.black.cgColor
        create.layer.borderWidth = 1.0
        pokemonType.data = typeList
        pokemonType2.data = typeList2
        weapon1.data = weaponNameList
        weapon2.data = weaponNameList
        weapon3.data = weaponNameList
        weapon4.data = weaponNameList
        
        item.data = itemList
        pokemonName.text = pokemonNameList[infoPokemon]
        
        pokemonType.textStore = safeCallArray(typeList, pokemonDataList[infoPokemon][1])
        pokemonType2.textStore = safeCallArray(typeList, pokemonDataList[infoPokemon][2])
       
        pokemonType.selectedRow =  pokemonDataList[infoPokemon][1]
        pokemonType2.selectedRow = pokemonDataList[infoPokemon][2]
        pokemonH.text = "\(pokemonDataList[infoPokemon][3])"
        pokemonA.text = "\(pokemonDataList[infoPokemon][4])"
        pokemonB.text = "\(pokemonDataList[infoPokemon][5])"
        pokemonC.text = "\(pokemonDataList[infoPokemon][6])"
        pokemonD.text = "\(pokemonDataList[infoPokemon][7])"
        pokemonS.text = "\(pokemonDataList[infoPokemon][8])"
        weapon1.textStore = safeCallArray(weaponNameList, pokemonDataList[infoPokemon][9])
        weapon2.textStore = safeCallArray(weaponNameList, pokemonDataList[infoPokemon][10])
        weapon3.textStore = safeCallArray(weaponNameList, pokemonDataList[infoPokemon][11])
        weapon4.textStore = safeCallArray(weaponNameList, pokemonDataList[infoPokemon][12])
        weapon1.selectedRow = pokemonDataList[infoPokemon][9]
        weapon2.selectedRow = pokemonDataList[infoPokemon][10]
        weapon3.selectedRow = pokemonDataList[infoPokemon][11]
        weapon4.selectedRow = pokemonDataList[infoPokemon][12]
        statusScore.text = "\(reviseScore(pokemonDataList[infoPokemon][3]+pokemonDataList[infoPokemon][4]+pokemonDataList[infoPokemon][5]+pokemonDataList[infoPokemon][6]+pokemonDataList[infoPokemon][7]+pokemonDataList[infoPokemon][8]))"
        if pokemonDataList[infoPokemon][9] != -1 {
        w1Score.text = "\(weaponScoreList[pokemonDataList[infoPokemon][9]])"
        }
             if pokemonDataList[infoPokemon][10] != -1 {
         w2Score.text = "\(weaponScoreList[pokemonDataList[infoPokemon][10]])"
            }
                 if pokemonDataList[infoPokemon][11] != -1 {
         w3Score.text = "\(weaponScoreList[pokemonDataList[infoPokemon][11]])"
                }
                     if pokemonDataList[infoPokemon][12] != -1 {
         w4Score.text = "\(weaponScoreList[pokemonDataList[infoPokemon][12]])"
                    }
        weaponTotalScore.text = "\(weaponScoreList[pokemonDataList[infoPokemon][9]]+weaponScoreList[pokemonDataList[infoPokemon][10]]+weaponScoreList[pokemonDataList[infoPokemon][11]]+weaponScoreList[pokemonDataList[infoPokemon][12]])"
        totalScore.text = "\(pokemonScoreList[infoPokemon][0])"
        if pokemonDataList[infoPokemon][13] == 10 {//ゴツメ回避
            pokemonDataList[infoPokemon][13] = 9
        }
        item.textStore = safeCallArray(itemList, pokemonDataList[infoPokemon][13])
        item.selectedRow = pokemonDataList[infoPokemon][13]
        if pokemonDataList[infoPokemon][13] == 9 {
            pokemonDataList[infoPokemon][13] = 10
        }
    }
    
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        var h1 = 0
        var a1 = 0
        var b1 = 0
        var c1 = 0
        var d1 = 0
        var s1 = 0
        var habcds = 0
        if pokemonH.text != "" {
            h1 = Int(pokemonH.text!)!
        }
        if pokemonA.text != "" {
            a1 = Int(pokemonA.text!)!
        }
        if pokemonB.text != "" {
            b1 = Int(pokemonB.text!)!
        }
        if pokemonC.text != "" {
            c1 = Int(pokemonC.text!)!
        }
        if pokemonD.text != "" {
            d1 = Int(pokemonD.text!)!
        }
        if pokemonS.text != "" {
            s1 = Int(pokemonS.text!)!
        }
        habcds = h1+a1+b1+c1+d1+s1
        habcds = reviseScore(habcds)
        statusScore.text = String(habcds)
        var w1 = 0
        var w2 = 0
        var w3 = 0
        var w4 = 0
        if weapon1.textStore != "" {
            w1 = weaponScoreList[weapon1.selectedRow]
            w1Score.text = String(weaponScoreList[weapon1.selectedRow])
        }
        if weapon2.textStore != "" {
            w2 = weaponScoreList[weapon2.selectedRow]
            w2Score.text = String(weaponScoreList[weapon2.selectedRow])
        }
        if weapon3.textStore != "" {
            w3 = weaponScoreList[weapon3.selectedRow]
            w3Score.text = String(weaponScoreList[weapon3.selectedRow])
        }
        if weapon4.textStore != "" {
            w4 = weaponScoreList[weapon4.selectedRow]
            w4Score.text = String(weaponScoreList[weapon4.selectedRow])
        }
        weaponTotalScore.text = String(w1+w2+w3+w4)
        totalScore.text = String(habcds+w1+w2+w3+w4)
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
