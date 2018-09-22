// Pivot Chords
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
    version: "1.0.0"
    menuPath: "Plugins.Composing Tools.Pivot Chords"
    description: "Compositional Assistant"
    pluginType: "dialog"
    width: 400
    height: 250

    function pivotChords() {

        var chordsOfMajor = {
            I: [0, 4, 7],
            Ne: [1, 5, 8],
            ii: [2, 5, 9],
            iii: [4, 7, 11],
            IV: [5, 9, 0],
            iv: [5, 8, 0],
            V: [7, 11, 2],
            V7: [7, 11, 2, 5],
            Ger: [8, 0, 3, 6],
            It: [8, 0, 6],
            Fr: [8, 0, 2, 6],
            vi: [9, 0, 4],
            vii: [11, 2, 5, 8]
        };

        var chordsOfMinor = {
            i: [0, 4, 7],
            Ne: [1, 5, 8],
            iid: [2, 5, 8],
            ii: [2, 5, 9],
            iii: [3, 7, 10],
            iiia: [3, 7, 11],
            IV: [5, 9, 0],
            iv: [5, 8, 0],
            v: [7, 10, 2],
            V: [7, 11, 2],
            V7: [7, 11, 2, 5],
            Ger: [8, 0, 3, 6],
            It: [8, 0, 6],
            Fr: [8, 0, 2, 6],
            vid: [9, 0, 3],
            vi: [8, 0, 3],
            vii: [11, 2, 5, 8]
        };

        var keys = [
            ["C"],
            ["C#", "Db"],
            ["D"],
            ["D#", "Eb"],
            ["E"],
            ["F"],
            ["F#", "Gb"],
            ["G"],
            ["G#", "Ab"],
            ["A"],
            ["A#", "Bb"],
            ["B"]
        ];

        this.Key = function(name, mode) {
            var found = false;
            var position = 0;
            keys.forEach(
                function(validNames, index, arr) {
                    validNames.forEach(
                        function(validName, i, arr) {
                            if (name == validName) {
                                found = true;
                                position = index;
                            }
                        }
                    )
                }
            );
            if (!found) {
                throw("invalid key: " + name);
            }
            if (mode != "Major" && mode != "Minor") {
                throw("invalid mode: " + mode);
            }
            this.position = position;
            this.name = name;
            this.mode = mode;
        }

        this.findPivots = function (key1, key2) {
            var chords1 = chordsOfKey(key1);
            var chords2 = chordsOfKey(key2);
            return commonChords(chords1, chords2);
        }

        function chordsOfKey(key) {
            if (key.mode == "Major") {
                var chords = chordsOfMajor;
            } else {
                var chords = chordsOfMinor;
            }

            var result = {};
            for (var chord in chords) {
                result[chord] = addOffset(key.position, chords[chord]);
            }

            return result;
        }

        function addOffset(offset, chord) {
            var result = [];
            for (var note in chord) {
                result.push((chord[note] + offset) % 12);
            }
            return result.sort(function(a, b){return a - b})
        }

        function commonChords(chords1, chords2) {
            var common = [];
            for (var chord1 in chords1) {
                for (var chord2 in chords2) {
                    if (chordsAreEqual(chords1[chord1], chords2[chord2])) {
                        common.push([chord1, chord2, positionsToNotes(chords1[chord1])]);
                    }
                }
            }
            return common;
        }

        function chordsAreEqual(chord1, chord2) {
            if (chord1.length != chord2.length) {
                return false;
            }
            var isEq = true;
            function cmp(val, index, arr) {
                if (val != chord2[index]) {
                    isEq = false;
                }
            }
            chord1.forEach(cmp);
            return isEq;
        }

        function positionsToNotes(chord) {
            return chord.map(
                function(value, index, arr) {
                    return keys[value][0];
                }
            );
        }
    }

    property string fromMode: "Major"
    property string toMode: "Major"

    function tellPivotChords() {
        var fromKey = fromKeyBox.model.get(fromKeyBox.currentIndex).key
        var toKey = toKeyBox.model.get(toKeyBox.currentIndex).key
        var finder = new pivotChords();
        var result = finder.findPivots(new finder.Key(fromKey, fromMode), new finder.Key(toKey, toMode));
        outputText.text = outputText.text + "<h4>To modulate from " + fromKey + " " + fromMode +
            " to " + toKey + " " + toMode + "</h4>";
        for (var i in result) {
            outputText.text = outputText.text + "<b>" + result[i][0] + "</b> is <b>" + result[i][1] + "</b> (" +
            result[i][2].toString() +
            ")<br/>";
        }
    }

    Rectangle {
        color: "lightgrey"
        anchors.fill: parent

        GridLayout {
            columns: 3
            anchors.fill: parent
            anchors.margins: 10
            Label {
                text: qsTr("From")
            }
            ComboBox {
                id: fromKeyBox
                model: ListModel {
                    id: fromKeyList
                    ListElement { text: "C";     key: "C" }
                    ListElement { text: "C#/Db"; key: "C#" }
                    ListElement { text: "D";     key: "D" }
                    ListElement { text: "D#/Eb"; key: "Eb" }
                    ListElement { text: "E";     key: "E" }
                    ListElement { text: "F";     key: "F" }
                    ListElement { text: "F#/Gb"; key: "F#" }
                    ListElement { text: "G";     key: "G" }
                    ListElement { text: "G#/Ab"; key: "Ab" }
                    ListElement { text: "A";     key: "A" }
                    ListElement { text: "A#/Bb"; key: "Bb" }
                    ListElement { text: "B";     key: "B" }
                }
                currentIndex: 0
            }
            RowLayout {
                ExclusiveGroup { id: fromModeGroup }
                RadioButton {
                    text: "Maj"
                    checked: true
                    exclusiveGroup: fromModeGroup
                    onClicked: {
                        fromMode = "Major"
                    }
                }
                RadioButton {
                    text: "Min"
                    checked: false
                    exclusiveGroup: fromModeGroup
                    onClicked: {
                        fromMode = "Minor"
                    }
                }
            }
            Label {
                text: qsTr("To")
            }
            ComboBox {
                id: toKeyBox
                model: ListModel {
                    id: toKeyList
                    ListElement { text: "C";     key: "C" }
                    ListElement { text: "C#/Db"; key: "C#" }
                    ListElement { text: "D";     key: "D" }
                    ListElement { text: "D#/Eb"; key: "Eb" }
                    ListElement { text: "E";     key: "E" }
                    ListElement { text: "F";     key: "F" }
                    ListElement { text: "F#/Gb"; key: "F#" }
                    ListElement { text: "G";     key: "G" }
                    ListElement { text: "G#/Ab"; key: "Ab" }
                    ListElement { text: "A";     key: "A" }
                    ListElement { text: "A#/Bb"; key: "Bb" }
                    ListElement { text: "B";     key: "B" }
                }
                currentIndex: 0
            }
            RowLayout {
                ExclusiveGroup { id: toModeGroup }
                RadioButton {
                    text: "Maj"
                    checked: true
                    exclusiveGroup: toModeGroup
                    onClicked: {
                        toMode = "Major"
                    }
                }
                RadioButton {
                    text: "Min"
                    checked: false
                    exclusiveGroup: toModeGroup
                    onClicked: {
                        toMode = "Minor"
                    }
                }
            }
            RowLayout {
                Layout.columnSpan: 3
                GridLayout {
                    columns: 1
                    anchors.fill: parent
                    anchors.margins: 10
                    Button {
                        id: tellButton
                        text: qsTr("Tell")
                        onClicked: {
                            tellPivotChords()
                        }
                    }
                    Button {
                        id: copyButton
                        text: "Copy"
                        onClicked: {
                            outputText.selectAll()
                            outputText.copy()
                            outputText.deselect()
                        }
                    }
                    Button {
                        id: quitBuuton
                        text: "Quit"
                        onClicked: {
                            Qt.quit();
                        }
                    }
                }
                GridLayout { // padding
                    columns: 1
                    anchors.fill: parent
                    anchors.margins: 10
                }
                TextArea {
                    id: outputText
                    readOnly: true
                    text: ""
                    textFormat: TextEdit.RichText
                }
            }
        }
    }
}

// vim: ft=javascript
