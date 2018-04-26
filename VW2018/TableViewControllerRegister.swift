//
//  TableViewControllerRegister.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class TableViewControllerRegister: UITableViewController {

    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var crafter =  Crafter()
    var strings: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCrafter()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.loadStrings()
    }
    
    func loadStrings(){
        
        strings.append("Crafter \(crafter.id)")
        strings.append(crafter.plates)
        strings.append(crafter.model)
        strings.append("Año \(crafter.year)")
        strings[3] = "Año " + (String)(crafter.year)
        strings[4] = "Batería (" + String(crafter.batteries[0].date) + ")"
        strings[5] = "Gasolina"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return strings.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mantenimiento"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = strings[row]
        
        return cell
    }
    
    
    func getCrafter(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let plates = UserDefaults.standard.string(forKey: "registerCrafter")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters?plates=\(plates!)")
        let request = URLRequest(url: url! as URL)
        
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    func processData(data: Data){
        let jsonDecoder = JSONDecoder()
        let array = try? jsonDecoder.decode([Crafter].self, from: data)
        self.crafter = array!.first!
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
