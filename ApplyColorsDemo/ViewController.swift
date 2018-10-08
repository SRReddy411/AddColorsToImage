//
//  ViewController.swift
//  CGBlendModeExample
//
//  Created by René Kann on 19.03.18.
//  Copyright © 2018 René Kann. All rights reserved.
//

import UIKit
import ChromaColorPicker
@objc protocol AddColorPhotoEditorDelegate {
    func imageEdited(image: UIImage)
   
}
class ViewController: UIViewController {
    
    @IBOutlet weak var blendModePicker: UIPickerView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var colorPickerView: UIView?
    @IBOutlet weak var colorExampleView: UIView?
    var selectingImage:UIImage?
     var blendModes = [(description: String, blendmode: CGBlendMode)]()
     var originalImage: UIImage?
     var selectedColor: UIColor = .clear
     var colorPicker: ChromaColorPicker?
     @objc var photoEditorDelegate: AddColorPhotoEditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = selectingImage
        //originalImage = UIImage(named: "DesignHome.jpg")
        
        blendModes = [
            (description: "normal", blendmode: .normal),
            (description: "multiply", blendmode: .multiply),
            (description: "screen", blendmode: .screen),
            (description: "overlay", blendmode: .overlay),
            (description: "darken", blendmode: .darken),
            (description: "lighten", blendmode: .lighten),
            (description: "colorDodge", blendmode: .colorDodge),
            (description: "colorBurn", blendmode: .colorBurn),
            (description: "softLight", blendmode: .softLight),
            (description: "hardLight", blendmode: .hardLight),
            (description: "difference", blendmode: .difference),
            (description: "exclusion", blendmode: .exclusion),
            (description: "hue", blendmode: .hue),
            (description: "saturation", blendmode: .saturation),
            (description: "color", blendmode: .color),
            (description: "luminosity", blendmode: .luminosity),
            (description: "clear", blendmode: .clear),
            (description: "copy", blendmode: .copy),
            (description: "sourceIn", blendmode: .sourceIn),
            (description: "sourceOut", blendmode: .sourceOut),
            (description: "sourceAtop", blendmode: .sourceAtop),
            (description: "destinationOver", blendmode: .destinationOver),
            (description: "destinationIn", blendmode: .destinationIn),
            (description: "destinationOut", blendmode: .destinationOut),
            (description: "destinationAtop", blendmode: .destinationAtop),
            (description: "xor", blendmode: .xor),
            (description: "plusDarker", blendmode: .plusDarker),
            (description: "plusLighter", blendmode: .plusLighter),
        ]
        
        showImage(withBlendMode: .normal, andColor: .clear)
        
        if let colorPickerView = colorPickerView {            
            let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: colorPickerView.frame.size.width, height: colorPickerView.frame.size.height))
            neatColorPicker.delegate = self
            neatColorPicker.padding = 5
            neatColorPicker.stroke = 3
            neatColorPicker.hexLabel.textColor = UIColor.black
            neatColorPicker.addTarget(self, action: #selector(didChangeColorPicker), for: .valueChanged)
            colorPickerView.addSubview(neatColorPicker)
            colorPicker = neatColorPicker
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         
    }
    
    
    //MARK:- SAVE BTN ACTION
    @IBAction func saveBtnAction(_ sender: Any) {
        photoEditorDelegate?.imageEdited(image: (imageView?.image)!)
          self.navigationController?.popViewController(animated: true)
//          UserDefaults.standard.set(imageView?.image, forKey: "applyColorImage")
//        let image = UserDefaults.standard.object(forKey: "applyColorImage")
//        print("apply color image",image ?? "nil")
     
    }
    
    
    func showImage(withBlendMode blendmode: CGBlendMode = .normal, andColor color: UIColor = .clear) {
        imageView?.image = originalImage?.mask(withColor: color, andBlendmode: blendmode)
        
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showImage(withBlendMode: blendModes[row].blendmode, andColor: selectedColor)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blendModes[row].description
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blendModes.count
    }
}

extension ViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colorChanged(to: color)
    }
    
    @objc func didChangeColorPicker(_ colorPicker: ChromaColorPicker) {
        
        print("change color picker ",colorPicker.currentColor)
        colorChanged(to: colorPicker.currentColor)
    }
    
    func colorChanged(to color: UIColor) {
        selectedColor = color
         print("change color picker ",color)
        colorExampleView?.backgroundColor = color
        
        if let selectedRow = blendModePicker?.selectedRow(inComponent: 0) {
            showImage(withBlendMode: blendModes[selectedRow].blendmode, andColor: selectedColor)
        }
    }
}

extension UIImage {
    
    public func mask(withColor color: UIColor, andBlendmode blendmode: CGBlendMode) -> UIImage {
        
        guard color != .clear else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(blendmode)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
}

