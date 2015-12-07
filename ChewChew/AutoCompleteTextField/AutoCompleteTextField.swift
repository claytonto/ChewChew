//
//  AutoCompleteTextField.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 6/13/15.
//  Copyright (c) 2015 MaiLin. All rights reserved.
//

import Foundation
import UIKit

public class AutoCompleteTextField:UITextField, UITableViewDataSource, UITableViewDelegate{
    /// Manages the instance of tableview
    private var autoCompleteTableView:UITableView?
    /// Holds the collection of attributed strings
    private var attributedAutoCompleteStrings:[NSAttributedString]?
    /// Handles user selection action on autocomplete table view
    public var onSelect:(String, NSIndexPath)->() = {_,_ in}
    /// Handles textfield's textchanged
    public var onTextChange:(String)->() = {_ in}
    
    /// Font for the text suggestions
    public var autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
    /// Color of the text suggestions
    public var autoCompleteTextColor = UIColor.blackColor()
    /// Used to set the height of cell for each suggestions
    public var autoCompleteCellHeight:CGFloat = 44.0
    /// The maximum visible suggestion
    public var maximumAutoCompleteCount = 2
    /// Used to set your own preferred separator inset
    public var autoCompleteSeparatorInset = UIEdgeInsetsZero
    /// Shows autocomplete text with formatting
    public var enableAttributedText = false
    /// User Defined Attributes
    public var autoCompleteAttributes:[String:AnyObject]?
    // Hides autocomplete tableview after selecting a suggestion
    public var hidesWhenSelected = true
    /// Hides autocomplete tableview when the textfield is empty
    public var hidesWhenEmpty:Bool?{
        didSet{
            assert(hidesWhenEmpty != nil, "hideWhenEmpty cannot be set to nil")
            autoCompleteTableView?.hidden = hidesWhenEmpty!
        }
    }
    /// The table view height
    public var autoCompleteTableHeight:CGFloat?{
        didSet{
            redrawTable()
        }
    }
    /// The strings to be shown on as suggestions, setting the value of this automatically reload the tableview
    public var autoCompleteStrings:[String]?{
        didSet{ reload() }
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupAutocompleteTable(superview!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        setupAutocompleteTable(superview!)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        commonInit()
        setupAutocompleteTable(newSuperview!)
    }
    
    private func commonInit(){
        hidesWhenEmpty = true
        autoCompleteAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]
        autoCompleteAttributes![NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.clearButtonMode = .Always
        self.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
    }
    
    private func setupAutocompleteTable(view:UIView){
        let screenSize = UIScreen.mainScreen().bounds.size
        let tableView = UITableView(frame: CGRectMake(self.frame.origin.x - 130, self.frame.origin.y + CGRectGetHeight(self.frame) - 61, screenSize.width - 142, 30.0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = autoCompleteCellHeight
        tableView.hidden = hidesWhenEmpty ?? true
        view.addSubview(tableView)
        autoCompleteTableView = tableView
        
        autoCompleteTableHeight = 85.0
    }
    
    private func redrawTable(){
        if autoCompleteTableView != nil{
            var newFrame = autoCompleteTableView!.frame
            newFrame.size.height = autoCompleteTableHeight!
            autoCompleteTableView!.frame = newFrame
        }
    }
    
    //MARK: - UITableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteStrings != nil ? (autoCompleteStrings!.count > maximumAutoCompleteCount ? maximumAutoCompleteCount : autoCompleteStrings!.count) : 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        if enableAttributedText{
            cell?.textLabel?.attributedText = attributedAutoCompleteStrings![indexPath.row]
        }
        else{
            cell?.textLabel?.font = autoCompleteTextFont
            cell?.textLabel?.textColor = autoCompleteTextColor
            cell?.textLabel?.text = autoCompleteStrings![indexPath.row]
        }
        
        return cell!
    }
    
    //MARK: - UITableViewDelegate
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        onSelect(cell!.textLabel!.text!, indexPath)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            tableView.hidden = self.hidesWhenSelected
        })
    }
    
    public func hideSuggestions() {
        autoCompleteTableView?.hidden = true
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:"){
            cell.separatorInset = autoCompleteSeparatorInset}
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:"){
            cell.preservesSuperviewLayoutMargins = false}
        if cell.respondsToSelector("setLayoutMargins:"){
            cell.layoutMargins = autoCompleteSeparatorInset}
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
    
    //MARK: - Private Interface
    private func reload(){
        if enableAttributedText{
            let attrs = [NSForegroundColorAttributeName:autoCompleteTextColor, NSFontAttributeName:UIFont.systemFontOfSize(12.0)]
            if attributedAutoCompleteStrings == nil{
                attributedAutoCompleteStrings = [NSAttributedString]()
            }
            else{
                if attributedAutoCompleteStrings?.count > 0 {
                    attributedAutoCompleteStrings?.removeAll(keepCapacity: false)
                }
            }
            
            if autoCompleteStrings != nil{
                for i in 0..<autoCompleteStrings!.count{
                    let str = autoCompleteStrings![i] as NSString
                    let range = str.rangeOfString(text!, options: .CaseInsensitiveSearch)
                    let attString = NSMutableAttributedString(string: autoCompleteStrings![i], attributes: attrs)
                    attString.addAttributes(autoCompleteAttributes!, range: range)
                    attributedAutoCompleteStrings?.append(attString)
                }
            }
        }
        autoCompleteTableView?.reloadData()
    }
    
    //MARK: - Internal
    func textFieldDidChange(){
        onTextChange(text!)
        if text!.isEmpty{ autoCompleteStrings = nil }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.autoCompleteTableView?.hidden =  self.hidesWhenEmpty! ? self.text!.isEmpty : false
        })
    }
}