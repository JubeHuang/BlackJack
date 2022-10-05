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
    @IBOutlet weak var betMoneyLabel: UILabel!
    let suits = ["club", "spade", "heart", "diamond"]
    let ranks = Array(1...13)
    var playerSumNumber = 0
    var bankerSumNumber = 0
    var hitIndex = 2
    var playerCardIndex = 1
//    var playerCards = [Card]()
//    var bankerCards = [Card]()
    var cards = [Card]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
        reStart()
    }

    @IBAction func deal(_ sender: UIButton) {
        for i in 1...4 {
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
        
        if cards[0].rank > 10 {
            cards[0].rank = 10
        } else if cards[0].rank == 1 {
            cards[0].rank = 11
        }
        if cards[2].rank > 10 {
            cards[2].rank = 10
        } else if cards[2].rank == 1 {
            cards[2].rank = 11
        }
        if cards[3].rank == 1 {
            cards[3].rank = 11
        } else if cards[3].rank > 10 {
            cards[3].rank = 10
        }
        print(cards[0].rank,cards[2].rank,cards[3].rank)
        playerSumNumber = cards[0].rank + cards[2].rank
        bankerSumNumber = cards[3].rank
        playerSum.text = "\(playerSumNumber)"
        bankerSum.text = "\(bankerSumNumber)"
        wordingLabel.text = ""
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
            }
        default:
            break
        }
        remainMoneyLabel.text = "\(remainMoney)"
        betMoneyLabel.text = "\(betMoney)"
    }
    @IBAction func stand(_ sender: UIButton) {
        let betMoney = Int(betMoneyLabel.text!)!
        var remainMoney = Int(remainMoneyLabel.text!)!
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.8, delay: 0) {
            self.bankerCards[0].image = UIImage(named: self.cards[1].suit + "\(self.cards[1].rank)")
            self.bankerCards[0].alpha = 1
        }
        if cards[1].rank > 10 {
            cards[1].rank = 10
        } else if cards[1].rank == 1 {
            cards[1].rank = 11
        }
        print(cards[1].rank)
        bankerSumNumber += cards[1].rank
        bankerSum.text = "\(bankerSumNumber)"
        if playerSumNumber > 21 {
            wordingLabel.text = "爆掉!"
        } else if playerSumNumber > bankerSumNumber {
            wordingLabel.text = "你贏了"
            remainMoney += betMoney * 2
        } else if playerSumNumber < bankerSumNumber {
            wordingLabel.text = "你輸了"
        }
        betMoneyLabel.text = "0"
        remainMoneyLabel.text = "\(remainMoney)"
        hitIndex = 2
        playerCardIndex = 1
        shuffleCards()
    }
    @IBAction func hit(_ sender: UIButton) {
        hitIndex += 2
        playerCardIndex += 1
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.playerCards[self.playerCardIndex].image = UIImage(named: self.cards[self.hitIndex].suit + "\(self.cards[self.hitIndex].rank)")
            self.playerCards[self.playerCardIndex].alpha = 1
        }
        if cards[hitIndex].rank > 10 {
            cards[hitIndex].rank = 10
        }
        playerSumNumber += cards[hitIndex].rank
        playerSum.text = "\(playerSumNumber)"
    }
    @IBAction func surrender(_ sender: UIButton) {
    }
    
    func shuffleCards() {
        for suit in suits {
            for rank in ranks {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
        cards.shuffle()
    }
    func reStart() {
        wordingLabel.text = "請下注開始遊戲"
        remainMoneyLabel.text = "2000"
        betMoneyLabel.text = "0"
        playerSum.text = "0"
        bankerSum.text = "0"
//        for i in 0...4 {
//            playerCards[i].isHidden = true
//        }
    }
}
