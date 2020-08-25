//
//  ViewController.swift
//  share-to-instagram-like-spotify
//
//  Created by ARIF on 11/08/20.
//  Copyright © 2020 aR&D. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var btnShare: UIButton!
    
    var storyImg = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bundle = Bundle(for: ShareViewContent.self)
        let contentView = UINib(nibName: "ShareViewContent", bundle: bundle)
        let contentViewShow = contentView.instantiate(withOwner: self, options: nil)[0] as! ShareViewContent
        self.storyImg = contentViewShow.asImage()
    }
    
    @IBAction func shareBtn(_ sender: UIButton) {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                //                guard let image = self.shareImg else { return }
                guard let imageData = self.storyImg.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                if #available(iOS 10, *) {
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                    ]
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Sorry the application is not installed")
            }
        }
    }
    
}

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

