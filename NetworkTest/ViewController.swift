//
//  ViewController.swift
//  NetworkTest
//
//  Created by Decagon on 10/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
    }
    @IBAction func btnClicked(_ sender: Any) {
        progressLbl.isHidden = false
        progressBar.progress = 0
        downloadImageView.image = UIImage()
        let urlString = "https://d3re0f381bckq9.cloudfront.net/46415737_laptop-hp-laptop-jumia-laptops-macbook-pro-hp-pavilion-hp-elitebook-laptop-price-hp-pavilion-15-notebook-apple-laptop-dell-laptops-hp-15-lenovo-laptop-hp-laptop-price-hp-envy-hp-pro6_1500x1125.jpg"
        guard let url = URL(string: urlString) else {
            print("this is an invalid url")
            return
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        session.downloadTask(with: url).resume()
    }
}

extension ViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("the data couldn't be loaded")
            return
        }
        let image = UIImage(data: data)
        DispatchQueue.main.async { [weak self] in
            self?.downloadImageView.image = image
            self?.progressLbl.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async { [weak self] in
            self?.progressBar.progress = progress
            self?.progressLbl.text = "\(Int(progress * 100))%"
        }
    }
}
