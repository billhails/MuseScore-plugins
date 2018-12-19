# Tuning

I've written a plugin (tested with MuseScore 2.1.0) that others may find useful.

I've been intrigued for a while by the tuning Bach purportedly used for his WTC according to Bradley Lehman [Website Here](http://www.larips.com) and initially set out to just do that, however I found a great resource on other tunings by Pierre Lewis [Here](http://leware.net/temper/temper.htm) and went ahead and added all of those too.

![Tuning Pop Up](https://raw.githubusercontent.com/billhails/MuseScore-plugins/develop/images/Tuning.png)

## Tunings and Temperaments Supported

Supported tunings with a brief description, see the Pierre Lewis page above for an explaination of the descriptions `:-)`

| Tuning | Description |
| ------ | ----------- |
| Equal | Each fifth is tempered 2 cents short of a pure fifth. equally distributing the comma |
| Pythagore | Untempered pure fifths, the entire 24-cent comma is between Eb and G# |
| Aaron | Each fifth is tempered 5.5 cents so that major thirds are pure, but resulting in a 36.5 cent "wolf" between Eb and G# |
| Silberman | Compromise tempering each fifth by 1/6 of a syntonic comma (used by high Baroque organs) |
| Salinas | A negative temperament (1/3 comma makes the major thirds slightly narrow) |
| Kirnberger | Irregular temperamemt (different fifths tempered differently) means each key has a distinctive sound |
| Vallotti | Another irregular temperament |
| Werkmeister | Another, less symmetric irregular temperament |
| Marpurg | Three fifths tempered by 8 cents and evenly distributed |
| Just | "Just" intonation, near thirds and fifths are pure, at the expense of some intervals (and this tuning in general) being unusable |
| Mean Semitone | like Aaron, but the remaining comma is distributed between B-F# and Bb-F (15.75 cents each) |
| Grammateus | Hybrid Pythagorean tuning with the chromatic notes tempered |
| French | Temperament Ordinaire, first fifths tuned wide of a pure fifth, later fifths narrowed to compensate |
| French (2) | Similar to French |
| Rameau | Similar to French |
| Irregular Fr. 17e | Similar to French |
| Bach/Lehman | see the Bradley Lehman link above |

## Installation

* Copy the pluging to your `MuseScore2/Plugins` directory
* start MuseScore
* enable the plugin via `Plugins > Plugin Manager...`.

## Usage

Select a passage, then invoke the plugin via `Plugins > Playback > Tuning`, select a tuning and apply. It changes the tuning offset for every selected note appropriately. To reset, select everything and apply the "equal" tuning (equal temperament.)

New in this release, you can now select a root note other than C on which the tuning will be centered.

## PS

Many people say they can't tell the difference between tunings, and it is a subtle difference in the character of chords for the most part. To convince yourself that this plugin is working, I suggest applying the "Just" intonation (a particularily extreme tuning) to a passage of chordal music with chromatic harmony and notice how some (yymv) sounds beautifully concordant while the rest sounds horribly out of tune.
