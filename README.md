Assignment 3: Mailbox
=====================

# Time Spent
6 hours

# Required Features
* On dragging the message left...
   * Initially, the revealed background color should be gray.
   * As the reschedule icon is revealed, it should start semi-transparent and become fully opaque. If released at this point, the message should return to its initial position.
   * After 60 pts, the later icon should start moving with the translation and the background should change to yellow.
     * Upon release, the message should continue to reveal the yellow background. When the animation it complete, it should show the reschedule options.
   * After 260 pts, the icon should change to the list icon and the background color should change to brown.
     * Upon release, the message should continue to reveal the brown background. When the animation it complete, it should show the list options.
   * ~~User can tap to dismissing the reschedule or list options. After the reschedule or list options are dismissed, you should see the message finish the hide animation.~~
   * __When dismissed, the line item returns but when an action is taken (scheduled or added to a list), the message hides__
* On dragging the message right...
   * Initially, the revealed background color should be gray.
   * As the archive icon is revealed, it should start semi-transparent and become fully opaque. If released at this point, the message should return to its initial position.
   * After 60 pts, the archive icon should start moving with the translation and the background should change to green.
     * Upon release, the message should continue to reveal the green background. When the animation it complete, it should hide the message.
   * After 260 pts, the icon should change to the delete icon and the background color should change to red.
     * Upon release, the message should continue to reveal the red background. When the animation it complete, it should hide the message.

# Optional Features
* Menu
   * Panning from the left edge should reveal the menu
   * After 285 pts, if user lifts finger, continues to reveal menu
     * Otherwise it will return to left edge
* Segmented control
   * Tints correctly
   * Shows scrollview for archived messages
* Shake to undo: only performs when there's something to undo

# External libraries
* UIColor Hex https://github.com/yeahdongcn/UIColor-Hex-Swift
