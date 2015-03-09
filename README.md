#Cherry

**Cherry** is a miniscule Pomodoro Timer app designed for the   Watch. It started off as [KTPomodoro](https://github.com/kenshin03/KTPomodoro) but I decided to re-start the project in Swift once I had a firmer grasp of WatchKit's APIs and limitations. There is a Storyboard which is the Watchkit app, and a set of  Interface Controllers that contain the logic.

##Video
<img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/cherry-screencaps.gif" width="312">


##Screenshots
<div align="left">
<tr>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/screenshot_1.png" width="266" />
    </td>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/screenshot_2.png" width="266" />
    </td>
</tr>
</div>
<div align="left">
<tr>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/screenshot_3.png" width="266" />
    </td>
    <td>
        <img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/screenshot_4.png" width="266" />
    </td>
</tr>
</div>
<img src="https://raw.githubusercontent.com/kenshin03/Cherry/master/Cherry-storyboard.png" width="600">


##Features

- Add new Activity right from the watch.
- Start/Stop Activity.
- Persisting of Activities data in CoreData: shared in App Container between App Extension and App.
- Provides **Glances** that show thew status of an in-progress activity. 
- Jump straight to the WatchApp by tapping on the Glances.

##How to build with app container support
1. Select the Cherry project in the Xcode project navigator
2. Update all three targets below to use your own **Team**:
	- **Cherry** - the Cherry app for iOS
	- **Cherry WatchKit Extension** - the WatchKit extension for Apple Watch
	- **Cherry WatchKit App** - the WatchKit app for Apple Watch
3. Now switch to **Cherry** target and select the **Capabilities** tab. Enable **App Groups** by flicking the switch to **On**.<br/>
Make sure the **App Groups** section is expanded, and tap the **+** button to add a new group. <br/> Name it `group.<YOUR_DOMAIN>.<GROUP_NAME>`. ex: `group.com.somegroup.KTPomodoro	` <br/> then slelect the group you just created.
4. Next,  enable app groups by repeating the same steps for the **Cherry WatchKit Extension** target. This time, all you have to do is select the **App Group** you just created.
5. Update the **Bundle Identifier** of all three targets, such as:
	- **Cherry** - `com.somegroup.KTPomodoro`
	- **Cherry WatchKit Extension** - `com.somegroup.KTPomodoro.watchkit`
	- **Cherry WatchKit App** - `com.somegroup.KTPomodoro` <br/>
	Then tap "Fix Issue" to let Xcode help you!
6. Update **KTCoreDataStack.swift** & **KTSharedUserDefaults.swift**,<br/>set **shouldUseAppGroupsForStorage** to **true**, then use **App Group** ID you created.
7. Update **KTWatchActivitiesListInterfaceController.swift**, replace `com.corgitoergosum.KTPomodoro.select_activity` to your own **Bundle Identifier**, ex: `com.somegroup.KTPomodoro.select_activity`
8. Select WatchKit Extension's info.plist, then change **NSExtension/NSExtensionAttributes/WKAppBundleIdentifier** to **Cherry WatchKit App**'s Bundle Identifier.
9. Select **Product** -> **Clean**, then change Schema to **Cherry Watchkit App** and you are ready to run!
	
##To-Do

- Fix WKInterfaceTable issue when beta 6 is released.
- Allowing selection of theme colors.
- Add sending of notifications on Pomo end and Activity End.
- Test Notifications on a real device? (As of Xcode6.2beta5, Watch simulator does not support receiving local notifications)
- Make Breaks between pomodoros optional.
- Make interruptions useful.
- Build an app component.

##License
`Cherry` is available under the MIT license. 

##Feedback
File an issue or pull request. Or ping me at [@kenshin03](http://twitter.com/kenshin03).
