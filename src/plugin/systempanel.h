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

#ifndef SYSTEM_PANEL_H
#define SYSTEM_PANEL_H

#include <QObject>

class SystemPanel : public QObject
{
    Q_OBJECT

public:
    SystemPanel(QObject *parent = 0);
    ~SystemPanel();

public Q_SLOTS:
    int turnOffScreen();
};

#endif
