//
//  ShoutOutEditorViewController.swift
//  ShoutOut

import UIKit
import CoreData

class ShoutOutEditorViewController: UIViewController, ManagedObjectContextDependentType, UIPickerViewDataSource, UIPickerViewDelegate {

    var shoutOut: ShoutOut!
	var managedObjectContext: NSManagedObjectContext!
	@IBOutlet weak var toEmployeePicker: UIPickerView!
	@IBOutlet weak var shoutCategoryPicker: UIPickerView!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var fromTextField: UITextField!
	
    let shoutCategories = [
        "Great Job!",
        "Awesome Work!",
        "Well Done!",
        "Amazing Effort!"]
    
    var employees: [Employee]!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        fetchEmployees()
        
        self.toEmployeePicker.dataSource = self
        self.toEmployeePicker.delegate = self
        toEmployeePicker.tag = 0
        
        self.shoutCategoryPicker.dataSource = self
        self.shoutCategoryPicker.delegate = self
        self.shoutCategoryPicker.tag = 1
        
        self.shoutOut = self.shoutOut ?? NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
        
        setUIValues()
        
		messageTextView.layer.borderWidth = CGFloat(0.5)
		messageTextView.layer.borderColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
		messageTextView.layer.cornerRadius = 5
		messageTextView.clipsToBounds = true
	}

    func setUIValues() {
        let selectedEmployeeRow = self.employees.index(of: self.shoutOut.toEmployee) ?? 0
        self.toEmployeePicker.selectRow(selectedEmployeeRow, inComponent: 0, animated: false)
        
        let selectedShoutOutRow = self.shoutCategories.index(of: self.shoutOut.shoutCategory) ?? 0
        self.shoutCategoryPicker.selectRow(selectedShoutOutRow, inComponent: 0, animated: false)
        
        self.messageTextView.text = self.shoutOut.message
        self.fromTextField.text = self.shoutOut.from
    }
    
    func fetchEmployees() {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(Employee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(Employee.firstName), ascending: true)
        employeeFetchRequest.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
        
        do{
            self.employees = try self.managedObjectContext.fetch(employeeFetchRequest)
        }catch _ {
            employees = []
            print("Something went wrong")
        }
    }
    
	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.managedObjectContext.rollback()
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		let employeeSelectedIndex = self.toEmployeePicker.selectedRow(inComponent: 0)
        let employeeSelected = self.employees[employeeSelectedIndex]
        shoutOut.toEmployee = employeeSelected
        
        let selectedShoutOutCategoryIndex = self.shoutCategoryPicker.selectedRow(inComponent: 0)
        let selectedShoutOutCategory = self.shoutCategories[selectedShoutOutCategoryIndex]
        shoutOut.shoutCategory = selectedShoutOutCategory
        
        self.shoutOut.message = messageTextView.text
        self.shoutOut.from = fromTextField.text ?? "Anonymous"
        
        do {
            try self.managedObjectContext.save()
            dismiss(animated: true, completion: nil)
        } catch _ {
            let alert = UIAlertController(title: "Trouble Saving", message: "Something went wrong when trying to saving the shout out", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
                self.managedObjectContext.rollback()
                self.shoutOut = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName,
                                                                    into: self.managedObjectContext) as! ShoutOut
                
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
	}
    
    // MARK: - UIPickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? self.employees.count : self.shoutCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let employee = self.employees[row]
        return ((pickerView.tag == 0) ? "\(employee.firstName) \(employee.lastName)" : self.shoutCategories[row])
    }
}
