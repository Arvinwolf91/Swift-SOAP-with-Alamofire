//
//  ViewController.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Krzysztof Deneka on 04.08.2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import UIKit

struct Country {
    var name:String = ""
}

class TableViewController: UITableViewController {

    var countryList = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.getCountries { (result) in
            self.countryList = result
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countryList[indexPath.row].name
        return cell
    }
}

