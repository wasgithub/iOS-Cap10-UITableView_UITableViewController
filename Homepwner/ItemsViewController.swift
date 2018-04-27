import UIKit


class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    let sections = ["A", "B"]
    
    @IBAction func addNewItem(_ sender: UIButton) {

        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        return itemStore.allItems.count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Lista"//sections[section]
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        print (statusBarHeight)
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        let footerView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        footerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        footerView.textAlignment = .center
        footerView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        
        
        footerView.text = "No more items!"
        footerView.font = UIFont(name:"Arial", size: 18)
        tableView.tableFooterView = footerView
        
        //redimensionamento automatico
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        //tableView.rowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! ItemCell
        
        //let section = indexPath.section
        print(indexPath.section)
        print(indexPath)
        
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = "$\(item.valueInDollars)"

        //configure the cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        
        if (item.valueInDollars < 50){
            cell.valueLabel.textColor = .red
        } else{
            cell.valueLabel.textColor = .green
        }
        cell.valueLabel.text = "$\(item.valueInDollars)"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1//sections.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive,
                                             handler: { (action) -> Void in

            // Remove the item from the stores
            self.itemStore.removeItem(item)
            // Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            ac.addAction(deleteAction)
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            // Update the model
        to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            } default:
                preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    

}
