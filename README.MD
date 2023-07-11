# Live Activity Realtime Polls SwiftUI App Built with Firebase, APNS

![alt text](https://i.ibb.co/gZBYj5t/promo.png)

The app provides features where users can create a poll with multiple options, share, and vote in realtime. 

It also supports the new iOS Live Activity feature using ActivityKit + APNS to display real time poll activity charts from Lock Screen, Dynamic Island, iOS 17 Standby screen.

## Requirements
- Xcode 15
- Replace the bundleID for the App with your own.
- Firebase iOS Project, download `GoogleService-info.plist` to your Xcode project target.
- Provide your Apple AuthKey.p8 with Apple Push Notification support in `firebase/functions` folder.
- Navigate to index.js in `firebase/functions` folder. Provide your Apple account teamID, p8 filePath, bundleID of your app.
- Update `.firebaserc` in `firebase`` folder to use your Firebase App projectID

## YouTube Tutorial
You can check the full video tutorial on building this from scratch.

[YouTube](https://youtu.be/OiPfDZTldMo)
