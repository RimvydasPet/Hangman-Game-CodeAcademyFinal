import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var hangmanImgView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var guessesRemainingLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    let defaults = UserDefaults.standard
    var totalScore = 0 {
        didSet {
            defaults.set(totalScore, forKey: Constants.scoreKey)
        }
    }
    var wordLetterArray = [String]()
    var word = ""
    var maskedWord = ""
    var maskedWordArray = [String]()
    var wordStrings = [String]()
    var level = 1
    var levelCompleted = false
    var usedLetters = ""
    var hangmanImgNumber = 0 {
        
        didSet {
            hangmanImgView.image = UIImage(named: "\(Constants.hangmanImg)\(hangmanImgNumber)")
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Points: \(score)"
        }
    }
    
    var livesRemaining = 10 {
        didSet {
            guessesRemainingLabel.text = "Lives remaining: \(livesRemaining)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        totalScore = defaults.integer(forKey: Constants.scoreKey)
        loadGame()
    }
    
    @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterChosen = sender.currentTitle?.lowercased() else { return }
        
        usedLetters.append(letterChosen)
        if wordLetterArray.contains(letterChosen) {
            for (index, letter) in wordLetterArray.enumerated() {
                if letterChosen == letter {
                    maskedWordArray[index] = letter
                }
            }
            
            maskedWord = maskedWordArray.joined()
            score += 1
            totalScore += 1
        
        } else {
            score -= 1
            totalScore -= 1
            hangmanImgNumber += 1
            livesRemaining -= 1
            
        }
        
        sender.isEnabled = false
        sender.setTitleColor(UIColor(named: Constants.Colours.labelColour), for: .disabled)
        wordLabel.text = maskedWord
        checkToSeeIfCompleted()
        
        if livesRemaining <= 1 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        if levelCompleted {
            for button in letterButtons {
                button.isEnabled = true
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            levelCompleted = false
        }        
    }
    
    func loadGame() {
        if let fileURL = Bundle.main.url(forResource: Constants.wordsURL.fileName, withExtension: Constants.wordsURL.fileExtension) {
            if let wordContents = try? String(contentsOf: fileURL) {
                var lines = wordContents.components(separatedBy: "\n")
                lines.shuffle()
                wordStrings += lines
            }
        } else {
            showAlertAction(title: "Error", message: "There was an error fetching data, please try again!", actionClosure: {
                [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            return
        }
        loadWord()
    }

    func checkToSeeIfCompleted() {
        if livesRemaining > 0 {
            if maskedWord == word {
                showAlertAction(title: "You Won", message: "Try another word", actionTitle: "Play again", actionClosure: self.loadWord)
                nextLevel()
                score = 0
            }
            
        } else {
            showAlertAction(title: "You Lost", message: "The word was \"\(word.uppercased())\"!", actionTitle: "Play again", actionClosure: self.loadWord)
            nextLevel()
            score = 0
        }
    }
    
    func loadWord() {
        wordLetterArray = [String]()
        word = ""
        maskedWord = ""
        maskedWordArray = [String]()
        livesRemaining = 10
        hangmanImgNumber = 0

        word = wordStrings[level]
        for letter in wordStrings[level] {
            wordLetterArray.append(String(letter))
        }
        print(wordLetterArray)
        print(word)
        for _ in 0..<wordLetterArray.count {
            maskedWord += "🔑"
            maskedWordArray.append("🔑")
        }
        wordLabel.text = maskedWord
    }
    
    func nextLevel() {
        level += 1
        levelCompleted = true
    }

    private func formatUI(){
        hangmanImgView.image = UIImage(named: "\(Constants.hangmanImg)\(hangmanImgNumber)")
        scoreLabel.text = "0 points"
        for button in letterButtons {
            button.setTitleColor(UIColor(named: Constants.Colours.labelColour), for: .normal)
        }
    }
}

