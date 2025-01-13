//
//  ViewController.swift
//  SliderGame
//
//  Created by Serhii Prysiazhnyi on 12.01.2025.
//

import UIKit
import AVFAudio

class ViewController: UIViewController {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var audioPlayerPerfect: AVAudioPlayer? // Для идеального попадания
    var audioPlayerMiss: AVAudioPlayer? // Для промаха
    
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
        
        let thumbImageNormal = UIImage(named: "ballYellow")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImagePressed = UIImage(named: "ballGrey")
        slider.setThumbImage(thumbImagePressed, for: .highlighted)
        
        let trackLeftImage = UIImage(named: "slotBaseBad")
        slider.setMinimumTrackImage(trackLeftImage, for: .normal)
        
        let trackRightImage = UIImage(named: "slotBaseGood")
        slider.setMaximumTrackImage(trackRightImage, for: .normal)
        
        newRound()
        loadSounds()
    }
    
    @IBAction func showAlertButton(_ sender: UIButton) {
        let diference = abs(targetValue - sliderValue)
        var currentScore = 100 - diference
        
        let title: String
        if diference == 0 {
            title = "Ідеально!"
            audioPlayerPerfect?.play()
            currentScore += 100
        } else if diference < 5 {
            title = "Майже вдалося!"
            currentScore += 50
            audioPlayerPerfect?.play()
        } else if diference < 10 {
            title = "Непогано!"
            audioPlayerPerfect?.play()
        } else {
            title = "Мимо("
            audioPlayerMiss?.play()
        }
        
        let message = "Ваше значеня: \(sliderValue)\nВи набрали: \(currentScore) балів"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            self.score += currentScore
            self.round += 1
            self.newRound()
        }
        alert.addAction(action)
        present(alert, animated: true)
        
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
    
    func loadSounds() {
        // Загрузка звука для идеального попадания
        if let perfectSoundURL = Bundle.main.url(forResource: "crowd-applause", withExtension: "wav") {
            do {
                audioPlayerPerfect = try AVAudioPlayer(contentsOf: perfectSoundURL)
                audioPlayerPerfect?.prepareToPlay()
            } catch {
                print("Ошибка загрузки звука perfectSound: \(error.localizedDescription)")
            }
        }
        
        // Загрузка звука для промаха
        if let missSoundURL = Bundle.main.url(forResource: "laugh-high-pitch", withExtension: "wav") {
            do {
                audioPlayerMiss = try AVAudioPlayer(contentsOf: missSoundURL)
                audioPlayerMiss?.prepareToPlay()
            } catch {
                print("Ошибка загрузки звука missSound: \(error.localizedDescription)")
            }
        }
    }
    
}
