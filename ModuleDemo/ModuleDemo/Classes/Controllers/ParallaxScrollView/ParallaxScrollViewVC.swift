//
//  ParallaxScrollViewVC.swift
//  ModuleDemo
//
//  Created by Le Thi An on 3/2/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

let NAVBAR_CHANGE_POINT:CGFloat = 50

class ParallaxScrollViewVC: UIViewController {

    //MARK: Outlets & Variables
    
    @IBOutlet var header: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var consTopHeaderImgToHeaderView: NSLayoutConstraint!
    @IBOutlet weak var consBottomHeaderImgToHeaderView: NSLayoutConstraint!
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let navbar:UINavigationBar! =  self.navigationController?.navigationBar
        navbar.translucent = true
        self.automaticallyAdjustsScrollViewInsets = false
    
        navbar.lt_setBackgroundColor(UIColor.clearColor())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha:CGFloat = min(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
        
        if scrollView.contentOffset.y >= 0 {
            // scrolling down
            header.clipsToBounds = true
            consBottomHeaderImgToHeaderView?.constant = -scrollView.contentOffset.y / 2
            consTopHeaderImgToHeaderView?.constant = scrollView.contentOffset.y / 2
        } else {
            // scrolling up
            consTopHeaderImgToHeaderView?.constant = scrollView.contentOffset.y
            header.clipsToBounds = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
        self.scrollViewDidScroll(self.tableView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.barStyle = .Default
        self.navigationController!.navigationBar.lt_reset()
    }
    
}

//MARK: UITableViewDataSource methods
extension ParallaxScrollViewVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell") as! TextCell
        return cell
    }
}

//MARK: UITableViewDelegate methods
extension ParallaxScrollViewVC: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
}
