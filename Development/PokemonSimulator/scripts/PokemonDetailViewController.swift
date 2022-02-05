//
//  PokemonDetailViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/10.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonDetailViewController: UIViewController, GADBannerViewDelegate {
    var info: Int = 0
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonH: UILabel!
    @IBOutlet weak var pokemonA: UILabel!
    @IBOutlet weak var pokemonB: UILabel!
    @IBOutlet weak var pokemonC: UILabel!
    @IBOutlet weak var pokemonD: UILabel!
    @IBOutlet weak var pokemonS: UILabel!
    @IBOutlet weak var pokemonType1: UILabel!
    @IBOutlet weak var pokemonType2: UILabel!
    @IBOutlet weak var pokemonWeapon1: UILabel!
    @IBOutlet weak var pokemonWeapon2: UILabel!
    @IBOutlet weak var pokemonWeapon3: UILabel!
    @IBOutlet weak var pokemonWeapon4: UILabel!
    @IBOutlet weak var pokemonItem: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var edit: UIButton!
    @IBAction func deletePokemon(_ sender: Any) {
        if usePokemonNumberList.index(of: info) == nil {
        pokemonNameList.remove(at: info)
        pokemonDataList.remove(at: info)
            pokemonScoreList.remove(at: info)
            for _ in 0...3 {
                useWeaponNumberList.remove(at: info*4)
            }
            for i in 0...partyNameList.count-1 {
                for j in 0...5 {
                    if partyDataList[i][j] > info {
                        partyDataList[i][j] -= 1
                        print(partyDataList[i],"変更")
                    }
                }
            }
            userDefaults.set(pokemonScoreList, forKey: "pokemonScore")
        userDefaults.set(pokemonNameList, forKey: "pokemonName")
        userDefaults.set(pokemonDataList, forKey: "pokemonData")
        userDefaults.set(useWeaponNumberList, forKey: "useWeaponData")
        userDefaults.synchronize()
            performSegue(withIdentifier: "pokemonDeleteSegue", sender: self)
        } else {
            let alert = UIAlertController(title:"削除できません", message: "このポケモンは使用されています", preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 5.0
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.layer.borderColor = UIColor.black.cgColor
        deleteButton.layer.borderWidth = 1.0
        edit.layer.masksToBounds = true
        edit.layer.cornerRadius = 5.0
        edit.backgroundColor = UIColor.red
        edit.setTitleColor(UIColor.white, for: .normal)
        edit.layer.borderColor = UIColor.black.cgColor
        edit.layer.borderWidth = 1.0
        print("okkkkk")
        infoPokemon = info
 print(pokemonDataList[info],"これ？")
        pokemonName.text = pokemonNameList[info]
        pokemonType1.text = safeCallArray(typeList, pokemonDataList[info][1])
        pokemonType2.text = safeCallArray(typeList, pokemonDataList[info][2])
        pokemonH.text = "\(pokemonDataList[info][3])"
        pokemonA.text = "\(pokemonDataList[info][4])"
        pokemonB.text = "\(pokemonDataList[info][5])"
        pokemonC.text = "\(pokemonDataList[info][6])"
        pokemonD.text = "\(pokemonDataList[info][7])"
        pokemonS.text = "\(pokemonDataList[info][8])"
        pokemonWeapon1.text = safeCallArray(weaponNameList, pokemonDataList[info][9])
        pokemonWeapon2.text = safeCallArray(weaponNameList, pokemonDataList[info][10])
        pokemonWeapon3.text = safeCallArray(weaponNameList, pokemonDataList[info][11])
        pokemonWeapon4.text = safeCallArray(weaponNameList, pokemonDataList[info][12])
        
        if pokemonDataList[info][13] == 10 {//ゴツメ回避
            pokemonDataList[info][13] = 9
        }
        pokemonItem.text = safeCallArray(itemList, pokemonDataList[info][13])
        if pokemonDataList[info][13] == 9 {
            pokemonDataList[info][13] = 10
        }
        totalScore.text = "\(pokemonScoreList[infoPokemon][0])"
        // Do any additional setup after loading the view.
        print(pokemonDataList[info])
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
