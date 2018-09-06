//
//  FirebaseStorageViewController.swift
//  CubezPlus
//
//  Created by mino on 8/28/18.
//  Copyright © 2018 mino. All rights reserved.
//

import UIKit
import  FirebaseStorage

class FirebaseStorageViewController: UIViewController {
    
    
    
    @IBOutlet weak var UploadImageView: UIImageView!
    
    @IBOutlet weak var DownloadImageView: UIImageView!
    
    let filename = "defaultPhoto.png"

    var imageReference : StorageReference
    {
     return Storage.storage().reference().child("images")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func Upload(_ sender: UIButton) {
        
        guard let image = UploadImageView.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }
        
        
        
        let uploadImageRef = imageReference.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        uploadTask.resume()
    }
    
    
    @IBAction func DownLoad(_ sender: UIButton) {
        
        
        let downloadImageRef = imageReference.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.DownloadImageView.image = image
            }
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
        
    
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
