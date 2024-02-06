//
//  ImagePickerViewModel.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import Foundation
import Photos
import Combine

 class ImagePickerViewModel{
    
    
   
   @Published var photoLibraryImages = [PHAsset]()

     func fetchLibraryPhotos(){
         
        PHPhotoLibrary.requestAuthorization { [weak self] status in
        print(status)
            if status == .authorized {
                
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object,_, _) in
                    print(object)
                    
                    
                    
                    self?.photoLibraryImages.append(object)
                }
                self?.photoLibraryImages.reverse()
            
                
            }
        }
    }
    
}
