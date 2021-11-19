# MooCoder
Tool for writing and debugging MooCode (for LambdaMoo - specifically with the stunt/toast fork, but should work on others.)

This is written in Delphi 10.2, and is now using synedit for the editor, so you will need to use getit synedit to compile.

This also acts as a simple mush client.

### Usage:
  Settings->Connect to a moo server.

 Once logged in (as a programmer) use "Dump" on an object to load all the verbs into separate editable tabs. This can then be edited, and sent back to the MOO server to compile.

 Get Verbs - will get each all the verbs from an object and add them to the verbs tab.

 Errors will be highlighted.
 You can also add a test command to test the results of your work.

 Runtime errors will be detected and the appropriate verb loaded, and the error line highlighted. A stack window will open, and you can double-click on the stack trace to view the calling code.

 The "Verbs" tab shows the currenly known verbs are listed. Double click to load and edit that verb.

 Ctrl+N will allow you to manually enter a verb definition to load.

 Ctrl+F works as Find.

 Shift+Ctrl+F will try to find a verb in an open tab (and also bring it to the front of the tab list).

 Ctrl+G goes to a line number.

 Ctrl+H works as a replace (BUT IT IS VERY PRIMITIVE AS YET, USE WITH CARE!)

 Ctrl+R reload the current verb code from the server. NOTE: Worth doing this after a successful compile as LambdaMOO does its own formatting, and the line nos may not now match what you have typed.

 Project->New Verb : will do @verb for you and load the tab. (Takes a few seconds currently)

 Basic syntax highlighting has been implemented.

 Double-click on any error message or call stack message to open that verb.

 Edit->Text Property - allows you to edit a text property.

Ctrl+up and Ctrl+Down will scroll you through your command history.

NOTE: Ansi codes are currently stripped by the @dump command. The "Get Verbs" mostly deals with this OK. It is something to be aware of.

**improved_dump.txt** is moocode to modify the @dump command to avoid the issue.

### Not working yet
 This is not idiot proofed.

 Multiple instances of verbs with the same name probably won't load correctly.

### Binary
Windows binary can be found here:
http://www.mithril.com.au/moocoder.zip

It is a single exe file. Unzip to anywhere and just run it.

### Release Notes ###
1.5.4.1 - Improved font style handling.

1.5.4.0 - Fixed "Unbold" support.

1.5.3.0 - Added "Wrap at 80 Chars" settings option

1.5.1.0 - Added Font selection for Console, fixed minor access violation on Verbs list.

1.5.0.0 - Changed BOLD to operate on colours, not font style. This should fix some variable width issues.

1.4.0.0 - Bracket Matching, Refresh keeps cursor on line.

1.3.1.0 - Got background color working.

1.3.0.0 - Added support for rgb and x256 colors. Fixed "find" function on main window.

1.2.0.0 - Added Property Text Editor (Edit->Text Property), shows args in verbs

1.1.0.0 - Improved escaped string display, fixed find to work in main window, stated work on propert text editor.

