//
//  ViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var upgradeView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var windTurbineView: UIView!
    @IBOutlet var closeUpgradeViewButton: UIButton!
    
    @IBAction func upgradeViewButton(_ sender: Any) {
        if upgradeView.isHidden { showUpgradeView() }
    }
    @IBAction func closeUpgradeView(_ sender: Any) {
        hideUpgradeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        windTurbineView.addSubview(WindTurbineView(frame: windTurbineView.frame))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}



