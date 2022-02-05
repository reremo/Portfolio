//
//  PokemonPartyDetailViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/12/02.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonPartyDetailViewController: UIViewController, GADBannerViewDelegate {
    var info: Int = 0
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var pokemon1: UILabel!
    @IBOutlet weak var pokemon2: UILabel!
    @IBOutlet weak var pokemon3: UILabel!
    @IBOutlet weak var pokemon4: UILabel!
    @IBOutlet weak var pokemon5: UILabel!
    @IBOutlet weak var pokemon6: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var totalScore: UILabel!
    @IBAction func deleteButton(_ sender: Any) {
        partyNameList.remove(at: info)
        partyDataList.remove(at: info)
        for _ in 0...5 {
            usePokemonNumberList.remove(at: info*6)
        }
        userDefaults.set(partyNameList, forKey: "partyName")
        userDefaults.set(partyDataList, forKey: "partyData")
        userDefaults.set(usePokemonNumberList, forKey: "usePokemonData")
        userDefaults.synchronize()
        print(usePokemonNumberList,"usepoke")
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
        infoParty = info
        partyName.text = partyNameList[info]
        pokemon1.text =  safeCallArray(pokemonNameList, partyDataList[info][0])
        pokemon2.text =  safeCallArray(pokemonNameList, partyDataList[info][1])
        pokemon3.text =  safeCallArray(pokemonNameList, partyDataList[info][2])
        pokemon4.text =  safeCallArray(pokemonNameList, partyDataList[info][3])
        pokemon5.text =  safeCallArray(pokemonNameList, partyDataList[info][4])
        pokemon6.text =  safeCallArray(pokemonNameList, partyDataList[info][5])
           totalScore.text = String(partyScoreList[infoParty][0])
        print("ポケモン情報",pokemonNameList[info],pokemonDataList[info])
        // Do any additional setup after loading the view.
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
