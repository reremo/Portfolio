//
//  AppDelegate.swift
//  pokemonsimulator
//
//  Created by 森居麗 on 2017/10/29.
//  Copyright © 2017年 森居麗. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity
import GoogleMobileAds
import Firebase
import GameKit
var generalSession : MCSession!
var generalMatch : GKMatch!
let typeList = ["あく","いわ","エスパー","かくとう","くさ","こおり","ゴースト","じめん","でんき","どく","ドラゴン","ノーマル","はがね","ひこう","フェアリー","ほのお","みず","むし"]
let typeList2 = ["あく","いわ","エスパー","かくとう","くさ","こおり","ゴースト","じめん","でんき","どく","ドラゴン","ノーマル","はがね","ひこう","フェアリー","ほのお","みず","むし","-"] //pokemonType2で使用
var subList = ["-","やけどにする","まひにする","こおりにする","どくにする","もうどくにする","ねむりにする","自分の攻撃をあげる","自分の攻撃をぐーんとあげる","自分の防御をあげる","自分の防御をぐーんとあげる","自分の特攻をあげる","自分の特攻をぐーんとあげる","自分の特防をあげる","自分の特防をぐーんとあげる","自分の素早さをあげる","自分の素早さをぐーんとあげる","自分の攻撃と防御をあげる","自分の攻撃と素早さをあげる","自分の特攻と特防をあげる","自分の防御と特防をあげる","自分の攻撃と防御を下げる","自分の防御と特防を下げる","自分の攻撃をがくっと下げる","自分の特攻をがくっと下げる","自分の素早さを下げる","相手の攻撃を下げる","相手の攻撃をがくっと下げる","相手の防御を下げる","相手の防御をがくっと下げる","相手の特攻を下げる","相手の特攻をがくっと下げる","相手の特防を下げる","相手の特防をがくっと下げる","相手の素早さを下げる","相手の素早さをがくっと下げる"]
var weaponP = [0,135,122,300,100,122,233,60,100,60,100,60,100,60,100,60,100,100,100,100,100,-23,-23,-23,-23,-13,60,100,60,100,60,100,60,100,60,100]
var statusGradeList =
[[1,0,0,0,0], //7  0
[2,0,0,0,0],
[0,1,0,0,0],
[0,2,0,0,0],
[0,0,1,0,0],
[0,0,2,0,0],
[0,0,0,1,0],
[0,0,0,2,0],
[0,0,0,0,1],
[0,0,0,0,2],
[1,1,0,0,0],
[1,0,0,0,1],
[0,0,1,1,0],
[0,1,0,1,0],
[-1,-1,0,0,0],
[-2,0,0,0,0],
[0,0,-2,0,0],
[0,0,0,0,-1],
[-1,0,0,0,0], //26  19
[-2,0,0,0,0],
[0,-1,0,0,0],
[0,-2,0,0,0],
[0,0,-1,0,0],
[0,0,-2,0,0],
[0,0,0,-1,0],
[0,0,0,-2,0],
[0,0,0,0,0-1],
[0,0,0,0,0-2], //35   28
]
let transeparent = UIColor.init(red: 42/255, green: 57/255, blue: 65/255, alpha: 0/255)
let aku = UIColor.init(red: 42/255, green: 57/255, blue: 65/255, alpha: 255/255)
let iwa = UIColor.init(red: 188/255, green: 121/255, blue: 67/255, alpha: 255/255)
let esupa = UIColor.init(red: 219/255, green: 96/255, blue: 198/255, alpha: 255/255)
let kakutou = UIColor.init(red: 177/255, green: 69/255, blue: 44/255, alpha: 255/255)
let kusa = UIColor.init(red: 22/255, green: 186/255, blue: 73/255, alpha: 255/255)
let kori = UIColor.init(red: 95/255, green: 255/255, blue: 255/255, alpha: 255/255)
let gosuto = UIColor.init(red: 71/255, green: 54/255, blue: 123/255, alpha: 255/255)
let jimen = UIColor.init(red: 255/255, green: 209/255, blue: 3/255, alpha: 255/255)
let denki = UIColor.init(red: 243/255, green: 233/255, blue: 46/255, alpha: 255/255)
let doku = UIColor.init(red: 180/255, green: 96/255, blue: 155/255, alpha: 255/255)
let doragon = UIColor.init(red: 76/255, green: 104/255, blue: 255/255, alpha: 255/255)
let normal = UIColor.init(red: 219/255, green: 194/255, blue: 175/255, alpha: 255/255)
let hagane = UIColor.init(red: 97/255, green: 97/255, blue: 105/255, alpha: 255/255)
let hikou = UIColor.init(red: 23/255, green: 222/255, blue: 254/255, alpha: 255/255)
let huxeari = UIColor.init(red: 255/255, green: 130/255, blue: 175/255, alpha: 255/255)
let honoo = UIColor.init(red: 255/255, green: 2/255, blue: 31/255, alpha: 255/255)
let mizu = UIColor.init(red: 128/255, green: 174/255, blue: 236/255, alpha: 255/255)
let musi = UIColor.init(red: 142/255, green: 162/255, blue: 81/255, alpha: 255/255)
let nasi = UIColor.init(red: 219/255, green: 194/255, blue: 175/255, alpha: 255/255)
var colorList = [aku,iwa,esupa,kakutou,kusa,kori,gosuto,jimen,denki,doku,doragon,normal,hagane,hikou,huxeari,honoo,mizu,musi]
var compatibilityDataList: [[Double]] =
[[0.5,1,2,0.5,1,1,2,1,1,1,1,1,1,1,0.5,1,1,1,1]
,[1,1,1,0.5,1,2,1,0.5,1,1,1,1,0.5,2,1,2,1,2,1]
,[0,1,0.5,2,1,1,1,1,1,2,1,1,0.5,1,1,1,1,1,1]
,[2,2,0.5,1,1,2,0,1,1,0.5,1,2,2,0.5,0.5,1,1,10.5,1]
,[1,2,1,1,0.5,1,1,2,1,0.5,0.5,1,0.5,0.5,1,0.5,2,0.5,1]
,[1,1,1,1,2,0.5,1,2,1,1,2,1,0.5,2,1,0.5,0.5,1,1]
,[0.5,1,2,1,1,1,2,1,1,1,1,0,1,1,1,1,1,1,1]
,[1,2,1,1,0.5,1,1,1,2,2,1,1,2,0,1,2,1,0.5,1]
,[1,1,1,1,0.5,1,1,0,0.5,1,0.5,1,1,2,1,1,2,1,1]
,[1,0.5,1,1,2,1,0.5,0.5,1,0.5,1,1,0,1,2,1,1,1,1]
,[1,1,1,1,1,1,1,1,1,1,2,1,0.5,1,0,1,1,1,1]
,[1,0.5,1,1,1,1,0,1,1,1,1,1,0.5,1,1,1,1,1,1]
,[1,2,1,1,1,2,1,1,0.5,1,1,1,0.5,1,2,0.5,0.5,1,1]
,[1,0.5,1,2,2,1,1,1,0.5,1,1,1,0.5,1,1,1,1,2,1]
,[2,1,1,2,1,1,1,1,1,0.5,2,1,0.5,1,1,0.5,1,1,1]
,[1,0.5,1,1,2,2,1,1,1,1,0.5,1,2,1,1,0.5,0.5,2,1]
,[1,2,1,1,0.5,1,1,2,1,1,0.5,1,1,1,1,2,0.5,1,1]
,[2,1,2,0.5,2,1,0.5,1,1,0.5,1,1,0.5,0.5,0.5,0.5,1,1,1]]
//let typeList2 =  ["あく","いわ","エスパー","かくとう","くさ","こおり","ゴースト","じめん","でんき","どく","ドラゴン","ノーマル","はがね","ひこう","フェアリー","ほのお","みず","むし","なし"]
let genderList = ["オス","メス","不明"]
let PSList = ["物理","特殊"]


