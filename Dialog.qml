import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    // property alias fileOpen: _fileOpen
    // property alias fileSave: _fileSave
    // property alias failToSave: _failToSave
    property alias about: _about


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

   MessageDialog{
    id:_about
    modality: Qt.WindowModal
    buttons:MessageDialog.Ok
    text:"about"
    informativeText: qsTr("Calculus Visualization Tool")
    detailedText: ""
}

}