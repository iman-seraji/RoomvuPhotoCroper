//
//  ImageCropViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import UIKit
import Alamofire
import Mantis




class ImageCropViewController: UIViewController,ImageProcessingDelegate,UIScrollViewDelegate {
    
  
    var imageOriginal: UIImage?
    var scaleImage = 5

    @IBOutlet weak var imageSlider: UISlider!
    @IBOutlet weak var processedImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUi()
        if let recciveImage = imageOriginal{
            processedImage.image = recciveImage

        }else{
            processedImage.image = UIImage(named: "Image_sample")

        }
      }
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageSlider
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
    
    @IBAction func imageSliderChange(_ sender: UISlider) {
        
        
        let zoomScale = CGFloat(sender.value)
        scrollView.zoomScale = zoomScale
     //  let zoomScale = CGFloat(sender.value)
    //  scrollView.zoomScale = zoomScale
        
      //  scaleImage(processedImage.image!, scale: CGFloat(sender.value))
        
          }
    
    @IBAction func buttonCancel(_ sender: Any) {
      
                        
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundRemoverSwitch(_ sender: UISwitch) {
           
           if sender.isOn{
               if let image = processedImage.image  {
                   
                   performSegue(withIdentifier: "progressView", sender: self)
               }
           }
           
       }
    
    func initUi(){
         // Set up scrollView
         scrollView.minimumZoomScale = 1.0
         scrollView.maximumZoomScale = 6.0
         scrollView.delegate = self
                     
         // Set initial zoom level
         scrollView.zoomScale = 1.0
                     
         // Set up slider
         imageSlider.minimumValue = 1.0
         imageSlider.maximumValue = 6.0
         imageSlider.value = 1.0
        
        imageSlider.addTarget(self, action: #selector(zoomSliderValueChanged(_:)), for: .valueChanged)
     }
    // MARK: - Actions
        
        @objc func zoomSliderValueChanged(_ sender: UISlider) {
            let zoomScale = CGFloat(sender.value)
            scrollView.zoomScale = zoomScale
        }
    // Image Update Delegate
    func didFinishProcessingImage(_ image: UIImage) {
        processedImage.image = image

    }
    
    func showUploadSuccessAlert() {
          let alertController = UIAlertController(title: "Upload Successful", message: "Your image has been uploaded successfully.", preferredStyle: .alert)
          
          let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(okAction)
          
          present(alertController, animated: true, completion: nil)
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
    
   
    
 
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "progressView" {
       
            if let destinationVC = segue.destination as? ProgressViewController {
                destinationVC.uploadImage = processedImage.image
                destinationVC.delegate = self // Set the delegate to self
            }
               
            
           
        }
    }
    
 
    
  
}




