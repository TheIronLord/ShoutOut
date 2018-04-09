//
//  ViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutDraftsViewController: UIViewController,
									UITableViewDataSource,
									UITableViewDelegate,
									ManagedObjectContextDependentType,
                                    NSFetchedResultsControllerDelegate {

	@IBOutlet weak var tableView: UITableView!
	var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController<ShoutOut>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        configureFetchedResultsController()
        
        do {
            try fetchResultsController.performFetch()
        } catch _ {
            let alertController = UIAlertController(title: "Loading ShoutOuts Failed", message: "There was a problem loading the list of ShoutOuts", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
	}
	
    func configureFetchedResultsController() {
        let shoutOutRequests = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.firstName), ascending: true)
        shoutOutRequests.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
        
        self.fetchResultsController = NSFetchedResultsController<ShoutOut>(fetchRequest: shoutOutRequests,
                                                                 managedObjectContext: self.managedObjectContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        
        self.fetchResultsController.delegate = self
    }
    
	// MARK: TableView Data Source methods
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return nil
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
		
        let shoutOut = fetchResultsController.object(at: indexPath)
        
		cell.textLabel?.text = "\(shoutOut.toEmployee.firstName) \(shoutOut.toEmployee.lastName)"
		cell.detailTextLabel?.text = shoutOut.shoutCategory
		
		return cell
	}
	
	// MARK: TableView Delegate methods
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
    // MARK: NSFetchedResultsController Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = self.tableView.cellForRow(at: updateIndexPath)
                let updateShoutOut = self.fetchResultsController.object(at: updateIndexPath)
                
                cell?.textLabel?.text = "\(updateShoutOut.toEmployee.firstName) \(updateShoutOut.toEmployee.lastName)"
                cell?.detailTextLabel?.text = updateShoutOut.shoutCategory
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        }
    }
    
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier! {
		case "shoutOutDetails":
			let destinationVC = segue.destination as! ShoutOutDetailsViewController
			destinationVC.managedObjectContext = self.managedObjectContext
            
            let selectedIndexPath = self.tableView.indexPathForSelectedRow!
            let selectedShoutOut = fetchResultsController.object(at: selectedIndexPath)
            
            destinationVC.shoutOut = selectedShoutOut
		case "addShoutOut":
			let navigationController = segue.destination as! UINavigationController
			let destinationVC = navigationController.viewControllers[0] as! ShoutOutEditorViewController
			destinationVC.managedObjectContext = self.managedObjectContext
		default:
			break
		}
	}
}






