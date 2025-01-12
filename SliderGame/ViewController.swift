//
//  ViewController.swift
//  SliderGame
//
//  Created by Serhii Prysiazhnyi on 12.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var sliderValue = 50
    var score = 0 {
        didSet { scoreLabel.text = "\(score)" }
    }
    var round = 1 {
        didSet { roundLabel.text = "\(round)" }
    }
    var targetValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    @IBAction func showAlertButton(_ sender: UIButton) {
        let diference = abs(targetValue - sliderValue)
        let currentScore = 100 - diference
        
        let title: String
        if diference == 0 {
            title = "Ідеально!"
        } else if diference < 5 {
            title = "Майже вдалося!"
        } else if diference < 10 {
            title = "Непогано!"
        } else {
            title = "Мимо("
        }
        
        let message = "Ваше значеня: \(sliderValue)\nВи набрали: \(currentScore) балів"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in self.newRound()}
        alert.addAction(action)
        present(alert, animated: true)
        
        score += currentScore
        round += 1
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = lroundf(sender.value)
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        score = 0
        round = 1
        newRound()
    }

    func newRound() {
        targetValue = Int.random(in: 1...100)
        targetLabel.text = "\(targetValue)"
        scoreLabel.text = "\(score)"
        roundLabel.text = "\(round)"
    }
}

