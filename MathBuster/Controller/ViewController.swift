//
//  ViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 21.06.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var dataModel: ViewControllerDataModel = ViewControllerDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        generateProblem()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataModel.navigationBarPreviousTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .orange
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sheduleTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = dataModel.navigationBarPreviousTintColor
    }
    
    func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue Bold", size: 22), size: 22)]
        
    }
    
    
    
    func generateProblem() {
        
        let selectedIndex: Int = segmentedControl.selectedSegmentIndex
        let range = dataModel.ranges[selectedIndex]
        
        let firstDigit = Int.random(in: range)
        let arithmeticalOperator: String = ["+", "-", "x", "/"].randomElement()!
        
        var startingInteger: Int = range.lowerBound
        var endingInteger: Int = range.upperBound
        
        
        if arithmeticalOperator == "/" && startingInteger == 0 {
            startingInteger = 1
        }else if arithmeticalOperator == "-"{
            endingInteger = firstDigit
        }
        let secondDigit = Int.random(in: startingInteger...endingInteger)
        
        
        problemLabel.text = "\(firstDigit) \(arithmeticalOperator) \(secondDigit) = "
        
        switch arithmeticalOperator {
        case "+":
            dataModel.result = Double(firstDigit + secondDigit)
        case "-":
            dataModel.result = Double(firstDigit - secondDigit)
        case "x":
            dataModel.result = Double(firstDigit * secondDigit)
        case "/":
            dataModel.result = Double(firstDigit) / Double(secondDigit)
        default:
            dataModel.result = nil
        }
        
    }
    
    func sheduleTimer(){
        dataModel.countDown = 30
        dataModel.timer?.invalidate()
        dataModel.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerUI), userInfo: nil, repeats: true)
    }

    @objc
    func updateTimerUI(){
        dataModel.countDown -= 1
        
        var seconds: String = "\(dataModel.countDown)"
        
        if dataModel.countDown < 10 {
            seconds = "0\(dataModel.countDown)"
        }
        
        timerLabel.text = "00 : \(seconds)"
        progressView.progress = Float(30 - dataModel.countDown) / 30
        
        if dataModel.countDown <= 0{
            finishTheGame()
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let text = resultField.text else {
            print("Text is nil")
            return
        }
        
        guard !text.isEmpty else {
            print("Text is Empty")
            return
        }
        guard let result = Double(text) else {
            print("Couldn't convert text: \(text) to Double")
            return
        }
        
        if result == self.dataModel.result {
            print("Correct answer!")
            let selectedIndex = segmentedControl.selectedSegmentIndex
            dataModel.score += dataModel.scoreAmount[selectedIndex]
            scoreLabel.text = "Score: \(dataModel.score)"
        }else{
            print("Incorrect answer!")
        }
        
        generateProblem()
        resultField.text = nil
    }
    
    @IBAction func insertButtonPressed(_ sender: Any) {
        restart()
    }
    
    func restart() {
        dataModel.score = 0
        scoreLabel.text = "Score: 0"
        
        generateProblem()
        sheduleTimer()
        
        resultField.isEnabled = true
        submitButton.isEnabled = true
    }
    
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("Selected Index: \(sender.selectedSegmentIndex)")
        restart()
    }
    
    func finishTheGame(){
        dataModel.timer?.invalidate()
        resultField.isEnabled = false
        submitButton.isEnabled = false
        
        askForName()
    }
    
    func askForName() {
        let alertController = UIAlertController(title: "Game is Over", message: "Save your score: \(dataModel.score)", preferredStyle: .alert)
        alertController.addTextField { placeholderText in
            placeholderText.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first else{
                return
            }
            guard let text = textField.text, !text.isEmpty else {
                print("Text is nil or empty")
                return
            }
            print("Name: \(text)")
            
//            self.saveUserScore(name: text)
            self.saveUserScoreAsStruct(name: text)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func saveUserScoreAsStruct(name: String) {
        let userScore: UserScore = UserScore(name: name, score: dataModel.score)
        
        var level: Level?
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            level = .easy
        case 1:
            level = .medium
        case 2:
            level = .hard
        default:
            ()
    }
        
        guard let level = level else {
            print("Level is nil because index out of [1,2,3]")
            return
        }
        
        
        let userScoreArray: [UserScore] = ViewController.getAllUserScore(level: level) + [userScore]
        
        do{
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(userScoreArray)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: level.key())
            
            
        } catch {
            print("Couldn't encode given [UserScore] into data with error: \(error.localizedDescription)")
        }
        //get all previously save users
    }
    
    static func getAllUserScore(level: Level) -> [UserScore] {
        var result: [UserScore] = []
        
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: level.key()) as? Data {
            
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode([UserScore].self, from: data)
                
            } catch {
                print("couldn't decode given data to [UserScore with error \(error.localizedDescription)")
            }
            
        }
        
        return result
    }
    
    func saveUserScore(name: String) {
        let userScore: [String: Any] = ["name": name, "score": dataModel.score]
        let userScoreArray: [[String: Any]] = getUserScoreArray() + [userScore]
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userScoreArray, forKey: ViewControllerDataModel.userScoreKey)
    }
    
    func getUserScoreArray() -> [[String:Any]] {
        let userDefaults = UserDefaults.standard
        let array = userDefaults.array(forKey: ViewControllerDataModel.userScoreKey) as? [[String:Any]]
        return array ?? []
    }
}

struct ViewControllerDataModel {
    var timer: Timer?
    var countDown: Int = 30
    var result: Double?
    var score: Int = 0
    var ranges = [0...9, 10...99, 100...999]
    var scoreAmount = [1, 2, 3]
    
    var navigationBarPreviousTintColor: UIColor?
    
    static let userScoreKey: String = "userScore"
}

struct UserScore: Codable {
    let name: String
    let score: Int
}

enum Level {
    case easy
    case medium
    case hard
    
    func key() -> String {
        switch self {
        case .easy:
            return "easyUserScore"
        case .medium:
            return "mediumUserScore"
        case .hard:
            return "hardUserScore"
        }
    }
}



