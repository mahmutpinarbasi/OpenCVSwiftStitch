//
//  PanaromaViewController.swift
//  SwiftStitch
//
//  Created by Mahmut Pinarbasi on 28.03.2020.
//  Copyright © 2020 Mahmut Pinarbasi. All rights reserved.
//

import UIKit

class PanaromaViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var secondImageView: UIImageView!
    @IBOutlet private weak var thirdImageView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var viewModel: PanaromaViewModelProtocol!
    private let executionQueue = DispatchQueue.init(label: "com.mp.panaromicImage.executionQueue")
    
    // MARK: - View Lifecycle -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = PanaromaViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        bindViewModel()
    }
    
    // MARK - Private -
    private func prepareNavigationBar() {
        let cameraItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped(_:)))
        let resetItem = UIBarButtonItem.init(title: "Reset", style: .plain, target: self, action: #selector(resetTapped(_:)))
        let generateItem = UIBarButtonItem.init(title: "Generate", style: .plain, target: self, action: #selector(generateTapped(_:)))
        self.navigationItem.rightBarButtonItems = [cameraItem, resetItem, generateItem]
    }
    
    private func bindViewModel() {
        viewModel.didResetImages = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.firstImageView.image = nil
            strongSelf.secondImageView.image = nil
            strongSelf.thirdImageView.image = nil
            strongSelf.imageView.image = nil
        }
        
        viewModel.didAddImage = { [weak self] (image, index) in
            guard let strongSelf = self else { return }
            
            switch index {
            case 0:
                strongSelf.firstImageView.image = image
            case 1:
                strongSelf.secondImageView.image = image
            case 2:
                strongSelf.thirdImageView.image = image
            default:
                break
            }
        }
    }
   
    private func startProcess() {
        updateProgressViewVisibility(true)
        let images = self.viewModel.images
        self.executionQueue.async {
            let stitchedImage: UIImage = CVWrapper.process(with: images)
            DispatchQueue.main.async {
                self.imageView.image = stitchedImage
                self.updateProgressViewVisibility(false)
            }
        }
    }
    
    private func updateProgressViewVisibility(_ visible: Bool) {
        if visible {
            self.view.bringSubviewToFront(self.progressView)
            self.activityIndicator.startAnimating()
        } else {
            self.view.sendSubviewToBack(self.progressView)
            self.activityIndicator.stopAnimating()
        }
        self.progressView.isHidden = !visible
    }
    
    // MARK - Private Actions -
    @objc private func cameraTapped(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc private func resetTapped(_ sender: UIBarButtonItem) {
        viewModel.reset()
    }
    
    @objc private func generateTapped(_ sender: UIBarButtonItem) {
        startProcess()
    }
}

extension PanaromaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            viewModel.append(image.convert(to: CGSize(width: 720.0, height: 960.0)))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
