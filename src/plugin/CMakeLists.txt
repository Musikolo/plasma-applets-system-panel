set(plasmoidplugin_SRCS
    plasmoidplugin.cpp
    systempanel.cpp
    )

add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})
#TODO: Clean up
#target_link_libraries(plasmoidplugin Qt5::Quick KF5::Plasma)
target_link_libraries(plasmoidplugin Qt6::Quick)

install(TARGETS plasmoidplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/systempanel)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/systempanel)
