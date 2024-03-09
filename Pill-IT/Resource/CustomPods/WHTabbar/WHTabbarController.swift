import UIKit
import SwipeableTabBarController

open class WHTabbarController: SwipeableTabBarController {
    
    
    // Screen width.
    public var myScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var myScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    public var isCurvedTabbar : Bool = true
    public var centerButtonBottomMargin : CGFloat = 20.0
    public var centerButtonSize : CGFloat = 0.0
    public var centerButtonBackroundColor : UIColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    public var centerButtonBorderColor : UIColor =  #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    public var centerButtonBorderWidth : CGFloat = 3
    public var centerButtonImage : UIImage?
    public var centerButtonImageSize :  CGFloat = 25.0
    
    var blockView : UIView?
    var centreButtonContainer : UIView?
    public var shapeLayer: CALayer?

    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setupCenetrButton(vPosition : CGFloat ,  buttonClicked: @escaping()->Void )  {
            
        
        if isCurvedTabbar{
            makeTabbarCurved()
        }
        
        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        
      

        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let tabCount = self.tabBar.items?.count
            switch tabCount {
            case 3:
                self.tabBar.items?[1].title = ""
                break
            case 5:
                self.tabBar.items?[2].title = ""
                break
            default:
                print("")
            }
            
        }
        
        let centreButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: centerButtonSize , height: centerButtonSize))
        centreButtonContainer.layer.cornerRadius = centerButtonSize / 2
        
        
        
        if bottomSafeArea == 0{
            centerButtonBottomMargin =  centerButtonSize + 20
        }else{
         centerButtonBottomMargin = bottomSafeArea + tabBar.frame.height
        }
    
        
        centerButtonBottomMargin = centerButtonBottomMargin + vPosition

        
        centreButtonContainer.frame.origin.y = self.view.bounds.height - centerButtonBottomMargin
        
        centreButtonContainer.frame.origin.x = self.view.bounds.width/2 - centreButtonContainer.frame.width/2
        
        
        
        
        centreButtonContainer.backgroundColor = centerButtonBackroundColor
        centreButtonContainer.layer.borderColor = centerButtonBorderColor.cgColor
        centreButtonContainer.layer.borderWidth = centerButtonBorderWidth
        centreButtonContainer.clipsToBounds = true
        
        let blockView = UIView(frame: CGRect(x: centreButtonContainer.center.x , y: centreButtonContainer.frame.minY, width: centerButtonSize + 20 , height: self.tabBar.frame.height))
        
        
        let centerButtonImageView = UIImageView(frame: CGRect(x: 0 , y: 0, width: centerButtonImageSize, height: centerButtonImageSize))
        
        centerButtonImageView.center = CGPoint(x: centreButtonContainer.frame.size.width  / 2,
                                               y: centreButtonContainer.frame.size.height / 2)
        
        centerButtonImageView.image = centerButtonImage
        
        blockView.backgroundColor = UIColor.clear
        blockView.center.x = centreButtonContainer.center.x
        
        self.view.addSubview(blockView)
        self.view.addSubview(centreButtonContainer)
        self.view.bringSubviewToFront(centreButtonContainer)
        
        centreButtonContainer.addSubview(centerButtonImageView)
        
        centreButtonContainer.TapLisner {
            buttonClicked()
        }
        
        
    }
    
 
    
    
    
}

import Foundation

extension WHTabbarController {
    

    public func makeTabbarCurved() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
   
    public func createPath() -> CGPath {
        
        let height: CGFloat = 35.0
        let path = UIBezierPath()
        let centerWidth = self.tabBar.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.tabBar.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.tabBar.frame.width, y: self.tabBar.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.tabBar.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    
}
