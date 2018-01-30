//
//  CallInComingViewController.swift
//  People
//
//  Created by Quoc Dat on 12/20/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import UIKit
import AVFoundation
class CallInComingViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput : AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    @IBOutlet weak var switchCameraBt: UIButton!
    @IBAction func switchCamera(_ sender: UIButton) {
        switchCameraBt.isEnabled = false
        //Change camera source
        let session = captureSession
        //Indicate that some changes will be made to the session
        session.beginConfiguration()
        
        //Remove existing input
        let currentCameraInput:AVCaptureInput = session.inputs.first as! AVCaptureInput
        ;            session.removeInput(currentCameraInput)
        
        //Get new input
        var newCamera:AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = frontCamera
            }
            else {
                newCamera = backCamera
            }
        }
        
        //Add input to session
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if(newVideoInput == nil || err != nil) {
            print("Error creating capture device input: \(err!.localizedDescription)")
        }
        else {
            session.addInput(newVideoInput)
        }
        
        //Commit all the configuration changes at once
        session.commitConfiguration()
        
        switchCameraBt.isEnabled = true
    }
    
    @IBAction func hangOutBT(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
