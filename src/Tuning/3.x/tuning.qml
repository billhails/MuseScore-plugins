// Apply a choice of tempraments and tunings to a selection
// Copyright (C) 2018-2019  Bill Hails
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import MuseScore 3.0
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import FileIO 3.0

MuseScore {
    version: "3.0.2"
    menuPath: "Plugins.Playback.Tuning"
    description: "Converts between tuning systems"
    pluginType: "dialog"
    width: 550
    height: 500

    property var offsetTextWidth: 40;
    property var offsetLabelAlignment: 0x02 | 0x80;

    // see command.js
    property var history: 0;

    // set true if customisations are made to the tuning
    property var modified: false;

    /**
     * See http://leware.net/temper/temper.htm and specifically http://leware.net/temper/cents.htm
     *
     * I've taken the liberty of adding the Bach/Lehman temperament http://www.larips.com which was
     * my original motivation for doing this.
     *
     * These values are in cents. One cent is defined as 100th of an equal tempered semitone.
     * Each row is ordered in the cycle of fifths, so C, G, D, A, E, B, F#, C#, G#/Ab, Eb, Bb, F;
     * and the values are offsets from the equal tempered value.
     *
     * However for tunings who's default root note is not C, the values are pre-rotated so that applying the
     * root note rotation will put the first value of the sequence at the root note.
     */
    property var equal: {
        'offsets': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'root': 0,
        'pure': 0,
        'name': "equal"
    }
    property var pythagorean: {
        'offsets': [-6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0],
        'root': 9,
        'pure': 3,
        'name': "pythagorean"
    }
    property var aaron: {
        'offsets': [10.5, 7.0, 3.5, 0.0, -3.5, -7.0, -10.5, -14.0, -17.5, -21.0, -24.5, -28.0],
        'root': 9,
        'pure': 3,
        'name': "aaron"
    }
    property var silberman: {
        'offsets': [5.0, 3.3, 1.7, 0.0, -1.7, -3.3, -5.0, -6.7, -8.3, -10.0, -11.7, -13.3],
        'root': 9,
        'pure': 3,
        'name': "silberman"
    }
    property var salinas: {
        'offsets': [16.0, 10.7, 5.3, 0.0, -5.3, -10.7, -16.0, -21.3, -26.7, -32.0, -37.3, -42.7],
        'root': 9,
        'pure': 3,
        'name': "salinas"
    }
    property var kirnberger: {
        'offsets': [0.0, -3.5, -7.0, -10.5, -14.0, -12.0, -10.0, -10.0, -8.0, -6.0, -4.0, -2.0],
        'root': 0,
        'pure': 0,
        'name': "kirnberger"
    }
    property var vallotti: {
        'offsets': [0.0, -2.0, -4.0, -6.0, -8.0, -10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0],
        'root': 0,
        'pure': 0,
        'name': "vallotti"
    }
    property var werkmeister: {
        'offsets': [0.0, -4.0, -8.0, -12.0, -10.0, -8.0, -12.0, -10.0, -8.0, -6.0, -4.0, -2.0],
        'root': 0,
        'pure': 0,
        'name': "werkmeister"
    }
    property var marpurg: {
        'offsets': [0.0, 2.0, 4.0, 6.0, 0.0, 2.0, 4.0, 6.0, 0.0, 2.0, 4.0, 6.0],
        'root': 0,
        'pure': 0,
        'name': "marpurg"
    }
    property var just: {
        'offsets': [0.0, 2.0, 4.0, -16.0, -14.0, -12.0, -10.0, -30.0, -28.0, 16.0, 18.0, -2.0],
        'root': 0,
        'pure': 0,
        'name': "just"
    }
    property var meanSemitone: {
        'offsets': [0.0, -3.5, -7.0, -10.5, -14.0, 3.5, 0.0, -3.5, -7.0, -10.5, -14.0, -17.5],
        'root': 6,
        'pure': 6,
        'name': "meanSemitone"
    }
    property var grammateus: {
        'offsets': [-2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 0.0, 2.0, 4.0, 6.0, 8.0],
        'root': 11,
        'pure': 1,
        'name': "grammateus"
    }
    property var french: {
        'offsets': [0.0, -2.5, -5.0, -7.5, -10.0, -12.5, -13.0, -13.0, -11.0, -6.0, -1.5, 2.5],
        'root': 0,
        'pure': 0,
        'name': "french"
    }
    property var french2: {
        'offsets': [0.0, -3.5, -7.0, -10.5, -14.0, -17.5, -18.2, -19.0, -17.0, -10.5, -3.5, 3.5],
        'root': 0,
        'pure': 0,
        'name': "french2"
    }
    property var rameau: {
        'offsets': [0.0, -3.5, -7.0, -10.5, -14.0, -17.5, -15.5, -13.5, -11.5, -2.0, 7.0, 3.5],
        'root': 0,
        'pure': 0,
        'name': "rameau"
    }
    property var irrFr17e: {
        'offsets': [-8.0, -2.0, 3.0, 0.0, -3.0, -6.0, -9.0, -12.0, -15.0, -18.0, -21.0, -24.0],
        'root': 9,
        'pure': 3,
        'name': "irrFr17e"
    }
    property var bachLehman: {
        'offsets': [0.0, -2.0, -3.9, -5.9, -7.8, -5.9, -3.9, -2.0, -2.0, -2.0, -2.0, 2.0],
        'root': 0,
        'pure': 3,
        'name': "bachLehman"
    }

    property var currentTemperament: equal;
    property var currentRoot: 0;
    property var currentPureTone: 0;

    onRun: {
        if (!curScore) {
            error("No score open.\nThis plugin requires an open score to run.\n")
            Qt.quit()
        }
    }

    function getHistory() {
        if (history == 0) {
            history = new commandHistory()
        }
        return history
    }

    function applyTemperament()
    {
        var selection = getSelection()
        if (selection === null) {
            error("No selection.\nThis plugin requires a current selection to run.\n")
            Qt.quit()
        } else {
            curScore.startCmd()
            mapOverSelection(selection, filterNotes, reTune(getFinalTuning()))
            curScore.endCmd()
        }
    }

    function mapOverSelection(selection, filter, process) {
        selection.cursor.rewind(1)
        for (
            var segment = selection.cursor.segment;
                segment && segment.tick < selection.endTick;
                segment = segment.next
        ) {
            for (var track = selection.startTrack; track < selection.endTrack; track++) {
                var element = segment.elementAt(track)
                if (element) {
                    if (filter(element)) {
                        process(element)
                    }
                }
            }
        }
    }

    function filterNotes(element)
    {
        return element.type == Ms.CHORD
    }

    function reTune(tuning)
    {
        return function(chord) {
            for (var i = 0; i < chord.notes.length; i++) {
                var note = chord.notes[i]
                note.tuning = tuning(note.pitch)
            }
        }
    }

    function getSelection() {
        var cursor = curScore.newCursor()
        cursor.rewind(1)
        if (!cursor.segment) {
            return null
        }
        var selection = {
            cursor: cursor,
            startTick: cursor.tick,
            endTick: null,
            startStaff: cursor.staffIdx,
            endStaff: null,
            startTrack: null,
            endTrack: null
        }
        cursor.rewind(2)
        selection.endStaff = cursor.staffIdx + 1
        if (cursor.tick == 0) {
            selection.endTick = curScore.lastSegment.tick + 1
        } else {
            selection.endTick = cursor.tick
        }
        selection.startTrack = selection.startStaff * 4
        selection.endTrack = selection.endStaff * 4
        return selection
    }

    function error(errorMessage) {
        errorDialog.text = qsTr(errorMessage)
        errorDialog.open()
    }

    /**
     * map a note (pitch modulo 12) to a value in one of the above tables
     * then adjust for the choice of pure note.
     */
    function lookUp(note, table) {
        var i = ((note * 7) - currentRoot + 12) % 12;
        var offset = table.offsets[i];
        var j = (currentPureTone - currentRoot + 12) % 12;
        var pureNoteAdjustment = table.offsets[j];
        var finalOffset = offset - pureNoteAdjustment;
        return finalOffset
    }

    /**
     * subtract the equal tempered value from the current tuning value to get the tuning offset.
     */
    function getTuning() {
        return function(pitch) {
            return lookUp(pitch, currentTemperament);
        }
    }

    function getFinalTuning() {
        return function(pitch) {
            pitch = pitch % 12
            switch (pitch) {
                case 0:
                    return getFinalOffset(final_c)
                case 1:
                    return getFinalOffset(final_c_sharp)
                case 2:
                    return getFinalOffset(final_d)
                case 3:
                    return getFinalOffset(final_e_flat)
                case 4:
                    return getFinalOffset(final_e)
                case 5:
                    return getFinalOffset(final_f)
                case 6:
                    return getFinalOffset(final_f_sharp)
                case 7:
                    return getFinalOffset(final_g)
                case 8:
                    return getFinalOffset(final_g_sharp)
                case 9:
                    return getFinalOffset(final_a)
                case 10:
                    return getFinalOffset(final_b_flat)
                case 11:
                    return getFinalOffset(final_b)
                default:
                    error("unrecognised pitch: " + pitch)
            }
        }
    }

    function getFinalOffset(textField) {
        return parseFloat(textField.text)
    }

    function recalculate(tuning) {
        console.log("recalculate")
        var old_final_c       = final_c.text
        var old_final_c_sharp = final_c_sharp.text
        var old_final_d       = final_d.text
        var old_final_e_flat  = final_e_flat.text
        var old_final_e       = final_e.text
        var old_final_f       = final_f.text
        var old_final_f_sharp = final_f_sharp.text
        var old_final_g       = final_g.text
        var old_final_g_sharp = final_g_sharp.text
        var old_final_a       = final_a.text
        var old_final_b_flat  = final_b_flat.text
        var old_final_b       = final_b.text
        getHistory().add(
            function () {
                final_c.text               = old_final_c
                final_c.previousText       = old_final_c
                final_c_sharp.text         = old_final_c_sharp
                final_c_sharp.previousText = old_final_c_sharp
                final_d.text               = old_final_d
                final_d.previousText       = old_final_d
                final_e_flat.text          = old_final_e_flat
                final_e_flat.previousText  = old_final_e_flat
                final_e.text               = old_final_e
                final_e.previousText       = old_final_e
                final_f.text               = old_final_f
                final_f.previousText       = old_final_f
                final_f_sharp.text         = old_final_f_sharp
                final_f_sharp.previousText = old_final_f_sharp
                final_g.text               = old_final_g
                final_g.previousText       = old_final_g
                final_g_sharp.text         = old_final_g_sharp
                final_g_sharp.previousText = old_final_g_sharp
                final_a.text               = old_final_a
                final_a.previousText       = old_final_a
                final_b_flat.text          = old_final_b_flat
                final_b_flat.previousText  = old_final_b_flat
                final_b.text               = old_final_b
                final_b.previousText       = old_final_b
            },
            function() {
                final_c.text               = tuning(0).toFixed(1)
                final_c.previousText       = final_c.text
                final_c_sharp.text         = tuning(1).toFixed(1)
                final_c_sharp.previousText = final_c_sharp.text
                final_d.text               = tuning(2).toFixed(1)
                final_d.previousText       = final_d.text
                final_e_flat.text          = tuning(3).toFixed(1)
                final_e_flat.previousText  = final_e_flat.text
                final_e.text               = tuning(4).toFixed(1)
                final_e.previousText       = final_e.text
                final_f.text               = tuning(5).toFixed(1)
                final_f.previousText       = final_f.text
                final_f_sharp.text         = tuning(6).toFixed(1)
                final_f_sharp.previousText = final_f_sharp.text
                final_g.text               = tuning(7).toFixed(1)
                final_g.previousText       = final_g.text
                final_g_sharp.text         = tuning(8).toFixed(1)
                final_g_sharp.previousText = final_g_sharp.text
                final_a.text               = tuning(9).toFixed(1)
                final_a.previousText       = final_a.text
                final_b_flat.text          = tuning(10).toFixed(1)
                final_b_flat.previousText  = final_b_flat.text
                final_b.text               = tuning(11).toFixed(1)
                final_b.previousText       = final_b.text
            },
            "final offsets"
        )
    }

    function setCurrentTemperament(temperament) {
        console.log("setCurrentTemperament " + temperament.name)
        var oldTemperament = currentTemperament
        getHistory().add(
            function() {
                currentTemperament = oldTemperament
                checkCurrentTemperament()
            },
            function() {
                currentTemperament = temperament
                checkCurrentTemperament()
            },
            "current temperament"
        )
    }

    function checkCurrentTemperament() {
        switch (currentTemperament.name) {
            case "equal":
                equal_button.checked = true
                return
            case "pythagorean":
                pythagorean_button.checked = true
                return
            case "aaron":
                aaron_button.checked = true
                return
            case "silberman":
                silberman_button.checked = true
                return
            case "salinas":
                salinas_button.checked = true
                return
            case "kirnberger":
                kirnberger_button.checked = true
                return
            case "vallotti":
                vallotti_button.checked = true
                return
            case "werkmeister":
                werkmeister_button.checked = true
                return
            case "marpurg":
                marpurg_button.checked = true
                return
            case "just":
                just_button.checked = true
                return
            case "meanSemitone":
                meanSemitone_button.checked = true
                return
            case "grammateus":
                grammateus_button.checked = true
                return
            case "french":
                french_button.checked = true
                return
            case "french2":
                french2_button.checked = true
                return
            case "rameau":
                rameau_button.checked = true
                return
            case "irrFr17e":
                irrFr17e_button.checked = true
                return
            case "bachLehman":
                bachLehman_button.checked = true
                return
        }
    }

    function lookupTemperament(temperamentName) {
        switch (temperamentName) {
            case "equal":
                return equal
            case "pythagorean":
                return pythagorean
            case "aaron":
                return aaron
            case "silberman":
                return silberman
            case "salinas":
                return salinas
            case "kirnberger":
                return kirnberger
            case "vallotti":
                return vallotti
            case "werkmeister":
                return werkmeister
            case "marpurg":
                return marpurg
            case "just":
                return just
            case "meanSemitone":
                return meanSemitone
            case "grammateus":
                return grammateus
            case "french":
                return french
            case "french2":
                return french2
            case "rameau":
                return rameau
            case "irrFr17e":
                return irrFr17e
            case "bachLehman":
                return bachLehman
        }
    }

    function setCurrentRoot(root) {
        console.log("setCurrentRoot " + root)
        var oldRoot = currentRoot
        getHistory().add(
            function () {
                currentRoot = oldRoot
                checkCurrentRoot()
            },
            function() {
                currentRoot = root
                checkCurrentRoot()
            },
            "current root"
        )
    }

    function checkCurrentRoot() {
        switch (currentRoot) {
            case 0:
                root_c.checked = true
                break
            case 1:
                root_g.checked = true
                break
            case 2:
                root_d.checked = true
                break
            case 3:
                root_a.checked = true
                break
            case 4:
                root_e.checked = true
                break
            case 5:
                root_b.checked = true
                break
            case 6:
                root_f_sharp.checked = true
                break
            case 7:
                root_c_sharp.checked = true
                break
            case 8:
                root_g_sharp.checked = true
                break
            case 9:
                root_e_flat.checked = true
                break
            case 10:
                root_b_flat.checked = true
                break
            case 11:
                root_f.checked = true
                break
        }
    }

    function setCurrentPureTone(pureTone) {
        console.log("setCurrentPureTone " + pureTone)
        var oldPureTone = currentPureTone
        getHistory().add(
            function () {
                currentPureTone = oldPureTone
                checkCurrentPureTone()
            },
            function() {
                currentPureTone = pureTone
                checkCurrentPureTone()
            },
            "current pure tone"
        )
    }

    function checkCurrentPureTone() {
        switch (currentPureTone) {
            case 0:
                pure_c.checked = true
                break
            case 1:
                pure_g.checked = true
                break
            case 2:
                pure_d.checked = true
                break
            case 3:
                pure_a.checked = true
                break
            case 4:
                pure_e.checked = true
                break
            case 5:
                pure_b.checked = true
                break
            case 6:
                pure_f_sharp.checked = true
                break
            case 7:
                pure_c_sharp.checked = true
                break
            case 8:
                pure_g_sharp.checked = true
                break
            case 9:
                pure_e_flat.checked = true
                break
            case 10:
                pure_b_flat.checked = true
                break
            case 11:
                pure_f.checked = true
                break
        }
    }

    function setModified(state) {
        console.log("setModified " + state)
        var oldModified = modified
        getHistory().add(
            function () {
                modified = oldModified
            },
            function () {
                modified = state
            },
            "modified"
        )
    }

    function temperamentClicked(temperament) {
        getHistory().begin()
        setCurrentTemperament(temperament)
        setCurrentRoot(currentTemperament.root)
        setCurrentPureTone(currentTemperament.pure)
        recalculate(getTuning())
        getHistory().end()
    }

    function rootNoteClicked(note) {
        getHistory().begin()
        setModified(true)
        setCurrentRoot(note)
        setCurrentPureTone(note)
        recalculate(getTuning())
        getHistory().end()
    }

    function pureToneClicked(note) {
        getHistory().begin()
        setModified(true)
        setCurrentPureTone(note)
        recalculate(getTuning())
        getHistory().end()
    }

    function editingFinishedFor(textField) {
        var oldText = textField.previousText
        var newText = textField.text
        getHistory().begin()
        setModified(true)
        getHistory().add(
            function () {
                textField.text = oldText
            },
            function () {
                textField.text = newText
            },
            "edit text field"
        )
        getHistory().end()
        textField.previousText = newText
    }

    Rectangle {
        color: "lightgrey"
        anchors.fill: parent
 
        GridLayout {
            columns: 2
            anchors.fill: parent
            anchors.margins: 10
            GroupBox {
                title: "Temperament"
                ColumnLayout {
                    ExclusiveGroup { id: tempamentTypeGroup }
                    RadioButton {
                        id: equal_button
                        text: "Equal"
                        checked: true
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(equal) }
                    }
                    RadioButton {
                        id: pythagorean_button
                        text: "Pythagorean"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(pythagorean) }
                    }
                    RadioButton {
                        id: aaron_button
                        text: "Aaron"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(aaron) }
                    }
                    RadioButton {
                        id: silberman_button
                        text: "Silberman"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(silberman) }
                    }
                    RadioButton {
                        id: salinas_button
                        text: "Salinas"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(salinas) }
                    }
                    RadioButton {
                        id: kirnberger_button
                        text: "Kirnberger"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(kirnberger) }
                    }
                    RadioButton {
                        id: vallotti_button
                        text: "Vallotti"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(vallotti) }
                    }
                    RadioButton {
                        id: werkmeister_button
                        text: "Werkmeister"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(werkmeister) }
                    }
                    RadioButton {
                        id: marpurg_button
                        text: "Marpurg"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(marpurg) }
                    }
                    RadioButton {
                        id: just_button
                        text: "Just"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(just) }
                    }
                    RadioButton {
                        id: meanSemitone_button
                        text: "Mean Semitone"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(meanSemitone) }
                    }
                    RadioButton {
                        id: grammateus_button
                        text: "Grammateus"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(grammateus) }
                    }
                    RadioButton {
                        id: french_button
                        text: "French"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(french) }
                    }
                    RadioButton {
                        id: french2_button
                        text: "Tempérament Ordinaire"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(french2) }
                    }
                    RadioButton {
                        id: rameau_button
                        text: "Rameau"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(rameau) }
                    }
                    RadioButton {
                        id: irrFr17e_button
                        text: "Irr Fr 17e"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(irrFr17e) }
                    }
                    RadioButton {
                        id: bachlehman_button
                        text: "Bach/Lehman"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: { temperamentClicked(bachLehman) }
                    }
                }
            }

            ColumnLayout {
                GroupBox {
                    title: "Advanced"
                    ColumnLayout {
                        GroupBox {
                            title: "Root Note"
                            GridLayout {
                                columns: 4
                                anchors.margins: 10
                                ExclusiveGroup { id: rootNoteGroup }
                                RadioButton {
                                    text: "C"
                                    checked: true
                                    exclusiveGroup: rootNoteGroup
                                    id: root_c
                                    onClicked: { rootNoteClicked(0) }
                                }
                                RadioButton {
                                    text: "G"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_g
                                    onClicked: { rootNoteClicked(1) }
                                }
                                RadioButton {
                                    text: "D"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_d
                                    onClicked: { rootNoteClicked(2) }
                                }
                                RadioButton {
                                    text: "A"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_a
                                    onClicked: { rootNoteClicked(3) }
                                }
                                RadioButton {
                                    text: "E"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_e
                                    onClicked: { rootNoteClicked(4) }
                                }
                                RadioButton {
                                    text: "B"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_b
                                    onClicked: { rootNoteClicked(5) }
                                }
                                RadioButton {
                                    text: "F#"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_f_sharp
                                    onClicked: { rootNoteClicked(6) }
                                }
                                RadioButton {
                                    text: "C#"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_c_sharp
                                    onClicked: { rootNoteClicked(7) }
                                }
                                RadioButton {
                                    text: "G#"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_g_sharp
                                    onClicked: { rootNoteClicked(8) }
                                }
                                RadioButton {
                                    text: "Eb"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_e_flat
                                    onClicked: { rootNoteClicked(9) }
                                }
                                RadioButton {
                                    text: "Bb"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_b_flat
                                    onClicked: { rootNoteClicked(10) }
                                }
                                RadioButton {
                                    text: "F"
                                    exclusiveGroup: rootNoteGroup
                                    id: root_f
                                    onClicked: { rootNoteClicked(11) }
                                }
                            }
                        }

                        GroupBox {
                            title: "Pure Tone"
                            GridLayout {
                                columns: 4
                                anchors.margins: 10
                                ExclusiveGroup { id: pureToneGroup }
                                RadioButton {
                                    text: "C"
                                    checked: true
                                    id: pure_c
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(0) }
                                }
                                RadioButton {
                                    text: "G"
                                    id: pure_g
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(1) }
                                }
                                RadioButton {
                                    text: "D"
                                    id: pure_d
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(2) }
                                }
                                RadioButton {
                                    text: "A"
                                    id: pure_a
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(3) }
                                }
                                RadioButton {
                                    text: "E"
                                    id: pure_e
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(4) }
                                }
                                RadioButton {
                                    text: "B"
                                    id: pure_b
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(5) }
                                }
                                RadioButton {
                                    text: "F#"
                                    id: pure_f_sharp
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(6) }
                                }
                                RadioButton {
                                    text: "C#"
                                    id: pure_c_sharp
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(7) }
                                }
                                RadioButton {
                                    text: "G#"
                                    id: pure_g_sharp
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(8) }
                                }
                                RadioButton {
                                    text: "Eb"
                                    id: pure_e_flat
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(9) }
                                }
                                RadioButton {
                                    text: "Bb"
                                    id: pure_b_flat
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(10) }
                                }
                                RadioButton {
                                    text: "F"
                                    id: pure_f
                                    exclusiveGroup: pureToneGroup
                                    onClicked: { pureToneClicked(11) }
                                }
                            }
                        }

                        GroupBox {
                            title: "Final Offsets"
                            GridLayout {
                                columns: 8
                                anchors.margins: 0

                                Label {
                                    text: "C"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_c
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_c) }
                                }

                                Label {
                                    text: "G"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_g
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_g) }
                                }

                                Label {
                                    text: "D"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_d
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_d) }
                                }

                                Label {
                                    text: "A"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_a
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_a) }
                                }

                                Label {
                                    text: "E"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_e
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_e) }
                                }

                                Label {
                                    text: "B"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_b
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_b) }
                                }

                                Label {
                                    text: "F#"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_f_sharp
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_f_sharp) }
                                }

                                Label {
                                    text: "C#"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_c_sharp
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_c_sharp) }
                                }

                                Label {
                                    text: "G#"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_g_sharp
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_g_sharp) }
                                }

                                Label {
                                    text: "Eb"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_e_flat
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_e_flat) }
                                }

                                Label {
                                    text: "Bb"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_b_flat
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_b_flat) }
                                }

                                Label {
                                    text: "F"
                                    Layout.alignment: offsetLabelAlignment
                                }
                                TextField {
                                    Layout.maximumWidth: offsetTextWidth
                                    id: final_f
                                    text: "0.0"
                                    readOnly: false
                                    validator: DoubleValidator { bottom: -99.9; decimals: 1; notation: DoubleValidator.StandardNotation; top: 99.9 }
                                    property var previousText: "0.0"
                                    onEditingFinished: { editingFinishedFor(final_f) }
                                }
                            }
                        }
                        RowLayout {
                            Button {
                                id: saveButton
                                text: qsTranslate("PrefsDialogBase", "Save")
                                onClicked: {
                                    saveDialog.visible = true
                                }
                            }
                            Button {
                                id: loadButton
                                text: qsTranslate("PrefsDialogBase", "Load")
                                onClicked: {
                                    loadDialog.visible = true
                                }
                            }
                            Button {
                                id: undoButton
                                text: qsTranslate("PrefsDialogBase", "Undo")
                                onClicked: {
                                    getHistory().undo()
                                }
                            }
                            Button {
                                id: redoButton
                                text: qsTranslate("PrefsDialogBase", "Redo")
                                onClicked: {
                                    getHistory().redo()
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Button {
                        id: applyButton
                        text: qsTranslate("PrefsDialogBase", "Apply")
                        onClicked: {
                            applyTemperament()
                            if (modified) {
                                quitDialog.open()
                            } else {
                                Qt.quit()
                            }
                        }
                    }
                    Button {
                        id: cancelButton
                        text: qsTranslate("PrefsDialogBase", "Cancel")
                        onClicked: {
                            if (modified) {
                                quitDialog.open()
                            } else {
                                Qt.quit()
                            }
                        }
                    }

                }
            }
        }
    }

    MessageDialog {
        id: errorDialog
        title: "Error"
        text: ""
        onAccepted: {
            Qt.quit()
        }
    }

    MessageDialog {
        id: quitDialog
        title: "Quit?"
        text: "Do you want to quit the plugin?"
        detailedText: "It looks like you have made customisations to this tuning, you could save them to a file before quitting if you like."
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            Qt.quit()
        }
        onRejected: {
            quitDialog.close()
        }
    }

    FileIO {
        id: saveFile
        source: ""
    }

    FileIO {
        id: loadFile
        source: ""
    }

    function getFile(dialog) {
        var source = dialog.fileUrl.toString().substring(7) // strip the 'file://' prefix
        console.log("You chose: " + source)
        return source
    }

    function formatCurrentValues() {
        var data = {
            offsets: [
                parseFloat(final_c.text),
                parseFloat(final_c_sharp.text),
                parseFloat(final_d.text),
                parseFloat(final_e_flat.text),
                parseFloat(final_e.text),
                parseFloat(final_f.text),
                parseFloat(final_f_sharp.text),
                parseFloat(final_g.text),
                parseFloat(final_g_sharp.text),
                parseFloat(final_a.text),
                parseFloat(final_b_flat.text),
                parseFloat(final_b.text)
            ],
            temperament: currentTemperament.name,
            root: currentRoot,
            pure: currentPureTone
        };
        return(JSON.stringify(data))
    }

    function restoreSavedValues(data) {
        console.log("restoreSavedValues")
        getHistory().begin()
        setCurrentTemperament(lookupTemperament(data.temperament))
        setCurrentRoot(data.root)
        setCurrentPureTone(data.pure)
        recalculate(
            function(pitch) {
                return data.offsets[pitch % 12]
            }
        )
        getHistory().end()
    }

    FileDialog {
        id: loadDialog
        title: "Please choose a file"
        sidebarVisible: true
        onAccepted: {
            loadFile.source = getFile(loadDialog)
            var data = JSON.parse(loadFile.read())
            restoreSavedValues(data)
            loadDialog.visible = false
        }
        onRejected: {
            loadDialog.visible = false
        }
        visible: false
    }

    FileDialog {
        id: saveDialog
        title: "Please choose a file"
        sidebarVisible: true
        selectExisting: false
        onAccepted: {
            saveFile.source = getFile(saveDialog)
            saveFile.write(formatCurrentValues())
            saveDialog.visible = false
        }
        onRejected: {
            saveDialog.visible = false
        }
        visible: false
    }

    // Command pattern for undo/redo
    function commandHistory() {
        function Command(undo_fn, redo_fn, label) {
            this.undo = undo_fn
            this.redo = redo_fn
            this.label = label // for debugging
        }

        var history = []
        var index = -1
        var transaction = 0
        var maxHistory = 30

        function newHistory(commands) {
            if (index < maxHistory) {
                index++
                history = history.slice(0, index)
            } else {
                history = history.slice(1, index)
            }
            history.push(commands)
        }

        this.add = function(undo, redo, label) {
            var command = new Command(undo, redo, label)
            console.log("history add command " + label)
            command.redo()
            if (transaction) {
                history[index].push(command)
            } else {
                newHistory([command])
            }
        }

        this.undo = function() {
            if (index != -1) {
                console.log("history begin undo [" + index + "]")
                history[index].slice().reverse().forEach(
                    function(command) {
                        console.log("history undo " + command.label)
                        command.undo()
                    }
                )
                console.log("history end undo [" + index + "]")
                index--
            }
        }

        this.redo = function() {
            if ((index + 1) < history.length) {
                index++
                console.log("history begin redo [" + index + "]")
                history[index].forEach(
                    function(command) {
                        console.log("history redo " + command.label)
                        command.redo()
                    }
                )
                console.log("history end redo [" + index + "]")
            }
        }

        this.begin = function() {
            if (transaction) {
                throw new Error("already in transaction")
            }
            console.log("history begin transaction [" + (index + 1) + "]")
            newHistory([])
            transaction = 1
        }

        this.end = function() {
            if (!transaction) {
                throw new Error("not in transaction")
            }
            console.log("history end transaction [" + index + "]")
            transaction = 0
        }
    }

}
