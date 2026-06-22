// Module
// File: Dialogs.qml   Version: 0.1.0   License: AGPLv3
// Created:huangyulin       2026-06-22 08:40:32
// Description:将所有dialog放在一起，方便后续修改
//
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    // property alias fileOpen: _fileOpen
    // property alias fileSave: _fileSave
    // property alias failToSave: _failToSave
    property alias about: _about
    property alias error:_errorDialog

    //  FileDialog {
    //      id: _fileOpen
    //      title: "open file"
    //      currentFolder: StandardPaths.standardLocations
    //                     (StandardPaths.DocumentsLocation)[0]
    //      fileMode: FileDialog.OpenFiles
    //      nameFilters:
    //  }

    //  FileDialog {
    //      id: _fileSave
    //      title: "save file"
    //      modality: Qt.ApplicationModal
    //      currentFolder: StandardPaths.writableLocation
    //                     (StandardPaths.DocumentsLocation)
    //      fileMode: FileDialog.SaveFile
    //      nameFilters: [  ]
    //  }

    // MessageDialog {
    //  id: _failToSave
    //  title: qsTr("failsave")
    //  text: qsTr("save not sucessful")
    //  buttons: MessageDialog.Ok
    // }
    MessageDialog {
        id: _errorDialog
        title: qsTr("Error")
        text: qsTr("Undefined behavior")
        buttons: MessageDialog.Ok
        onButtonClicked: function(button, role) {
            if (role === MessageDialog.Ok)
                Qt.quit()
        }
    }
    MessageDialog{
        id:_about
        modality: Qt.WindowModal
        buttons:MessageDialog.Ok
        text:"about"
        informativeText: qsTr("Calculus Visualization Tool")
        detailedText: ""
    }

}