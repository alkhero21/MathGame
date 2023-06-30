//
//  UserScoreViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 27.06.2023.
//

import UIKit

class UserScoreViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [UserScoreSection] = [] {
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
        
        tableView.refreshControl?.endRefreshing()
        
        var easyScoreList = ViewController.getAllUserScore(level: .easy)
        easyScoreList.sort { userScore1 , userScore2 in
            return userScore1.score > userScore2.score
        }
        let easySection = UserScoreSection(list: easyScoreList, title: "Easy")
        
        var mediumScoreList = ViewController.getAllUserScore(level: .medium)
        mediumScoreList.sort {userScore1 , userScore2 in
                return userScore1.score > userScore2.score
            }
        let mediumSection = UserScoreSection(list: mediumScoreList, title: "Medium")
        
        var hardScoreList = ViewController.getAllUserScore(level: .hard)
        hardScoreList.sort {userScore1 , userScore2 in
            return userScore1.score > userScore2.score
        }
        let hardSection = UserScoreSection(list: hardScoreList, title: "Hard")
        
        
        self.dataSource = [easySection, mediumSection, hardSection]
        
                                                           
        
//        self.userScoreArrayOfDicitionaries = ViewController.getAllUserScore()
        
    }
    
    
    func getSingleUserText(indexPath: IndexPath) -> String? {
        let userScore: UserScore = dataSource[indexPath.section].list[indexPath.row]
        let text = "Name: \(userScore.name),  Score: \(userScore.score) \n"
        return text
    }
    
}

//MARK: UITableViewDatasource & UITableViewDelegate

extension UserScoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        cell.scoreTextLabel.text = getSingleUserText(indexPath: indexPath)

        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return 200
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ScoreDetailViewController()
        viewController.text = getSingleUserText(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}

struct UserScoreSection {
    let list: [UserScore]
    let title: String
}


