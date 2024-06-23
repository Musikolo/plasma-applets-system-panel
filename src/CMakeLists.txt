cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(plasma-applet-system-panel)

set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "6.0.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs6)
include(KDECMakeSettings NO_POLICY_SCOPE)

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED Quick)
find_package(Plasma ${KF6_MIN_VERSION} REQUIRED)

add_subdirectory(plugin)
add_subdirectory(translations)

plasma_install_package(package org.kde.plasma.systempanel)

message(STATUS "Install directory KDE_INSTALL_ICONDIR=${KDE_INSTALL_ICONDIR}")
install( DIRECTORY image/breeze DESTINATION ${KDE_INSTALL_ICONDIR})
install( DIRECTORY image/breeze-dark DESTINATION ${KDE_INSTALL_ICONDIR})
