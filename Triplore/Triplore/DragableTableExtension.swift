//
//  DragableTableExtension.swift
//  DragableTableExtension
//
//  Created by huangwenchen on 16/9/8.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import ObjectiveC
import UIKit

@objc public protocol DragableTableDelegate:AnyObject{
    
    /**
     A cell is moved from FromIndexPath to toIndexPath,you need to adjust your model here
     - parameter tableView: tableview
     - parameter fromIndexPath: from indexPath
     - parameter toIndexPath: toIndexPath
     - returns: void
     */
    func tableView(_ tableView:UITableView, dragCellFrom fromIndexPath:IndexPath, toIndexPath:IndexPath)
    
    /**
     A cell is moved from FromIndexPath over overIndexPath, you need to adjust your model here
     - parameter tableView: tableview
     - parameter fromIndexPath: from indexPath
     - parameter overIndexPath: overIndexPath
     - returns: void
     */
    @objc optional func tableView(_ tableView:UITableView, dragCellFrom fromIndexPath:IndexPath, overIndexPath:IndexPath)
    
    /**
     Weather a cell is dragable
     
     - parameter tableView: tableView
     - parameter indexPath: target indexPath
     - parameter point:     point that in tableview Cell
     
     - returns: dragable or not
     */
    @objc optional func tableView(_ tableView: UITableView, canDragCellFrom indexPath: IndexPath, withTouchPoint point:CGPoint) -> Bool
    
    /**
     Weather a cell is sticky during dragging
     
     - parameter tableView: tableview
     - parameter indexPath: toIndex
     
     - returns: sticky or not
     */
    @objc optional func tableView(_ tableView: UITableView, canDragCellTo indexPath: IndexPath) -> Bool
    
    /**
     Weather a cell is sticky during dragging
     
     - parameter tableView: tableview
     - parameter indexPath: toIndex
     
     - returns: sticky or not
     */
    @objc optional func tableView(_ tableView: UITableView, canDragCellFrom fromIndexPath: IndexPath, over overIndexPath: IndexPath) -> Bool

    /**
     Called when the screenshot imageView center change
     
     - parameter tableView: tableView
     - parameter imageView: screenshot
     */
    @objc optional func tableView(_ tableView: UITableView,dragableImageView imageView: UIImageView)

	
	@objc optional func tableView(_ tableView: UITableView, endDragCellTo indexPath: IndexPath)
}

/// A class to hold propertys
private class DragableHelper:NSObject,UIGestureRecognizerDelegate{
    
    weak var draggingCell:UITableViewCell?
    let displayLink: _DisplayLink
    let gesture: UILongPressGestureRecognizer
    let floatImageView: UIImageView
    
