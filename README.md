#Cherry

**Cherry** is a miniscule Pomodoro Timer app designed for the   Watch. It started off as [KTPomodoro](https://github.com/kenshin03/KTPomodoro) but I decided to re-start the project in Swift once I had a firmer grasp of WatchKit's APIs and limitations. 

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
