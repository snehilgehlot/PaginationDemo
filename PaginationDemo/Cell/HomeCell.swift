//
//  HomeCell.swift
//  PaginationDemo
//
//  Created by shree on 28/05/24.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet var userId : UILabel!
    @IBOutlet var id : UILabel!
    @IBOutlet var title : UILabel!
    @IBOutlet var body : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(objWelCome : WelcomeElement){
        
        if let userid = objWelCome.userId{
            self.userId.text =  "\(userid)"
        }
        if let id = objWelCome.id{
            self.id.text =  "\(id)"
        }
        if let title = objWelCome.title{
            self.title.text =  title
        }
        if let body = objWelCome.body{
            self.body.text =  body
        }
    
    }
    
}
