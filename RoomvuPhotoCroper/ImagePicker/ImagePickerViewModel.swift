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
     @Published var photos: [PHAsset] = []

     private var cancellables = Set<AnyCancellable>()

     init() {
         fetchPhotos()
     }

     func fetchPhotos() {
         
         let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
         
         
         PHPhotoLibrary.requestAuthorization { [weak self] status in
             guard status == .authorized else { return }
             let assets = PHAsset.fetchAssets(with: .image, options: nil)
             var fetchedPhotos: [PHAsset] = []
             assets.enumerateObjects { (asset, _, _) in
                 fetchedPhotos.append(asset)
             }
             DispatchQueue.main.async {
                 
                 self?.photos = fetchedPhotos
             }
         }
     }
 }
