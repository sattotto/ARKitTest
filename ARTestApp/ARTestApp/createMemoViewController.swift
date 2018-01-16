//
//  createMemoViewController.swift
//  ARTestApp
//
//  Created by satoto on 2018/01/15.
//  Copyright © 2018年 佐藤秀輔. All rights reserved.
//

import UIKit

class createMemoViewController: UIViewController {

    @IBOutlet var memoField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.memoField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let homeViewController: ViewController = segue.destination as! ViewController
        homeViewController.memoText = memoField.text
    }
    

}
