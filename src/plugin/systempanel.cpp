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
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDebug>

SystemPanel::SystemPanel(QObject *parent) : QObject(parent) {
}

SystemPanel::~SystemPanel() {
}

int SystemPanel::turnOffScreen(){

    QDBusInterface dbusPowerdevil("org.kde.kglobalaccel", "/component/org_kde_powerdevil",
                                  "org.kde.kglobalaccel.Component", QDBusConnection::sessionBus());
    QDBusReply<void> reply = dbusPowerdevil.call("invokeShortcut", "Turn Off Screen");

    if(reply.isValid()) {
        qDebug() << "QDBus reply was successful!";
        return 0;
    }

    qDebug() << "QDBus ERROR:" << reply.error().message();
    return 1;
}
