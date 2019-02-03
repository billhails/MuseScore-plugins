# Mirror Intervals about a given pivot note.
# Copyright (C) 2018-2019  Bill Hails
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

TEMPLATE=./mirror-intervals.qml.sh
V2=mirror-intervals-2.qml
V3=mirror-intervals-3.qml

.PHONY: all

all: $(V2) $(V3)

# docs say `segment` is now `segment()` but I get an error using `segment()` in 3.0.2
# leaving the macro in place in case it changes in a later release.

$(V2): $(TEMPLATE)
	MuseScoreImport=1.0 MuseScoreVersion=2.3.2 Segment='segment' Namespace=Element bash $< > $@

$(V3): $(TEMPLATE)
	MuseScoreImport=3.0 MuseScoreVersion=3.0.2 Segment='segment' Namespace=Ms bash $< > $@

$(V2) $(V3): Makefile

# vim:noet sw=8
