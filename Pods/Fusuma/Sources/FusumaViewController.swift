//
//  FusumaViewController.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/11/14.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit
import Photos
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public protocol FusumaDelegate: class {
    // MARK: Required
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode)
    func fusumaVideoCompleted(withFileURL fileURL: URL)
    func fusumaCameraRollUnauthorized()
    
    // MARK: Optional
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode)
    func fusumaClosed()
}

public extension FusumaDelegate {
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {}
    func fusumaClosed() {}
}

public var fusumaBaseTintColor   = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5568627451, alpha: 1)//UIColor.hex("#000000", alpha: 1.0)
public var fusumaTintColor       = UIColor.hex("#F38181", alpha: 1.0)
public var fusumaBackgroundColor = UIColor.hex("#3B3D45", alpha: 1.0)

public var fusumaAlbumImage : UIImage? = nil
public var fusumaCameraImage : UIImage? = nil
public var fusumaVideoImage : UIImage? = nil
public var fusumaCheckImage : UIImage? = nil
public var fusumaCloseImage : UIImage? = nil
public var fusumaFlashOnImage : UIImage? = nil
public var fusumaFlashOffImage : UIImage? = nil
public var fusumaFlipImage : UIImage? = nil
public var fusumaShotImage : UIImage? = nil

public var fusumaPhotoImage : UIImage? = nil
public var fusumaLibraryImage : UIImage? = nil
public var fusumaVideoStartImage : UIImage? = nil
public var fusumaVideoStopImage : UIImage? = nil

public var fusumaCropImage: Bool = true

public var fusumaCameraRollTitle = "CAMERA ROLL"
public var fusumaCameraTitle = "PHOTO"
public var fusumaVideoTitle = "VIDEO"
public var fusumaTitleFont = UIFont(name: "AvenirNext-DemiBold", size: 15)

public var fusumaTintIcons : Bool = true

public var takenPhoto : UIImage? = nil
public var photoFlag : Bool = false
public var photoCount = 0

public var viewController : FusumaViewController? = nil

public enum FusumaModeOrder {
    case cameraFirst
    case libraryFirst
}

public enum FusumaMode {
    case camera
    case library
    case video
}

//@objc public class FusumaViewController: UIViewController, FSCameraViewDelegate, FSAlbumViewDelegate {
public class FusumaViewController: UIViewController {
    
//    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
//    var heightRatio: CGFloat = 0.0
//    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
//    let width = UIScreen.main.bounds.size.width
//    let height = UIScreen.main.bounds.size.height
    
    public var hasVideo = false
    public var cropHeightRatio: CGFloat = 1
    
    var mode: FusumaMode = .camera
    public var modeOrder: FusumaModeOrder = .libraryFirst
    var willFilter = true
    
    @IBOutlet weak var photoLibraryViewerContainer: UIView!
    @IBOutlet weak var cameraShotContainer: UIView!
    @IBOutlet weak var videoShotContainer: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet var libraryFirstConstraints: [NSLayoutConstraint]!
    @IBOutlet var cameraFirstConstraints: [NSLayoutConstraint]!
    
    lazy var albumView  = FSAlbumView.instance()
    lazy var cameraView = FSCameraView.instance()
    lazy var videoView = FSVideoCameraView.instance()
    
    fileprivate var hasGalleryPermission: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    public weak var delegate: FusumaDelegate? = nil
    
