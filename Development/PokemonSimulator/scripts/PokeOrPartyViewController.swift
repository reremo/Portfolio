//
//  PokeOrPartyViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/05.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokeOrPartyViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var createWeapon: UIButton!
    @IBOutlet weak var createPokemon: UIButton!
    @IBOutlet weak var createParty: UIButton!
    
    
    @IBAction func pokemonSegue(_ sender: Any) {
        if weaponNameList.count != 0 {
        performSegue(withIdentifier: "pokemonCreateSegue", sender: self)
        } else {
            let alert = UIAlertController(title:"技が作成されてません", message: "先に技を作成してください", preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title: "戻る", style: UIAlertActionStyle.cancel)
             alert.addAction(cancel)
             self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func partySegue(_ sender: Any) {
        if pokemonNameList.count != 0 {
            performSegue(withIdentifier: "partyCreateSegue", sender: self)
        } else {
            let alert = UIAlertController(title:"ポケモンが作成されてません", message: "先にポケモンを作成してください", preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        
        createWeapon.layer.masksToBounds = true
        createWeapon.layer.cornerRadius = 20.0
        createWeapon.backgroundColor = UIColor.red
        createWeapon.setTitleColor(UIColor.white, for: .normal)
        createWeapon.layer.borderColor = UIColor.black.cgColor
        createWeapon.layer.borderWidth = 3.0
        createPokemon.layer.masksToBounds = true
        createPokemon.layer.cornerRadius = 20.0
        createPokemon.backgroundColor = UIColor.red
        createPokemon.setTitleColor(UIColor.white, for: .normal)
        createPokemon.layer.borderColor = UIColor.black.cgColor
        createPokemon.layer.borderWidth = 3.0
        createParty.layer.masksToBounds = true
        createParty.layer.cornerRadius = 20.0
        createParty.backgroundColor = UIColor.red
        createParty.setTitleColor(UIColor.white, for: .normal)
        createParty.layer.borderColor = UIColor.black.cgColor
        createParty.layer.borderWidth = 3.0
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
