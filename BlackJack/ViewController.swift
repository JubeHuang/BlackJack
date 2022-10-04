//
//  ViewController.swift
//  BlackJack
//
//  Created by JubeHuang黃冬伊 on 2022/10/4.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet var playerCards: [UIImageView]!
    @IBOutlet weak var wordingLabel: UILabel!
    @IBOutlet weak var bankerSum: UILabel!
    @IBOutlet weak var playerSum: UILabel!
    @IBOutlet weak var remainMoneyLabel: UILabel!
    @IBOutlet weak var betMoneyLabel: UILabel!
    let suits = ["club", "spade", "heart", "diamond"]
    let ranks = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"]
//    var playerCards = [Card]()
//    var bankerCards = [Card]()
    var cards = [Card]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
    }

    @IBAction func deal(_ sender: UIButton) {
    }
    @IBAction func addMinusBetMoney(_ sender: UIButton) {
    }
    @IBAction func stand(_ sender: UIButton) {
    }
    @IBAction func hit(_ sender: UIButton) {
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
}
