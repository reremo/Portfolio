//
//  ResultViewController.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/20.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import LTMorphingLabel
import GoogleMobileAds
import Spring
import ACEDrawingView
import SceneKit
import Lottie
class ResultViewController: UIViewController,GADInterstitialDelegate {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var card1: UILabel!
    @IBOutlet weak var card2: UILabel!
    @IBOutlet weak var card3: UILabel!
    @IBOutlet weak var card4: UILabel!
    @IBOutlet weak var card5: UILabel!
    @IBOutlet weak var myRank: UILabel!
    @IBOutlet weak var myRate: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var gapLabel: UILabel!
    @IBOutlet weak var returnBu: UIButton!
    @IBOutlet weak var detailView: SpringView!
    @IBOutlet weak var memo: ACEDrawingView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var particleView: SCNView!
    @IBOutlet weak var opponentDeckLabel: UILabel!
    var isDraw = false
    @IBAction func detail(_ sender: UIButton) {
        detailView.animation = "zoomIn"
        detailView.animate()
        detailView.isHidden = false
    }
    @IBAction func close(_ sender: UIButton) {
        detailView.animation = "zoomOut"
        detailView.animate()
    }
    var time = 0
   
    @IBAction func returnButton(_ sender: UIButton) {
            self.performSegue(withIdentifier: "return", sender: self)
    }
    var interstitial:GADInterstitial!
    let AdMobID = "ca-app-pub-9204323547115751/1156340289"
    // Simulator ID
    let SIMULSTOR_ID = kGADSimulatorID
    
    // 実機テスト用 ID を入れる
    let DEVICE_TEST_ID = "aaaaaaaaaaaaaaaaa0123456789"
    
    
    let DeviceTest:Bool = false
    let SimulatorTest:Bool = true
    var timer : Timer!
    var timer2 : Timer!
    var isChangeRank = false
    
    
    
    
    override func viewDidLoad() {
        print("resultきた")
        detailView.isHidden = true
       interstitial = GADInterstitial(adUnitID: AdMobID)
        
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
        result.textColor = UIColor.black
        print(win,lose,isOpTimeUp,isTimeUp)
        memo.loadImage(memoImage)
        memo.lineWidth = 0
         if language == "japanese" {
            opponentDeckLabel.text = "相手の手札"
        }
        if (win && !lose) || (isOpTimeUp && !isTimeUp) {
            isWin = true
        result.text = "Win!"
            if language == "japanese" {
                result.text = "勝利!"
            }
            if isOpTimeUp && !isTimeUp {
                result.font = UIFont.systemFont(ofSize: 20)
                result.text = "Opoonent\ntime up"
                if language == "japanese" {
                    result.text = "相手の\n時間切れ"
                }
                 result.font = UIFont.systemFont(ofSize: 50)
            }
        }
        if (!win && lose) || isTimeUp  {
            result.text = "Lose..."
            if language == "japanese" {
                result.text = "敗北..."
            }
            if isTimeUp {
                  result.font = UIFont.systemFont(ofSize: 20)
                result.text = "Time up"
                if language == "japanese" {
                    result.text = "時間切れ"
                }
                result.font = UIFont.systemFont(ofSize: 50)
            }
            isWin = false
        }
        if win && lose {
              isWin = false
            result.text = "Draw"
            if language == "japanese" {
                result.text = "引き分け"
            }
            isDraw = true
        }
        myRank.text = "Rate:\(rankList[rank])"
        let rate1 = rate
        
        if rate1 == rankUpRateList[rank+1] && isWin {
            
            result.text = "Runk Up"
            if language == "japanese" {
                result.text = "ランクアップ"
            }
            result.textColor = UIColor.red
        
            throwConfetti("SceneKit Particle System.scnp")
        
            rank += 1
            
//            if rank <= 4 {
//
//                self.myRank.morphingEffect = .pixelate
//
//            } else if rank <= 9 {
//
//                self.myRank.morphingEffect = .sparkle
//            } else if rank <= 14 {
//                self.myRank.morphingEffect = .anvil
//            } else if rank <= 19 {
//                self.myRank.morphingEffect = .burn
//            }
            isChangeRank = true
        }
        if rate1 == rankUpRateList[rank] && rate1 != 0 && !isWin {
             throwConfetti("Rain.scnp")
            result.text = "Runk Down"
            if language == "japanese" {
                result.text = "ランクダウン"
            }
            result.textColor = UIColor.blue
            rank -= 1
       //     myRank.morphingEffect = .fall
            isChangeRank = true
        }
        if !isDraw {
        rateCal()
        }
         print(rate)
        myRate.text = "\(rate)"
        myRank.text = "\(rankList[rank])"
        
        gapLabel.text = "\(rate-rate1)"
        if rate-rate1 >= 0 {
            gapLabel.text = "+\(rate-rate1)"
        }
        nextLabel.text = "Next:\(rankUpRateList[rank+1] - rate)"
        if rankUpRateList[rank+1] - rate == 0 && isWin {
            nextLabel.text = "Next: Rank Up Battle!"
            if language == "japanese" {
                nextLabel.text = "次回: ランクアップ戦!"
            }
        } else if rankUpRateList[rank+1] - rate == 0 && !isWin && rate != 0 {
            nextLabel.text = "Next: Rank Down Battle..."
            if language == "japanese" {
                nextLabel.text = "次回: ランクダウン戦..."
            }
        }
        if isChangeRank {
      // timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        }
        
        super.viewDidLoad()
        func upDateLabel(_ label : UILabel, _ order : Int) {
            label.text = "\(yourDeck[order].number)"
            switch yourDeck[order].color {
            case 0:
                label.backgroundColor = UIColor.red
            case 1:
                label.backgroundColor = UIColor.blue
            case 2:
                label.backgroundColor = UIColor.green
            default:
                break
            }
        }
        upDateLabel(card1, 0)
        upDateLabel(card2, 1)
        upDateLabel(card3, 2)
        upDateLabel(card4, 3)
        upDateLabel(card5, 4)
        returnBu.isHidden = true
        detailButton.isHidden = true
        visitCount += 1
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAd), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
  //  @objc func updateElapsedTime() {
   //    myRank.text = rankList[rank]
    //}
    @objc func updateAd() {
        if time == 0 {
            if visitCount % 2 == 1 {
        self.showAdMob(interstitial: interstitial)
            }
        }
        if time == 2 {
           returnBu.isHidden = false
            detailButton.isHidden = false
        }
        time += 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAdMob(interstitial: GADInterstitial){
        if (interstitial.isReady)
        {
            interstitial.present(fromRootViewController: self)
        }
    }
    private func throwConfetti(_ name: String) {
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: -6, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        let confetti = SCNParticleSystem(named: name, inDirectory: "")!
        scene.rootNode.addParticleSystem(confetti)
        
        particleView.scene = scene
        particleView.backgroundColor = UIColor.clear
        particleView.autoenablesDefaultLighting = true
        particleView.isUserInteractionEnabled = false
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
