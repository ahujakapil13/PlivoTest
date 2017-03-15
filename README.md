# Plivo Test

This is a Voice Client Application using Plivo Objective-C SDK.

## Instructions
- Open AppDelegate class and use your Plivo account sip endpoint username and password.
- Prepare to Receive VoIP Push Notifications
Like all apps that support background operation, your VoIP app must have background mode enabled in the Xcode Project > Capabilities pane. Select the checkbox for Voice over IP
![Default](https://raw.githubusercontent.com/ahujakapil13/PlivoTest/master/Resources/xcode_project_capabilities_backgroundmodes.png)
You must also create a certificate for your VoIP app. Each VoIP app requires its own individual VoIP Services certificate, mapped to a unique App ID. This certificate allows your notification server to connect to the VoIP service.Using VoIP Push notification your app will not ask for any permission from user.
![Default](https://raw.githubusercontent.com/ahujakapil13/PlivoTest/master/Resources/voip_certificate_creation.png)
- Register VoIP push token with server

## Limitations
This project is based on VoIP, So will not work in Simulator. 

## Test Code
Use X-lite on desktop, Zoiper desktop or iOS or Android client app for testing purpose.

## Documentation

### AppDelegate.swift

Enter your sip username and password to connect to endpoint.
		Constants.Instance.Username = ""
		Constants.Instance.Password = ""

    func voipRegistration ()
This method is used to Register for VoIP notifications.


    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType)
This method is used to Handle updated push credentials

	func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType)
This method is for Handle incoming pushes

### ViewController.swift
ViewController class contains delegate methods to handle incoming call.

    func onLogin()
    func onLoginFailed()
    func onIncomingCall()
    func onIncomingCallHangup()
    func onIncomingCallRejected()
This methods handle logs of all events occur. 

### CallProviderDelegate Class
CallProviderDelegate class contains delegate methods for handling CallKit. 

    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil);
This method would make a native call UI.

    func providerDidBegin(_ provider: CXProvider)
    func providerDidReset(_ provider: CXProvider)
    func provider(_ provider: CXProvider, perform action: CXEndCallAction)
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction)
This methods handle all the actions happen during call.

### APIManager.swift
APIManager class will interact with Plivo Objective-C SDK. 

    func connectEndpoint()
This method will connect to endpoint.

### Constants.swift
Constants class will contain all values which will remain Constant for Application. 


