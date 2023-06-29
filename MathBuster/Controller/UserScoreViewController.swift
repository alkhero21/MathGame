//
//  UserScoreViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 27.06.2023.
//

import UIKit

class UserScoreViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 5
    
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
        
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getUserScore), for: .valueChanged)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getUserScore()
        
        navigationItem.titleView?.tintColor = .orange
        navigationController?.navigationItem.titleView?.tintColor = .systemOrange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
    }

    @objc func getUserScore() {
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
        tableView.refreshControl?.endRefreshing()
        
        self.userScoreArrayOfDicitionaries = userScoreArrayOfDictionaries
        
    }
    
    
    func getSingleUserText(index: Int) -> String? {
        let dictionary: [String: Any] = userScoreArrayOfDicitionaries[index]
        guard let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int else{
            return nil
        }
        let text = "Name: \(name),  Score \(score) \n"
        return text
    }
    
}

//MARK: UITableViewDatasource & UITableViewDelegate

extension UserScoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScoreArrayOfDicitionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        cell.scoreTextLabel.text = getSingleUserText(index: indexPath.row)

        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ScoreDetailViewController()
        viewController.text = getSingleUserText(index: indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