    weak var attachTableView:UITableView?
    var scrollSpeed: CGFloat = 0.0
    init(tableView: UITableView, displayLink:_DisplayLink, gesture:UILongPressGestureRecognizer,floatImageView:UIImageView) {
        self.displayLink = displayLink
        self.gesture = gesture
        self.floatImageView = floatImageView
        self.attachTableView = tableView
        super.init()
        self.gesture.delegate = self
    }
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let attachTableView = attachTableView else{
            return false
        }
        return attachTableView.lh_gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
public extension UITableView{
    fileprivate struct OBJC_Key{
        static var dragableDelegateKey = 0
        static var dragableHelperKey = 1
        static var dragableKey = 2
        static var dragablePaddingTopKey = 3
    }
    // MARK: - Associated propertys -
    public var dragableDelegate:DragableTableDelegate?{
        get{
            return objc_getAssociatedObject(self, &OBJC_Key.dragableDelegateKey) as? DragableTableDelegate
        }
        set{
            objc_setAssociatedObject(self, &OBJC_Key.dragableDelegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    public var dragable:Bool{
        get{
            let number = objc_getAssociatedObject(self, &OBJC_Key.dragableKey) as! NSNumber
            return number.boolValue
        }
        set{
            if newValue {
                setupDragable()
            }else{
                cleanDragable()
            }
            let number = NSNumber(value: newValue as Bool)
            objc_setAssociatedObject(self, &OBJC_Key.dragableDelegateKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    /// The padding you want before trigger scroll up
    public var paddingTop:CGFloat{
        get{
            let number = objc_getAssociatedObject(self, &OBJC_Key.dragablePaddingTopKey) as? NSNumber
            guard let num = number else{
                return 0.0;
            }
            return CGFloat(num.floatValue)
        }
        set{
            let number = NSNumber(value: Float(newValue) as Float)
            objc_setAssociatedObject(self, &OBJC_Key.dragablePaddingTopKey, number, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    fileprivate var dragableHelper:DragableHelper?{
        get{
            return objc_getAssociatedObject(self, &OBJC_Key.dragableHelperKey) as? DragableHelper
        }
        set{
            objc_setAssociatedObject(self, &OBJC_Key.dragableHelperKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    // MARK: - Private set up -
    fileprivate func setupDragable(){
        if dragableHelper != nil{
            cleanDragable()
        }
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(UITableView.handleLongPress))
        addGestureRecognizer(longPressGesture)
        let displayLink = _DisplayLink{ [unowned self] in
            guard let dragableHelper = self.dragableHelper else{
                return
            }
            self.contentOffset.y = min(max(0.0, self.contentOffset.y + dragableHelper.scrollSpeed),self.contentSize.height - self.frame.height)
            self.adjusFloatImageViewCenterY(dragableHelper.gesture.location(in: self).y)
        }
        
        let imageView = UIImageView()
        let helper = DragableHelper(tableView:self,displayLink: displayLink, gesture: longPressGesture, floatImageView: imageView)
        dragableHelper = helper
    }
    fileprivate func cleanDragable(){
        guard let helper = dragableHelper else{
            return
        }
        removeGestureRecognizer(helper.gesture)
        dragableHelper = nil
    }
    
    // MARK: - Handle gesture and display link-
    @objc fileprivate func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        assert(dragableDelegate != nil, "You must set delegate")
        guard let dragableHelper = dragableHelper else{
            return
        }
        let location = gesture.location(in: self)
        switch gesture.state {
        case .began:
            guard let currentIndexPath = indexPathForRow(at: location),let currentCell = cellForRow(at: currentIndexPath) else {
                return
            }
            if let selectedRow = indexPathForSelectedRow{
                deselectRow(at: selectedRow, animated: false)
            }
            allowsSelection = false
            currentCell.isHighlighted = false
            dragableHelper.draggingCell = currentCell
            //Configure imageview
            let screenShot = currentCell.lh_screenShot()
            dragableHelper.floatImageView.image = screenShot
            
            dragableHelper.floatImageView.frame = currentCell.bounds
            dragableHelper.floatImageView.center = currentCell.center
            self.dragableDelegate?.tableView?(self, dragableImageView: dragableHelper.floatImageView)
            dragableHelper.floatImageView.layer.shadowRadius = 5.0
            dragableHelper.floatImageView.layer.shadowOpacity = 0.2
            dragableHelper.floatImageView.layer.shadowOffset = CGSize.zero
            dragableHelper.floatImageView.layer.shadowPath = UIBezierPath(rect: dragableHelper.floatImageView.bounds).cgPath
            addSubview(dragableHelper.floatImageView)
            
            UIView.animate(withDuration: 0.2, animations: {
                dragableHelper.floatImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                dragableHelper.floatImageView.alpha = 0.5
            })
            currentCell.isHidden =  true
        case .changed:
            adjusFloatImageViewCenterY(location.y)
            dragableHelper.scrollSpeed = 0.0
            //Refer from here https://github.com/okla/QuickRearrangeTableView/blob/master/QuickRearrangeTableView.swift
            if contentSize.height > frame.height {
                let halfCellHeight = dragableHelper.floatImageView.frame.size.height / 2.0
                let cellCenterToTop = dragableHelper.floatImageView.center.y - bounds.origin.y - paddingTop
                self.dragableDelegate?.tableView?(self, dragableImageView: dragableHelper.floatImageView)
                if cellCenterToTop < halfCellHeight {
                    dragableHelper.scrollSpeed = 5.0*(cellCenterToTop/halfCellHeight - 1.1)
                }
                else if cellCenterToTop > frame.height - halfCellHeight {
                    dragableHelper.scrollSpeed = 5.0*((cellCenterToTop - frame.height)/halfCellHeight + 1.1)
                }
                dragableHelper.displayLink.paused = (dragableHelper.scrollSpeed == 0)
            }
        default:
            allowsSelection = true
            dragableHelper.displayLink.paused = true
            if adjustFinalCellOrderIfNecessary() {
                UIView.animate(withDuration: 0.2,
                               animations: {
                                dragableHelper.floatImageView.transform = CGAffineTransform.identity
                                dragableHelper.floatImageView.alpha = 1.0
                },
                               completion: { (completed) in
                                dragableHelper.floatImageView.removeFromSuperview()
                                dragableHelper.draggingCell?.isHidden = false
                                dragableHelper.draggingCell = nil
								if let currentIndexPath = self.indexPathForRow(at: location) {
									self.dragableDelegate?.tableView?(self, endDragCellTo: currentIndexPath)
								}
                })
            } else {
                UIView.animate(withDuration: 0.2,
                                           animations: {
                                            dragableHelper.floatImageView.transform = CGAffineTransform.identity
                                            dragableHelper.floatImageView.alpha = 1.0
                                            dragableHelper.floatImageView.frame = dragableHelper.draggingCell!.frame
                    },
                                           completion: { (completed) in
                                            dragableHelper.floatImageView.removeFromSuperview()
                                            dragableHelper.draggingCell?.isHidden = false
                                            dragableHelper.draggingCell = nil
											if let currentIndexPath = self.indexPathForRow(at: location) {
												self.dragableDelegate?.tableView?(self, endDragCellTo: currentIndexPath)
											}
                })
            }
        }
    }
    func lh_gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        guard let currentIndexPath = indexPathForRow(at: location),let currentCell = cellForRow(at: currentIndexPath) else{
            return false
        }
        let pointInCell = convert(location, to: currentCell)
        guard let canDrag = dragableDelegate?.tableView?(self, canDragCellFrom: currentIndexPath, withTouchPoint: pointInCell) else{
            return true
        }
        return canDrag
    }
    
    // MARK: - Private method -
    func adjusFloatImageViewCenterY(_ newY:CGFloat){
        guard let floatImageView = dragableHelper?.floatImageView else{
            return
        }
        floatImageView.center.y = min(max(newY, bounds.origin.y), bounds.origin.y + bounds.height)
        self.dragableDelegate?.tableView?(self, dragableImageView: floatImageView)
        adjustCellOrderIfNecessary()
    }
    
    func adjustCellOrderIfNecessary(){
        guard let dragableDelegate = dragableDelegate,let floatImageView = dragableHelper?.floatImageView,let toIndexPath = indexPathForRow(at: floatImageView.center) else{
            return
        }
        guard let draggingCell = dragableHelper?.draggingCell,let dragingIndexPath = indexPath(for: draggingCell) else{
            return
        }
        guard (dragingIndexPath as NSIndexPath).compare(toIndexPath) != ComparisonResult.orderedSame else{
            return
        }
        if let canDragTo = dragableDelegate.tableView?(self, canDragCellTo: toIndexPath) {
            if !canDragTo {
                return
            }
        }
        let destinationCell = cellForRow(at: toIndexPath)!
        let sign = CGFloat((toIndexPath.row - dragingIndexPath.row >= 0) ? 1 : -1)
        
        if ((floatImageView.center.y - destinationCell.center.y) * sign < destinationCell.frame.height / 3) {
            return
        }
        
        draggingCell.isHidden = true
        beginUpdates()
        dragableDelegate.tableView(self, dragCellFrom: dragingIndexPath, toIndexPath: toIndexPath)
        moveRow(at: dragingIndexPath, to: toIndexPath)
        endUpdates()
    }
    
    func adjustFinalCellOrderIfNecessary() -> Bool {
        guard let dragableDelegate = dragableDelegate,let floatImageView = dragableHelper?.floatImageView,let toIndexPath = indexPathForRow(at: floatImageView.center) else{
            return false
        }
        guard let draggingCell = dragableHelper?.draggingCell,let dragingIndexPath = indexPath(for: draggingCell) else{
            return false
        }
        guard (dragingIndexPath as NSIndexPath).compare(toIndexPath) != ComparisonResult.orderedSame else{
            return false
        }
        if let canDragOver = dragableDelegate.tableView?(self, canDragCellFrom: dragingIndexPath, over: toIndexPath) {
            if !canDragOver {
                return false
            }
        }
        
        let destinationCell = cellForRow(at: toIndexPath)!
        let sign = CGFloat((toIndexPath.row - dragingIndexPath.row >= 0) ? 1 : -1)

        if ((floatImageView.center.y - destinationCell.center.y) * sign > destinationCell.frame.height / 3) {
            return false
        }
        draggingCell.isHidden = true
        beginUpdates()
        dragableDelegate.tableView?(self, dragCellFrom: dragingIndexPath, overIndexPath: toIndexPath)
        //deleteRows(at: [dragingIndexPath], with: .automatic)
        endUpdates()
        return true
    }
}
private class _DisplayLink{
    var paused:Bool{
        get{
            return _link.isPaused
        }
        set{
            _link.isPaused = newValue
        }
    }
    fileprivate init (_ callback: @escaping (Void) -> Void) {
        _callback = callback
        _link = CADisplayLink(target: _DisplayTarget(self), selector: #selector(_DisplayTarget._callback))
        _link.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        _link.isPaused = true
    }
    
    fileprivate let _callback: (Void) -> Void
    
    fileprivate var _link: CADisplayLink!
    
    deinit {
        _link.invalidate()
    }
}

/// Retained by CADisplayLink.
private class _DisplayTarget {
    
    init (_ link: _DisplayLink) {
        _link = link
    }
    
    weak var _link: _DisplayLink!
    
    @objc func _callback () {
        _link?._callback()
    }
}
private extension UIView{
    /**
     Get the screenShot of a UIView
     
     - returns: Image of self
     */
    func lh_screenShot()->UIImage?{
        let mask = layer.mask
        layer.mask = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        layer.mask = mask
        return image
    }
}
