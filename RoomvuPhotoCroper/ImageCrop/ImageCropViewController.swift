//
//  ImageCropViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import UIKit
import Alamofire
import Mantis




class ImageCropViewController: UIViewController,ImageProcessingDelegate {
    
  
    var imageOriginal: UIImage?

    @IBOutlet weak var imageSlider: UISlider!
    
    @IBOutlet weak var processedImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      }
    
    // Image Update Delegate
    func didFinishProcessingImage(_ image: UIImage) {
        processedImage.image = image

    }
  
 
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonRotat(_ sender: Any) {
        imageOriginal = processedImage.image
        processedImage.image = rotateImage(imageOriginal, byDegrees: 90)
        
        
   
    }
    
    

    @IBAction func buttonUploadHeadshot(_ sender: Any) {
   
       
        showUploadSuccessAlert()
    }

    func showUploadSuccessAlert() {
        let alertController = UIAlertController(title: "Upload Successful", message: "Your image has been uploaded successfully.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
 
    
    @IBAction func imageSliderChange(_ sender: UISlider) {
   
     
          }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scaleImage(_ image: UIImage, scale: CGFloat) -> UIImage {
         let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
         UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
         image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
         let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return scaledImage ?? image
     }
    
    
    func rotateImage(_ image: UIImage?, byDegrees degrees: CGFloat) -> UIImage? {
           guard let originalImage = image else { return nil }
           
           // Begin image context
           UIGraphicsBeginImageContextWithOptions(originalImage.size, false, originalImage.scale)
           
           // Perform image rotation
           let context = UIGraphicsGetCurrentContext()!
           context.translateBy(x: originalImage.size.width / 2, y: originalImage.size.height / 2)
           context.rotate(by: degrees * CGFloat.pi / 180)
           originalImage.draw(in: CGRect(x: -originalImage.size.width / 2, y: -originalImage.size.height / 2, width: originalImage.size.width, height: originalImage.size.height))
           
           // Get rotated image
           let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
           
           // End image context
           UIGraphicsEndImageContext()
           
           return rotatedImage
       }
    
   
    
 
    @IBAction func backgroundRemoverSwitch(_ sender: UISwitch) {
        
        if sender.isOn{
            if let image = processedImage.image  {
                
                performSegue(withIdentifier: "progressView", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "progressView" {
       
            if let destinationVC = segue.destination as? ProgressViewController {
                destinationVC.uploadImage = processedImage.image
                destinationVC.delegate = self // Set the delegate to self
            }
               
            
           
        }
    }
    
 
    
  
}




