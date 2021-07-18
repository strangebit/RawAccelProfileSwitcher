# Changelog


## v1.0.3

* Added a `--help` option to display help text.
* Updated the [Guide](guide.md) to reflect the above change.
* Made a few more minor improvements to the [Guide](guide.md).


## v1.0.2

* Added a `--list` option to display a list of all saved profiles.
    You can also specify a filter, which can include wildcards.
* Updated the [Guide](guide.md) to reflect the above change.
* Significantly improved the [Guide](guide.md) in a multitude of other ways.
* Fixed a bug that sometimes caused the RawAccel GUI application to
    restore when it shouldn't. This was occurring when the script was
    being used multiple times from the same Command Prompt session,
    due to an internal variable having global and persistent scope.
* Reworked the Batch script code somewhat significantly to use better
    coding practices, but this should hopefully not result in any
    outwards-facing differences or regressions.


## v1.0.1

* Added a `--delete` option to delete saved profiles.
* Allow all options to be specified before the profile name.
    Typing `rawaccel-switch --gui quake` will now work as expected.
* Updated the [Guide](guide.md) to reflect the above changes.


## v1.0.0

* Initial release.
