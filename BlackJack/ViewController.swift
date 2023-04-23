//
//  ViewController.swift
//  BlackJack
//
//  Created by JubeHuang黃冬伊 on 2022/10/4.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bankerCards: [UIImageView]!
    @IBOutlet var playerCards: [UIImageView]!
    @IBOutlet weak var wordingLabel: UILabel!
    @IBOutlet weak var bankerSum: UILabel!
    @IBOutlet weak var playerSum: UILabel!
    @IBOutlet weak var remainMoneyLabel: UILabel!
    @IBOutlet weak var standBtn: UIButton!
    @IBOutlet weak var betMoneyLabel: UILabel!
    
    let suits = ["club", "spade", "heart", "diamond"]
    let ranks = Array(1...13)
    var playerSumNumber = 0
    var bankerSumNumber = 0
    lazy var realBankerSumNumber = 0
    var stackOfCardIndex = 3
    var playerCardImageIndex = 1
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for suit in suits {
            for rank in ranks {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        reStart()
    }
    //下注
    @IBAction func deal(_ sender: UIButton) {
        guard betMoneyLabel.text != "0" else { return }
        
        cards.shuffle()
        
        for card in self.playerCards {
            card.alpha = 0
        }
        
        //莊閒各第一張牌
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.playerCards[0].image = UIImage(named: self.cards[0].suit + "\(self.cards[0].rank)")
            self.playerCards[0].alpha = 1
            self.bankerCards[0].image = UIImage(named: "cardBack")
            self.bankerCards[0].alpha = 1
        }
        //莊閒各第二張牌
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.8, delay: 0.5) {
            self.playerCards[1].image = UIImage(named: self.cards[2].suit + "\(self.cards[2].rank)")
            self.playerCards[1].alpha = 1
            self.bankerCards[1].image = UIImage(named: self.cards[3].suit + "\(self.cards[3].rank)")
            self.bankerCards[1].alpha = 1
        }
        
        //玩家牌計算
        playerSumNumber += calculateCardsNumber(cards: [cards[0].rank, cards[2].rank], roleSumNumber: playerSumNumber)
        
        //莊家牌計算
        bankerSumNumber += calculateCardsNumber(cards: [cards[3].rank], roleSumNumber: bankerSumNumber)
        realBankerSumNumber += calculateCardsNumber(cards: [cards[1].rank], roleSumNumber: realBankerSumNumber)
        realBankerSumNumber += bankerSumNumber
        
        //拿到兩張A both
        if playerSumNumber == 22 {
            playerSumNumber = 12
        }
        if realBankerSumNumber == 22 {
            realBankerSumNumber = 12
        }
        var remainMoney = Int(remainMoneyLabel.text!)!
        let betMoney = Int(betMoneyLabel.text!)!
        //莊閒兩張牌21
        if playerSumNumber == 21, realBankerSumNumber == 21 {
            wordingLabel.text = "你輸了"
            betMoneyLabel.text = "0"
            showBankerHideCard()
            
        } else if playerSumNumber == 21 {
            wordingLabel.text = "Black Jack"
            betMoneyLabel.text = "0"
            showBankerHideCard()
            remainMoney += betMoney * 5 / 2
            bankerSum.text = "\(realBankerSumNumber)"
        } else if realBankerSumNumber == 21 {
            wordingLabel.text = "你輸了"
            betMoneyLabel.text = "0"
            showBankerHideCard()
            remainMoney -= betMoney
            bankerSum.text = "\(realBankerSumNumber)"
        } else {
            wordingLabel.text = ""
            bankerSum.text = "\(bankerSumNumber)"
        }
        playerSum.text = "\(playerSumNumber)"
        remainMoneyLabel.text = "\(remainMoney)"
        
    }
    
    @IBAction func addMinusBetMoney(_ sender: UIButton) {
        if betMoneyLabel.text == "0" {
            initSumNumber()
        }
        
        var betMoney = Int(betMoneyLabel.text!)!
        var remainMoney = Int(remainMoneyLabel.text!)!
        switch sender.tag {
        case 1: //減
            if betMoney >= 100 {
                betMoney -= 100
                remainMoney += 100
            }
        case 2: //加
            if remainMoney >= 100 {
                remainMoney -= 100
                betMoney += 100
                
                playerCards.forEach({$0.alpha = 0})
                bankerCards.forEach({$0.alpha = 0})
            }
        default:
            break
        }
        remainMoneyLabel.text = "\(remainMoney)"
        betMoneyLabel.text = "\(betMoney)"
        wordingLabel.text = ""
    }
    //開牌
    @IBAction func stand(_ sender: UIButton) {
        var bankerCardImageNumber = 1
        var bankerCardsArray = [cards[1], cards[3]]
        let betMoney = Int(betMoneyLabel.text!)!
        var remainMoney = Int(remainMoneyLabel.text!)!
        
        //show蓋牌
        showBankerHideCard()
        //玩家有無爆牌
        if playerSumNumber > 21 {
            wordingLabel.text = "爆掉!"
        } else {
            // 兩張A
            if realBankerSumNumber == 22 {
                realBankerSumNumber = 12
            }
            //莊家小於17 自動補牌
            while realBankerSumNumber < 17 {
                bankerCardImageNumber += 1
                stackOfCardIndex += 1
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
                    self.bankerCards[bankerCardImageNumber].image = UIImage(named: self.cards[self.stackOfCardIndex].suit + "\(self.cards[self.stackOfCardIndex].rank)")
                    self.bankerCards[bankerCardImageNumber].alpha = 1
                }
                //莊家排計算
                realBankerSumNumber = calculateCardsNumber(cards: [cards[stackOfCardIndex].rank], roleSumNumber: realBankerSumNumber)
                
                bankerCardsArray.append(cards[stackOfCardIndex])
                let bankCardsAceArray = bankCardsAceArray(cards: bankerCardsArray)

                // sum > 21, A == 1
                for _ in 0..<bankCardsAceArray.count {
                    if realBankerSumNumber > 21 {
                        realBankerSumNumber -= 10
                    }
                }
                
                bankerSum.text = "\(realBankerSumNumber)"
            }
            if realBankerSumNumber > 21 || playerSumNumber > realBankerSumNumber {
                wordingLabel.text = "你贏了"
                remainMoney += betMoney * 2
            } else if playerSumNumber < realBankerSumNumber {
                wordingLabel.text = "你輸了"
            } else if playerSumNumber == realBankerSumNumber {
                wordingLabel.text = "平手"
            }
        }
        
        betMoneyLabel.text = "0"
        remainMoneyLabel.text = "\(remainMoney)"
        stackOfCardIndex = 3
        playerCardImageIndex = 1
        bankerCardImageNumber = 1
        // 玩家沒錢了
        if betMoneyLabel.text == "0", remainMoneyLabel.text == "0"{
            reStart()
        }
    }
    //要牌
    @IBAction func hit(_ sender: UIButton) {
        stackOfCardIndex += 1
        playerCardImageIndex += 1
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.playerCards[self.playerCardImageIndex].image = UIImage(named: self.cards[self.stackOfCardIndex].suit + "\(self.cards[self.stackOfCardIndex].rank)")
            self.playerCards[self.playerCardImageIndex].alpha = 1
        }
        //玩家排計算
        switch cards[stackOfCardIndex].rank {
        case 11...13:
            playerSumNumber += 10
        case 1...10:
            playerSumNumber += cards[stackOfCardIndex].rank
        default:
            break
        }
        switch playerCardImageIndex {
        case 2:
            if playerSumNumber > 11 {
                if cards[0].rank == 1 {
                    playerSumNumber -= 10
                } else if cards[2].rank == 1 {
                    playerSumNumber -= 10
                } else if cards[0].rank == 1, cards[2].rank == 1 {
                    playerSumNumber -= 20
                }
            } else {
                if cards[stackOfCardIndex].rank == 1 {
                    playerSumNumber += 10
                }
            }
        case 3:
            if playerSumNumber <= 11 {
                if cards[stackOfCardIndex].rank == 1 {
                    playerSumNumber += 10
                }
            }
        case 4:
            if playerSumNumber <= 11 {
                if cards[stackOfCardIndex].rank == 1 {
                    playerSumNumber += 10
                }
            }
        default:
            break
        }
        playerSum.text = "\(playerSumNumber)"
    }
    @IBAction func surrender(_ sender: UIButton) {
        if wordingLabel.text == "" {
            var remainMoney = Int(remainMoneyLabel.text!)!
            let betMoney = Int(betMoneyLabel.text!)!
            showBankerHideCard()
            remainMoney += betMoney / 2
            wordingLabel.text = "棄牌"
            betMoneyLabel.text = "0"
            remainMoneyLabel.text = "\(remainMoney)"
        }
    }
    
    func reStart() {
        wordingLabel.text = "請下注開始遊戲"
        remainMoneyLabel.text = "2000"
        betMoneyLabel.text = "0"
        playerSum.text = "0"
        bankerSum.text = "0"
        stackOfCardIndex = 3
        playerCardImageIndex = 1
    }
    
    func showBankerHideCard(){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.bankerCards[0].image = UIImage(named: self.cards[1].suit + "\(self.cards[1].rank)")
            self.bankerCards[0].alpha = 1
        }
        
        bankerSum.text = "\(realBankerSumNumber)"
    }
    
    func calculateCardsNumber(cards: [Int], roleSumNumber: Int) -> Int {
        var sumNumber = roleSumNumber
        
        cards.forEach {
            switch $0 {
            case 11...13:
                sumNumber += 10
            case 2...10:
                sumNumber += $0
            case 1:
                sumNumber += 11
            default:
                break
            }
        }
        print("sumNumber: \(sumNumber)")
        return sumNumber
    }
    
    func initSumNumber() {
        playerSumNumber = 0
        bankerSumNumber = 0
        realBankerSumNumber = 0
        playerSum.text = "\(playerSumNumber)"
        bankerSum.text = "\(realBankerSumNumber)"
    }
    
    func bankCardsAceArray(cards: [Card]) -> [Card] {
        var bankCardsAceArray = [Card]()
        cards.forEach {
            if $0.rank == 1 {
                bankCardsAceArray.append($0)
            }
        }
        return bankCardsAceArray
    }
}
