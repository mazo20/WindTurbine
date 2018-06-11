//
//  UITableView+Extension.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 11.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
}
