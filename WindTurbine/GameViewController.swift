//
//  ViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var lightningCountView: UIView!
    @IBOutlet var levelView: UIView!
    @IBOutlet var upgradeView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var windTurbineView: WindTurbineView!
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
        //windTurbineView.addSubview(WindTurbineView(frame: windTurbineView.frame))
        //upgradeView.isHidden = true
        hideUpgradeView()
        moneyLabel.layer.cornerRadius = 40
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        print("Wind turbine tapped")
        windTurbineView.rpm += 5.0
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        cell.textLabel?.text = "Extra wind"
        cell.detailTextLabel?.text = "$\(indexPath.row*100)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}



