//
//  PanaromaViewModel.swift
//  SwiftStitch
//
//  Created by Mahmut Pinarbasi on 28.03.2020.
//  Copyright © 2020 Mahmut Pinarbasi. All rights reserved.
//

import Foundation

protocol PanaromaViewModelProtocol {
    var images: [UIImage] { get }
    
    func append(_ image: UIImage)
    func reset()
    
    var didResetImages: (() -> (Void))? { get set }
    var didAddImage: ((_ image: UIImage, _ imageIndex: Int) -> (Void))? { get set }
}

private enum ImageIndex: Int {
    case first = 0
    case second = 1
    case third = 2
}

class PanaromaViewModel: PanaromaViewModelProtocol {
    
    private static let maxElement = 3
    private(set) var images: [UIImage]
    private var currentIndex: Int = -1
    
    var didResetImages: (() -> ())?
    var didAddImage: ((_ image: UIImage, _ imageIndex: Int) -> (Void))?
    
    init() {
        self.images = [UIImage]()
    }
    
    // MARK: - PanaromaViewModelProtocol -
    func append(_ image: UIImage) {
        if currentIndex + 1 >= Self.maxElement {
            reset()
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        images.append(image)
        let newIndex = currentIndex
        DispatchQueue.main.async {
            self.didAddImage?(image, newIndex)
        }
    }
    
    func reset() {
        images.removeAll()
        
        DispatchQueue.main.async {
            self.didResetImages?()
        }
    }
}