// ゴツメはまだきついvar itemList = ["-","こだわりスカーフ","こだわりメガネ","こだわりハチマキ","いのちのたま","きあいのタスキ","オボンのみ","とつげきチョッキ","たべのこし","ゴツゴツメット","たつじんのおび"]
var itemList = ["-","こだわりスカーフ","こだわりメガネ","こだわりハチマキ","いのちのたま","きあいのタスキ","オボンのみ","とつげきチョッキ","たべのこし","たつじんのおび"]
var ailmentList = ["","やけど","まひ","こおり","どく","もうどく","ねむり"]
var choice = false // こだわっているか否か
var choiceNumber = 0
var isResponsible = false // 計算を行うプレイヤーか否か
var buildCount = Int()
var isGKMatch = false
var recievingCount = 0
var isDecide = false
var numberForDecide = 0
let userDefaults = UserDefaults.standard




var callSelfCount = 0
var infoWeapon = 0
var infoPokemon = 0
var infoParty = 0
var battleLog = ""
var resultBattleLog = ""
var myHPRate:Float = 1.0
var rivalHPRate:Float = 1.0
var waiting = false
var rivalWaiting = false
var myWeaponNumber = Int() //
var rivalWeaponNumber = Int()
var battleRow = 0 //バトルに選択されたパーティー番号
var recievedData = [Int]()// PokemonSelectViewControllerのsessionで使用

var pokemonNameList = [String]()
var pokemonDataList = [[Int]]()// [gender,type,type2,H,A,B,C,D,S,weapon1,weapon2,weapon3,weapon4,item,0]
var usePokemonNumberList = [Int]() // 削除できないリスト
var myBattlePokemonDataList = [[Int]]()

var weaponNameList = [String]()
var weaponDataList = [[Int]]()// [power,rate,type,nature]
var useWeaponNumberList = [Int]()
var partyNameList = [String]() // pokemon名前を管理
var partyDataList = [[Int]]() // pokemon番号を管理

var selectedPartyData = [Int]()//　
var myBattlePartyData = [Int]() //
var rivalBattlePartyData = [Int]()

var myPartyNameList = [String]() // バトル中の名前リストを管理
var rivalPartyNameList = [String]() // バトル中の相手の名前リストを管理
var myWeaponNameList = [String]()
var myPartyWeaponNameList = [String]()
var rivalWeaponNameList = [String]()
var rivalPartyWeaponNameList = [String]()
var myBattlingPokemonName = String() // 戦闘中のポケモンの名前
var myBattlingPokemonNumber = 0 //　myBattlePartyDataの何番目が戦闘中か
var myWaitingPokemon1Number = 1
var myWaitingPokemon2Number = 2
var rivalBattlingPokemonNumber = 0
var oldMyBattlingPokemonNumber = 0 // viewloadの問題解決用
var isFromChanging = false
var isFromChangingDying = false
var draw = false // 共倒れ
var myHPList = [Int]()//バトル中の味方三体のHP管理
var myOriginHPList = [Int]()
var rivalHPList = [Int]()//バトル中の相手三体のHP管理
var rivalOriginHPList = [Int]()
var myCurrentHP = Int() //戦闘中のHPを管理
var rivalCurrentHP = Int() //
var myStatusData = [6,6,6,6,6] //戦闘中の能力変化を管理
var rivalStatusData = [6,6,6,6,6]
var myAilmentList = [0,0,0] // 戦闘中の状態異常リストを管理
var rivalAilmentList = [0,0,0]
var mySleepingCountList = [0,0,0] //眠りターン数管理
var rivalSleepingCountList = [0,0,0]
var myPoisonCount = 0// 猛毒の管理
var rivalPoisonCount = 0
var myAttackDamage = 0 //自分の与えるダメージ
var rivalAttackDamage = 0 //自分が受けるダメージ
var myBattleData = [Int]()
//たたかう送信データ
//  [gender,type,type2,H,A,B,C,D,S,power,rate,type,nature,myBattlingNumber,myWeaponNumber,item,ailment,subRate,sub,-2]0は数調節
//[gender,type,type2,H,A,B,C,D,S,W1,W2,W3,W4,myWaitingpokemonNumber,myBattlingNumber,item,ailment,-3]
var rivalBattleData = [Int]()//たたかう受信データ[0gender,1type,2type2,3H,4A,5B,6C,7D,8S,9power,10rate,11type,12nature,13-2]
var resultData = [Int]()//[situation]
var myTypeData = [Int]()
var rivalTypeData = [Int]()
var weaponScoreList = [Int]()
var pokemonScoreList = [[Int]]()
var partyScoreList = [[Int]]()
var battleTimer = 0
var timeUpWin = false
var timeUpLose = false
var disconnectWin = false
var disconnectLose = false


//素早さ判定
func speedJudging(_ myS: Int,_ rivalS: Int,_ myItem: Int,_ rivalItem: Int,_ myAilment: Int,_ rivalAilment: Int) -> Int {
    var judge = 0
    var myResultS = 0
    var rivalResultS = 0
    let myStatusS = returnRate(myStatusData)[4]
    let rivalStatusS = returnRate(rivalStatusData)[4]
    if myItem == 1 {
        myResultS = Int(1.5*Double(myS)) //こだわりスカーフ
    } else {
        myResultS = myS
    }
    if rivalItem == 1 {
        rivalResultS = Int(1.5*Double(rivalS))
    } else {
        rivalResultS = rivalS
    }
    if myAilment == 2 {//麻痺なら
        myResultS = Int(0.5*Double(myS))
    }
    if rivalAilment == 1 {
        rivalResultS = Int(0.5*Double(rivalS))
    }
    myResultS = Int(Double(myResultS)*myStatusS)
    rivalResultS = Int(Double(rivalResultS)*rivalStatusS)
    if myResultS > rivalResultS {
        judge = 0
    } else if myResultS < rivalResultS {
        judge = 1
    } else if myResultS == rivalResultS {
        judge = Int(arc4random_uniform(2))
    }
    print("callSppedJudging",judge,myResultS,rivalResultS)
    return judge
}
func calculating(_ attack: Int ,_ defence: Int,_ power: Int,_ rate: Int,_ compatibility: Double,_ mainTypeRate: Double,_ attackItemEffect: Double,_ defenceItemEffect: Double,_ isBurn: Double,_ attackRate: Double,_ defenceRate: Double)->[Int] {
    let randomNumber1 = Double(85 + Int(arc4random_uniform(16)))/100.0
    let randomNumber2 = Int(arc4random_uniform(100))
    let randomNumber3 = Int(arc4random_uniform(10000))
    var isHit = 0 //hit
    var hitRate = 1.0
    var isCritical = 1
    var criticalRate = 1.0
    let burn = isBurn
    var damage = 0
    if randomNumber2 < rate {
        isHit = 0
    } else {
        isHit = 1
        hitRate = 0
    }
    if randomNumber3 < 675 {
        isCritical = 0
        criticalRate = 1.5
    } else {
        isCritical = 1
    }
    let finalPower = Double(power)
    let finalAttack = Double(attack)*attackItemEffect*burn*attackRate
    let finalDefence = Double(defence)*defenceItemEffect*defenceRate

    damage = Int(hitRate*Double(Int(Double(Int(22.0*finalPower*finalAttack/finalDefence))/50.0+2.0))*criticalRate*randomNumber1*mainTypeRate*compatibility)
    if power == 0 {
        damage = 0
    }
    return [damage, isHit, isCritical]
}

