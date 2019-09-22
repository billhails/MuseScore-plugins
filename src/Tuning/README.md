# Tuning

I've written a plugin (tested with MuseScore 2.1.0 and 3.0.5) that others may find useful.
However with MuseScore 3.x pretty stable now, I will no longer be back-porting new features into the
2.x version.

I've been intrigued for a while by the tuning Bach purportedly used
for his WTC according to Bradley Lehman [Website Here](http://www.larips.com)
and initially set out to just do that,
however I found a great resource on other tunings by Pierre Lewis
[Here](http://leware.net/temper/temper.htm) and went ahead and added
all of those too.

## Screen Shot

![Tuning Pop Up](https://raw.githubusercontent.com/billhails/MuseScore-plugins/develop/images/Tuning.png)

## Tunings and Temperaments Supported

Supported tunings with a brief description, see the Pierre Lewis
page linked above for an explaination of the descriptions `:-)`.
But in brief, a cent is 1/100 of an equal-tempered semitone, a comma
(or diatonic comma) is the difference between the C you started on
and the B# you finish on when tuning in pure fiths (24 cents) and
the syntonic comma is the difference between a pure third and the
first third you reach when tuning in pure fifths (around 21.5 cents.)

| Tuning | Description |
| ------ | ----------- |
| Equal | Each fifth is tempered 2 cents short of a pure fifth. equally distributing the comma. |
| Pythagorean | Untempered pure fifths, the entire 24-cent comma is between Eb and G#. |
| Aaron | Each fifth is tempered 5.5 cents so that major thirds are pure, but resulting in a 36.5 cent "wolf" between Eb and G#. |
| Silberman | Compromise tempering each fifth by 1/6 of a syntonic comma. Used by high Baroque organs. |
| Salinas | A negative temperament. 1/3 comma makes the major thirds slightly narrow. |
| Kirnberger | an irregular temperamemt (different fifths tempered differently) means each key has a distinctive sound. |
| Vallotti | Another irregular temperament. |
| Werkmeister | Another, less symmetric irregular temperament. |
| Marpurg | Three fifths tempered by 8 cents and evenly distributed. |
| Just | "Just" intonation, An academic temperament. Near thirds and fifths are pure, at the expense of some intervals being unusable. See [here](https://musescore.com/billhails/scores/5704148)|
| Mean Semitone | Like Aaron, but the remaining comma is distributed between B-F# and Bb-F (15.75 cents each.) |
| Grammateus | Hybrid Pythagorean tuning with the chromatic notes tempered. |
| French | Temperament Ordinaire, first fifths tuned wide of a pure fifth, later fifths narrowed to compensate. |
| French (2) | Similar to French. |
| Rameau | Similar to French. |
| Irregular Fr. 17e | Similar to French. |
| Bach/Lehman | Bach's own irregular temperament used for the 48 according to Lehman. See the Bradley Lehman link above. |

## Installation

* Choose either the `2.x/tuning.qml` or `3.x/tuning.qml` file.
* Click the "raw" button.
* Or choose one of these links: [2.x](https://raw.githubusercontent.com/billhails/MuseScore-plugins/master/src/Tuning/2.x/tuning.qml) or [3.x](https://raw.githubusercontent.com/billhails/MuseScore-plugins/master/src/Tuning/3.x/tuning.qml).
* In your browser do "Save as" and make sure there's no `.txt` extension.
* Save the plugin to your `MuseScore2/Plugins` or `MuseScore3/Plugins` directory as appropriate.
* start MuseScore
* enable the plugin via `Plugins > Plugin Manager...`.

## Basic Usage

If you select a passage of music, then only that passage wiil be
affected, otherwise the entire score will be processed.  Invoke the
plugin via `Plugins > Playback > Tuning`, select a tuning and apply.
It changes the tuning offset for every selected note appropriately.

To reset just hit Ctrl-Z (Cmd-Z on a Mac,) or if you're removing a
tuning that was applied in a previous session, apply the "equal"
tuning (equal temperament.)

## Advanced Usage

You can make the following adjustments to the tuning, before applying
it:

### Root Note

Allows you to choose a different root note to center the tuning on.
This has the effect of rotating the tuning around the cycle of
fifths. For example suppose in a particular tuning, with C as the
root note, the interval from C to G is a pure fifth while the
interval G to D is slightly wide. If you select G as the root note,
then the interval from G to D will be a pure fifth, and the interval
from D to A will be slightly wide, and so on for all the other
intervals.

This basically allows you to make certain tunings more usable in
remote keys.

Note that certain tunings, such as the Pythagorean, already specify
a root note other than C.

### Pure Tone

Adjusts each note by a constant amount so that the chosen pure tone
is tuned to its "correct" equal tempered pitch (i.e. offset 0.0),
while maintaining the relationships of the tuning. This is occasionally
necessary to correctly reproduce a desired tuning exactly.

Note that when you change the Root Note above, the Pure Tone also
changes to the same note. This is usually what you want, but you
can subsequently adjust the Pure Tone separately if needed.

Also note that certain preset tunings already have a pure tone
other than C, to properly represent the correct tuning. Again
you can override this choice if needed.

### Tweak

This just adds the specified value in cents to each of the final
values.  Useful if you require a particular non-zero offset for a
particular note.

### Final Values

Allows you to directly edit all the offsets that will be applied.

### Advanced Controls

#### Save

Will prompt for a filename and save the current settings. I'd
recomment creating a directory called `tunings` under your `Plugins`
directory, but you can put them where you like. The file is text,
in JSON format, so you can share your tunings with others or save
them for later re-use.

#### Load

Loads a file previously saved above.

#### Undo

Undoes the last change. There is a hstory limit of 30.

#### Redo

Redo a previous undo, where possible.

### Caveats

With the exception of the "Annotate" checkbox, the controls are
applied strictly top to bottom and left to right.  This means that
making a change in any of the controls will override any changes
below and to the right of that control, so for example if you
manually edit the Final Values then select a different Root Note
your changes to the Final Values will be overridden. You can use
the Undo button to revert that change however.

### Apply and Cancel

If you have made customisations to a tuning, and you hit "Apply"
or "Cancel", you will be asked to confirm that you want the plugin to
quit. You might be quite annoyed if you spent time entering a set
of offsets manually, hit apply to try them out, and the plugin
applied them then vanished with no record of your work other than the
score.

### Annotate

Annotates each note with the offset in cents that was applied. I wanted
this, so you all get it `:-)`.

