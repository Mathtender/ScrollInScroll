# ScrollInScroll
An approach to make a `UIScrollView` inside another `UIScrollView` with unstoppable scrolling.

Code in this repo provides posibility to pass scrolling from an outer `UIScrollView` to the inner `UIScrollView` and vice versa without any interruptions.\
The idea is to use custom `UIPanGestureRecognizer` rather than scrollView's pan gesture.\
With this approach we are able to handle pan gesture as we want to, so it's easy to pass it to the outer or to the inner scroll depending on the situation.\
The main problem of this approach was a deceleration, but the problem was solved through the custom deceleration animation based on pan gesture velocity and current scrollView's contnet offset.

Usage: 
1) Copy the source files to your project.
2) Copy code from ViewController.swift to your controller.
3) Delete the outlets or bind your own if you have them.
4) Use continious scrolling through outer and inner views :)

Test scrolling:
1) Create new iOS App Xcode project.
2) Copy files to the project folder replacing Main.storyboard.
3) Launch the project.
4) Profit :)
