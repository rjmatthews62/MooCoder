# MooCoder
Tool for writing and debugging MooCode (for LambaMoo with the stunt/toast fork)

This is written in Delphi 10.2, and is now using synedit for the editor, so you will need to use getit synedit to compile.

This also acts as a simple mush client.

### Usage:
  Settings->Connect to a mush server.
  
 Once logged in (as a programmer) use "Dump" on an object to load all the verbs into separate editable tabs. This can then be edited, and sent back to the MOO server to compile.
 
 Get Verbs - will get each all the verbs from an object and add them to the verbs tab.
 
 Errors will be highlighted.
 You can also add a test command to test the results of your work.
 
 Runtime errors will be detected and the appropriate verb loaded, and the error line highlighted. You can also double-click on the stack trace in the debug window (you may have to scroll back a bit, it's a bit messy at present)
 
 The "Verbs" tab shows the currenly known verbs are listed. Double click to load and edit that verb.
 
 Ctrl+N will allow you to manually enter a verb definition to load.
 
 Ctrl+F works as Find.
 
 Ctrl+G goes to a line number.

 Ctrl+R reload the current verb code from the server.
 
 Project->New Verb : will do @verb for you and load the tab. (Take a few seconds currently)
 
 Basic syntax highlighting has been implemented.
 
NOTE: Ansi codes are currently stripped by the @dump command. The "Get Verbs" mostly deals with this OK. It is something to be aware of.
 
### Not working yet 
 This is not idiot proofed.
 
 Multiple instances of verbs with the same name probably won't load correctly.
 
 Need to implement indenting properly.
 
 

