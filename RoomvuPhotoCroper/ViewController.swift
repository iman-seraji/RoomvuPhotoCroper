//
//  ViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/3/24.
//

import UIKit
import CropViewController

class ViewController: UIViewController {
    func didFinishProcessing(_ lable: String) {
        nameLable.text = lable
        print(lable)
    }
    
    @IBOutlet weak var nameLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }


    @IBAction func selectButton(_ sender: Any) {
        

       
        
//        
//        let piker = UIImagePickerController()
//        piker.sourceType = .photoLibrary
//        present(piker, animated: true)
    }
}

