//
//  FeedTableVC.swift
//  Instagramclone
//
//  Created by McKinney family  on 6/30/19.
//  Copyright © 2019 FasTek Technologies. All rights reserved.
//

import UIKit
import Parse

class FeedTableVC: UITableViewController {

    var messages = [String]()
    var userNames = [String]()
    var imageFiles = [PFFileObject]()
    
    
    
    var users = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for object in users {
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
                
            }
            let getFolloweredUserQuery = PFQuery(className: "Followers")
            
            getFolloweredUserQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            
            getFolloweredUserQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    for object in followers {
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userid", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let posts = objects {
                                    for object in posts {
                                        if let post = object as? PFObject {
                                            self.messages.append(post["message"] as! String)
                                            
                                            self.imageFiles.append(post["imageFile"] as! PFFileObject)
                                            
                                            self.userNames.append(self.users[post["userid"] as! String]!)
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            })
                            
                        }
                    }
                }
            })
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell

        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
            
                if let downloadedImage = UIImage(data: imageData) {
                
                    cell.postedImage.image = downloadedImage
            }
        }
            
        }
 
        
        cell.postedImage.image = UIImage(named: "Image")
        
        cell.usernameLbl.text = userNames[indexPath.row]
        cell.messageLbl.text = messages[indexPath.row]

        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
