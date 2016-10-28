# FixedOrientationViewControllers

Recently I was asked to recreate the native iOS camera App in terms of having an interface that stays relatively static when you rotate the phone except for a few specific views. After some research and some trial and error, I came up with 3 solutions that did not involve writing a complete layout system.

Each of the 3 ways has different pros and cons and ultimately we decided as a team which one to move forward with. I was very interested by the difficulty that iOS imposes on developers regarding handling orientation changes as well as the relatively little documentation out there (stackoverflow, etc) regarding doing something similar that I decided to document my solutions in case anyone else wanted to see them.
