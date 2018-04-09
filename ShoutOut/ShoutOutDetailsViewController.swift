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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil) { (notification: Notification) in
                                                if let updateShoutOut = notification.userInfo?[NSUpdatedObjectsKey] as? Set<ShoutOut> {
                                                    self.shoutOut = updateShoutOut.first
                                                    self.setUIValues()
                                                }
        }
        setUIValues()
    }
	
    func setUIValues(){
        self.shoutCategoryLabel.text = shoutOut.shoutCategory
        self.messageTextView.text = shoutOut.message
        self.fromLabel.text = shoutOut.from
    }
    
	// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let navigationController = segue.destination as! UINavigationController
		let destinationVC = navigationController.viewControllers[0] as! ShoutOutEditorViewController
		destinationVC.managedObjectContext = self.managedObjectContext
        
        destinationVC.shoutOut = self.shoutOut
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
                print("Something went wrong")
            }
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
}
