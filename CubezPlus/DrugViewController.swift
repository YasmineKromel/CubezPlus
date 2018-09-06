//
//  DrugViewController.swift
//  CubezPlus
//
//  Created by mino on 8/24/18.
//  Copyright © 2018 mino. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseStorage

class DrugViewController: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var DrugName: UITextField!
    @IBOutlet weak var DrugPhoto: UIImageView!
    @IBOutlet weak var DrugPrice: UITextField!
    @IBOutlet weak var DrugAvailabelity: UISwitch!
    @IBOutlet weak var DrugDiagnose: UITextField!
    @IBOutlet weak var DrugManufacture: UITextField!
    
    @IBOutlet weak var SaveBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    var AvailabilityStatus: String = "true"
    var ImageFileName:String?
    
    var Drug : DrugModel?
    var EditMode : Bool = false
    

    
    // DataBase reference
    var dbref : DatabaseReference!
    
    // Image Storage reference
    var imageReference : StorageReference
    {
        return Storage.storage().reference().child("images")
        
    }
    
    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    let imagePickerController = UIImagePickerController()
    
    
    // MARK:DidLoad()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         imagePickerController.delegate = self
       dbref =  Database.database().reference().child("cubezplus-d0790")
      // SaveBtn.isEnabled = true
        
        DrugName.delegate = self
        DrugManufacture.delegate = self
        DrugDiagnose.delegate = self
        DrugPrice.delegate = self
        
        DrugPhoto.isUserInteractionEnabled = true
        
        if let drug = Drug
        {
            EditMode = true
            DrugName.text = drug.DName
            Drug?.ID = drug.ID
            DrugPrice.text = drug.DPrice
            DrugDiagnose.text = drug.DDiagnose
            DrugManufacture.text = drug.DManu
            
            if drug.DAvailablity == "true"
            {
                DrugAvailabelity.isOn = true
            }
            else if drug.DAvailablity == "false"
            {
               DrugAvailabelity.isOn = false
                
            }
      
            
            DownLoad(filename: drug.DPhotoPath, PhotoView:DrugPhoto )
            
        }
             
    }
    
 
    
    // MARK: Actions
    @IBAction func Save(_ sender: UIButton) {
        
        
      if DrugName.text != "" && DrugPrice.text != "" && DrugDiagnose .text != "" && DrugManufacture .text != ""
       {
        
            let nam = self.DrugName.text
            let pric = self.DrugPrice.text
            let diag = self.DrugDiagnose .text
            let manu = self.DrugManufacture.text
        
            if EditMode != true
            {
                 print ("saving mode image that will be uploaded")
                
              //   let myGroup = DispatchGroup()
                
               // let sp = displaySpinner(onView: self.view)
             //   myGroup.enter()
            //
                let sname = UPloadImageToFireBaseStorage()
                 SaveDrug(name: nam!,photopath: sname ,price: pric!, manu: manu!, daignose: diag!, available: AvailabilityStatus)
               // myGroup.leave()
               // myGroup.wait()
                
            //    myGroup.notify(queue: DispatchQueue.main) {
                    
                   
                    print("dismissed")
                    self.dismiss(animated: true, completion: nil)
            //    }
               
                
            }else
                {
                    print(" edit mode image will be delete" )
                    print(Drug?.DPhotoPath)
                    
                    DeleteDrugPhoto(PhotoName: (Drug?.DPhotoPath)!)
                    print ("image that will be uploaded")
                  //  let myGroup = DispatchGroup()
                   // let sp = displaySpinner(onView: self.view)
                   // myGroup.enter()
                    let fname = UPloadImageToFireBaseStorage()
                    SaveDrugWithID(id:(Drug?.ID)! ,name: nam!,photopath: fname ,price: pric!, manu: manu!, daignose: diag!, available: AvailabilityStatus)
                   // myGroup.leave()
                   // myGroup.wait()
                  //  myGroup.notify(queue: DispatchQueue.main) {
                 //   self.removeSpinner(spinner: sp)
                    self.EditMode = false
                    print("dismissed")
                    self.dismiss(animated: true, completion: nil)
                   // }
                    
                    
                }
     }
        else{
            
            let alertController = UIAlertController(title: "Error", message: "Please All Data Required Fill them", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        
         dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        // imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    //MARK:Switch on/off
    
    @IBAction func onAllAccessory(_ sender: UISwitch) {
        
        if DrugAvailabelity.isOn == true
        {
            AvailabilityStatus = "true"
        }
        else
        {
            AvailabilityStatus = "false"
        }
    }


    
    //MARK: Functions - 
   
    // MARK: func- ActiveSaveButton
//    func ActiveSaveButton()
//    {
//        if DrugName.text != "" && DrugPrice.text != "" && DrugDiagnose .text != "" && DrugManufacture .text != ""
//        {
//            SaveBtn.isEnabled = true
//        }
//    }
    
    func DeleteDrugPhoto(PhotoName:String)
    {
        // Create a reference to the file to delete
        let iRef = imageReference.child(PhotoName)
        iRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("deleted successfully")
            }
        }
    }
  
  //MARK: func- SaveDrugData
    
    func SaveDrug(name:String ,photopath:String ,price: String , manu: String , daignose:String , available : String)
    {
        
       dbref.childByAutoId().setValue(["Name":name,"PhotoPath":photopath,"Price":price, "Manu": manu , "Diagnose": daignose, "available": available])
        print("Drug Saved")
    
    }
    
    // update drug with specific Id
    func SaveDrugWithID(id:String, name:String ,photopath:String ,price: String , manu: String , daignose:String , available : String)
    {
        
        dbref?.child(id).updateChildValues(["Name":name,"PhotoPath":photopath,"Price":price, "Manu": manu , "Diagnose": daignose, "available": available])
        print("Drug Saved for specific ID")
        
    }
    
    
    // Mark:func- UploadImageTofirebaseStorage 
    func UPloadImageToFireBaseStorage()->String
    {
        
         let image = DrugPhoto.image
        let imageData = UIImageJPEGRepresentation(image!, 1)
        var filename = ""
        print(ImageFileName)
        print(EditMode)
        if EditMode == true && ImageFileName == nil
        {
            filename = (Drug?.DPhotoPath)!
            return filename
        }
        if EditMode == false && ImageFileName == nil
        {
            filename = String(Date().timeIntervalSinceNow)+"Photo.png"
        }
        else{
    
            filename = String(Date().timeIntervalSinceNow)+ImageFileName!
        }
        print(filename)
        let uploadImageRef = imageReference.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData!, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
         
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        
        uploadTask.resume()
        
        
        return filename
        
  }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // ActiveSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //SaveBtn.isEnabled = false
    }
    
    func DownLoad(filename: String, PhotoView:UIImageView )
        {
        
        let downloadImageRef = imageReference.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                PhotoView.image = image
                PhotoView.contentMode = .scaleAspectFit
            }
            print(error ?? "NO ERROR")
        }
        
                downloadtask.observe(.progress) { (snapshot) in
                    print(snapshot.progress ?? "NO MORE PROGRESS")
                }
        
         downloadtask.resume()
        
    }
    
    // imagepickercancel
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    // call image picker to get an image from user 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        ImageFileName = url.lastPathComponent!
        print(ImageFileName)
        
        // Set photoImageView to display the selected image.
        DrugPhoto.image = selectedImage
        
                
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
   // MARK: RecieveMemoryWarning
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
     func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
