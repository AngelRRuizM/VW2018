//
//  ViewController.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Checar si email es nil. Si no lo es, ya hizo login
        if UserDefaults.standard.string(forKey: "email") != nil {
            print("lol")
            self.performSegue(withIdentifier: "toCrafter", sender: self)
        }
        else{
            print("lol2")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logIn(_ sender: Any) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let user = username.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let pass = password.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/drivers?email=\(user)&password=\(pass)")
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
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? [Any]{
            if array.count == 1{
                //Hace set del email.
                let x = UserDefaults.standard
                x.set(username.text!, forKey: "email")
                x.synchronize()
                self.performSegue(withIdentifier: "toCrafter", sender: self)
                //Agregar lo de guardar en la plist
            }
            else{
                let alert = UIAlertController(title: "Inicio de sesión", message: "Usuario o contraseña invalidos", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    
    @IBAction func forgottenPassword(_ sender: Any) {
        
        if (username.text?.isEmpty)!{
            let alert = UIAlertController(title: "Contraseña", message: "Por favor introduzca su correo electronico", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Contraseña", message: "Una liga para restablecer su contraseña se ha enviado a su correo", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
}

