# RawAccel Profile Switcher for the CLI (v1.0.0)

RawAccel Profile Switcher is a simple Batch script that allows you
to quickly save and switch between different [RawAccel](https://github.com/a1xd/rawaccel)
settings from the Command-Line Interface (CLI), including the Run
dialog (by pressing WinKey + R).

To save your current RawAccel settings, press WinKey + R, type in
`rawaccel-switch quake --save`, and then hit ENTER. To restore these
settings later, type in `rawaccel-switch quake`. This will
automatically restore your saved RawAccel settings. When you
are done playing Quake, you could then type in `rawaccel-switch windows`
to automatically switch back to the RawAccel settings you prefer to use
in Windows (assuming you have a saved profile under that name).

![WindowsRunDialogExample](rawaccel-switch-doc/images/WindowsRunDialog.png)

If you prefer, you can also use the simpler command `rawaccel`, rather
than `rawaccel-switch`, by slightly tweaking the set-up process. This
is how I personally use it, but to set it up in this way you will also
be required to edit your Batch script and point it to your particular
RawAccel program directory. Don't worry, this is relatively easy to do.
Detailed instructions are found at the bottom of the [Guide](rawaccel-switch-doc/guide.md).

![WindowsRunDialogExample2](rawaccel-switch-doc/images/WindowsRunDialog2.png)

----

To download RawAccel Profile Switcher, please refer to the
[Releases page](https://github.com/strangebit/RawAccelProfileSwitcher/releases).

For help setting up RawAccel Profile Switcher, please refer to the
detailed [Guide](rawaccel-switch-doc/guide.md).
