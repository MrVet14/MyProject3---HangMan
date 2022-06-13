//
//  ViewController.swift
//  MyProject3 - HangMan
//
//  Created by Vitali Vyucheiski on 4/1/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var wordToShowOnScreen: UILabel!
    @IBOutlet weak var playersScore: UILabel!
    @IBOutlet weak var numberOfTriesLeft: UILabel!
    @IBAction func buttonToAddCharacter(_ sender: UIButton) {
        promptForLetter()
    }
    @IBOutlet weak var usedLettersDisplay: UILabel!
    
    var allWords = [String]()
    var wordToGuess = [String]()
    var wordToShow = [String]()
    var usedCharacters = [""]
    var numberOfGuessesLeft: Int = 7 {
        didSet {
            numberOfTriesLeft.text = "Tries Left: \(numberOfGuessesLeft)"
        }
    }
    var score = 0 {
        didSet {
            playersScore.text = "Score: \(score)"
        }
    }
    var numberOfRightGuesses = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HangManGameee"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        playersScore.text = "Score: \(score)"
        
        startGame()
    }
    
    
    @objc func startGame() {
        wordToGuess.removeAll()
        wordToShow.removeAll()
        usedCharacters.removeAll()
        numberOfRightGuesses = 0
        
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
                for (index, word) in allWords.enumerated() {
                    if word == "" {
                        allWords[index] = "basic"
                    }
                }
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        for letter in allWords.randomElement()?.uppercased() ?? "SILKWORM" {
            wordToGuess.append(String(letter))
        }
        
        for _ in wordToGuess {
            wordToShow.append("_")
        }
        
        numberOfGuessesLeft = 7
        numberOfTriesLeft.text = "Tries Left: \(numberOfGuessesLeft)"
        
        wordToShowOnScreen.text = wordToShow.joined(separator: "")
        displayUsedLetters()
    }
    
    
    @objc func promptForLetter() {
        let ac = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer.uppercased())
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        var usedChCheck = false
        
        if answer.count == 0 {
            errorOnSubmit(0)
            return
        } else if  answer.count != 1 {
            errorOnSubmit(1)
            return
        }
        
        for ch in usedCharacters {
            if ch == answer {
                usedChCheck = true
            }
            if usedChCheck == true {
                errorOnSubmit(2)
                usedChCheck = false
                return
            }
        }
        
        usedCharacters.append(answer)
        displayUsedLetters()
        
        for (index, letter) in wordToGuess.enumerated() {
            if letter == answer {
                wordToShow[index] = answer
                numberOfRightGuesses += 1
            }
        }
        
        wordToShowOnScreen.text = wordToShow.joined(separator: "")
        numberOfGuessesLeft -= 1
        
        if numberOfRightGuesses == wordToGuess.count {
            playerWon()
            return
        }
        
        if numberOfGuessesLeft == 0 {
            playerLost()
        }
    }
    
    
    func errorOnSubmit(_ numberOfError: Int) {
        let errors = ["You have to enter 1 letter, try again?", "You entered more than 1 character, try again?", "You've already used this character, try again?"]
        
        let ac = UIAlertController(title: errors[numberOfError], message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func playerLost() {
        score = 0
        let ac = UIAlertController(title: "You lost, try again?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: startGameAC))
        present(ac, animated: true)
    }
    func startGameAC(action: UIAlertAction) {
        startGame()
    }
    
    
    func playerWon() {
        score += 1
        let ac = UIAlertController(title: "You WON, try again?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: startGameAC))
        present(ac, animated: true)
    }
    
    func displayUsedLetters() {
        usedLettersDisplay.text = "\"" + usedCharacters.joined(separator: "\" \"") + "\""
    }


}

