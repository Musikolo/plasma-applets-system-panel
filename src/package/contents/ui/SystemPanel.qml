/*
    Copyright (c) 2016 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2

Item {
    id: systemPanel

    property var systemPanelPlugin: null
    property bool systemPanelFailedToInitialize: false
    
    function getSystemPanelPlugin() {
        
        if (systemPanelPlugin !== null) {
            return systemPanelPlugin
        }
        
        if (!systemPanelFailedToInitialize) {
            console.log('Initializing systemPanel plugin...')
            try {
                systemPanelPlugin = Qt.createQmlObject('import org.kde.private.systempanel 1.0 as WW; WW.SystemPanel {}', systemPanel, 'SystemPanel')
                console.log('SystemPanel plugin initialized successfully!')
            }catch (e) {
                console.exception('ERROR: SystemPanel plugin FAILED to initialize -->', e)
                systemPanelFailedToInitialize = true
            }
        }
        
        return systemPanelPlugin
    }
    
    function turnOffScreen() {
        
        var plugin = getSystemPanelPlugin()
        if (plugin) {
            plugin.turnOffScreen()
            
        } else {
            console.exception('ERROR: Turning off screen - SystemPanel plugin not available')
        }
    }
}
