# Apply a choice of tempraments and tunings to a selection
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

TEMPLATE=./tuning.sh
V2=2.x/tuning.qml
V3=3.x/tuning.qml

.PHONY: all

all: $(V2) $(V3)

# docs say `segment` is now `segment()` but I get an error using `segment()` in 3.0.2
# leaving the macro in place in case it changes in a later release.

$(V2): $(TEMPLATE)
	MuseScoreImport=1.0 MuseScoreVersion=2.3.2 Segment='segment' Namespace=Element FileIO=1.0 Width=510 bash $< > $@

$(V3): $(TEMPLATE)
	MuseScoreImport=3.0 MuseScoreVersion=3.0.2 Segment='segment' Namespace=Ms FileIO=3.0 Width=550 bash $< > $@

$(V2) $(V3): Makefile

# vim:noet sw=8
