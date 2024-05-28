//
//  ViewController.swift
//  PaginationDemo
//
//  Created by shree on 28/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    var objWelcomeViewModal = WelcomeViewModal()
    @IBOutlet var tblHome : UITableView!
    let customIndicator = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var isLastCellVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tblHome.register(nib, forCellReuseIdentifier: "HomeCell")
        
        tblHome.rowHeight = UITableView.automaticDimension
        tblHome.estimatedRowHeight = 100 //
        
        self.fetch()
        self.observation()
    }
    
    func fetch(){
        
        print("page count - ", MyVariables.pageCount)
        self.showIndicator()
        objWelcomeViewModal.fetchProduct()
    }
    
    func observation(){
       
        objWelcomeViewModal.eventHandler = {[weak self] response in
            guard let self else {return}
            
            switch response {
            case .loadIndicator:
                print("loading")
            case .stopIndicator :
                print("stop indicator")
            case .loadData:
                DispatchQueue.main.async {
                    self.hideIndicator()
                    self.tblHome.reloadData()
                }
               
            default:
                break
            }
             
        }
    }
    
    
    func showIndicator(){
        view.showActivityIndicator()
    }
    
    func hideIndicator(){
        // Simulate a network request or a long-running task
        DispatchQueue.main.async {
            self.view.hideActivityIndicator()
        }
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objWelcomeViewModal.objWelCome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
        cell?.configureCell(objWelCome: self.objWelcomeViewModal.objWelCome[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate and return the height based on the cell's content
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           let height = scrollView.frame.size.height

           if offsetY > contentHeight - height - 10 { // Add a small buffer
               if !isLastCellVisible {
                   isLastCellVisible = true
                   // Perform your action here
                   MyVariables.pageCount += 1
                   self.fetch()
                   
                   
                   print("Last cell is visible")
               }
           } else {
               isLastCellVisible = false
           }
       }
}

