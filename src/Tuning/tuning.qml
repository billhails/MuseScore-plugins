// Apply a choice of tempraments and tunings to a selection
// Copyright (C) 2018  Bill Hails
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

import MuseScore 1.0
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

MuseScore {
    version: "1.2.0"
    menuPath: "Plugins.Playback.Tuning"
    description: "Converts between tuning systems"
    pluginType: "dialog"
    width: 450
    height: 500

    /**
     * See http://leware.net/temper/temper.htm and specifically http://leware.net/temper/cents.htm
     *
     * I've taken the liberty of adding the Bach/Lehman temperament http://www.larips.com which was
     * my original motivation for doing this.
     *
     * These values are in cents. One cent is defined as 100th of an equal tempered semitone.
     * Each row is ordered in the cycle of fifths, so C, G, D, A, E, B, F#, C#, G#/Ab, Eb, Bb, F;
     * and you can see that for equal temperament the values are pure multiples of 100.
     */
    property var equal: [ 000.0, 700.0, 200.0, 900.0, 400.0, 1100.0, 600.0, 100.0, 800.0, 300.0, 1000.0, 500.0 ];
    property var pythagore: [ 000.0, 702.0, 204.0, 906.0, 408.0, 1110.0, 612.0, 114.0, 816.0, 294.0, 996.0, 498.0 ];
    property var aaron: [ 000.0, 696.5, 193.0, 889.5, 386.0, 1082.5, 579.0, 75.5, 772.0, 310.5, 1007.0, 503.5 ];
    property var silberman: [ 000.0, 698.3, 196.7, 895.0, 393.3, 1091.7, 590.0, 88.3, 786.7, 305.0, 1003.3, 501.7 ];
    property var salinas: [ 000.0, 694.7, 189.3, 884.0, 378.7, 1073.3, 568.0, 62.7, 757.3, 316.0, 1010.7, 505.3 ];
    property var kirnberger: [ 000.0, 696.5, 193.0, 889.5, 386.0, 1088.0, 590.0, 90.0, 792.0, 294.0, 996.0, 498.0 ];
    property var vallotti: [ 000.0, 698.0, 196.0, 894.0, 392.0, 1090.0, 592.0, 94.0, 796.0, 298.0, 1000.0, 502.0 ];
    property var werkmeister: [ 000.0, 696.0, 192.0, 888.0, 390.0, 1092.0, 588.0, 90.0, 792.0, 294.0, 996.0, 498.0 ];
    property var marpurg: [ 000.0, 702.0, 204.0, 906.0, 400.0, 1102.0, 604.0, 106.0, 800.0, 302.0, 1004.0, 506.0 ];
    property var just: [ 000.0, 702.0, 204.0, 884.0, 386.0, 1088.0, 590.0, 070.0, 772.0, 316.0, 1018.0, 498.0 ];
    property var meanSemitone: [ 000.0, 696.5, 193.0, 889.5, 386.0, 1082.5, 600.0, 96.5, 793.0, 289.5, 986.0, 503.5 ];
    property var grammateus: [ 000.0, 702.0, 204.0, 906.0, 408.0, 1110.0, 600.0, 102.0, 804.0, 306.0, 1008.0, 498.0 ];
    property var french: [ 000.0, 697.5, 195.0, 892.5, 390.0, 1087.5, 587.0, 87.0, 789.0, 294.0, 998.5, 502.5 ];
    property var french2: [ 000.0, 696.5, 193.0, 889.5, 386.0, 1082.5, 581.8, 81.0, 783.0, 289.5, 996.5, 503.5 ];
    property var rameau: [ 000.0, 696.5, 193.0, 889.5, 386.0, 1082.5, 584.5, 86.5, 788.5, 298.0, 1007.0, 503.5 ];
    property var irrFr17e: [ 000.0, 697.0, 194.0, 891.0, 388.0, 1085.0, 582.0, 79.0, 776.0, 292.0, 998.0, 503.0 ];
    property var bachLehman: [ 000.0, 698.0, 196.1, 894.1, 392.2, 1094.1, 596.1, 98.0, 798.0, 298.0, 998.0, 502.0 ];

    property var chosenTemperament: equal;
    property var chosenRoot: 0;
    property var chosenPureTone: 0;

    onRun: {
        if (!curScore) {
            error("No score open.\nThis plugin requires an open score to run.\n")
            Qt.quit()
        }
    }

    function applyTemperament()
    {
        var selection = getSelection()
        if (selection === null) {
            error("No selection.\nThis plugin requires a current selection to run.\n")
            Qt.quit()
        } else {
            curScore.startCmd()
            mapOverSelection(selection, filterNotes, reTune(getTuning()))
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
        return element.type == Element.CHORD
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
        var i = ((note * 7) - chosenRoot + 12) % 12;
        var offset = table[i];
        var j = (chosenPureTone - chosenRoot + 12) % 12;
        var pureNoteAdjustment = table[j];
        return offset - pureNoteAdjustment;
    }

    /**
     * subtract the equal tempered value from the chosen tuning value to get the tuning offset.
     */
    function getTuning() {
        return function(pitch) {
            var note = pitch % 12;
            return lookUp(note, chosenTemperament) - lookUp(note, equal);
        }
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
                        text: "Equal"
                        checked: true
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = equal
                        }
                    }
                    RadioButton {
                        text: "Pythagore"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = pythagore
                        }
                    }
                    RadioButton {
                        text: "Aaron"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = aaron
                        }
                    }
                    RadioButton {
                        text: "Silberman"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = silberman
                        }
                    }
                    RadioButton {
                        text: "Salinas"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = salinas
                        }
                    }
                    RadioButton {
                        text: "Kirnberger"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = kirnberger
                        }
                    }
                    RadioButton {
                        text: "Vallotti"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = vallotti
                        }
                    }
                    RadioButton {
                        text: "Werkmeister"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = werkmeister
                        }
                    }
                    RadioButton {
                        text: "Marpurg"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = marpurg
                        }
                    }
                    RadioButton {
                        text: "Just"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = just
                        }
                    }
                    RadioButton {
                        text: "Mean Semitone"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = meanSemitone
                        }
                    }
                    RadioButton {
                        text: "Grammateus"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = grammateus
                        }
                    }
                    RadioButton {
                        text: "French"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = french
                        }
                    }
                    RadioButton {
                        text: "Tempérament Ordinaire"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = french2
                        }
                    }
                    RadioButton {
                        text: "Rameau"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = rameau
                        }
                    }
                    RadioButton {
                        text: "Irr Fr 17e"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = irrFr17e
                        }
                    }

                    RadioButton {
                        text: "Bach/Lehman"
                        exclusiveGroup: tempamentTypeGroup
                        onClicked: {
                            chosenTemperament = bachLehman
                        }
                    }
                }
            }

            ColumnLayout {
                GroupBox {
                    title: "Root Note"
                    GridLayout {
                        columns: 4
                        anchors.fill: parent
                        anchors.margins: 10
                        ExclusiveGroup { id: rootNoteGroup }
                        RadioButton {
                            text: "C"
                            checked: true
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 0;
                                chosenPureTone = 0;
                                pure_c.checked = true
                            }
                        }
                        RadioButton {
                            text: "G"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 1;
                                chosenPureTone = 1;
                                pure_g.checked = true
                            }
                        }
                        RadioButton {
                            text: "D"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 2;
                                chosenPureTone = 2;
                                pure_d.checked = true
                            }
                        }
                        RadioButton {
                            text: "A"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 3;
                                chosenPureTone = 3;
                                pure_d.checked = true
                            }
                        }
                        RadioButton {
                            text: "E"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 4;
                                chosenPureTone = 4;
                                pure_e.checked = true
                            }
                        }
                        RadioButton {
                            text: "B"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 5;
                                chosenPureTone = 5;
                                pure_b.checked = true
                            }
                        }
                        RadioButton {
                            text: "F#"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 6;
                                chosenPureTone = 6;
                                pure_f_sharp.checked = true
                            }
                        }
                        RadioButton {
                            text: "C#"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 7;
                                chosenPureTone = 7;
                                pure_c_sharp.checked = true
                            }
                        }
                        RadioButton {
                            text: "G#"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 8;
                                chosenPureTone = 8;
                                pure_g_sharp.checked = true
                            }
                        }
                        RadioButton {
                            text: "Eb"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 9;
                                chosenPureTone = 9;
                                pure_e_flat.checked = true
                            }
                        }
                        RadioButton {
                            text: "Bb"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 10;
                                chosenPureTone = 10;
                                pure_b_flat.checked = true
                            }
                        }
                        RadioButton {
                            text: "F"
                            exclusiveGroup: rootNoteGroup
                            onClicked: {
                                chosenRoot = 11;
                                chosenPureTone = 11;
                                pure_f.checked = true
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Pure Tone"
                    GridLayout {
                        columns: 4
                        anchors.fill: parent
                        anchors.margins: 10
                        ExclusiveGroup { id: pureNoteGroup }
                        RadioButton {
                            text: "C"
                            checked: true
                            id: pure_c
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 0
                            }
                        }
                        RadioButton {
                            text: "G"
                            id: pure_g
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 1
                            }
                        }
                        RadioButton {
                            text: "D"
                            id: pure_d
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 2
                            }
                        }
                        RadioButton {
                            text: "A"
                            id: pure_a
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 3
                            }
                        }
                        RadioButton {
                            text: "E"
                            id: pure_e
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 4
                            }
                        }
                        RadioButton {
                            text: "B"
                            id: pure_b
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 5
                            }
                        }
                        RadioButton {
                            text: "F#"
                            id: pure_f_sharp
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 6
                            }
                        }
                        RadioButton {
                            text: "C#"
                            id: pure_c_sharp
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 7
                            }
                        }
                        RadioButton {
                            text: "G#"
                            id: pure_g_sharp
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 8
                            }
                        }
                        RadioButton {
                            text: "Eb"
                            id: pure_e_flat
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 9
                            }
                        }
                        RadioButton {
                            text: "Bb"
                            id: pure_b_flat
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 10
                            }
                        }
                        RadioButton {
                            text: "F"
                            id: pure_f
                            exclusiveGroup: pureNoteGroup
                            onClicked: {
                                chosenPureTone = 11
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
                            Qt.quit()
                        }
                    }
                    Button {
                        id: cancelButton
                        text: qsTranslate("PrefsDialogBase", "Cancel")
                        onClicked: {
                            Qt.quit()
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
        visible: false
    }
}

// vim: ft=javascript
