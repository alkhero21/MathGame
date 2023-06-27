//
//  UserScoreViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 27.06.2023.
//

import UIKit

class UserScoreViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserScore()
    }
    

    func getUserScore() {
        let userDefaults = UserDefaults.standard
        guard let userScore = userDefaults.array(forKey: ViewController.userScoreKey) else {
            print("UserDefaults doesn't contain array with key : \(ViewController.userScoreKey)")
            return
        }
        
        guard let userScoreArrayOfDictionaries = userScore as? [[String: Any]] else {
            print("Couldn't convert Any to [[String: Any]]")
            return
        }
        
        var text:String = ""
        
        userScoreArrayOfDictionaries.forEach{ dictionary in
            if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
                text += "Name: \(name),  Score \(score) \n"
            }
            
        }
        
        textLabel.text = text
        
    }

}
