//
//  ImagePickerViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import UIKit
import Photos
import Combine




class ImagePickerCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     
    private var viewModel = ImagePickerViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var images = [PHAsset]()
    var selecctedImage :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view layout
               if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.minimumInteritemSpacing = 0
                   layout.minimumLineSpacing = 0
                   
                   // Calculate the item size based on the collection view's width
                   let itemWidth = (collectionView.bounds.width) / 3
                   layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // You can adjust the height as per your requirement
               }

        bindViewModel()
    }
    

    
    private func bindViewModel() {
         viewModel.$photos
             .receive(on: DispatchQueue.main)
             .sink { [weak self] photos in
                 self?.images = photos
                 self?.collectionView.reloadData()
                 

             }
             .store(in: &cancellables)
     }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as? ImagePickerCollectionViewCell else {
            fatalError("no cell")
        }
    
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        // Set the target for your button
        cell.imageButton.tag = indexPath.item
              
              // Add the target for the button
              cell.imageButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        let options = PHImageRequestOptions()
           options.isSynchronous = true // For simplicity, set to synchronous, but consider using asynchronous requests in production code

        manager.requestImage(for: asset, targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFit, options: options) {image, _ in
            
           
                
                cell.imageButton.setImage(image, for: .normal)
                
           
        }
    
        return cell
    }
    
    func showImagePicker(with asset: PHAsset) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }

        // Do something with the selected image
        // For example, you can display it in an image view
        // Or you can process it further
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
 
    @objc func buttonTapped(_ sender: UIButton) {
            let index = sender.tag
            print("Button tapped in cell at index \(index)")
        let asset = self.images[index]
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
           options.isSynchronous = true // For simplicity, set to synchronous, but consider using asynchronous requests in production code

        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) {image, _ in
            
           
                
            self.selecctedImage = image
            self.performSegue(withIdentifier: "imageCropView", sender: self)
           
        }
            // Handle button tap here
        }
    
    
  
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "imageCropView" {
   
        if let destinationVC = segue.destination as? EditHeadShotViewController {
            destinationVC.imageOriginal = selecctedImage
        }
           
        
       
    }
}
 
    // MARK: UICollectionViewDelegate
    

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