    override public func loadView() {
        
        if let view = UINib(nibName: "FusumaViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            
            self.view = view
            
            viewController = self
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
//        heightRatio = userDevice.userDeviceHeight()
//        widthRatio = userDevice.userDeviceWidth()
        
        self.view.backgroundColor = fusumaBackgroundColor
        
        
        cameraView.delegate = self
        albumView.delegate  = self
        videoView.delegate = self
        
        menuView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 0.9)//fusumaBackgroundColor
//        menuView.addBottomBorder(UIColor.black, width: 1.0)
        
        let bundle = Bundle(for: self.classForCoder)
        
        // Get the custom button images if they're set
        let albumImage = fusumaAlbumImage != nil ? fusumaAlbumImage : UIImage(named: "ic_insert_photo", in: bundle, compatibleWith: nil)
        //ic_photo_camera
        let cameraImage = fusumaCameraImage != nil ? fusumaCameraImage : UIImage(named: "ic_photo_camera", in: bundle, compatibleWith: nil)
        
        let videoImage = fusumaVideoImage != nil ? fusumaVideoImage : UIImage(named: "ic_videocam", in: bundle, compatibleWith: nil)
        
        
        let checkImage = fusumaCheckImage != nil ? fusumaCheckImage : UIImage(named: "ic_check", in: bundle, compatibleWith: nil)
        let closeImage = fusumaCloseImage != nil ? fusumaCloseImage : UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        
        if fusumaTintIcons {
            
            libraryButton.setImage(albumImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            libraryButton.setImage(albumImage?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            libraryButton.setImage(albumImage?.withRenderingMode(.alwaysTemplate), for: .selected)
            libraryButton.tintColor = fusumaTintColor
            libraryButton.adjustsImageWhenHighlighted = false
            
            cameraButton.setImage(cameraImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            cameraButton.setImage(cameraImage?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            cameraButton.setImage(cameraImage?.withRenderingMode(.alwaysTemplate), for: .selected)
            cameraButton.tintColor  = fusumaTintColor
            cameraButton.adjustsImageWhenHighlighted  = false
            
            closeButton.setImage(closeImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            closeButton.setImage(closeImage?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            closeButton.setImage(closeImage?.withRenderingMode(.alwaysTemplate), for: .selected)
            closeButton.tintColor = UIColor.white//fusumaBaseTintColor
            closeButton.layer.shadowColor = UIColor.black.cgColor
            closeButton.layer.shadowRadius = 1
            closeButton.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
            closeButton.layer.shadowOpacity = 1.0
            
            videoButton.setImage(videoImage, for: UIControlState())
            videoButton.setImage(videoImage, for: .highlighted)
            videoButton.setImage(videoImage, for: .selected)
            videoButton.tintColor  = fusumaTintColor
            videoButton.adjustsImageWhenHighlighted = false
            
            doneButton.setImage(checkImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            doneButton.tintColor = UIColor.white//fusumaBaseTintColor
            doneButton.layer.shadowColor = UIColor.black.cgColor
            doneButton.layer.shadowRadius = 1
            doneButton.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
            doneButton.layer.shadowOpacity = 1.0
            
            
            
            
        } else {
            
            libraryButton.setImage(albumImage, for: UIControlState())
            libraryButton.setImage(albumImage, for: .highlighted)
            libraryButton.setImage(albumImage, for: .selected)
            libraryButton.tintColor = nil
            
            cameraButton.setImage(cameraImage, for: UIControlState())
            cameraButton.setImage(cameraImage, for: .highlighted)
            cameraButton.setImage(cameraImage, for: .selected)
            cameraButton.tintColor = nil
            
            videoButton.setImage(videoImage, for: UIControlState())
            videoButton.setImage(videoImage, for: .highlighted)
            videoButton.setImage(videoImage, for: .selected)
            videoButton.tintColor = nil
            
            closeButton.setImage(closeImage, for: UIControlState())
            doneButton.setImage(checkImage, for: UIControlState())
        }
        
        cameraButton.clipsToBounds  = true
        libraryButton.clipsToBounds = true
        videoButton.clipsToBounds = true
        
        changeMode(FusumaMode.library)
        
        photoLibraryViewerContainer.addSubview(albumView)
        cameraShotContainer.addSubview(cameraView)
        videoShotContainer.addSubview(videoView)
        
        titleLabel.textColor = UIColor.hex("#000000", alpha: 1.0) //fusumaBaseTintColor
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)

        
        //        if modeOrder != .LibraryFirst {
        //            libraryFirstConstraints.forEach { $0.priority = 250 }
        //            cameraFirstConstraints.forEach { $0.priority = 1000 }
        //        }
        
        if !hasVideo {
            
            videoButton.removeFromSuperview()
            
            self.view.addConstraint(NSLayoutConstraint(
                item:       self.view,
                attribute:  .trailing,
                relatedBy:  .equal,
                toItem:     cameraButton,
                attribute:  .trailing,
                multiplier: 1.0,
                constant:   0
                )
            )
            
            self.view.layoutIfNeeded()
        }
        
        if fusumaCropImage {
            let heightRatio = getCropHeightRatio()
            cameraView.croppedAspectRatioConstraint = NSLayoutConstraint(item: cameraView.previewViewContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: cameraView.previewViewContainer, attribute: NSLayoutAttribute.width, multiplier: heightRatio, constant: 0)
            
            cameraView.fullAspectRatioConstraint.isActive = false
            cameraView.croppedAspectRatioConstraint?.isActive = true
        } else {
            cameraView.fullAspectRatioConstraint.isActive = true
            cameraView.croppedAspectRatioConstraint?.isActive = false
        }
        
        //donebutton
        //doneButton.isHidden = true
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, color: UIColor){
        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: startX, y: startY, width: width, height: height))
        
        line.backgroundColor = color
        
        
        self.view.addSubview(line)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPoint.zero, size: photoLibraryViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        cameraView.frame = CGRect(origin: CGPoint.zero, size: cameraShotContainer.frame.size)
        cameraView.layoutIfNeeded()
        
        
        albumView.initialize()
        cameraView.initialize()
        
        if hasVideo {
            
            videoView.frame = CGRect(origin: CGPoint.zero, size: videoShotContainer.frame.size)
            videoView.layoutIfNeeded()
            videoView.initialize()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAll()
    }
    
    override public var prefersStatusBarHidden : Bool {
        
        return true
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        if (self.mode == .library) {
            
            self.dismiss(animated: true, completion: {
                
                self.delegate?.fusumaClosed()
            })
        } else if (self.mode == .camera) {
            
            if ( photoFlag ) {
                photoFlag = !photoFlag
                
                self.doneButton.tintColor = UIColor.clear
                self.doneButton.isEnabled = false
                self.doneButton.isUserInteractionEnabled = false
                
                cameraView.initialize()
                changeMode(FusumaMode.camera)
                
            } else {
                
                self.doneButton.tintColor = UIColor.white
                self.doneButton.layer.shadowColor = UIColor.black.cgColor
                self.doneButton.layer.shadowRadius = 1
                self.doneButton.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
                self.doneButton.layer.shadowOpacity = 1.0
                self.doneButton.isEnabled = true
                self.doneButton.isUserInteractionEnabled = true
                
                self.dismiss(animated: true, completion: {
                    
                    self.delegate?.fusumaClosed()
                })
            }
            
        }
        
        
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        
        self.doneButton.tintColor = UIColor.white
        self.doneButton.layer.shadowColor = UIColor.black.cgColor
        self.doneButton.layer.shadowRadius = 1
        self.doneButton.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
        self.doneButton.layer.shadowOpacity = 1.0
        self.doneButton.isEnabled = true
        self.doneButton.isUserInteractionEnabled = true
        changeMode(FusumaMode.library)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        
        self.doneButton.tintColor = UIColor.clear
        self.doneButton.isEnabled = false
        self.doneButton.isUserInteractionEnabled = false
        changeMode(FusumaMode.camera)
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        
        changeMode(FusumaMode.video)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let view = albumView.imageCropView
        
        if fusumaCropImage {
            let normalizedX = (view?.contentOffset.x)! / (view?.contentSize.width)!
            let normalizedY = (view?.contentOffset.y)! / (view?.contentSize.height)!
            
            let normalizedWidth = (view?.frame.width)! / (view?.contentSize.width)!
            let normalizedHeight = (view?.frame.height)! / (view?.contentSize.height)!
            
            let cropRect = CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
            
            DispatchQueue.global(qos: .default).async(execute: {
                
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true
                options.normalizedCropRect = cropRect
                options.resizeMode = .exact
                
                let targetWidth = floor(CGFloat(self.albumView.phAsset.pixelWidth) * cropRect.width)
                let targetHeight = floor(CGFloat(self.albumView.phAsset.pixelHeight) * cropRect.height)
                let dimensionW = max(min(targetHeight, targetWidth), 1024 * UIScreen.main.scale)
                let dimensionH = dimensionW * self.getCropHeightRatio()
                
                let targetSize = CGSize(width: dimensionW, height: dimensionH)
                
                PHImageManager.default().requestImage(for: self.albumView.phAsset, targetSize: targetSize,
                                                      contentMode: .aspectFill, options: options) {
                                                        result, info in
                                                        
                                                        /*
                                                         DispatchQueue.main.async(execute: {
                                                         self.delegate?.fusumaImageSelected(result!, source: self.mode)
                                                         
                                                         self.dismiss(animated: true, completion: {
                                                         self.delegate?.fusumaDismissedWithImage(result!, source: self.mode)
                                                         })
                                                         })*/
                                                        
                                                        if (self.mode == .library) {
                                                            
                                                            DispatchQueue.main.async(execute: {
                                                                self.delegate?.fusumaImageSelected(result!, source: self.mode)
                                                                
                                                                
                                                                self.dismiss(animated: false, completion: {
                                                                    self.delegate?.fusumaDismissedWithImage(result!, source: self.mode)
                                                                })
                                                                
                                                            })
                                                        } else if (self.mode == .camera) {
                                                            
                                                            
                                                            DispatchQueue.main.async(execute: {
                                                                
                                                                
                                                                self.delegate?.fusumaImageSelected(takenPhoto!, source: self.mode)
                                                                
                                                                
                                                                self.dismiss(animated: false, completion: {
                                                                    self.delegate?.fusumaDismissedWithImage(takenPhoto!, source: self.mode)
                                                                    
                                                                    
                                                                })
                                                                
                                                            })
                                                        }
                }
            })
        } else {
            
            
            let imageWidth = CGFloat((view?.image.size.width)!)
            let imageHeight = CGFloat((view?.image.size.height)!)
            
            
            if (self.mode == .library) {
                
                DispatchQueue.main.async(execute: {
                    
                    self.delegate?.fusumaImageSelected((view?.image)!, source: self.mode)
                    
                    if imageHeight/imageWidth < 0.56 || imageWidth/imageHeight > 1.78{
                        
                        let alertView = UIAlertController(title: "경고", message: "가로가 지나치게 큰 사진입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alertView.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        alertWindow.windowLevel = UIWindowLevelAlert + 1
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
                        
                    }else if imageHeight/imageWidth > 1.78 || imageWidth/imageHeight < 0.56{
                        
                        let alertView = UIAlertController(title: "경고", message: "세로가 지나치게 큰 사진입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alertView.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        alertWindow.windowLevel = UIWindowLevelAlert + 1
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
                        
                    }else{
                        
                        self.dismiss(animated: false, completion: {
                            self.delegate?.fusumaDismissedWithImage((view?.image)!, source: self.mode)
                        })
                        
                    }
                    
                    
                    
                })
            } else if (self.mode == .camera) {
                
                
                DispatchQueue.main.async(execute: {
                    
                    
                    self.delegate?.fusumaImageSelected(takenPhoto!, source: self.mode)
                    
                    
                    self.dismiss(animated: false, completion: {
                        self.delegate?.fusumaDismissedWithImage(takenPhoto!, source: self.mode)
                        
                        
                    })
                    
                })
            }
            
            /*
             delegate?.fusumaImageSelected((view?.image)!, source: mode)
             
             self.dismiss(animated: true, completion: {
             self.delegate?.fusumaDismissedWithImage((view?.image)!, source: self.mode)
             })
             */
        }
    }
    
}

extension FusumaViewController: FSAlbumViewDelegate, FSCameraViewDelegate, FSVideoCameraViewDelegate {
    public func getCropHeightRatio() -> CGFloat {
        return cropHeightRatio
    }
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(_ image: UIImage) {
        
        delegate?.fusumaImageSelected(image, source: mode)
        self.dismiss(animated: true, completion: {
            
            self.delegate?.fusumaDismissedWithImage(image, source: self.mode)
        })
    }
    
    func cameraDidShot(_ image: UIImage) {
        
        DispatchQueue.main.async(execute: {
            //self.doneButton.isHidden = false
            takenPhoto = image
        })
    }
    
    public func albumViewCameraRollAuthorized() {
        // in the case that we're just coming back from granting photo gallery permissions
        // ensure the done button is visible if it should be
        self.updateDoneButtonVisibility()
    }
    
    // MARK: FSAlbumViewDelegate
    public func albumViewCameraRollUnauthorized() {
        delegate?.fusumaCameraRollUnauthorized()
    }
    
    func videoFinished(withFileURL fileURL: URL) {
        delegate?.fusumaVideoCompleted(withFileURL: fileURL)
        self.dismiss(animated: true, completion: nil)
    }
    
}

private extension FusumaViewController {
    
    func stopAll() {
        
        if hasVideo {
            
            self.videoView.stopCamera()
        }
        
        self.cameraView.stopCamera()
    }
    
    func changeMode(_ mode: FusumaMode) {
        
        if self.mode == mode {
            return
        }
        
        //operate this switch before changing mode to stop cameras
        switch self.mode {
        case .library:
            break
        case .camera:
            self.cameraView.stopCamera()
        case .video:
            self.videoView.stopCamera()
        }
        
        self.mode = mode
        
        dishighlightButtons()
        updateDoneButtonVisibility()
        
        
        let bundle = Bundle(for: self.classForCoder)
        
        let libraryImage = fusumaLibraryImage != nil ? fusumaLibraryImage : UIImage(named: "ic_photo_camera", in: bundle, compatibleWith: nil)
        let photoImage = fusumaPhotoImage != nil ? fusumaPhotoImage : UIImage(named: "ic_insert_photo", in: bundle, compatibleWith: nil)
        
        //cameraButton.setImage(photoImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        //libraryButton.setImage(libraryImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        switch mode {
        case .library:
            titleLabel.text = NSLocalizedString(fusumaCameraRollTitle, comment: fusumaCameraRollTitle)
            
            
            highlightButton(libraryButton,cameraButton,0)
            self.view.bringSubview(toFront: photoLibraryViewerContainer)
        case .camera:
            titleLabel.text = NSLocalizedString(fusumaCameraTitle, comment: fusumaCameraTitle)
            
            //doneButton.isHidden = true
            highlightButton(libraryButton,cameraButton,1)
            self.view.bringSubview(toFront: cameraShotContainer)
            cameraView.initialize()
            cameraView.startCamera()
        case .video:
            titleLabel.text = fusumaVideoTitle
            
            //highlightButton(videoButton)
            self.view.bringSubview(toFront: videoShotContainer)
            videoView.startCamera()
        }
        doneButton.isHidden = !hasGalleryPermission
        self.view.bringSubview(toFront: menuView)
    }
    
    
    func updateDoneButtonVisibility() {
        // don't show the done button without gallery permission
        if !hasGalleryPermission {
            self.doneButton.isHidden = true
            return
        }
        
        switch self.mode {
        case .library:
            self.doneButton.isHidden = false
        default:
            self.doneButton.isHidden = true
        }
    }
    
    func dishighlightButtons() {
        cameraButton.tintColor  = fusumaBaseTintColor
        libraryButton.tintColor = fusumaBaseTintColor
        
        if cameraButton.layer.sublayers?.count > 1 {
            
            for layer in cameraButton.layer.sublayers! {
                
                if let borderColor = layer.borderColor , UIColor(cgColor: borderColor) == fusumaTintColor {
                    
                    layer.removeFromSuperlayer()
                }
                
            }
        }
        
        if libraryButton.layer.sublayers?.count > 1 {
            
            for layer in libraryButton.layer.sublayers! {
                
                if let borderColor = layer.borderColor , UIColor(cgColor: borderColor) == fusumaTintColor {
                    
                    layer.removeFromSuperlayer()
                }
                
            }
        }
        
        if let videoButton = videoButton {
            
            videoButton.tintColor = fusumaBaseTintColor
            
            if videoButton.layer.sublayers?.count > 1 {
                
                for layer in videoButton.layer.sublayers! {
                    
                    if let borderColor = layer.borderColor , UIColor(cgColor: borderColor) == fusumaTintColor {
                        
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    func highlightButton(_ library: UIButton, _ photo: UIButton,_ flag : Int) {
        
        let bundle = Bundle(for: self.classForCoder)
        
        let libraryImage = fusumaLibraryImage != nil ? fusumaLibraryImage : UIImage(named: "ic_photo_camera", in: bundle, compatibleWith: nil)
        let photoImage = fusumaPhotoImage != nil ? fusumaPhotoImage : UIImage(named: "ic_insert_photo", in: bundle, compatibleWith: nil)
        
        let albumImage = fusumaAlbumImage != nil ? fusumaAlbumImage : UIImage(named: "ic_insert_photo", in: bundle, compatibleWith: nil)
        
        let cameraImage = fusumaCameraImage != nil ? fusumaCameraImage : UIImage(named: "ic_photo_camera", in: bundle, compatibleWith: nil)
        
        //cameraButton.setImage(photoImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        //libraryButton.setImage(libraryImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        if flag == 1 {
            
            photo.tintColor = fusumaTintColor
            library.setImage(albumImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            photo.setImage(libraryImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        }else if flag == 0{
            
            drawLine(startX: 0, startY: 622, width: 375, height: 0.5, color: #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5568627451, alpha: 0.2961793664))
            library.tintColor = fusumaTintColor
            library.setImage(photoImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
            photo.setImage(cameraImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        }
        
        //button.addBottomBorder(fusumaTintColor, width: 3)
    }
}
