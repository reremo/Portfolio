//
//  HelpViewController.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/27.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBAction func languageChange(_ sender: Any) {
        Changelanguage = true
    }
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var text2: UITextView!
    @IBOutlet weak var text3: UITextView!
    @IBOutlet weak var q1: UILabel!
    @IBOutlet weak var q2: UILabel!
    @IBOutlet weak var q3: UILabel!
    @IBOutlet weak var q4: UILabel!
    @IBOutlet weak var q5: UILabel!
    @IBOutlet weak var q6: UILabel!
    @IBOutlet weak var q7: UILabel!
    @IBOutlet weak var q8: UILabel!
    @IBOutlet weak var q9: UILabel!
    @IBOutlet weak var q10: UILabel!
    @IBOutlet weak var q11: UILabel!
    @IBOutlet weak var q12: UILabel!
    @IBOutlet weak var q13: UILabel!
    @IBOutlet weak var q14: UILabel!
    @IBOutlet weak var q15: UILabel!
    @IBOutlet weak var q16: UILabel!
    @IBOutlet weak var q17: UILabel!
    @IBOutlet weak var q18: UILabel!
    @IBOutlet weak var q19: UILabel!
    @IBOutlet weak var q20: UILabel!
    @IBOutlet weak var q21: UILabel!
    
    override func viewDidLoad() {
        if language == "japanese" {
            close.setTitle("閉じる", for: .normal)
            languageButton.setTitle("言語", for: .normal)
            text1.text = "1. 内容\nこのゲームは20枚の数字カードと21枚の質問カードを使って遊びます。"
            q1.text = "奇数は何枚？"
            q2.text = "偶数は何枚？"
            q3.text = "連番はどこ？"
            q4.text = "０はどこ？"
            q5.text = "５はどこ？"
            q6.text = "１や２はどこ？"
            q7.text = "３や４はどこ？"
            q8.text = "６や７はどこ？"
            q9.text = "８や９はどこ？"
            q10.text = "真ん中３枚の合計は？"
            q11.text = "最初の３枚の合計は？"
            q12.text = "最後の３枚の合計は？"
            q13.text = "[C]最大と最小の差は？"
            q14.text = "[C]全てのカードの合計は？"
            q15.text = "[C]真ん中のカードは５以上？"
            q16.text = "赤は何枚？"
            q17.text = "青は何枚？"
            q18.text = "隣り合う同じ色はどこ？"
            q19.text = "赤の合計は？"
            q20.text = "青の合計は？"
            q21.text = "同じ数字は何組？"
            text2.text = "2. 準備\nはじめに、それぞれのプレイヤーに5枚ずつカードが配られ、2つのルールに従って並べられます。\n・左から小さいもん順\n・同じ数字がある場合は必ず赤が左"
            text3.text = "そして、6枚の質問カードが配られます。これらのカードは2人のプレイヤーで共有のカードです。\n\n3. ゲームの流れ\n毎ターン1枚の質問カードを使うことができます。そして、相手の手札を色、数字共に正確に予測できたならば、チャレンジをすることができます。そのチャレンジが成功すれば勝利！また、同じターンに質問カードを使ってチャレンジすることはできません。\n\n4. 詳細\n・[C]と書かれたカードは情報共有カードです。この質問カードを使うと、自分の答えも相手にバレてしまいます。慎重に使うタイミングを選びましょう。\n\n・「１や２はどこ？」のような質問カードでは、どちらか一方の数字を指定しなければなりません。\n\n・先手、後手は自動的に決められます。もし先手がチャレンジに成功したとしても、そのターンが終わるまで後手にもチャレンジするチャンスがあります。後手のチャレンジも成功すれば、勝負は引き分けに持ち込めます。\n\n・毎ターンの制限時間は1分です。(ただし先手の一番はじめのターンのみ1分半) 制限時間を過ぎたり、アプリを閉じたりした場合は敗北となります。\n\n・21枚の質問カードが全て使われるとお互いチャレンジしかできません。\n\n5. ヒント\n\n・5を除いて同じカードはありません。自分の手札も参考にして見ましょう。\n\n・もし知られたくない質問カードがあるなら、自分で先に使ってしまいましょう。\n\n・相手の質問した内容も見ることができます。\n\n・5は唯一の緑カードです。注意しましょう。\n\n・「連番はどこ？」のような質問の答えに注意しましょう。例えば、[1,2,6,7,9]と[1,2,3,4,6]はどのような答えが返ってくるでしょうか。"
        }
        super.viewDidLoad()

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
