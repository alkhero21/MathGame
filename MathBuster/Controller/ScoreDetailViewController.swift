//
//  ScoreDetailViewController.swift
//  MathBuster
//
//  Created by Alibek Allamzharov on 29.06.2023.
//

import UIKit

class ScoreDetailViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    var text: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textLabel.text = text
    }

    @IBAction func goBackButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
