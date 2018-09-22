# Pivot Chords

Given two keys, displays the chords that those keys have in common.

Such chords are known as "pivot chords" and can be used to modulate between those two keys.

## Installation

* Copy the file `PivotChords.qml` into your MuseScore2 Plugins directory.
* Start MuseScore2.
* Go to Plugins > Plugin Manager.
* Tick the box next to PivotChords.

## Usage

* Navigate to Plugins > Composing Tools > Pivot Chords.
* The pop up window allows you to select a "from" key and mode (Major or Minor) and a "to" key and mode.
* Click the "Tell" button and a description of the possible pivot chords is shown in the textarea.
* You can choose any number of key combinations, click "Tell" after each one, and the instructions in the text area will accumulate.
* The text in the text area can then be copied to your clipboard with the "Copy" button, from whence you can paste it into a notepad or similar application.
* Finally the "Quit" button quits the plugin.

## Notes on the Output

Each pivot chord is described as its function in the first key and its function in the second key, in the form "func1 is func2". For
those users that don't understand roman numeral analysis, the notes of the chord are supplied in brackets.

## Limitations

* The plugin does not supply any canonical name for the chords, but it wouldn't be hard to do.
* Because of the way the plugin works, the notes of the chord are not guaranteed to be in root position.
* The plugin is really intended for people who already know about modulation, as well as the various chords and their uses.
