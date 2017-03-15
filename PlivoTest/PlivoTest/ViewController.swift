//
//  ViewController.swift
//  PlivoTest
//
//  Created by Kapil Ahuja on 15/03/17.
//  Copyright © 2017 Kapil Ahuja. All rights reserved.
//

import UIKit
import CallKit

class ViewController: UIViewController, PlivoEndpointDelegate {

    @IBOutlet weak var TxtvLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Connect to Endpoint */
        logMessage(message: "- Logging in\n")
        APIManager.Instance.connectEndpoint()
        
        /* set delegate for debug log text view */
        APIManager.Instance.endpoint?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Print debug log to textview in the middle of the view screen
     */
    func logMessage(message: String) {
        
        /**
         * Check if this code is executed from main thread.
         * Only main thread that can update the GUI.
         */
        guard Thread.isMainThread else {
            logMessage(message: message)
            return
        }
        
        /* insert message and scroll textview*/
        TxtvLog.insertText(message)
        TxtvLog.scrollRangeToVisible(NSMakeRange(TxtvLog.text.characters.count - 1, 0))
    }
    
    /**
     * Reset UI to empty textview
     */
    func resetUI() {
        TxtvLog.text = ""
    }
    
    /**
     * onLogin delegate implementation
     */
    func onLogin() {
        logMessage(message: "- Login OK\n- Ready to receive a call")
    }
    
    /**
     * onLoginFailed delegate implementation.
     */
    func onLoginFailed() {
        logMessage(message: "- Login failed. Please check your username and password")
    }
    
    /**
     * onIncomingCall delegate implementation
     */
    func onIncomingCall(_ incoming: PlivoIncoming!) {
        logMessage(message: "- Call from \(incoming.fromContact)")
        APIManager.Instance.inCall = incoming
    }
    
    /**
     * onIncomingCallHangup delegate implementation.
     */
    func onIncomingCallHangup(_ incoming: PlivoIncoming!) {
        logMessage(message: "- Incoming call ended")
        resetUI()
    }
    
    /**
     * onIncomingCallRejected implementation.
     */
    func onIncomingCallRejected(_ incoming: PlivoIncoming!) {
        logMessage(message: "- Incoming call rejected")
        resetUI()
    }
    
}

final class CallProviderDelegate: NSObject, CXProviderDelegate {
    
    // CXProvider with Configuration
    private let provider: CXProvider
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration:CXProviderConfiguration?
        providerConfiguration = CXProviderConfiguration(localizedName: "Test Call")
        providerConfiguration!.supportsVideo = false
        providerConfiguration!.maximumCallsPerCallGroup = 1
        return providerConfiguration!
    }
    
    /**
     * class initialization.
     */
    override init() {
        provider = CXProvider(configuration: CallProviderDelegate.providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    /**
     * displayIncomingCall implementation.
     */
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            completion?(error as? NSError)
        }
    }
    
    /**
     * providerDidBegin implementation.
     */
    func providerDidBegin(_ provider: CXProvider) {
         print("Provider did begin")
        APIManager.Instance.inCall.answer()
    }
    
    /**
     * providerDidReset implementation.
     */
    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")
        /*
         End any ongoing calls if the provider resets, and remove them from the app's list of calls,
         since they are no longer valid.
         */
        APIManager.Instance.inCall.hangup()
    }
    
    /**
     * provider ending the call.
     */
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        /*
         Perform your action after ending the call
         */
        APIManager.Instance.inCall.reject()
    }
    
    /**
     * provider muting or unmuting a call.
     */
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        if action.isMuted {
            APIManager.Instance.inCall.mute()
        }else{
            APIManager.Instance.inCall.unmute()
        }
    }
}

