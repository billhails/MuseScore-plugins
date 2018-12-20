// Voice Velocity
//
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
    menuPath: "Plugins.Playback.Voice Velocity"
    version: "1.0.0"
    description: qsTr("Offsets the velocity (volume) of a chosen voice in a selection by a specified amount")
    pluginType: "dialog"

    width:  240

    onRun: {
        if (!curScore) {
            error("No score open.\nThis plugin requires an open score to run.\n")
            Qt.quit()
        }
    }

    function applyVoiceVelocity() {
        var selection = getSelection()
        if (selection === null) {
            error("No selection.\nThis plugin requires a current selection to run.\n")
            Qt.quit()
        }
        curScore.startCmd()
        mapOverSelection(selection, filterVoice(getChosenVoice()), setVelocity(getVelocityOffset()))
        curScore.endCmd()
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
                    if (filter(element, track)) {
                        process(element)
                    }
                }
            }
        }
    }

    function filterVoice(chosenVoice) {
        return function (element, track) {
            return element.type == Element.CHORD && track % 4 == chosenVoice
        }
    }

    function setVelocity(velocityOffset) {
        return function (chord) {
            for (var i = 0; i < chord.notes.length; i++) {
                var note = chord.notes[i]
                note.veloType = Note.OFFSET_VAL
                note.veloOffset = velocityOffset
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

    function getChosenVoice() {
        return chosenVoice
    }

    function getVelocityOffset() {
        return velocityOffset.value
    }

    function getIntFrom(container) {
        var text = container.text
        if (text == "") {
            text = container.placeholderText
        }
        return parseInt(text)
    }

    property int chosenVoice: 0

    Rectangle {
        color: "lightgrey"
        anchors.fill: parent

        GridLayout {
            columns: 2
            anchors.fill: parent
            anchors.margins: 10
            Label {
                text: qsTr("offset (-127 to 127): ")
            }
            SpinBox {
                id: velocityOffset
                maximumValue: 127
                minimumValue: -127
                value: 0
            }
            GroupBox {
                Layout.columnSpan: 2
                title: "Voice"
                RowLayout {
                    ExclusiveGroup { id: chosenVoiceGroup }
                    RadioButton {
                        text: "1"
                        checked: true
                        exclusiveGroup: chosenVoiceGroup
                        onClicked: {
                            chosenVoice = 0
                        }
                    }
                    RadioButton {
                        text: "2"
                        exclusiveGroup: chosenVoiceGroup
                        onClicked: {
                            chosenVoice = 1
                        }
                    }
                    RadioButton {
                        text: "3"
                        exclusiveGroup: chosenVoiceGroup
                        onClicked: {
                            chosenVoice = 2
                        }
                    }
                    RadioButton {
                        text: "4"
                        exclusiveGroup: chosenVoiceGroup
                        onClicked: {
                            chosenVoice = 3
                        }
                    }
                }
            }
            Button {
                id: applyButton
                text: qsTranslate("PrefsDialogBase", "Apply")
                onClicked: {
                    applyVoiceVelocity()
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
