//
//  PokemonWeaponViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/11.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonWeaponViewController: UIViewController, UITableViewDataSource, GADBannerViewDelegate {
    @IBOutlet weak var pokeWeList: UITableView!
       override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...weaponNameList.count-1 {
        print("技情報",weaponNameList[i],weaponDataList[i])
        }
        print("技データ",weaponDataList)
        
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
        
        
        
        pokeWeList.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weaponNameList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeWecell: WeaponCustomTableViewCell! =
            tableView.dequeueReusableCell(withIdentifier: "PokemonWeapon") as! WeaponCustomTableViewCell
        let weaponName = weaponNameList[indexPath.row]
        let weapon = weaponDataList[indexPath.row][2]
        pokeWecell.textLabel?.text = weaponName
        pokeWecell.weaponType.text = typeList[weapon]
        pokeWecell.weaponType.backgroundColor = colorList[weapon]
        pokeWecell.weaponPower.text = "威力:\(weaponDataList[indexPath.row][0])"
        pokeWecell.weaponRate.text = "命中率:\(weaponDataList[indexPath.row][1])"
        pokeWecell.weaponNature.text = PSList[weaponDataList[indexPath.row][3]]
        pokeWecell.weaponScore.text = "技P:\(weaponScoreList[indexPath.row])"
        if weaponScoreList[indexPath.row] <= 200 {
             pokeWecell.weaponScore.backgroundColor = UIColor.red
        } else {
            pokeWecell.weaponScore.backgroundColor = UIColor.white
        }
        return pokeWecell
    
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weaponSegue" {
            if let selectedRow = pokeWeList.indexPathForSelectedRow {
                let controller = segue.destination as! PokemonWeaponDetailViewController
                controller.info = selectedRow.row
            }
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
