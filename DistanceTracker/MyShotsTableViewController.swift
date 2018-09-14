//
//  MyShotsTableViewController.swift
//  DistanceTracker
//
//  Created by Henry Bethke on 9/13/18.
//  Copyright © 2018 Henry Bethke. All rights reserved.
//

import Foundation
import UIKit

class MyShotsTableViewController: UITableViewController {
    
    var shots: [Shot] = []
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let row = indexPath.row
        
        let date = formateDate(shots[row].date)
        cell.textLabel?.text = "\(shots[row].distance) yards - \(date)"
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shots.count
    }
    
    func formateDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
}
