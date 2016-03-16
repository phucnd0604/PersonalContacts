//
//  ListTableViewController.swift
//  Enterprise contacts
//
//  Created by andrey on 3/1/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let reuseIdentifiers = ["directorCell", "employeeCell", "bookkeeperCell"]
    enum Section: Int {
        case director, employee, bookkeeper
    }
    private lazy var fetchedResultsController: FetchedResultsController<Worker> = {
        let fetchRequest = NSFetchRequest(entityName: Worker.entityName)
        let workerTypeSortDescriptor = NSSortDescriptor(key: "workerType", ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        
        fetchRequest.sortDescriptors = [workerTypeSortDescriptor, firstNameSortDescriptor, lastNameSortDescriptor]

        guard let stack = CoreDataStackSingleton.sharedInstance.coreDataStack else {fatalError("CoreDataStack is not set yet")}
        let frc = FetchedResultsController<Worker>(fetchRequest: fetchRequest, managedObjectContext: stack.mainQueueContext, sectionNameKeyPath: "workerType")
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    
    private lazy var frcDelegate: WorkerFetchedResultsControllerDelegate = {
        return WorkerFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPerson")
        self.navigationItem.title = "List"
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var nib = UINib(nibName: "DirectorTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifiers[0])
        nib = UINib(nibName: "EmployeeTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifiers[1])
        nib = UINib(nibName: "BookkeeperTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifiers[2])

        
        do {
            try fetchedResultsController.performFetch()
        } catch{
            print("Cant perform fetch \(error)")
        }
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    //MARK: - Actions
    func addPerson() {
        let workerViewController = WorkerTableViewController()
        workerViewController.adding = true
        self.navigationController?.pushViewController(workerViewController, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let sections = fetchedResultsController.sections else {
            fatalError("sections missing")
        }
        
        let section = sections[indexPath.section]
        let worker = section.objects[indexPath.row]
        print("workerType = \(worker.workerType)")
        guard let workerType = worker.workerType else {fatalError("workerType is nil")}
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifiers[Int(workerType)], forIndexPath: indexPath)
        
        if let sectionNumber = Section(rawValue: Int(workerType)) {
            switch sectionNumber {
            case .director:
                if let director = worker as? Director {
                    (cell as? DirectorTableViewCell)?.configureWithDirector(director)
                }
            case .employee:
                if let employee = worker as? Employee {
                    (cell as? EmployeeTableViewCell)?.configureWithEmployee(employee)
                }
            case .bookkeeper:
                if let bookkeeper = worker as? Bookkeeper {
                    (cell as? BookkeeperTableViewCell)?.configureWithBookkeeper(bookkeeper)
                }
            }
        }
        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let sections = fetchedResultsController.sections else {
                assertionFailure("Sections missing")
                return
            }
            let worker = sections[indexPath.section].objects[indexPath.row]
            CoreDataStackSingleton.sharedInstance.coreDataStack?.mainQueueContext.deleteObject(worker)
            CoreDataStackSingleton.sharedInstance.saveContext()
        }
    }
    
    //preventing re-ordering outside of section
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        guard let sections = fetchedResultsController.sections else {
            assertionFailure("Sections missing")
            return imageView
        }
        
        let section = sections[section]
        let worker = section.objects[0]//guarantee that object exists
        guard let workerType = worker.workerType else {return imageView}
        
        if let sectionNumber = Section(rawValue: Int(workerType)) {
            switch sectionNumber {
            case .director:
                imageView.image = UIImage(named: "director")
            case .employee:
                imageView.image = UIImage(named: "employee")
            case .bookkeeper:
                imageView.image = UIImage(named: "bookkeeper")
            }
        }
        return imageView
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "//Hack for displaying header view for sections
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workerViewController = WorkerTableViewController()
        
        guard let sections = fetchedResultsController.sections else {
            assertionFailure("Sections missing")
            return
        }
        
        let section = sections[indexPath.section]
        let worker = section.objects[indexPath.row]
        guard let workerType = worker.workerType else {return}
        
        if let sectionNumber = Section(rawValue: Int(workerType)) {
            switch sectionNumber {
            case .director:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? DirectorTableViewCell
                workerViewController.director = cell?.director
                workerViewController.initialPersonType = .director
            case .employee:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? EmployeeTableViewCell
                workerViewController.employee = cell?.employee
                workerViewController.initialPersonType = .employee
            case .bookkeeper:
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? BookkeeperTableViewCell
                workerViewController.bookkeeper = cell?.bookkeeper
                workerViewController.initialPersonType = .bookkeeper
            }
        }
        self.navigationController?.pushViewController(workerViewController, animated: true)
    }
    
    
}

//MARK: - FetchedResultsControllerDelegate
class WorkerFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<Worker>) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<Worker>) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<Worker>) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Worker>,
        didChangeObject change: FetchedResultsObjectChange<Worker>) {
            switch change {
            case let .Insert(_, indexPath):
                tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            case let .Delete(_, indexPath):
                tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            case let .Move(_, fromIndexPath, toIndexPath):
                tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
                
            case let .Update(_, indexPath):
                tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Worker>,
        didChangeSection change: FetchedResultsSectionChange<Worker>) {
            switch change {
            case let .Insert(_, index):
                tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
                
            case let .Delete(_, index):
                tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
            }
    }
}
