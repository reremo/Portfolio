//
//  PokemonPartyViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/15.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonPartyViewController: UIViewController, UITableViewDataSource, GADBannerViewDelegate {
    @IBOutlet weak var pokepaList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...partyNameList.count-1 {
            print("パーティ情報",partyNameList[i],partyDataList[i])
        }
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
        
        
        
        
pokepaList.dataSource = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyNameList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokepacell: PartyCustomTableViewCell! =
            tableView.dequeueReusableCell(withIdentifier: "PokemonParty") as! PartyCustomTableViewCell
        let partyName = partyNameList[indexPath.row]
        pokepacell.textLabel?.text = partyName
        pokepacell.score.text = "パーティP:\(partyScoreList[indexPath.row][0])"
        if partyScoreList[indexPath.row][1] == 0 {
            pokepacell.score.backgroundColor = UIColor.red
        } else {
            pokepacell.score.backgroundColor = UIColor.white
        }
        if partyDataList[indexPath.row][0] != -1 {
        pokepacell.pokemon1.text = pokemonNameList[partyDataList[indexPath.row][0]]
        }
        if partyDataList[indexPath.row][1] != -1 {
            pokepacell.pokemon2.text = pokemonNameList[partyDataList[indexPath.row][1]]
        }
        if partyDataList[indexPath.row][2] != -1 {
            pokepacell.pokemon3.text = pokemonNameList[partyDataList[indexPath.row][2]]
        }
        if partyDataList[indexPath.row][3] != -1 {
            pokepacell.pokemon4.text = pokemonNameList[partyDataList[indexPath.row][3]]
        }
        if partyDataList[indexPath.row][4] != -1 {
            pokepacell.pokemon5.text = pokemonNameList[partyDataList[indexPath.row][4]]
        }
        if partyDataList[indexPath.row][5] != -1 {
            pokepacell.pokemon6.text = pokemonNameList[partyDataList[indexPath.row][5]]
        }
        return pokepacell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "partySegue" {
            if let selectedRow = pokepaList.indexPathForSelectedRow {
                let controller = segue.destination as! PokemonPartyDetailViewController
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
