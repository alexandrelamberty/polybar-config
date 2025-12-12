#!/bin/bash
# GTK Dialog Example

gtkdialog --program=MY_DIALOG

exit

MY_DIALOG='
<window title="Example Dialog" resizable="false">
  <vbox>
    <text>
      <label>Enter your name:</label>
    </text>
    <entry>
      <variable>user_name</variable>
    </entry>
    <hbox>
      <button>
        <label>OK</label>
        <action>echo "Hello, $user_name!" && exit</action>
      </button>
      <button>
        <label>Cancel</label>
        <action>exit</action>
      </button>
    </hbox>
  </vbox>
</window>'