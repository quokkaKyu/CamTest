//
//  CameraViewController.swift
//  CamTest
//
//  Created by kyuminlee on 2023/05/09.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    let capturePhotoOutput = AVCapturePhotoOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var circleLineView = CircleLineView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 미리보기를 표시할 레이어 생성
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // AVCaptureDevice 객체 가져오기
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            capturePhotoOutput.isHighResolutionCaptureEnabled = true
            captureSession.addOutput(capturePhotoOutput)
            
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        } catch {
            print(error.localizedDescription)
            return
        }
        
        let button = UIButton(frame: CGRect(x: view.frame.midX - 50, y: 300, width: 100, height: 60))
        button.setTitle("Capture", for: .normal)
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        view.addSubview(button)
        circleLineView.draw(CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(circleLineView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global().async {
            self.captureSession.stopRunning()
        }
    }
    
    @objc func capturePhoto() {
        print("capturePhoto")
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        let photoOutput = AVCapturePhotoOutput()
        
        // AVCaptureSession에 photoOutput 추가
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // handle sample buffer here
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        print("image: \(image)")
        // TODO: 촬영한 이미지를 처리하는 코드 작성
        if let jpegData = image?.jpegData(compressionQuality: 0.8) {
            // 저장할 경로를 지정합니다.
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("image.jpeg")
            // 파일에 저장합니다.
            try? jpegData.write(to: fileURL)
        }
    }
}
