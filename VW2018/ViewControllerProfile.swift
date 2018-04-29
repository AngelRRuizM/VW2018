//
//  ViewControllerProfile.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerProfile: UIViewController{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var driver = Driver()
    var changePass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getDriver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if changePass {
            let view = segue.destination as! ViewControllerChangePassword
            view.driver = driver
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Hace get del driver
    func getDriver(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let email = UserDefaults.standard.string(forKey: "email")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/drivers?email=\(email!)")
        let request = URLRequest(url: url! as URL)
        //Petición a la URL especificada, con el email definido.
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //Si la petición es exitosa, llama a procesar la información
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
    
    //Hace el procesamiento de la información del conductor
    func processData(data: Data){
        print(data)
        let jsonDecoder = JSONDecoder()
        let array = try? jsonDecoder.decode([Driver].self, from: data)
        
        self.driver = array!.first!
        nameLabel.text = driver.name
        self.setStars()
    }
    
    //Pone las estrellas de acuerdo al rating del conductor
    func setStars(){
        if driver.rating >= 1{
            star1.image = #imageLiteral(resourceName: "star")
        }
        if driver.rating >= 2 {
            star2.image = #imageLiteral(resourceName: "star")
        }
        if driver.rating >= 3 {
            star3.image = #imageLiteral(resourceName: "star")
        }
        if driver.rating >= 4 {
            star4.image = #imageLiteral(resourceName: "star")
        }
        if driver.rating >= 5 {
            star5.image = #imageLiteral(resourceName: "star")
        }
    }
    
    //Hace cambio de contraseña, cambiando la vista
    @IBAction func changePass(_ sender: Any) {
        changePass = true
        self.performSegue(withIdentifier: "toChangePassword", sender: self)
    }
    
    //Logout
    @IBAction func logOut(_ sender: Any) {
        //Hace set del email.
        changePass = false
        let x = UserDefaults.standard
        x.set(nil, forKey: "email")
        x.synchronize()
        x.set(nil, forKey: "crafter")
        x.synchronize()
        x.set(nil, forKey: "id")
        x.synchronize()
        self.performSegue(withIdentifier: "toLogIn", sender: self)
    }
    
    
    
}
