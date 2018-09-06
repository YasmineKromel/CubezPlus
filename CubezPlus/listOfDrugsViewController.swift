//
//  listOfDrugsViewController.swift
//  CubezPlus
//
//  Created by mino on 8/28/18.
//  Copyright © 2018 mino. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

import os.log


class listOfDrugsViewController: UIViewController , UITableViewDelegate,UITableViewDataSource  {
    
    
    
    @IBOutlet weak var TableViewDrugsList: UITableView!
    
    var dbref : DatabaseReference!
    var DrugsData = [DrugModel]()
    
    var imageReference : StorageReference
    {
        return Storage.storage().reference().child("images")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
         dbref =  Database.database().reference().child("cubezplus-d0790")
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        TableViewDrugsList.dataSource = self
        TableViewDrugsList.delegate = self
        
       // GetDrugs()
        // self.TableViewDrugsList.backgroundColor = UIColor.black
        // self.TableViewDrugsList.isOpaque = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GetDrugs()
      // self.TableViewDrugsList.reloadData()
        
    }
    
  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    
    // count cells and return them
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DrugsData.count ?? 0
    }
    
    // fill every cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = TableViewDrugsList.dequeueReusableCell(withIdentifier:"DrugTableViewCell", for: indexPath) as! DrugTableViewCell
        
        let drug = DrugsData[indexPath.row]
        
        cell.DrugTitle.text = drug.DName
        cell.DrugPrice.text = drug.DPrice
        cell.DrugCurrency.text = "EGP"
        if drug.DAvailablity == "true"
        {
           cell.IsStocked.text = "Stocked"
            cell.IsStocked.backgroundColor = UIColor.green
        }
        else if drug.DAvailablity == "false"
        {
            cell.IsStocked.text = "Out Of Stock"
            cell.IsStocked.backgroundColor = UIColor.red
            
        }
        DownLoad(filename: drug.DPhotoPath, PhotoView: cell.PhotoOfDrug)
        return cell
        
    }
    
    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  
    
   
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let selectedDrug = DrugsData[indexPath.row]
            let keyValue = selectedDrug.ID
            let drugPhotoPath = selectedDrug.DPhotoPath
            DeleteDrug(key: keyValue)
            DeleteDrugPhoto(PhotoName:drugPhotoPath)
        
            DrugsData.remove(at: indexPath.row)
            TableViewDrugsList.deleteRows(at: [indexPath], with: .fade)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func DownLoad(filename: String, PhotoView:UIImageView) {
        
        let downloadImageRef = imageReference.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                PhotoView.image = image
                PhotoView.contentMode = .scaleAspectFit
            }
            print(error ?? "NO ERROR")
        }
        
//        downloadtask.observe(.progress) { (snapshot) in
//            print(snapshot.progress ?? "NO MORE PROGRESS")
//        }
        
       // downloadtask.resume()
        
        
    }

    
    func GetDrugs()
    {
        
           // observing the data changes (Get All Data)
             dbref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.DrugsData.removeAll()
                
                //iterating through all the values
                for drug in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let drugObject = drug.value as? [String: AnyObject]
                    let drugName = drugObject?["Name"]
                    let drugPhotopath = drugObject?["PhotoPath"]
                    let drugPrice = drugObject?["Price"]
                    let drugDiagnose = drugObject?["Diagnose"]
                    let drugManu = drugObject?["Manu"]
                    let drugAvail = drugObject?["available"]
                    let drugID = drug.key
                   
                    
                    //creating artist object with model and fetched values
                    let Drug = DrugModel(id:drugID as! String, name:drugName as! String,photo:drugPhotopath as! String,price:drugPrice as! String,manu:drugManu as! String , diag:drugDiagnose as! String,avail :drugAvail as! String)                  //appending it to list
                    self.DrugsData.append(Drug)
                   
                }
                 print("Succeed to bring data ")
                
                //reloading the tableview
                self.TableViewDrugsList.reloadData()
            }
            else{
                print("No values")
            }
        })
        
        
    }
    
    // delete drug from list view
    
    func DeleteDrug(key:String)
    {
       dbref?.child(key).setValue(nil)
        print ("Drug Deleted")
        
    }
    
    // delte drug photo from firebase storage
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
    
    // Editing navigation controller status
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        
        let status = navigationItem.leftBarButtonItem?.title      
        
        
        if status == "Edit" {
            
            TableViewDrugsList.isEditing = true
            
            navigationItem.leftBarButtonItem?.title = "Done"
            
        }
            
        else {
            
            TableViewDrugsList.isEditing = false
            
            navigationItem.leftBarButtonItem?.title = "Edit"
            
        }
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? "") {
            
        case "AddDrug":
            os_log("Adding a new Drug.", log: OSLog.default, type: .debug)
            
        case "ShowDrugDetails":
            guard let DrugDetailViewController = segue.destination as? DrugViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDrugCell = sender as? DrugTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = TableViewDrugsList.indexPath(for: selectedDrugCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDrug = DrugsData[indexPath.row]
            DrugDetailViewController.Drug = selectedDrug
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }

    }
    

}