func damagecalculating(_ AttackData: [Int],_ DefenceData: [Int]) -> [Int]{
   var damage = 0
    var isHit = 0
    var isCritical = 0
    var isBurn = 1.0
    var isPararized = 0 //痺れると１
    var isSleeping = 0 //寝てると１
    var isFreezing = 0 //溶けると１、凍っていると２
    var isSub = 1 //0だとサブが発動
    var attackStatus = [6,6,6,6,6]
    var defenceStatus = [6,6,6,6,6]
    for i in 0...4 {
        attackStatus[i] = AttackData[19+i]
        defenceStatus[i] = DefenceData[19+1]
    }
    let attackStatusRate = returnRate(attackStatus)
    let defenceStatusRate = returnRate(defenceStatus)
    if AttackData[16] == 1 && AttackData[12] == 0 {//やけど＆物理
        isBurn = 0.5
    }
    if AttackData[16] == 2 {//麻痺なら
        if Int(arc4random_uniform(4)) == 0 {
            isPararized = 1
        }
    }
    if AttackData[16] == 6 {
        isSleeping = 1
    }
    if AttackData[16] == 3 {
        isFreezing = 2
        if Int(arc4random_uniform(4)) == 0 {
            isFreezing = 1
        }
    }
   let compatibility = typeCompatibility(AttackData[11], DefenceData[1], DefenceData[2])
    var mainTypeRate = 1.0
    if AttackData[1] == AttackData[11] || AttackData[2] == AttackData[11] {
        mainTypeRate = 1.5
    }
    var attackItemEffect = 1.0
    if AttackData[15] == 4 { // いのちのたま
        attackItemEffect = 1.3 //厳密にはちゃう
    }
    if AttackData[15] == 10 { //達人
        if compatibility > 1 {
            attackItemEffect = 1.2
        }
    }
    var defenceItemEffect = 1.0
    var compatibilityValue = 0
    if AttackData[12] == 0 { //物理
        if AttackData[15] == 3 { //こだわりハチマキ
            attackItemEffect = 1.5
        }
        var result = calculating(AttackData[4], DefenceData[5], AttackData[9], AttackData[10], compatibility, mainTypeRate, attackItemEffect, defenceItemEffect,isBurn, attackStatusRate[0], defenceStatusRate[1])
        damage = result[0]
        isHit = result[1]
        isCritical = result[2]
        
    } else { //特殊
        if AttackData[15] == 2 { //メガネ
            attackItemEffect = 1.5
        }
        if DefenceData[15] == 7 { //チョッキ
            defenceItemEffect = 1.5
        }
        var result = calculating(AttackData[6], DefenceData[7], AttackData[9], AttackData[10], compatibility, mainTypeRate, attackItemEffect, defenceItemEffect,isBurn, attackStatusRate[2], defenceStatusRate[3])
        damage = result[0]
        isHit = result[1]
        isCritical = result[2]
        if isPararized == 1 {
            damage = 0
        }
    }
    if isPararized == 1 {
        damage = 0
    }
    if isSleeping == 1 {
        damage = 0
    }
    if isFreezing == 2 {
        damage = 0
    }
    let randomNumber = Int(arc4random_uniform(100))
    if randomNumber < AttackData[17] && isHit == 0 && DefenceData[16] == 0 && compatibility != 0 && isPararized != 1 && isSleeping != 1 && isFreezing != 2 {
        isSub = 0
    }
    if compatibility == 0 {
        compatibilityValue = 0
    } else if compatibility < 1 {
        compatibilityValue = 1
    } else if compatibility == 1 {
        compatibilityValue = 2
    } else if compatibility > 1 {
        compatibilityValue = 3
    }
    return [damage,isHit,isCritical,compatibilityValue,isSub,isPararized,isFreezing]
}
func returnRate(_ rank:[Int])->[Double]{
    var rate = [1.0,1.0,1.0,1.0,1.0]
    for i in 0...4 {
        switch rank[i] {
        case 0: rate[i] = 2/8
            case 0: rate[i] = 2/8
            case 1: rate[i] = 2/7
            case 2: rate[i] = 2/6
            case 3: rate[i] = 2/5
            case 4: rate[i] = 2/4
            case 5: rate[i] = 2/3
            case 6: rate[i] = 2/2
            case 7: rate[i] = 3/2
            case 8: rate[i] = 4/2
            case 9: rate[i] = 5/2
            case 10: rate[i] = 6/2
            case 11: rate[i] = 7/2
            case 12: rate[i] = 8/2
        default: break
        }
    }
    return rate
}


func typeCompatibility(_ attackType: Int,_ defenceType1: Int,_ defenceType2: Int) -> Double {
    var defenceType3 = 0
    if defenceType2 == -1 {
        defenceType3 = 18
    } else {
        defenceType3 = defenceType2
    }
    let compatibility = compatibilityDataList[attackType][defenceType1]*compatibilityDataList[attackType][defenceType3]
    return compatibility
}





