// Command pattern in JavaScript (for undo/redo functionality)
// Copyright (C) 2019  Bill Hails
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

function History() {
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
