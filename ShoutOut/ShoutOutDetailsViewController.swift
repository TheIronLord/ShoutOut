//
//  ShoutOutDetailsViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutDetailsViewController: UIViewController, ManagedObjectContextDependentType {
    
    var shoutOut: ShoutOut!

	var managedObjectContext: NSManagedObjectContext!
	@IBOutlet weak var shoutCategoryLabel: UILabel!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var fromLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let navigationController = segue.destination as! UINavigationController
		let destinationVC = navigationController.viewControllers[0] as! ShoutOutEditorViewController
		destinationVC.managedObjectContext = self.managedObjectContext
    }
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete ShoutOut", message: "Are your sure you want to delete this?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) -> Void in
            // write code to delete ShoutOut
            self.managedObjectContext.delete(self.shoutOut)
            
            do {
                try self.managedObjectContext.save()
            } catch _ {
                self.managedObjectContext.rollback()
                print("Something went wrong: \(Error)")
            }
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        alertController.present(alertController, animated: true, completion: nil)
    }
}
