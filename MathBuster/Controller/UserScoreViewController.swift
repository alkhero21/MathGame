//
//  UserScoreViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 27.06.2023.
//

import UIKit

class UserScoreViewController: UIViewController, UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
//    let cellSpacingHeight: CGFloat = 5
    
    var userScoreArrayOfDicitionaries: [[String: Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getUserScore()
        
        navigationItem.titleView?.tintColor = .orange
        navigationController?.navigationItem.titleView?.tintColor = .systemOrange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        
        
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
        
//        var text:String = ""
//
//        userScoreArrayOfDictionaries.forEach{ dictionary in
//            if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
//                text += "Name: \(name),  Score \(score) \n"
//            }
//
//        }
        
        self.userScoreArrayOfDicitionaries = userScoreArrayOfDictionaries
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScoreArrayOfDicitionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        let dictionary: [String: Any] = userScoreArrayOfDicitionaries[indexPath.row]
        if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
            cell.scoreTextLabel.text = "Name: \(name),  Score \(score) \n"
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return cellSpacingHeight
//    }
    
    

}
