//
//  PokemonWeaponCreateViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/15.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonWeaponCreateViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var weaponName: UITextField!
    @IBOutlet weak var weaponPower: UITextField!
    @IBOutlet weak var weaponRate: UITextField!
    @IBOutlet weak var weaponType: PickerKeyboard!
    @IBOutlet weak var weaponNature: PickerKeyboard!
    @IBOutlet weak var subRate: UITextField!
    @IBOutlet weak var sub: PickerKeyboard!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBAction func help(_ sender: Any) {
        let alert = UIAlertController(title:"技P", message: "ランダムマッチでの使用条件：技Pが200以下\n\n技P\n = (威力＋命中率)の５の倍数切り上げ\n＋\n(命中率×サブP)の５の倍数切り上げ\n\n※ サブPとは状態ステータス変化効果それぞれに設定されたPのこと", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "了解", style: UIAlertActionStyle.cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pokemonWeaponCreate(_ sender: Any) {
        if weaponName.text != "" && weaponPower.text != "" && weaponRate.text != "" &&
            weaponNature.textStore != "" {
           weaponNameList.append(weaponName.text!)
            let weaponPower = Int((self.weaponPower.text!))!
            var weaponRate = Int((self.weaponRate.text!))!
            if weaponRate > 100 {
                weaponRate = 100
            }
          //  var subRate = 0
             var sub = 0
            if self.sub.textStore != "" {
           // subRate = Int((self.subRate.text!))!
         //   if subRate > 100 {
          //      subRate = 100
          //  }
                 sub = self.sub.selectedRow
            }
            
            
            
            
            
            weaponDataList.append([weaponPower, weaponRate, weaponType.selectedRow, weaponNature.selectedRow,100,sub])
            var scoreA = 0
            var scoreB = 0
           scoreA = weaponPower + weaponRate
                if scoreA % 5 != 0 {
                    scoreA += 5 - (scoreA % 5)
                }
            var WP = weaponP
                if sub == 21 {
                    if weaponNature.selectedRow == 1 {
                        WP[21] = 0
                    }
                }
                if sub == 23 {
                    if weaponNature.selectedRow == 1 {
                        WP[23] = 0
                    }
                }
                if sub == 24 {
                    if weaponNature.selectedRow == 0 {
                        WP[24] = 0
                    }
                
               
            }
            scoreB = Int(Double(weaponRate)/100.0 * Double(WP[sub]))
            if scoreB % 5 != 0 {
                scoreB += 5 - (scoreB % 5)
            }
            print("hetrjrjsyrs",scoreA+scoreB)
            weaponScoreList.append(scoreA+scoreB)
            userDefaults.set(weaponScoreList, forKey: "weaponScore")
            userDefaults.set(weaponNameList, forKey: "weaponName")
           userDefaults.set(weaponDataList, forKey: "weaponData")
            userDefaults.synchronize()
            performSegue(withIdentifier: "weaponAddSegue", sender: self)
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
        
        
        
        
        create.layer.masksToBounds = true
        create.layer.cornerRadius = 5.0
        create.backgroundColor = UIColor.red
        create.setTitleColor(UIColor.white, for: .normal)
        create.layer.borderColor = UIColor.black.cgColor
        create.layer.borderWidth = 1.0
        self.weaponPower.keyboardType = UIKeyboardType.numberPad
        self.weaponRate.keyboardType = UIKeyboardType.numberPad
        self.subRate.keyboardType = UIKeyboardType.numberPad
        weaponType.data = typeList
        weaponNature.data = PSList
        sub.data = subList
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        var scoreA = 0
        var scoreB = 0
        if weaponPower.text != "" && weaponRate.text != "" {
            
            scoreA = Int(weaponPower.text!)! + Int(weaponRate.text!)!
            if scoreA % 5 != 0 {
                scoreA += 5 - (scoreA % 5)
            }
            score1.text = String(scoreA)
        }
        if weaponNature.textStore != "" && weaponRate.text != "" && sub.textStore != "" {
            var WP = weaponP
            if sub.selectedRow == 21 {
                if weaponNature.selectedRow == 1 {
                    WP[21] = 0
                }
            }
            if sub.selectedRow == 23 {
                if weaponNature.selectedRow == 1 {
                    WP[23] = 0
                }
            }
            if sub.selectedRow == 24 {
                if weaponNature.selectedRow == 0 {
                    WP[24] = 0
                }
            }
            scoreB = Int(Double(weaponRate.text!)!/100.0 *  Double(WP[sub.selectedRow]))
            if scoreB % 5 != 0 {
                scoreB += 5 - (scoreB % 5)
            }
            score2.text = String(scoreB)
        }
        
        totalScore.text = String(scoreA+scoreB)
        score1.text = String(scoreA)
        score2.text = String(scoreB)
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
