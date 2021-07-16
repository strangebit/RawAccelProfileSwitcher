# RawAccel Profile Switcher for the CLI (v1.0.2)

RawAccel Profile Switcher is a simple Batch script that allows you
to quickly save and switch between different [RawAccel](https://github.com/a1xd/rawaccel)
settings from the Command-Line Interface (CLI), including the Run
dialog (by pressing WinKey + R).

To save your current RawAccel settings, press WinKey + R, type in
`rawaccel-switch --save quake`, and then hit ENTER. To restore these
settings later, just type `rawaccel-switch quake`. When you are done
playing Quake, you could type in `rawaccel-switch windows` to switch
back to your preferred Windows settings (assuming you already have a
previously-saved profile under that name).

![WindowsRunDialogExample](rawaccel-switch-doc/images/WindowsRunDialog.png)

If you prefer, you can also use the simpler `rawaccel` command, rather
than more cumbersome `rawaccel-switch` command, by slightly tweaking
the installation process. This is how I personally use it, but to set
it up in this way you will also be required to edit the Batch script
yourself to point to your particular RawAccel program directory. Don't
worry, this is relatively easy to do. Detailed instructions are found
at the [bottom of the Guide](rawaccel-switch-doc/guide.md#how-to-install-as-rawaccel-rather-than-rawaccel-switch).

![WindowsRunDialogExample2](rawaccel-switch-doc/images/WindowsRunDialog2.png)

----

## Using RawAccel Profile Switcher

    rawaccel-switch [--save | --delete | --gui | --writer] <profile-name>
    rawaccel-switch --list [<profile-name-filter>]

When using the `--save` option, your current RawAccel settings will be
saved into the specified profile. If a profile already exists under
that name, it will overwrite the profile without asking for
confirmation. Be sure that this is what you want to do before using
this option.

When using the `--delete` option, this will cause the specified
previously-saved profile to be deleted so that it is no longer
accessible to RawAccel Profile Switcher. This will occur without
asking for confirmation, so be sure that this is what you want to do
before using this option.

When using `rawaccel-switch` without any of the options, this will simply
restore the specified profile and apply them to your current RawAccel
settings. For example, `rawaccel-switch windows` will restore and apply
the `windows` profile to your current RawAccel settings.

When restoring a saved profile, use the `--gui` or `--writer` options
if you want to enforce that the RawAccel GUI application is launched,
or that RawAccel's `writer.exe` is used. For more information on using
these options, see the section of the Guide entitled
[Using the gui and writer options](rawaccel-switch-doc/guide.md#using-the-gui-and-writer-options).

Using the `--list` option will display a list of all of the saved
profiles by their profile names. You can also specify a filter, which
can include wildcards. For example, `rawaccel-switch --list fk2_*` will
display a list of all saved profiles that have an `fk2_` prefix in
their profile names.

----

## Download

To download RawAccel Profile Switcher, please visit the
[Releases page](https://github.com/strangebit/RawAccelProfileSwitcher/releases).

For help setting up and using RawAccel Profile Switcher, please refer to the
[Guide](rawaccel-switch-doc/guide.md#how-to-set-up-and-use-multiple-rawaccel-profiles).
