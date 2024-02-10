//
//  ProgressViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/6/24.
//

import UIKit
import Alamofire

protocol ImageProcessingDelegate {
    func didFinishProcessingImage(_ image: UIImage)
}

class ProgressViewController: UIViewController {
 
    
   
     var delegate: ImageProcessingDelegate?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var prossesLable: UILabel!
    
    @IBOutlet weak var cofeeImage: UIImageView!
    var uploadImage: UIImage?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        if let sendImage = uploadImage {
            
            uploadImageWithAPI(image: sendImage)

        }
      
    }
    
  
    
    
    func uploadImageWithAPI(image: UIImage) {
        // API endpoint
        let url = ApiInfo.UserImage.Value

        // Image data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to get image data")
            return
        }
        
        // Headers
        let headers: HTTPHeaders = [
            "token": ApiInfo.apiToken,
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        // Request parameters
        let parameters: [String: Any] = [
            "image": imageData
        ]
        // Perform the request
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            }
        }, to: url, method: .post, headers: headers)
        .validate()
        .uploadProgress{ progress in
            
            DispatchQueue.main.async {
                   self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
                   self.prossesLable.text = "\(Int(progress.fractionCompleted * 100))% Processed..."
                   
                   if progress.isFinished {
                       // Dismiss the progress view controller when the upload is complete
                      
                   }
               }
            
        }
        .responseJSON { response in
            switch response.result {
            case .success(let value):
               // print("Upload Success: \(value)")
                               
                //If you have a Codable struct, you can also decode directly
                let decoder = JSONDecoder()
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                 let decodedObject = try? decoder.decode(ApiResponse.self, from: jsonData) {
                    print("Decoded Object: \(decodedObject)")

                    //delegate?.didFinishProcessingImage(processedImage)

                    DispatchQueue.main.async {
                        
                        if let base64ImageData = decodedObject.data?.enhanced_user_image{
                            
                            let prefix = "data:image/png;base64,"
                            var base64String = base64ImageData

                            // Remove the prefix if present
                            if base64ImageData.hasPrefix(prefix) {
                                base64String = String(base64ImageData.dropFirst(prefix.count))
                                
                                if let newImageData = Data(base64Encoded: base64String,options: .ignoreUnknownCharacters){
                                    if  let generatedImage = UIImage(data: newImageData){
                                       // self.cofeeImage.image = generatedImage
                                        self.delegate?.didFinishProcessingImage(generatedImage)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        
                        
                    }
    
                
                }
            case .failure(let error):
                print("Upload Failure: \(error)")
                // Handle failure response here
            }
        }
    }
    
 
 
    
    
    
    

}
