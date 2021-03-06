//
//  InboxViewController.swift
//  Place-it
//
//  Created by Ilona Michalowska on 11/5/14.
//  Copyright (c) 2014 Ilona Michalowska & Irina Kalashnikova. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {
    

    @IBOutlet weak var CancelBarButton: UIBarButtonItem!
    @IBOutlet weak var InboxMessagesTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Inbox"

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returning to View--Update the list of messages:
    override func viewWillAppear(animated: Bool) {
        InboxMessagesTableView.reloadData()
    }
    
    
    // Optional function for UITableViewDelegate--Delete functionality for the table:
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            var tempMessage: message = inboxMessageMgr.removeMessage(indexPath.row)
            
            // Append tempMessage to Trash array
            trashMessageMgr.addMessage(tempMessage.sender, receiver_arg: tempMessage.receiver, place_arg: tempMessage.place, time_arg: tempMessage.time, content_arg: tempMessage.content, timeOfCreating_arg: tempMessage.timeOfCreating, ID_arg: tempMessage.ID)
            
            //Update the Table View:
            InboxMessagesTableView.reloadData()
        }
    }
    
    
    // Mandatory function for UITableViewDataSource (tell the table how many rows it needs to render):
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return inboxMessageMgr.messages.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    // Mandatory function for UITableViewDataSource (create cells in the table)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell_i: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        // might be incorrect...
        cell_i.textLabel?.text = inboxMessageMgr.messages[indexPath.row].sender
        cell_i.detailTextLabel?.text = inboxMessageMgr.messages[indexPath.row].content
        cell_i.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell_i
    }
    
    
    // Select & Display
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        // Create an Instance of From-ToVC
        var detail: From_ToVC = self.storyboard?.instantiateViewControllerWithIdentifier("From_ToVC") as From_ToVC
        
        // Assign message details
        detail.From = inboxMessageMgr.messages[indexPath.row].sender
        detail.To = inboxMessageMgr.messages[indexPath.row].receiver
        detail.Where = inboxMessageMgr.messages[indexPath.row].place
        detail.When = inboxMessageMgr.messages[indexPath.row].time
        detail.What = inboxMessageMgr.messages[indexPath.row].content
        detail.realTime = "Sent on: " + inboxMessageMgr.messages[indexPath.row].timeOfCreating
        
        // Programmatically push to associated VC (To-FromVC)
        self.navigationController?.pushViewController(detail, animated: true)
        
        
        /*
        // Get the row data for the selected row
        messageToEdit = draftsMessageMgr.messages[indexPath.row]
        indexToEdit = indexPath.row
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "Message selected"
        //alert.message = "Now you can Edit"
        alert.addButtonWithTitle("Ok")
        alert.show()*/
        
    }

    

}