func battleSystem(_ Data1:[Int],_ Data2:[Int]) -> [Int]{
    //[0      1    2     3 4 5 6 7 8 9  10 11 12 13    14    15 16  17      18  19 20 21 22 23 24]
    //[gender,type,type2,H,A,B,C,D,S,po,ra,ty,na,myBaN,myWeN,it,ail,subRate,sub,SA,SB,SC,SD,SS,-2]
   // [gender,type,type2,H,A,B,C,D,S,W1,W2,W3,W4,myWaN,myBaN,it,ail,oriIt,oriAi,SA,SB,SC,SD,SS,-3]
    var myData = Data1
    var rivalData = Data2
    var isFirst = 0
    var situationNumber = 0
    var originMyBattlingPokemonNumber = 0
    var originRivalBattlingPokemonNumber = 0
    var myAttackIsHit = 0
    var myAttackIsCritical = 0
    var rivalAttackIsHit = 0
    var rivalAttackIsCritical = 0
    var myCompatibilityValue = 0
    var rivalComtibilityValue = 0
    let myItem = myData[15]
    let rivalItem = rivalData[15]
    var mySub = 1 //サブ効果が発動したら０
    var rivalSub = 1
    var myAilment = myData[16]
    var rivalAilment = rivalData[16]
    var myLifeOrbDamage = 0
    var rivalLifeOrbDamage = 0
    var mySash = 0 //襷が発動すれば1
    var rivalSash = 0
    var myObonHeal = 0
    var rivalObonHeal = 0
    var myLeftoversHeal = 0 //食べ残し
    var rivalLeftoversHeal = 0
    var myPRA = 0 //痺れが発動したら１
    var rivalPRA = 0
    var myWakeUp = 0//起きたら１、まだ寝て居たら２
    var rivalWakeUp = 0
    var myMelt = 0 //溶けたら１凍っていれば２
    var rivalMelt = 0
    var myBurnDamage = 0 //やけどダメージ
    var rivalBurnDamage = 0
    var myPoisonDamage = 0 //毒ダメージ
    var rivalPoisonDamage = 0
    var myDoAttack = 0//攻撃が発動１
    var rivalDoAttack = 0
    let myOriginHP = myOriginHPList[myData[13]]
    let rivalOriginHP = rivalOriginHPList[rivalData[13]]
    var myResultHP = 0
    var rivalResultHP = 0
    var myStatusA = 0
    var myStatusB = 0
    var myStatusC = 0
    var myStatusD = 0
    var myStatusS = 0
    var rivalStatusA = 0
    var rivalStatusB = 0
    var rivalStatusC = 0
    var rivalStatusD = 0
    var rivalStatusS = 0
    var mySubMassage = 0
    var rivalSubMassage = 0
    myAttackDamage = 0
    rivalAttackDamage = 0
  //  myCurrentHP = myHPList[myBattlingPokemonNumber]
  //  rivalCurrentHP = rivalHPList[rivalBattlingPokemonNumber]
    myCurrentHP = myData[3]
    rivalCurrentHP = rivalData[3]
    myResultHP = myCurrentHP
    rivalResultHP = rivalCurrentHP
    func checkDamage(_ resultHP: Int,_ damage: Int)->Int {
        if resultHP < damage {
            return resultHP
        }
        return damage
    }
    func checkSash(_ MorR: String) -> Int {
        if MorR == "M" {
            if myItem == 5 && myResultHP == myOriginHPList[myData[13]] && rivalAttackDamage >= myResultHP {
                mySash = 1
                return rivalAttackDamage-1
            } else {
                return rivalAttackDamage
            }
            } else {
            if rivalItem == 5 && rivalResultHP == rivalOriginHPList[rivalData[13]] && myAttackDamage >= rivalResultHP {
                rivalSash = 1
                return myAttackDamage-1
            } else {
                return myAttackDamage
            }
        }
    }
  
    if myData.last! == -3 && rivalData.last! == -3 {//両者交代
        situationNumber = 0
        myPoisonCount = 0
        rivalPoisonCount = 0
        isFirst = speedJudging(myData[8], rivalData[8], myData[17], rivalData[17], myData[18], rivalData[18])
        
        originMyBattlingPokemonNumber = myData[14]
        originRivalBattlingPokemonNumber = rivalData[14]
        
    } else if myData.last! == -3 && rivalData.last! == -2 {//自分だけ交代
        situationNumber = 1
        isFirst = 0
        myPoisonCount = 0
        if rivalSleepingCountList[rivalBattlingPokemonNumber] > 0 {//睡眠処理
            rivalSleepingCountList[rivalBattlingPokemonNumber] -= 1
            if rivalSleepingCountList[rivalBattlingPokemonNumber] == 0 {
                rivalWakeUp = 1
                rivalAilmentList[rivalBattlingPokemonNumber] = 0
                rivalData[16] = 0
            } else {
                rivalWakeUp = 2
            }
        }
        var rivalResult = damagecalculating(rivalData, myData) // [damage,isHit,isCritical,compatibilityValue,isSub,isPararaized,isFreezing]
        rivalAttackDamage = rivalResult[0]
        rivalAttackDamage = checkDamage(myResultHP, rivalAttackDamage)
        rivalAttackDamage = checkSash("M")
        myResultHP -= rivalAttackDamage
        rivalAttackIsHit = rivalResult[1]
        rivalAttackIsCritical = rivalResult[2]
        rivalComtibilityValue = rivalResult[3]
        rivalSub = rivalResult[4]
        if rivalSub == 0 {
            rivalSubMassage = rivalData[18]
        }
        if rivalSub == 0 && rivalData[18] < 7 && rivalData[18] > 0 {
            myData[16] = rivalData[18]
            myAilmentList[myBattlingPokemonNumber] = myData[16]
            if myData[16] == 6 {
                mySleepingCountList[myBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
            }
        } else if rivalSub == 0 && rivalData[18] > 6 && rivalData[18] < 26 {
            rivalStatusA = statusGradeList[rivalData[18]-7][0]
            rivalStatusB = statusGradeList[rivalData[18]-7][1]
            rivalStatusC = statusGradeList[rivalData[18]-7][2]
            rivalStatusA = statusGradeList[rivalData[18]-7][3]
            rivalStatusA = statusGradeList[rivalData[18]-7][4]
            rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
            for i in 0...4 {
                if rivalStatusData[i] > 12 {
                    rivalStatusData[i] = 12
                }
                if rivalStatusData[i] < 0 {
                    rivalStatusData[i] = 0
                }
                rivalData[i+19] = rivalStatusData[i]
            }
        } else if rivalSub == 0 && rivalData[18] > 25 && rivalData[18] < 36 {
            myStatusA = statusGradeList[rivalData[18]-7][0]
            myStatusB = statusGradeList[rivalData[18]-7][1]
            myStatusC = statusGradeList[rivalData[18]-7][2]
            myStatusD = statusGradeList[rivalData[18]-7][3]
            myStatusS = statusGradeList[rivalData[18]-7][4]
            myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
            for i in 0...4 {
                if myStatusData[i] > 12 {
                    myStatusData[i] = 12
                }
                if myStatusData[i] < 0 {
                    myStatusData[i] = 0
                }
                myData[i+19] = myStatusData[i]
            }
        }
        rivalPRA = rivalResult[5]
        rivalMelt = rivalResult[6]
        if rivalMelt == 1 {
            rivalData[16] = 0
            rivalAilmentList[rivalBattlingPokemonNumber] = 0
        }
        rivalWeaponNumber = rivalData[14]
        if myItem == 6 && myResultHP > 0 && myResultHP <= myOriginHPList[myData[13]]/2 {//オボン
            myObonHeal = myOriginHPList[myData[13]]/4
            myResultHP += myObonHeal
        }
        if rivalItem == 4 && rivalAttackIsHit == 0 && rivalComtibilityValue != 0 && rivalAttackDamage != 0 {//いのちのたま
            rivalLifeOrbDamage = Int(Double(rivalOriginHPList[rivalBattlingPokemonNumber])/10.0)
            rivalLifeOrbDamage = checkDamage(rivalResultHP, rivalLifeOrbDamage)
            rivalResultHP -= rivalLifeOrbDamage
        }
        originMyBattlingPokemonNumber = myData[14]
    } else if myData.last! == -2 && rivalData.last! == -3 {//相手だけ交代
        situationNumber = 2
        isFirst = 1
       rivalPoisonCount = 0
        if mySleepingCountList[myBattlingPokemonNumber] > 0 {//睡眠処理
            mySleepingCountList[myBattlingPokemonNumber] -= 1
            if mySleepingCountList[myBattlingPokemonNumber] == 0 {
                myWakeUp = 1
                myAilmentList[myBattlingPokemonNumber] = 0
                   myData[16] = 0
            } else {
                myWakeUp = 2
            }
        }
        var myResult = damagecalculating(myData, rivalData)
        myAttackDamage = myResult[0]
        myAttackDamage = checkDamage(rivalResultHP, myAttackDamage)
        myAttackDamage = checkSash("R")
        rivalResultHP -= myAttackDamage
        myAttackIsHit = myResult[1]
        myAttackIsCritical = myResult[2]
        myCompatibilityValue = myResult[3]
        mySub = myResult[4]
        if mySub == 0 {
            mySubMassage = myData[18]
        }
        if mySub == 0 && myData[18] < 7 && myData[18] > 0 {
            rivalData[16] = myData[18]
            rivalAilmentList[rivalBattlingPokemonNumber] = rivalData[16]
            if rivalData[16] == 6 {
                rivalSleepingCountList[rivalBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
            }
        } else if mySub == 0 && myData[18] > 6 && myData[18] < 26 {
            myStatusA = statusGradeList[rivalData[18]-7][0]
            myStatusB = statusGradeList[rivalData[18]-7][1]
            myStatusC = statusGradeList[rivalData[18]-7][2]
            myStatusD = statusGradeList[rivalData[18]-7][3]
            myStatusS = statusGradeList[rivalData[18]-7][4]
            myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
            for i in 0...4 {
                if myStatusData[i] > 12 {
                    myStatusData[i] = 12
                }
                if myStatusData[i] < 0 {
                    myStatusData[i] = 0
                }
                myData[i+19] = myStatusData[i]
            }
        } else if mySub == 0 && myData[18] > 25 && myData[18] < 36 {
            rivalStatusA = statusGradeList[rivalData[18]-7][0]
            rivalStatusB = statusGradeList[rivalData[18]-7][1]
            rivalStatusC = statusGradeList[rivalData[18]-7][2]
            rivalStatusA = statusGradeList[rivalData[18]-7][3]
            rivalStatusA = statusGradeList[rivalData[18]-7][4]
            rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
            for i in 0...4 {
                if rivalStatusData[i] > 12 {
                    rivalStatusData[i] = 12
                }
                if rivalStatusData[i] < 0 {
                    rivalStatusData[i] = 0
                }
                rivalData[i+19] = rivalStatusData[i]
            }
        }
        myPRA = myResult[5]
        myMelt = myResult[6]
        if myMelt == 1 {
            myAilmentList[myBattlingPokemonNumber] = 0
            myData[16] = 0
        }
        myWeaponNumber = myData[14]
        if rivalItem == 6 && rivalResultHP > 0 && rivalResultHP <= rivalOriginHPList[rivalData[13]]/2 {//オボン
            rivalObonHeal = rivalOriginHPList[rivalData[13]]/4
            rivalResultHP += rivalObonHeal
        }
        if myItem == 4 && myAttackIsHit == 0 && myCompatibilityValue != 0 && myAttackDamage != 0 {//いのちのたま
            myLifeOrbDamage = Int(Double(myOriginHPList[myBattlingPokemonNumber])/10.0)
            myLifeOrbDamage = checkDamage(myResultHP, myLifeOrbDamage)
            myResultHP -= myLifeOrbDamage
        }
        originRivalBattlingPokemonNumber = rivalData[14]
    } else if myData.last! == -2 && rivalData.last! == -2 {//ともに攻撃
        isFirst = speedJudging(myData[8],rivalData[8], myData[15], rivalData[15], myData[16], rivalData[16])
        situationNumber = 3
        rivalWeaponNumber = rivalData[14]
        if isFirst == 0 {
            if mySleepingCountList[myBattlingPokemonNumber] > 0 {//睡眠処理
                mySleepingCountList[myBattlingPokemonNumber] -= 1
                if mySleepingCountList[myBattlingPokemonNumber] == 0 {
                    myWakeUp = 1
                    myAilmentList[myBattlingPokemonNumber] = 0
                       myData[16] = 0
                } else {
                    myWakeUp = 2
                }
            }
            var myResult = damagecalculating(myData, rivalData)
            myAttackDamage = myResult[0]
            myAttackDamage = checkDamage(rivalResultHP, myAttackDamage)
            myAttackDamage = checkSash("R")
            rivalResultHP -= myAttackDamage
            myAttackIsHit = myResult[1]
            myAttackIsCritical = myResult[2]
            myCompatibilityValue = myResult[3]
            mySub = myResult[4]
            if mySub == 0 {
                mySubMassage = myData[18]
            }
            if mySub == 0 && myData[18] < 7 && myData[18] > 0 {
                rivalData[16] = myData[18]
                rivalAilmentList[rivalBattlingPokemonNumber] = rivalData[16]
                if rivalData[16] == 6 {
                    rivalSleepingCountList[rivalBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
                }
            } else if mySub == 0 && myData[18] > 6 && myData[18] < 26 {
                myStatusA = statusGradeList[rivalData[18]-7][0]
                myStatusB = statusGradeList[rivalData[18]-7][1]
                myStatusC = statusGradeList[rivalData[18]-7][2]
                myStatusD = statusGradeList[rivalData[18]-7][3]
                myStatusS = statusGradeList[rivalData[18]-7][4]
                myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
                for i in 0...4 {
                    if myStatusData[i] > 12 {
                        myStatusData[i] = 12
                    }
                    if myStatusData[i] < 0 {
                        myStatusData[i] = 0
                    }
                    myData[i+19] = myStatusData[i]
                }
            } else if mySub == 0 && myData[18] > 25 && myData[18] < 36 {
                rivalStatusA = statusGradeList[rivalData[18]-7][0]
                rivalStatusB = statusGradeList[rivalData[18]-7][1]
                rivalStatusC = statusGradeList[rivalData[18]-7][2]
                rivalStatusA = statusGradeList[rivalData[18]-7][3]
                rivalStatusA = statusGradeList[rivalData[18]-7][4]
                rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
                for i in 0...4 {
                    if rivalStatusData[i] > 12 {
                        rivalStatusData[i] = 12
                    }
                    if rivalStatusData[i] < 0 {
                        rivalStatusData[i] = 0
                    }
                    rivalData[i+19] = rivalStatusData[i]
                }
            }
            myPRA = myResult[5]
            myMelt = myResult[6]
            if myMelt == 1 {
                myAilmentList[myBattlingPokemonNumber] = 0
                myData[16] = 0
            }
            myWeaponNumber = myData[14]
            if rivalItem == 6 && rivalResultHP > 0 && rivalResultHP <= rivalOriginHPList[rivalData[13]]/2 {//オボン
                rivalObonHeal = rivalOriginHPList[rivalData[13]]/4
                rivalResultHP += rivalObonHeal
            }
            if myItem == 4 && myAttackIsHit == 0 && myCompatibilityValue != 0 && myAttackDamage != 0 {//いのちのたま
                myLifeOrbDamage = Int(Double(myOriginHPList[myBattlingPokemonNumber])/10.0)
                myLifeOrbDamage = checkDamage(myResultHP, myLifeOrbDamage)
                myResultHP -= myLifeOrbDamage
            }
            if myResultHP > 0 && rivalResultHP > 0 {
            
                if rivalSleepingCountList[rivalBattlingPokemonNumber] > 0 {//睡眠処理
                    rivalSleepingCountList[rivalBattlingPokemonNumber] -= 1
                    if rivalSleepingCountList[rivalBattlingPokemonNumber] == 0 {
                        rivalWakeUp = 1
                        rivalAilmentList[rivalBattlingPokemonNumber] = 0
                         rivalData[16] = 0
                    } else {
                        rivalWakeUp = 2
                    }
                }
                var rivalResult = damagecalculating(rivalData, myData)
                rivalAttackDamage = rivalResult[0]
                rivalAttackDamage = checkDamage(myResultHP, rivalAttackDamage)
                rivalAttackDamage = checkSash("M")
                myResultHP -= rivalAttackDamage
                rivalAttackIsHit = rivalResult[1]
                rivalAttackIsCritical = rivalResult[2]
                rivalComtibilityValue = rivalResult[3]
                rivalSub = rivalResult[4]
                if rivalSub == 0 {
                    rivalSubMassage = rivalData[18]
                }
                if rivalSub == 0 && rivalData[18] < 7 && rivalData[18] > 0 {
                    myData[16] = rivalData[18]
                    myAilmentList[myBattlingPokemonNumber] = myData[16]
                    if myData[16] == 6 {
                        mySleepingCountList[myBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
                    }
                } else if rivalSub == 0 && rivalData[18] > 6 && rivalData[18] < 26 {
                    rivalStatusA = statusGradeList[rivalData[18]-7][0]
                    rivalStatusB = statusGradeList[rivalData[18]-7][1]
                    rivalStatusC = statusGradeList[rivalData[18]-7][2]
                    rivalStatusA = statusGradeList[rivalData[18]-7][3]
                    rivalStatusA = statusGradeList[rivalData[18]-7][4]
                    rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
                    for i in 0...4 {
                        if rivalStatusData[i] > 12 {
                            rivalStatusData[i] = 12
                        }
                        if rivalStatusData[i] < 0 {
                            rivalStatusData[i] = 0
                        }
                        rivalData[i+19] = rivalStatusData[i]
                    }
                } else if rivalSub == 0 && rivalData[18] > 25 && rivalData[18] < 36 {
                    myStatusA = statusGradeList[rivalData[18]-7][0]
                    myStatusB = statusGradeList[rivalData[18]-7][1]
                    myStatusC = statusGradeList[rivalData[18]-7][2]
                    myStatusD = statusGradeList[rivalData[18]-7][3]
                    myStatusS = statusGradeList[rivalData[18]-7][4]
                    myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
                    for i in 0...4 {
                        if myStatusData[i] > 12 {
                            myStatusData[i] = 12
                        }
                        if myStatusData[i] < 0 {
                            myStatusData[i] = 0
                        }
                        myData[i+19] = myStatusData[i]
                    }
                }
                rivalPRA = rivalResult[5]
                rivalMelt = rivalResult[6]
                if rivalMelt == 1 {
                    rivalData[16] = 0
                    rivalAilmentList[rivalBattlingPokemonNumber] = 0
                }
                rivalWeaponNumber = rivalData[14]
                if myItem == 6 && myResultHP > 0 && myResultHP <= myOriginHPList[myData[13]]/2 {//オボン
                    myObonHeal = myOriginHPList[myData[13]]/4
                    myResultHP += myObonHeal
                }
                if rivalItem == 4 && rivalAttackIsHit == 0 && rivalComtibilityValue != 0 && rivalAttackDamage != 0 {//いのちのたま
                    rivalLifeOrbDamage = Int(Double(rivalOriginHPList[rivalBattlingPokemonNumber])/10.0)
                    rivalLifeOrbDamage = checkDamage(rivalResultHP, rivalLifeOrbDamage)
                    rivalResultHP -= rivalLifeOrbDamage
                }
            
            }
        } else if isFirst == 1 {
            if rivalSleepingCountList[rivalBattlingPokemonNumber] > 0 {//睡眠処理
                rivalSleepingCountList[rivalBattlingPokemonNumber] -= 1
                if rivalSleepingCountList[rivalBattlingPokemonNumber] == 0 {
                    rivalWakeUp = 1
                    rivalAilmentList[rivalBattlingPokemonNumber] = 0
                     rivalData[16] = 0
                } else {
                    rivalWakeUp = 2
                }
            }
            var rivalResult = damagecalculating(rivalData, myData)
            rivalAttackDamage = rivalResult[0]
            rivalAttackDamage = checkDamage(myResultHP, rivalAttackDamage)
            rivalAttackDamage = checkSash("M")
            myResultHP -= rivalAttackDamage
            rivalAttackIsHit = rivalResult[1]
            rivalAttackIsCritical = rivalResult[2]
            rivalComtibilityValue = rivalResult[3]
            rivalSub = rivalResult[4]
            if rivalSub == 0 {
                rivalSubMassage = rivalData[18]
            }
            if rivalSub == 0 && rivalData[18] < 7 && rivalData[18] > 0 {
                myData[16] = rivalData[18]
                myAilmentList[myBattlingPokemonNumber] = myData[16]
                if myData[16] == 6 {
                    mySleepingCountList[myBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
                }
            } else if rivalSub == 0 && rivalData[18] > 6 && rivalData[18] < 26 {
                rivalStatusA = statusGradeList[rivalData[18]-7][0]
                rivalStatusB = statusGradeList[rivalData[18]-7][1]
                rivalStatusC = statusGradeList[rivalData[18]-7][2]
                rivalStatusA = statusGradeList[rivalData[18]-7][3]
                rivalStatusA = statusGradeList[rivalData[18]-7][4]
                rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
                for i in 0...4 {
                    if rivalStatusData[i] > 12 {
                        rivalStatusData[i] = 12
                    }
                    if rivalStatusData[i] < 0 {
                        rivalStatusData[i] = 0
                    }
                    rivalData[i+19] = rivalStatusData[i]
                }
            } else if rivalSub == 0 && rivalData[18] > 25 && rivalData[18] < 36 {
                myStatusA = statusGradeList[rivalData[18]-7][0]
                myStatusB = statusGradeList[rivalData[18]-7][1]
                myStatusC = statusGradeList[rivalData[18]-7][2]
                myStatusD = statusGradeList[rivalData[18]-7][3]
                myStatusS = statusGradeList[rivalData[18]-7][4]
                myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
                for i in 0...4 {
                    if myStatusData[i] > 12 {
                        myStatusData[i] = 12
                    }
                    if myStatusData[i] < 0 {
                        myStatusData[i] = 0
                    }
                    myData[i+19] = myStatusData[i]
                }
            }
            rivalPRA = rivalResult[5]
            rivalMelt = rivalResult[6]
            if rivalMelt == 1 {
                rivalData[16] = 0
                rivalAilmentList[rivalBattlingPokemonNumber] = 0
            }
            rivalWeaponNumber = rivalData[14]
            if myItem == 6 && myResultHP > 0 && myResultHP <= myOriginHPList[myData[13]]/2 {//オボン
                myObonHeal = myOriginHPList[myData[13]]/4
                myResultHP += myObonHeal
            }
            if rivalItem == 4 && rivalAttackIsHit == 0 && rivalComtibilityValue != 0 && rivalAttackDamage != 0 {//いのちのたま
                rivalLifeOrbDamage = Int(Double(rivalOriginHPList[rivalBattlingPokemonNumber])/10.0)
                rivalLifeOrbDamage = checkDamage(rivalResultHP, rivalLifeOrbDamage)
                rivalResultHP -= rivalLifeOrbDamage
            }
            if rivalResultHP > 0 && myResultHP > 0 {
                if mySleepingCountList[myBattlingPokemonNumber] > 0 {//睡眠処理
                    mySleepingCountList[myBattlingPokemonNumber] -= 1
                    if mySleepingCountList[myBattlingPokemonNumber] == 0 {
                        myWakeUp = 1
                        myAilmentList[myBattlingPokemonNumber] = 0
                         myData[16] = 0
                    } else {
                        myWakeUp = 2
                    }
                }
                var myResult = damagecalculating(myData, rivalData)
                myAttackDamage = myResult[0]
                myAttackDamage = checkDamage(rivalResultHP, myAttackDamage)
                myAttackDamage = checkSash("R")
                rivalResultHP -= myAttackDamage
                myAttackIsHit = myResult[1]
                myAttackIsCritical = myResult[2]
                myCompatibilityValue = myResult[3]
                mySub = myResult[4]
                if mySub == 0 {
                    mySubMassage = myData[18]
                }
                if mySub == 0 && myData[18] < 7 && myData[18] > 0 {
                    rivalData[16] = myData[18]
                    rivalAilmentList[rivalBattlingPokemonNumber] = rivalData[16]
                    if rivalData[16] == 6 {
                        rivalSleepingCountList[rivalBattlingPokemonNumber] = 2+Int(arc4random_uniform(3))
                    }
                } else if mySub == 0 && myData[18] > 6 && myData[18] < 26 {
                    myStatusA = statusGradeList[rivalData[18]-7][0]
                    myStatusB = statusGradeList[rivalData[18]-7][1]
                    myStatusC = statusGradeList[rivalData[18]-7][2]
                    myStatusD = statusGradeList[rivalData[18]-7][3]
                    myStatusS = statusGradeList[rivalData[18]-7][4]
                    myStatusData += [myStatusA,myStatusB,myStatusC,myStatusD,myStatusS]
                    for i in 0...4 {
                        if myStatusData[i] > 12 {
                            myStatusData[i] = 12
                        }
                        if myStatusData[i] < 0 {
                            myStatusData[i] = 0
                        }
                        myData[i+19] = myStatusData[i]
                    }
                } else if mySub == 0 && myData[18] > 25 && myData[18] < 36 {
                    rivalStatusA = statusGradeList[rivalData[18]-7][0]
                    rivalStatusB = statusGradeList[rivalData[18]-7][1]
                    rivalStatusC = statusGradeList[rivalData[18]-7][2]
                    rivalStatusA = statusGradeList[rivalData[18]-7][3]
                    rivalStatusA = statusGradeList[rivalData[18]-7][4]
                    rivalStatusData += [rivalStatusA,rivalStatusB,rivalStatusC,rivalStatusD,rivalStatusS]
                    for i in 0...4 {
                        if rivalStatusData[i] > 12 {
                            rivalStatusData[i] = 12
                        }
                        if rivalStatusData[i] < 0 {
                            rivalStatusData[i] = 0
                        }
                        rivalData[i+19] = rivalStatusData[i]
                    }
                }
                myPRA = myResult[5]
                myMelt = myResult[6]
                if myMelt == 1 {
                    myAilmentList[myBattlingPokemonNumber] = 0
                    myData[16] = 0
                }
                myWeaponNumber = myData[14]
                if rivalItem == 6 && rivalResultHP > 0 && rivalResultHP <= rivalOriginHPList[rivalData[13]]/2 {//オボン
                    rivalObonHeal = rivalOriginHPList[rivalData[13]]/4
                    rivalResultHP += rivalObonHeal
                }
                if myItem == 4 && myAttackIsHit == 0 && myCompatibilityValue != 0 && myAttackDamage != 0 {//いのちのたま
                    myLifeOrbDamage = Int(Double(myOriginHPList[myBattlingPokemonNumber])/10.0)
                    myLifeOrbDamage = checkDamage(myResultHP, myLifeOrbDamage)
                    myLifeOrbDamage = checkDamage(myResultHP, myLifeOrbDamage)
                    myResultHP -= myLifeOrbDamage
                }
            
            }
        }
    }
    
    
  //いのちのたま処理
  /*  if myItem != 4 {//いの珠を持たないとき
        if myCurrentHP < rivalAttackDamage {
            rivalAttackDamage = myCurrentHP
        }
    } else {//持つとき
        if situationNumber == 1 {
            if myCurrentHP < rivalAttackDamage {
                rivalAttackDamage = myCurrentHP
            }
        }
        if situationNumber == 2 {
            if myCurrentHP < myLifeOrbDamage {
                myLifeOrbDamage = myCurrentHP
            }
        }
        if situationNumber == 3 {
            if isFirst == 0 {
                if myCurrentHP < myLifeOrbDamage {
                    myLifeOrbDamage = myCurrentHP
                } else if myCurrentHP - myLifeOrbDamage < rivalAttackDamage {
                    rivalAttackDamage = myCurrentHP - myLifeOrbDamage
                }
            }
            if isFirst == 1 {
                if myCurrentHP < rivalAttackDamage {
                    rivalAttackDamage = myCurrentHP
                } else if myCurrentHP - rivalAttackDamage < myLifeOrbDamage {
                    myLifeOrbDamage = myCurrentHP - rivalAttackDamage
                }
            }
        }
    }
    if rivalItem != 4 {
        if rivalCurrentHP < myAttackDamage {
            myAttackDamage = rivalCurrentHP
        }
    } else {
        if situationNumber == 1 {
            if rivalCurrentHP < rivalLifeOrbDamage {
                rivalLifeOrbDamage = rivalCurrentHP
            }
        }
        if situationNumber == 2 {
            if rivalCurrentHP < myAttackDamage {
                myAttackDamage = rivalCurrentHP
            }
        }
        if situationNumber == 3 {
            if isFirst == 0 {
                if rivalCurrentHP < myAttackDamage {
                    myAttackDamage = rivalCurrentHP
                } else if rivalCurrentHP - myAttackDamage < rivalLifeOrbDamage {
                    rivalLifeOrbDamage = rivalCurrentHP - myAttackDamage
                }
            }
            if isFirst == 1 {
                if rivalCurrentHP < rivalLifeOrbDamage {
                    rivalLifeOrbDamage = rivalCurrentHP
                } else if rivalCurrentHP - rivalLifeOrbDamage < myAttackDamage {
                    myAttackDamage = rivalCurrentHP - rivalLifeOrbDamage
                }
            }
        }
    }
    //タスキ処理
    if myItem == 5 && myCurrentHP == myOriginHPList[myData[13]] && myCurrentHP <= rivalAttackDamage {//気合の襷
        mySash = 1
    rivalAttackDamage = myCurrentHP - 1
    }
    if rivalItem == 5 && rivalCurrentHP == rivalOriginHPList[rivalData[13]] && rivalCurrentHP <= myAttackDamage {
        rivalSash = 1
        myAttackDamage = rivalCurrentHP - 1
    }
 */
    //食べ残し処理
    if myItem == 8 && myResultHP > 0 {
        myLeftoversHeal = myOriginHPList[myData[13]]/16
        if myResultHP + myLeftoversHeal > myOriginHPList[myData[13]] {
            myLeftoversHeal = myOriginHPList[myData[13]] - myResultHP
        }
    }
    if rivalItem == 8 && rivalResultHP > 0 {
        rivalLeftoversHeal = rivalOriginHPList[rivalData[13]]/16
        if rivalResultHP + rivalLeftoversHeal > rivalOriginHPList[rivalData[13]] {
            rivalLeftoversHeal = rivalOriginHPList[rivalData[13]] - rivalResultHP
    }
    }
    //毒
    if myData[16] == 4 {
        myPoisonDamage = myOriginHPList[myData[13]]/8
        myPoisonDamage = checkDamage(myResultHP, myPoisonDamage)
        myResultHP -= myPoisonDamage
    }
    if rivalData[16] == 4 {
        rivalPoisonDamage = rivalOriginHPList[rivalData[13]]/8
        rivalPoisonDamage = checkDamage(rivalResultHP, rivalPoisonDamage)
        rivalResultHP -= rivalPoisonDamage
    }
    //猛毒
    if myData[16] == 5 {
        myPoisonCount += 1
        myPoisonDamage = myOriginHPList[myData[13]]/16*myPoisonCount
        myPoisonDamage = checkDamage(myResultHP, myPoisonDamage)
        myResultHP -= myPoisonDamage
    }
    if rivalData[16] == 5 {
        rivalPoisonCount += 1
        rivalPoisonDamage = rivalOriginHPList[rivalData[13]]/16*rivalPoisonCount
        rivalPoisonDamage = checkDamage(rivalResultHP, rivalPoisonDamage)
        rivalResultHP -= rivalPoisonDamage
    }
    //やけど
    if myData[16] == 1 {
        myBurnDamage = myOriginHPList[myData[13]]/16
        myBurnDamage = checkDamage(myResultHP, myBurnDamage)
        myResultHP -= myBurnDamage
    }
    if rivalData[16] == 1 {
        rivalBurnDamage = rivalOriginHPList[rivalData[13]]/16
        rivalBurnDamage = checkDamage(rivalResultHP, rivalBurnDamage)
        rivalResultHP -= rivalBurnDamage
    }
    if myPRA == 0 && myWakeUp != 2 && myMelt != 2 {
        myDoAttack = 1
    }
    if rivalPRA == 0 && rivalWakeUp != 2 && rivalMelt != 2 {
        rivalDoAttack = 1
    }
    myAilment = myData[16]
    rivalAilment = rivalData[16]
    myHPList[myBattlingPokemonNumber] = myResultHP
    rivalHPList[rivalBattlingPokemonNumber] = rivalResultHP
   // myHPList[myBattlingPokemonNumber] = myCurrentHP - rivalAttackDamage - myLifeOrbDamage + myObonHeal + myLeftoversHeal
   // rivalHPList[rivalBattlingPokemonNumber] = rivalCurrentHP - myAttackDamage - rivalLifeOrbDamage + rivalObonHeal + rivalLeftoversHeal
  //  let myResultHP = myHPList[myBattlingPokemonNumber]
  //  let rivalResultHP = rivalHPList[rivalBattlingPokemonNumber]
    print(myHPList,rivalHPList)
    print(myCurrentHP,rivalCurrentHP,myResultHP,rivalResultHP,myAttackDamage,rivalAttackDamage)
    rivalBattleData = []
    
    return [situationNumber,isFirst,myCurrentHP,rivalCurrentHP,myResultHP,rivalResultHP,myBattlingPokemonNumber,originMyBattlingPokemonNumber,rivalBattlingPokemonNumber,originRivalBattlingPokemonNumber,myWeaponNumber,rivalWeaponNumber,myAttackIsHit,rivalAttackIsHit,myAttackIsCritical,rivalAttackIsCritical,myCompatibilityValue,rivalComtibilityValue,myAttackDamage,rivalAttackDamage,myItem,rivalItem,myLifeOrbDamage,rivalLifeOrbDamage,mySash,rivalSash,myObonHeal,rivalObonHeal,myLeftoversHeal,rivalLeftoversHeal,myOriginHP,rivalOriginHP,myAilment,rivalAilment,myBurnDamage,rivalBurnDamage,myPRA,rivalPRA,myMelt,rivalMelt,myPoisonDamage,rivalPoisonDamage,myWakeUp,rivalWakeUp,mySub,rivalSub,myDoAttack,rivalDoAttack,mySubMassage,rivalSubMassage,-4]
   
}

func sendClear() {
    var clearKey = -6
    let data = NSData(bytes: &clearKey, length: MemoryLayout<NSInteger>.size)
    do {
        if isGKMatch {
        try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
    } else {
        try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
        }
    } catch {
    }
}


func buttonFunction(_ buttonNumber: Int) {
    let myItem = myBattlePokemonDataList[myBattlingPokemonNumber][13]
    if myItem == 1 || myItem == 2 || myItem == 3 {
        choice = true
        choiceNumber = buttonNumber
    }
    myWeaponNumber = accessWeaponNameNumber(myBattlingPokemonNumber, buttonNumber)
    print(pokemonDataList,partyDataList,selectedPartyData,myBattlePartyData)
    let wData = searchWeaponData(myBattlePartyData[myBattlingPokemonNumber], buttonNumber)
    var ppData = [Int]()
    let pData = myBattlePokemonDataList[myBattlingPokemonNumber]
    for i in 0...8 {
        ppData.append(pData[i])
    }
    var w1Data = [Int]()
    var w2Data = [Int]()
    for i in 0...3 {
        w1Data.append(wData[i])
    }
    for i in 4...5 {
        w2Data.append(wData[i])
    }
    ppData[3] = myHPList[myBattlingPokemonNumber]
    myBattleData.removeAll()
    myBattleData = ppData + w1Data
    myBattleData.append(myBattlingPokemonNumber)
    myBattleData.append(myWeaponNumber)
    myBattleData.append(pData[13])//道具
    myBattleData.append(myAilmentList[myBattlingPokemonNumber])
    myBattleData.append(w2Data[0])
    myBattleData.append(w2Data[1])//
    for i in 0...4 {
        myBattleData.append(myStatusData[i])
    }
    myBattleData.append(-2)
    print(myBattleData)
    sendClear()
    for i in 0...myBattleData.count-1 {
        let data = NSData(bytes: &myBattleData[i], length: MemoryLayout<NSInteger>.size)
        do {
            if isGKMatch {
                try  generalMatch.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
            } else {
                try generalSession.send(data as Data, toPeers: generalSession.connectedPeers, with: MCSessionSendDataMode.reliable)
            }
        } catch {
        }
    }
    
}
func accessWeaponNameNumber(_ BattlingNumber: Int,_ weaponNumber:Int) -> Int {

    return myBattlePartyData[BattlingNumber]*4 + weaponNumber - 1
}
func searchWeaponName(_ p: Int, _ w: Int) -> String {
    return safeCallArray(weaponNameList, pokemonDataList[selectedPartyData[p]][8+w])
}
func searchWeaponData(_ p: Int, _ w: Int) -> [Int] {
    return weaponDataList[pokemonDataList[selectedPartyData[p]][8+w]]
}
func searchPokemonData(_ p: Int) -> [Int] {
    return pokemonDataList[selectedPartyData[p]]
}
func deleteSame(_ a: [Int]) -> [Int] {
    var b = a
    for i in 0...a.count-1 {
        for j in 0...a.count-1 {
            if i != j {
                if b[i] == b[j] {
                    b.remove(at: j)
                    b.append(-1)
                }
            }
        }
    }
    if b[0] == -1 {
        b.remove(at: 0)
        b.append(-1)
    }
    return b
}

func safeCallArray(_ a: [String], _ i: Int) -> String {
    if i != -1 {
        return a[i]
    } else {
        return "-"
    }
    
}
func reviseScore(_ b:Int)->Int {
    var a = b
if a % 5 != 0 {
    a += 5 - (a % 5)
}
    return a
}
func reviseForm(_ a:Int)->String {
    var form = ""
    if a >= 100000 {
        form += "H"
    }
    if a % 100000 >= 10000 {
        form += "A"
    }
    if a % 10000 >= 1000 {
        form += "B"
    }
    if a % 1000 >= 100 {
        form += "C"
    }
    if a % 100 >= 10 {
        form += "D"
    }
    if a % 10 >= 1 {
        form += "S"
    }
    return form
}
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        print("touchesBegan")
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        print("touchesMoved")
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        print("touchesEnded")
    }
}


class TLHorizontalScrollView : UIScrollView{
    
    // タップ開始時のスクロール位置格納用
    var startPoint : CGPoint!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        Initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        Initialize();
    }
    
    // initialize method
    func Initialize(){
        self.delegate = self;
        
        // 横固定なので縦のIndicatorいらない
        self.showsVerticalScrollIndicator = false;
    }
}

extension TLHorizontalScrollView : UIScrollViewDelegate{
    
    // ドラッグ開始時のスクロール位置記憶
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startPoint = scrollView.contentOffset;
    }
    
    // ドラッグ(スクロール)しても y 座標は開始時から動かないようにする(固定)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = self.startPoint.x;
    }
}


