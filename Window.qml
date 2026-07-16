// File: Window.qml
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
// Change Log:
//     [v0.1.1] suqian2024051604029 3236863614@qq.com   2026-07-16 02:19:18
//         * 完善window.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "todraw.js" as Controller

ApplicationWindow {
    id: mainView
    width: 1280
    height: 1024
    visible: true
    title: "ToDraw-GeoGebra"

    property alias content: content
    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { action: actions.exportAction }
            MenuSeparator {}
            MenuItem { action: actions.exitAction }
        }
        Menu {
            title: "&Help"
            MenuItem { text: "About"; onTriggered: content.dialogs.about.open() }
        }
    }

    header: ToolBar {
        RowLayout{
            ToolButton{ action: actions.exportAction }
            ToolButton{ action:actions.aboutAction }
        }
    }


    Actions{
        id:actions
        exportAction.onTriggered: {
            Controller.exportToImage()
        }
        aboutAction.onTriggered: {
            Controller.showAbout()
        }
    }

    Content{
        id:content
        anchors.fill: parent
    }

    Component.onCompleted: {
        Controller.initial()
    }
}