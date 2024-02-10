//
//  testViewController.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/9/24.
//

import UIKit

class testViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up scrollView
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        
        // Set initial zoom level
        scrollView.zoomScale = 1.0
        
        // Set up slider
        zoomSlider.minimumValue = 1.0
        zoomSlider.maximumValue = 6.0
        zoomSlider.value = 1.0
        zoomSlider.addTarget(self, action: #selector(zoomSliderValueChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - Actions
    
    @objc func zoomSliderValueChanged(_ sender: UISlider) {
        let zoomScale = CGFloat(sender.value)
        scrollView.zoomScale = zoomScale
    }
}
