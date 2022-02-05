//
//  TutorialViewController.swift
//  Logicard
//
//  Created by 森居麗 on 2018/09/06.
//  Copyright © 2018年 森居麗. All rights reserved.
import UIKit
import Gecco
import Spring
class TutorialViewController: SpotlightViewController {
    @IBOutlet var tutotialView: [UIView]!
    @IBOutlet weak var numberView: SpringView!
    
    var stepIndex: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        numberView.isHidden = true
        delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func next(_ labelAnimated: Bool) {
        
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            print("0")
            spotlightView.appear(Spotlight.Oval(center: CGPoint(x: screenSize.width - 26, y: 42), diameter: 50))
        case 1:
            print("1")
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 75, y: 42), diameter: 50))
        case 2:
            print("2")
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: 42), size: CGSize(width: 120, height: 40), cornerRadius: 6), moveType: .disappear)
        case 3:
            print("3")
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width / 2, y: 200), diameter: 220), moveType: .disappear)
        case 4:
            print("4")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    func updateAnnotationView(_ animated: Bool) {
        tutotialView.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
            
        }
             print("naze")
    }
}
extension TutorialViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
        print("pre")
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
        print("tap")
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
        print("dis")
    }
}
