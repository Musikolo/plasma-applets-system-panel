/*
    Copyright (c) 2024 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

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

#include "systempanel.h"

SystemPanel::SystemPanel(QObject *parent) : QObject(parent) {
}

SystemPanel::~SystemPanel() {
}

int SystemPanel::turnOffScreen(){
    
    //TODO: For wayland we need sleep 0.5 && qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut "Turn Off Screen"
    //TODO: We can also use kscreen-doctor --dpms off or implment integration with libkscreen
    // const int result = system("/usr/bin/xset dpms force off");
    const int result = system("/usr/bin/kscreen-doctor --dpms off");
    // const int result = system("qdbus org.kde.kglobalaccel /component/org_kde_powerdevil invokeShortcut \"Turn Off Screen\"");
    
    return result;
}
