# Voice Velocity

Alters the velocity offset of all the notes of a chosen voice within a selection.

The dynamics (PP, P etc.) allow a choice of Part (single stave), Stave (both staves in the case of a piano) or System (all staves).
That does not allow the control of the dynamics of a single voice within a part, which this plugin adresses.

## Installing
* Copy the file `voice-velocity.qml` to your MuseScore2 Plugins directory.
* Re-start MuseScore.
* Go to Plugins > Plugin Manager and tick the box next to voice-velocity.

## Running
* Select a passage of music within a single stave with multiple voices.
* Select Plugins > Playback > Voice Velocity to start the plugin.
* Choose an offset. Negative values make the voice quieter, positive values louder.
* Choose the voice that you want to alter.
* Click Apply.
* You can check that it worked by selecting a single note of that voice and looking at the velocity in the inspector.
