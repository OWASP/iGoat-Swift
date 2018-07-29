//
//  MethodSwizzlingExerciseVC.swift
//  iGoat-Swift
//
//  Created on 7/28/18.
//  Copyright © 2018 OWASP. All rights reserved.
//

import UIKit

class MethodSwizzlingExerciseVC: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var forceJailbreakEnvironment: UISwitch!
    
    fileprivate static var originalImp:IMP? = nil

    var jailbreakSentinelPath:String {
        if forceJailbreakEnvironment.isOn {
            let sentinelPath = Bundle.main.path(forResource: "Sentinel", ofType: "txt")
            assert(sentinelPath != nil, "Sentinel.text not found in the bundle....")
            return Bundle.main.path(forResource: "Sentinel", ofType: "txt")!
        } else {
            return "/Applications/Cydia.app"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.sizeToFit()
    }
    
    deinit {
        // Restore the original implementation of FileManager
        swizzleFileManager(false)
    }
    
    @IBAction func verifyStatus(_ sender: Any) {

        if FileManager.default.fileExists(atPath: jailbreakSentinelPath) {
            UIAlertController.showAlertWith(title: "Jailbreak Status", message: "This app is running on a jailbroken device")
        } else {
            UIAlertController.showAlertWith(title: "Jailbreak Status", message: "This app is not running on a jailbroken device")
        }
    }

    @IBAction func evadeJailbreakButtonDidGetTapped(_ sender: UISwitch) {
        swizzleFileManager(sender.isOn)
    }

    // MARK:- swizzle method
    
    private func swizzleFileManager(_ swizzle:Bool) {
        
        guard let method = class_getInstanceMethod(object_getClass(FileManager.default), #selector(fileExists(atPath:))) else {
            assert(false, "#selector(fileExists(atPath:)) for FileManager could not be found...")
            return
        }

        if MethodSwizzlingExerciseVC.originalImp == nil {
            MethodSwizzlingExerciseVC.originalImp = method_getImplementation(method)
        }

        if swizzle {
            let thisMethod = class_getInstanceMethod(object_getClass(self), #selector(fileExists(atPath:)))!
            let imp = method_getImplementation(thisMethod)
            method_setImplementation(method, imp)
        } else {
            method_setImplementation(method, MethodSwizzlingExerciseVC.originalImp!)
        }
    }

    @objc private func fileExists(atPath:String) -> Bool {
        
        assert(MethodSwizzlingExerciseVC.originalImp != nil, "Failure occured in swizzling...")
        
        if atPath.hasSuffix("Cydia.app") ||
            atPath.hasSuffix("bash") ||
            atPath.hasSuffix("MobileSubstrate.dylib") ||
            atPath.hasSuffix("sshd") ||
            atPath.hasSuffix("apt") {
            return false
        }
        
        // Sentinel to simulate jailbreak
        if atPath.hasSuffix("Sentinel.txt") {
            return false
        }
        
        // Invoke original IMP
        typealias Function = @convention(c) (AnyObject, Selector, String) -> Bool
        let aFunc:Function = unsafeBitCast(MethodSwizzlingExerciseVC.originalImp!, to: Function.self)
        let exists = aFunc(FileManager.default, #selector(fileExists(atPath:)), atPath)
        return exists
    }
}


//******************************************************************************
// SOLUTION
//
// Quite a few hacker tools in the wild leverage method swizzling
// to intercept Objective C method calls (selectors) and perform code subtitution.
// In doing so, the hacker is able to intercept filesystem inspection methods
// and mislead the app about its filesystem environment.
//
// There are a number of different strategies you can employ to prevent a hacker
// from performing method swizzling against your app. The most ideal solution
// is to examine each message selector's method implementation and compare
// the address of eacg method implementation against what the app
// sees at compile time. While this solution is the most
// complete and accurate, it is difficult for a Software Engineer to implement
// this from scratch.  There are commercial products that will provide this level
// of sophistication in method swizzling prevention.
//
// To raise the bar and make it harder to perform method swizzling, switch the code from
// using upon an Objective C method to a C equivalent. In doing so, the hacker will no
// longer be able to exploit method swizzling because the app will not be passing
// Objective C selectors (that can be redirected via method swizzling) when executing the code.
//
// 1. Replace the fetchButtonTapped: implementation above with the implementation below.
//    In the implementation below, the application no longer relies upon NSFileManager
//    to inspect its filesystem. Instead, it uses C library calls to perform the same
//    operations. It is now immune to method swizzling attack vectors.
//
//    NOTE: To verify that the hacker can no longer swizzle and mislead the app,
//          you should run this solution on a truly jailbroken device.  Otherwise,
//          the switches will force the output to a particular value.
//
// 2. Extra credit: How do you prevent a hacker from taking that next step of hooking C methods?
//******************************************************************************

/*
@IBAction func verifyStatusCorrect(_ sender: Any)
{
    // Note: To verify this is really working,
    // you must run this on an actual jailbroken device.
    // Here, the delegate method no longer takes into account
    // user preferences for 'faking jailbreak status' in an emulator environment.
    // If it did, the app will never report what it truly thinks is the
    // state of the environment and the correctness of this solution cannot be verified.
    //
    
    // Determine whether this is a jailbroken phone or not
    
    let cydiaFileHandle = fopen("/Applications/Cydia.app", "r")
    let fileExists = cydiaFileHandle != nil;
    if cydiaFileHandle != nil {
        fclose(cydiaFileHandle);
    }
    
    if fileExists {
        UIAlertController.showAlertWith(title: "Jailbreak Status", message: "This app is running on a jailbroken device")
    } else {
        UIAlertController.showAlertWith(title: "Jailbreak Status", message: "This app is not running on a jailbroken device")
    }
}
 */




