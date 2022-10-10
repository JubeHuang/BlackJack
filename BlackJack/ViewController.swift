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
    var stackOfCardIndex = 3
    var playerCardImageIndex = 1
    var bankerCardImageNumber = 1
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
        cards.shuffle()
        reStart()
    }
    //下注
    @IBAction func deal(_ sender: UIButton) {
        if betMoneyLabel.text != "0" {
            for i in 0...4 {
                self.playerCards[i].alpha = 0
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
            for i in 0...3{
                if cards[i].rank > 10 {
                    cards[i].rank = 10
                } else if cards[i].rank == 1 {
                    cards[i].rank = 11
                }
            }
            playerSumNumber = cards[0].rank + cards[2].rank
            //拿到兩張A
            if cards[0].rank == 11, cards[2].rank == 11 {
                playerSumNumber = 12
            }
            bankerSumNumber = cards[3].rank
            let realBankerSumNumber = bankerSumNumber + cards[1].rank
            var remainMoney = Int(remainMoneyLabel.text!)!
            let betMoney = Int(betMoneyLabel.text!)!
            //莊閒兩張牌21
            if playerSumNumber == 21, realBankerSumNumber == 21 {
                wordingLabel.text = "你輸了"
                betMoneyLabel.text = "0"
                showBankerHideCard()
                bankerSum.text = "\(realBankerSumNumber)"
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
    }
    @IBAction func addMinusBetMoney(_ sender: UIButton) {
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
                for i in 0...4{
                    playerCards[i].alpha = 0
                    bankerCards[i].alpha = 0
                }
                playerSum.text = "0"
                bankerSum.text = "0"
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
        //print(cards)
        let betMoney = Int(betMoneyLabel.text!)!
        var remainMoney = Int(remainMoneyLabel.text!)!
        //show蓋牌
        showBankerHideCard()
        //玩家有無爆牌
        if playerSumNumber > 21 {
            wordingLabel.text = "爆掉!"
        } else {
            //莊家小於17 自動補牌
            while bankerSumNumber < 17 {
                bankerCardImageNumber += 1
                stackOfCardIndex += 1
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
                    self.bankerCards[self.bankerCardImageNumber].image = UIImage(named: self.cards[self.stackOfCardIndex].suit + "\(self.cards[self.stackOfCardIndex].rank)")
                    self.bankerCards[self.bankerCardImageNumber].alpha = 1
                }
                //當新補的牌=10時，前面A都算1;當補牌後總數<=11，A算11
                if cards[stackOfCardIndex].rank >= 10 {
                    cards[stackOfCardIndex].rank = 10
                    bankerSumNumber += cards[stackOfCardIndex].rank
                    if cards[1].rank == 11 {
                        cards[1].rank = 1
                        bankerSumNumber -= 10
                    } else if cards[3].rank == 11 {
                        cards[3].rank = 1
                        bankerSumNumber -= 10
                    } else if cards[1].rank == 11, cards[3].rank == 11 {
                        cards[1].rank = 1
                        cards[3].rank = 1
                        bankerSumNumber += cards[stackOfCardIndex].rank - 20
                    }
                } else if bankerSumNumber <= 11, cards[stackOfCardIndex].rank == 1 {
                    cards[stackOfCardIndex].rank = 11
                    bankerSumNumber += cards[stackOfCardIndex].rank
                } else {
                    bankerSumNumber += cards[stackOfCardIndex].rank
                }
                bankerSum.text = "\(bankerSumNumber)"
            }
            
            if bankerSumNumber > 21 || playerSumNumber > bankerSumNumber {
                wordingLabel.text = "你贏了"
                remainMoney += betMoney * 2
            } else if playerSumNumber < bankerSumNumber {
                wordingLabel.text = "你輸了"
            } else if playerSumNumber == bankerSumNumber {
                wordingLabel.text = "平手"
            }
        }
        betMoneyLabel.text = "0"
        remainMoneyLabel.text = "\(remainMoney)"
        stackOfCardIndex = 3
        playerCardImageIndex = 1
        bankerCardImageNumber = 1
        cards.shuffle()
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
        if playerSumNumber <= 11 {
            if cards[stackOfCardIndex].rank >= 10 {
                cards[stackOfCardIndex].rank = 10
                playerSumNumber += cards[stackOfCardIndex].rank
                if cards[0].rank == 11 {
                    cards[0].rank = 1
                    playerSumNumber -= 10
                } else if cards[2].rank == 11 {
                    cards[2].rank = 1
                    playerSumNumber -= 10
                } else if cards[0].rank == 11, cards[2].rank == 11 {
                    cards[0].rank = 1
                    cards[2].rank = 1
                    playerSumNumber -= 20
                }
            } else if playerSumNumber <= 11, cards[stackOfCardIndex].rank == 1 {
                cards[stackOfCardIndex].rank = 11
                playerSumNumber += cards[stackOfCardIndex].rank
            } else {
                playerSumNumber += cards[stackOfCardIndex].rank
            }
        } else {
            playerSumNumber += cards[stackOfCardIndex].rank
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
        bankerCardImageNumber = 1
    }
    func showBankerHideCard(){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.bankerCards[0].image = UIImage(named: self.cards[1].suit + "\(self.cards[1].rank)")
            self.bankerCards[0].alpha = 1
        }
        if cards[1].rank > 10 {
            cards[1].rank = 10
        } else if cards[1].rank == 1 {
            cards[1].rank = 11
        }
        bankerSumNumber += cards[1].rank
        bankerSum.text = "\(bankerSumNumber)"
    }
}
