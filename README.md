# Fixed Orientation View Controllers

Recently I was asked to recreate the native iOS camera App in terms of having an interface that stays relatively static when you rotate the phone except for a few specific views. After some research and some trial and error, I came up with 3 solutions that did not involve writing a complete layout system.

Each of the 3 ways has different pros and cons and ultimately we decided as a team which one to move forward with. I was very interested by the difficulty that iOS imposes on developers regarding handling orientation changes as well as the relatively little documentation out there (stackoverflow, etc) regarding doing something similar that I decided to document my solutions in case anyone else wanted to see them.

## Methods

### Size Classes

This method uses size classes to provide different layouts for portrait and landscape. There is an additional trick, though. In the view controller, we override the trait collections that are reported for landscape right so that it will use a different layout than the normal landscape layout. During the rotations we disable animations so that it doesn't appear that the UI has changed at all. This method is likely the most time intensive as it requires doing your layouts 3 different times, but it is arguably the least error prone from a UIKit perspective.

### Fake Rotation

This method is the simplest to understand and maintain. Basically, we just don't allow actual interface rotations. Instead, we get device orientation change notifications and respond to those appropriately. The main downside of this method is that if your user is in "landscape" and they receive a system notification, it will come from the "side" of the screen. Additaionlly, the notification center and control center are located on the "sides" of the screen. On the plus side, the logic for the rotation code can be very simple and nicely encapsulated.

### Reverse Core Animation Transforms

I got this method from [Apple](https://developer.apple.com/library/content/qa/qa1890/_index.html). It relies on the `transform` property of the view's CALayer. Essentially, an interface orientation change is implemented as a rotation about the z axis on the layer's transform. During the animation, we "undo" the transformation that the system is trying to apply. This is an oversimplification of UIKit of course, but it gets the point across.

This method doesn't play nicely with autolayout, as Apple mentions, but using the new, old springs and struts you can still achieve a fairly robust layout without much effort. This method is probably the most fragile from a UIKit perspective as Apple could very easily break your code in a future OS.
