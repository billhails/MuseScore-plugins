# Mirror Intervals

This plugin mirrors intervals chromatically about a chosen pivot note.

## Behaviour

The plugin requests a pivot note, then for each voice part in the selection:

* Identify the first note in the part within the selection.
* Find the pivot tone nearest that first note.
* Mirror the whole part chromatically about that pivot tone.

The outcome of this is that the parts should stay reasonably close in pitch when mirrored, the bass will
(more or less) stay in the bass and the treble in the treble, provided the voices don't have an extreme
ambitus or start on an uncharacteristic pitch. If they do end up in the wrong range, you can select a single
voice with the standard selection filter `View > Selection Filter` then transpose it up or down an octave.

## Some Observations

This is pure chromatic mirroring. The results can be surprising but here are some guidelines and observations.

Mirroring a section about either D or G# will map white notes to white notes, specifically:

| From | To |
| ---- | -- |
| G#   | Ab |
| A    | G  |
| Bb   | F# |
| B    | F  |
| C    | E  |
| C#   | Eb |
| D    | D  |
| E    | C  |
| F    | B  |
| F#   | Bb |
| G    | A  |

Looking at the above table, you should be able to work out that the tonic in C major maps to the tonic in A minor, but in an odd way:

| From | To |
| ---- | -- |
| G    | A  |
| E    | C  |
| C    | E  |

If the tonic C is in root position, the resulting tonic A is in second inversion.

That means to mirror a major to its relative minor you should pivot about the supertonic or the flattened submediant, and
to mirror a minor to a major you should pivot about the leading tone or the subdominant.

I've had considerable (perhaps too much) success using this to generate variations on melodies; though the results aren't
always pleasing, they are often surprisingly convincing musically, if the source material is.

## Installation

* Copy the pluging to your `MuseScore2/Plugins` directory
* start MuseScore
* enable the plugin via `Plugins > Plugin Manager...`.

## Usage

Select a passage of music, invoke the plugin via `Plugins > Composing Tools > Mirror Intervals`, choose a pivot tone and apply.
