import Foundation
import Capacitor
import SwiftSignatureView

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(EsignaturePlugin)
public class EsignaturePlugin: CAPPlugin, SwiftSignatureViewDelegate, UIApplicationDelegate {
    private let implementation = Esignature()


    // Buttons

        // Clear
        let clearButton = UIButton(frame: CGRect(x: 0, y: 25, width: (UIScreen.main.bounds.width / 3), height: 50))
        // Clear

        // Save
        let saveButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width / 3), y: 25, width: (UIScreen.main.bounds.width / 3), height: 50))
        // Save

        // Close
        let closeButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 3)), y: 25, width: (UIScreen.main.bounds.width / 3), height: 50))
        // Close

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    // Buttons

    var signatureView: SwiftSignatureView = {
        SwiftSignatureView(frame: CGRect.zero)
        }()

    override public func load() {
       NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)


    }

     @objc func rotated()
    {
        self.clearButton.frame = CGRect(x: 0, y: 25, width: (UIScreen.main.bounds.width / 3), height: 50)
        self.saveButton.frame = CGRect(x: (UIScreen.main.bounds.width / 3), y: 25, width: (UIScreen.main.bounds.width / 3), height: 50)
        self.closeButton.frame = CGRect(x: (UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 3)), y: 25, width: (UIScreen.main.bounds.width / 3), height: 50)
        self.label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    public func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        print("swiftSignatureViewDidDrawGesture")
    }

    public func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        print("swiftSignatureViewDidDraw")
    }

    @objc func initialise(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            guard let bridge = self.bridge else { return }

            let viewController = bridge.viewController;

            if let viewController = viewController {
                self.signatureView.translatesAutoresizingMaskIntoConstraints = false

                if viewController.traitCollection.userInterfaceStyle == .dark {
                    self.signatureView.strokeColor = UIColor.red
                } else {
                    self.signatureView.strokeColor = UIColor.black
                }

                self.signatureView.backgroundColor = UIColor.white
                self.signatureView.minimumStrokeWidth = 1
                self.signatureView.maximumStrokeWidth = 5
                self.signatureView.strokeAlpha = 1

                UIView.transition(with: viewController.view, duration: 0.5, options: [.curveEaseIn, .transitionFlipFromLeft], animations: {
                    viewController.view.addSubview(self.signatureView)
                }, completion: nil)

                viewController.view.addConstraint(NSLayoutConstraint(item: self.signatureView, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1, constant: 0))
                viewController.view.addConstraint(NSLayoutConstraint(item: self.signatureView, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1, constant: 0))
                viewController.view.addConstraint(NSLayoutConstraint(item: self.signatureView, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1, constant: 0))
                viewController.view.addConstraint(NSLayoutConstraint(item: self.signatureView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height))

                self.signatureView.delegate = self

                // Buttons

                    // Clear
                    self.clearButton.backgroundColor = .red
                    self.clearButton.isUserInteractionEnabled = true
                    self.clearButton.isEnabled = true
                    self.clearButton.setTitle("Clear", for: .normal)
                    self.clearButton.addTarget(self, action:#selector(self.clearSignature), for: .touchUpInside)
                    self.signatureView.addSubview(self.clearButton)
                    // Clear

                    // Save
                    self.saveButton.backgroundColor = .systemGreen
                    self.saveButton.isUserInteractionEnabled = true
                    self.saveButton.isEnabled = true
                    self.saveButton.setTitle("Save", for: .normal)
                    self.saveButton.addTarget(self, action:#selector(self.save), for: .touchUpInside)
                    self.signatureView.addSubview(self.saveButton)
                    // Save

                    // Close
                    self.closeButton.backgroundColor = .black
                    self.closeButton.isUserInteractionEnabled = true
                    self.closeButton.isEnabled = true
                    self.closeButton.setTitle("Close", for: .normal)
                    self.closeButton.addTarget(self, action:#selector(self.close), for: .touchUpInside)
                    self.signatureView.addSubview(self.closeButton)
                    // Close

                // Buttons

                // Label
                self.label.textAlignment = .center
                self.label.text = "Sign here"
                self.label.font = self.label.font.withSize(35)
                self.label.textColor = UIColor.lightGray
                self.label.alpha = 0.5
                self.signatureView.addSubview(self.label)
                // Label

                call.resolve([ "success": "Signature is showing" ])
            }
        }

    }

    @objc func clearSignature(_ call: CAPPluginCall) {
      DispatchQueue.main.async {
        self.signatureView.clear()
      }
   }

    @objc func save() {
        DispatchQueue.main.async {

            if (self.signatureView.isEmpty) {

                guard let bridge = self.bridge else { return }

                let viewController = bridge.viewController;

                if let viewController = viewController {

                    let alert = UIAlertController(title: "No Signature", message: "A signature must be provided", preferredStyle: .alert)

                     let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                     })

                     alert.addAction(ok)

                     DispatchQueue.main.async(execute: {
                        viewController.present(alert, animated: true)
                     })

                }

            } else {

                let image = self.convertImageToBase64String(img: self.signatureView.getCroppedSignature()!);

                self.notifyListeners("signatureSaved", data: [ "success": image ]);

                self.close()

            }

        }
   }

    @objc func close() {
        guard let bridge = self.bridge else { return }

        let viewController = bridge.viewController;

        if let viewController = viewController {

            UIView.transition(with: viewController.view, duration: 0.5, options: [.curveEaseInOut, .transitionFlipFromRight], animations: {
                self.signatureView.removeFromSuperview()
            }, completion: nil)

        }

   }

    @objc func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.3)?.base64EncodedString() ?? ""
    }

}
