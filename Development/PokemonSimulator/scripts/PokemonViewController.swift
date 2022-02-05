//
//  PokemonViewController.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/11/03.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PokemonViewController: UIViewController, UITableViewDataSource, GADBannerViewDelegate {
       @IBOutlet weak var pokelist: UITableView!
       override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...pokemonNameList.count-1 {
            print("ポケモン情報",pokemonNameList[i],pokemonDataList[i])
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
        
        
        
        
        pokelist.dataSource = self
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemonNameList.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let pokecell: PokemonCustomTableViewCell! =
                tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonCustomTableViewCell
            let pokemonName = pokemonNameList[indexPath.row]
             var item = pokemonDataList[indexPath.row][13]
            if item == 10 {
                item = 9
            }
            
            let pokemonItem = safeCallArray(itemList, item)
            pokecell.textLabel?.text = pokemonName
            pokecell.type1.text = typeList[pokemonDataList[indexPath.row][1]]
            pokecell.type1.backgroundColor = colorList[pokemonDataList[indexPath.row][1]]
            if pokemonDataList[indexPath.row][2] != -1 {
            pokecell.type2.text = typeList[pokemonDataList[indexPath.row][2]]
            pokecell.type2.backgroundColor = colorList[pokemonDataList[indexPath.row][2]]
            }
            pokecell.item.text = pokemonItem
            pokecell.score.text = "P:\(pokemonScoreList[indexPath.row][0])"
            if pokemonScoreList[indexPath.row][2] == 0 {
                pokecell.score.backgroundColor = UIColor.red
            } else {
                pokecell.score.backgroundColor = UIColor.white
            }
            let formStr = reviseForm(pokemonScoreList[indexPath.row][1])
            pokecell.form.text = formStr
            return pokecell
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonSegue" {
            if let selectedRow = pokelist.indexPathForSelectedRow {
            let controller = segue.destination as! PokemonDetailViewController
            controller.info = selectedRow.row
            }
    }
    }
        // Do any additional setup after loading the view.

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
