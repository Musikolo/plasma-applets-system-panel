#! /usr/bin/env bash
$XGETTEXT `find . -name \*.qml` -o $podir/plasma_applet_system_panel.pot
$XGETTEXT `find . -name \*.js -o -name \*.qml -o -name \*.cpp` -o $podir/plasma_applet_system_panel.pot