class PickerKeyboard: UIControl {
    
    var data = [String]()
    var textStore: String = ""
    var selectedRow =  -1
    override func draw(_ rect: CGRect) {
        UIColor.black.set()
        UIRectFrame(rect)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.init(red: 137/255, green: 255/255, blue: 255/255, alpha: 255/255).cgColor
       // self.layer.borderWidth = 1.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
       
        let attrs: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 17), NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): paragraphStyle]
        NSString(string: textStore).draw(in: rect, withAttributes: attrs)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(PickerKeyboard.didTap(sender:)), for: .touchUpInside)
        
    }
    
    @objc func didTap(sender: PickerKeyboard) {
        becomeFirstResponder()
    }
    
    @objc func didTapDone(sender: UIButton) {
        resignFirstResponder()
        
    }
    @objc func didTapCancel(sender: UIButton) {
        resignFirstResponder()
        selectedRow = -1
        textStore = ""
       
        setNeedsDisplay()
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputView: UIView? {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        let row = data.index(of: textStore) ?? -1
        pickerView.selectRow(row, inComponent: 0, animated: false)
        return pickerView
    }
    
    override var inputAccessoryView: UIView? {
        let button = UIButton(type: .system)
        button.setTitle("完了", for: .normal)
        button.addTarget(self, action: #selector(PickerKeyboard.didTapDone(sender:)), for: .touchUpInside)
        button.sizeToFit()
        
        let button2 = UIButton(type: .system)
        button2.setTitle("選択しない", for: .normal)
        button2.addTarget(self, action: #selector(PickerKeyboard.didTapCancel(sender:)), for: .touchUpInside)
        button2.sizeToFit()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.backgroundColor = .groupTableViewBackground
        
        button.frame.origin.x = 16
        button.center.y = view.center.y
        button2.frame.origin.x = 200
        button2.center.y = view.center.y
        button.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        view.addSubview(button)
        view.addSubview(button2)
        return view
    }
    
}

extension PickerKeyboard: UIKeyInput {
    // It is not necessary to store text in this situation.
    var hasText: Bool {
        return !textStore.isEmpty
    }
    
    func insertText(_ text: String) {
        textStore += text
        setNeedsDisplay()
    }
    
    func deleteBackward() {
        textStore.remove(at: textStore.index(before: textStore.endIndex))
        setNeedsDisplay()
    }
}

extension PickerKeyboard: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textStore = data[row]
        selectedRow = row
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タップ時のカラー
      //  self.backgroundColor = aku
         becomeFirstResponder()
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.white
    }
}



extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}
private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        
        #if swift(>=4.0)
            text = String(prospectiveText[..<maxCharIndex])
        #else
            text = prospectiveText.substring(to: maxCharIndex)
        #endif
        
        selectedTextRange = selection
    }
    
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9204323547115751~9728018078")
        FirebaseApp.configure()
        if let presentView = window?.rootViewController {
            let target = presentView
            let player = GKLocalPlayer.localPlayer()
            player.authenticateHandler = {(viewController, error) -> Void in
                if ((viewController) != nil) {
                    print("GameCenter Login: Not Logged In > Show GameCenter Login")
                    
                    target.present(viewController!, animated: true, completion: nil);
                } else {
                    print("GameCenter Login: Log In")
                    
                    if (error == nil){
                        print("LoginAuthentication: Success")
                    } else {
                        print("LoginAuthentication: Failed")
                    }
                }
            }
        }
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("さようなら")
        if isGKMatch {
            generalMatch.disconnect()
            print("ok4")
            timeUpLose = true
        } 
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {}
}


