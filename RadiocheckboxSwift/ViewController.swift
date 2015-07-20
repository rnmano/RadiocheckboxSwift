//
//  ViewController.swift
//  RadiocheckboxSwift
//
//  Created by Manokaran on 15/07/15.
//  Copyright (c) 2015 Netiapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    
    var btnRect:CGRect!=CGRect()
    var ItemArray : NSMutableArray! = NSMutableArray()
    var addArray : NSMutableArray! = NSMutableArray()
    var itemDic: NSDictionary!=NSDictionary()
    var radioButton:RadioButton!
    var checkbox:UICheckbox!
    
    
    var Scrollview:UIScrollView=UIScrollView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

      //MARK: -  Now  calling the method get from local json file
        
        self.navigationController?.navigationBar.tintColor=UIColor.greenColor()
        readDataFromFile()
        
        self.title="Looking for Catering Services"
        
        self.Scrollview.frame=CGRectMake(0, 66, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-66)
        Scrollview.backgroundColor=UIColor.clearColor()
        self.view.addSubview(self.Scrollview)
        self.ItemArray=self.itemDic.valueForKey("post") as NSMutableArray
        
       self.automaticallyAdjustsScrollViewInsets=false
        
//MARK: - Now create the RadioButton and Checkbox
        
        for var i = 0; i < self.ItemArray.count; i++
        {
            
            var dictionaryval=self.ItemArray.objectAtIndex(i) as NSDictionary
            
//            println(btnRect.origin.y)
            
            var lab:UILabel!=UILabel()
//            println(dictionaryval)
            lab.frame=CGRectMake(0, btnRect.origin.y, self.view.bounds.size.width, 50)
//            println(dictionaryval)
            lab.tag=i
            lab.text=dictionaryval.valueForKey("Keyname") as? String
            lab.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lab.numberOfLines = 0
            self.Scrollview.addSubview(lab)
            var checkType=dictionaryval.valueForKey("Type") as? String
             btnRect = CGRectMake(20, lab.frame.size.height+btnRect.origin.y, 25, 25);
            if((dictionaryval.valueForKey("Type") as NSString).isEqualToString("Radio"))
            {
                
               
                var QAnsIdArray:NSArray=NSArray()
                
                QAnsIdArray=dictionaryval.valueForKey("information") as NSArray
                
                var groupid = String(i)
               
                for var z=0;z<QAnsIdArray.count;z++
                {
                    
                    //radio button assign to groupId and index
                    
                    radioButton=RadioButton(groupId: groupid, index: UInt(z))
                    
                   radioButton.tag=z
                    radioButton.frame = btnRect;
                    
                    var Answer=QAnsIdArray.objectAtIndex(z) as String
                    
                    if((Answer as NSString).isEqualToString("Other"))
                    {
                        
                        
                        
                        
                    }
                    else
                    {
                        
                        var Answerlab:UILabel!=UILabel()
                        Answerlab.frame=CGRectMake(59,  btnRect.origin.y, self.view.bounds.size.width, 25)
                        Answerlab.lineBreakMode=NSLineBreakMode.ByWordWrapping
                        Answerlab.numberOfLines=0
                        Answerlab.text=Answer
                        
                        Scrollview.addSubview(Answerlab)

                        
                        
                    }
                    
                    Scrollview.addSubview(radioButton)
                   btnRect.origin.y+=40;
                    
                    
                     RadioButton.addObserverForGroupId(groupid, observer: self)
                   
                }

            }
            else
            {
                var QAnsIdArray:NSArray=NSArray()
                
                QAnsIdArray=dictionaryval.valueForKey("information") as NSArray
                for var z=0;z<QAnsIdArray.count;z++
                {
                    
                    var Answer=QAnsIdArray.objectAtIndex(z) as String
                    
                    checkbox=UICheckbox()
                    checkbox.frame=btnRect
                    checkbox.backgroundColor=UIColor.clearColor()
                    checkbox.addTarget(self, action:"oncheckButtonValueChanged:", forControlEvents: UIControlEvents.TouchUpInside)
                    checkbox.checked=false
                    checkbox.disabled=false
                    

                    if((Answer as NSString).isEqualToString("Other"))
                    {

                        
                        var Othertxt:UITextField = UITextField(frame: CGRectMake(55,  btnRect.origin.y, 100, 25))
                        Othertxt.tag=z
                        
                        checkbox.tag=z
                        Othertxt.placeholder="Other"
                        
                        Othertxt.layer.borderColor=UIColor.grayColor().CGColor
                        Othertxt.layer.borderWidth=1.0
                        
                        Othertxt.delegate=self
                        Othertxt.resignFirstResponder()
                    
                        Scrollview.addSubview(Othertxt)
                        
                        checkbox.accessibilityHint=Answer
                        

                        
                    }
                    else
                    {
                        
                        
                        checkbox.text=Answer
                        
                        checkbox.tag=z

                        checkbox.accessibilityHint=Answer
              
                        
                        
                    }
                    
                    checkbox.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Left
                    
                    btnRect.origin.y+=40
                    Scrollview.addSubview(checkbox)
                    
                }

            }
            
            Scrollview.contentSize=CGSizeMake(self.view.bounds.size.width, lab.bounds.size.height+btnRect.origin.y)
            
          
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
//MARK: - Load the json from local Food.Json file
    
func readDataFromFile()
    {
        
        
        var url:NSURL!
        
      
        url=NSBundle.mainBundle().URLForResource("Food", withExtension: "json")
        
        var request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response : NSURLResponse?
        var error : NSError?
        var data:NSData!
        
        data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        //MARK: -Now create a NSDictionary from the JSON data

        
        self.itemDic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
       

    
    }
    
//MARK: - radioButton Selected At Index

    func radioButtonSelectedAtIndex(index :Int ,inGroup:NSString)
    {
        
        println(index)
         println(inGroup)
        
    }
   
    
    
//MARK: - On Check Box Selected At Index
    
    func oncheckButtonValueChanged(sender: UICheckbox)
    {
        
        var variable=sender.accessibilityHint
        println(variable)
        println(sender.tag)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
