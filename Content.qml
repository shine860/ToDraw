// File: Content.qml
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-16 02:00:46
//         * 主要是完善了最开始比较基础的content.qml
// Change Log:
//     [v0.1.1]  黄钰琳2024051604104 <389930006@qq.com>  2026-07-16 02:01:39
//         * 主要是添加了2d函数相关计算函数以及与2d矢量场相关的函数
// Change Log:
//     [v0.1.1] lilin2024051604098，2293779871@qq.com   2026-07-16 02:02:29
//         * 主要是完善了3d的画图功能，因为这里引用了第三方库，矢量场我们暂时确实没有找到办法来画三维场中的箭头
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import QtQuick3D
import QtQuick3D.Helpers
import todraw 1.0
import "calculator.js" as Calc

Item {
    id: contentRoot
    property alias dialogs: _dialogs
    property alias plotCanvas: plotCanvas//这两个都是为了导出图片
    property alias graphsContainer: graphsContainer

    property int currentGraphMode: 0

    property var function2DList: [""]
    property var color2DList:["red","blue","green","orange","purple","cyan","brown","pink","grey"]

    property bool needUpdate2D: false
    property bool needUpdateVector: false

    property string function3D:"sin(x)*cos(y)"
    Dialogs{id: _dialogs}

    Timer{
        id: update2DTimer
        interval: 80
        onTriggered:{
            if(needUpdate2D && currentGraphMode === 0){
                create2DPoints()
                needUpdate2D = false
            }
            if(needUpdateVector&&currentGraphMode === 0){
                create2DVectorField()
                needUpdateVector = false
            }
        }
    }

    ListModel{
        id: function2DListModel
        ListElement { expr: "" }
    }

    // 3D函数的ListModel
    ListModel{
        id: function3DListModel
        ListElement{expr: "sin(x)*cos(y)"}
    }

    //2D函数
    function create2DPoints(){
        var allData=[]
        var xMin=plotCanvas.xMin
        var xMax=plotCanvas.xMax
        var funcs=[]
        var indxs=[]
        for (var i=0;i<function2DList.length;i++) {
            var f=function2DList[i]
            if(f&&f.trim()!== ""){
                funcs.push(f)
                indxs.push(i)
            }
        }
        if(funcs.length === 0){
            plotCanvas.setMultiFunctionData([])
            return
        }
        //测试
        for(var v=0;v<funcs.length;v++){
            try{
                var tmp = funcs[v].replace(/x/g, "(1)")
                Calc.calculate(tmp)
            }catch (msg){
                _dialogs.error.informativeText = msg.toString()
                _dialogs.error.open()
                return
            }
        }
        var results=Calc.sampleMult2DFunctions(funcs, xMin, xMax)
        for(var j=0;j<results.length;j++){
            var r=results[j]
            if(!r||r.segments.length === 0) continue

            var pts = []
            for(var s = 0;s<r.segments.length;s++){
                var seg=r.segments[s]
                for(var p = 0; p < seg.length; p++){
                    pts.push(Qt.point(seg[p].x, seg[p].y))
                }
                if(s< r.segments.length-1){
                    pts.push(Qt.point(NaN, NaN))
                }
            }
            var origin=indxs[j]
            allData.push({
                             "points": pts,
                             "color": color2DList[origin % color2DList.length],
                             "expr": r.expression
                         })
        }
        plotCanvas.setMultiFunctionData(allData)
    }
    //2D矢量场
    function create2DVectorField(){
        var xMin=plotCanvas.xMin
        var xMax=plotCanvas.xMax
        var yMin=plotCanvas.yMin
        var yMax=plotCanvas.yMax
        // 找第一个有效的函数
        var firstV=""
        for(var i=0;i<function2DList.length;++i){
            if (function2DList[i] && function2DList[i].trim()!=="") {
                firstV=function2DList[i]
                break
            }
        }
        if(firstV===""){
            plotCanvas.setVectorFieldData([])
            return
        }
        //用差分法近似求导
        var funcExpr=firstV
        var h=0.001
        var f_x=funcExpr.replace(/x/g, "(x)")
        var f_xh=funcExpr.replace(/x/g, "(x+"+h+")")
        var pExpr = "1"
        var qExpr="(" + f_xh + "-" + f_x + ")/" + h

        var result=Calc.sampleVector(pExpr, qExpr,xMin, xMax, yMin, yMax)

        var vectorData=[]
        var vectors=result.vectors
        var maxMag=result.maxMagnitude
        for(var j=0;j<vectors.length;j++){
            var v=vectors[j]
            var color=Calc.vecColor(v.magnitude, maxMag)
            vectorData.push({
                                "fromX": v.fromX,
                                "fromY": v.fromY,
                                "toX": v.toX,
                                "toY": v.toY,
                                "color": color,
                                "magnitude": v.magnitude
                            })
        }

        plotCanvas.setVectorFieldData(vectorData)
    }
    //更新所有图形
    function updateGraphs(){
        if(currentGraphMode === 0){
            create2DPoints()
            if(plotCanvas.showVectorField){
                create2DVectorField()
            }
        }else if(currentGraphMode===1){
            refresh3DView()
        }
    }

    //2D 函数管理
    function add2DFunction(){
        function2DList.push("")
        function2DListModel.append({"expr": ""})
        if(currentGraphMode === 0){
            create2DPoints()
            if(plotCanvas.showVectorField){
                create2DVectorField()
            }
        }
    }

    function remove2DFunction(index){
        if(function2DList.length <= 1) return
        function2DList.splice(index, 1)
        function2DListModel.remove(index)
        if(currentGraphMode === 0){
            create2DPoints()
            if(plotCanvas.showVectorField){
                create2DVectorField()
            }
        }
    }

    function update2DFunction(index, newText){
        function2DList[index] = newText
        function2DListModel.setProperty(index, "expr", newText)
        if(currentGraphMode === 0){
            create2DPoints()
            if(plotCanvas.showVectorField){
                create2DVectorField()
            }
        }
    }

    //3D函数管理

    function autoConvertTo3D(expr){ //保证输入一个变量的函数也可以显示
        if(!expr || expr.trim() === "") return expr;

        var t = expr.trim();
        var hasX = /x/.test(t);
        var hasY = /y/.test(t);

        if(hasX && hasY) return t;
        if(hasX && !hasY){
            return t + "+0*y";
        }
        if(!hasX && hasY){
            return t + "+0*x";
        }
        if(!hasX && !hasY){
            return t + "+0*x+0*y";
        }
        return t;
    }

    function refresh3DView(){
        graph3DLoader.active = false
        graph3DLoader.active = true

        // 让loader加载完
        var waitAndLoad=function(){
            var view=graph3DLoader.item
            if(!view){
                Qt.callLater(waitAndLoad, 100)
                return
            }
            // 收集所有函数
            var funcs=[]
            for(var i=0;i<function3DListModel.count;i++){
                var expr=function3DListModel.get(i).expr
                if (expr&&expr.trim() !== "") {
                    var fixed=autoConvertTo3D(expr.trim())
                    funcs.push(fixed)
                }
            }
            console.log("Functions:", funcs)
            if(funcs.length > 0){
                view.addFunctions(funcs)
            }
        }
        Qt.callLater(waitAndLoad, 150)
    }

    function add3DFunction(){
        function3DListModel.append({"expr": ""})
        console.log("Added new 3D function input, total:", function3DListModel.count)
    }
    function remove3DFunction(index){
        if(function3DListModel.count<=1) return
        function3DListModel.remove(index)
        refresh3DView()
    }

    function update3DFunction(index, newText){
        function3DListModel.setProperty(index, "expr", newText)
        refresh3DView()
    }

    function create3DPoints(){
        refresh3DView()
    }
    //布局
    RowLayout{
        anchors.fill: parent
        // 左侧控制面板
        Rectangle {
            id: features
            Layout.preferredWidth: parent.width / 4
            Layout.fillHeight: true
            color: "white"
            border.color: "grey"
            border.width: 1

            ColumnLayout{
                anchors.fill: parent
                spacing: 15
                anchors.margins: 10

                // 模式选择
                ComboBox{
                    id: graphTypes
                    currentIndex: 0
                    Layout.preferredHeight: 35
                    Layout.fillWidth: true

                    model: ListModel{
                        ListElement { text: "2D Module" }
                        ListElement { text: "3D Module" }
                    }
                    onCurrentIndexChanged:{
                        currentGraphMode = currentIndex
                        if(currentGraphMode === 0){
                            create2DPoints()
                            if(plotCanvas.showVectorField){
                                create2DVectorField()
                            }
                        }else{
                            refresh3DView()
                        }
                    }
                }

                Rectangle{
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                //2D 模式
                ColumnLayout{
                    visible: currentGraphMode === 0
                    spacing: 10
                    Label{
                        text: "2D Functions"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                        font.pixelSize: 15
                        ToolTip{
                            visible: tooltip2D.hovered
                            text: "每个函数会画一条曲线，颜色不同\n支持: + - * / ^ ( )\n"
                        }
                        HoverHandler { id: tooltip2D }
                    }

                    Button{
                        text: "+ Add Function"
                        Layout.alignment: Qt.AlignLeft
                        onClicked: add2DFunction()
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }

                    ScrollView{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        clip: true

                        ColumnLayout{
                            width: parent.width
                            spacing: 8

                            Repeater{
                                model: function2DListModel
                                RowLayout{
                                    Layout.fillWidth: true
                                    spacing: 8
                                    Rectangle{
                                        width: 20
                                        height: 20
                                        radius: 4
                                        color: color2DList[index % color2DList.length]
                                    }
                                    TextField{
                                        Layout.fillWidth: true
                                        text: model.expr
                                        placeholderText: "eg: sin(x)"
                                        onEditingFinished: {
                                            update2DFunction(index, text)
                                        }
                                    }
                                    Button{
                                        text: "Delete"
                                        onClicked: remove2DFunction(index)
                                        enabled: function2DListModel.count > 1
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }

                    // 矢量场
                    Button{
                        id: vectorFieldBtn
                        text: "Vector Field"
                        Layout.fillWidth: true
                        checkable: true
                        checked: plotCanvas ? plotCanvas.showVectorField : false
                        onCheckedChanged:{
                            if(plotCanvas){
                                plotCanvas.showVectorField = checked
                                if(checked && currentGraphMode === 0){
                                    create2DVectorField()
                                }else if(!checked){
                                    plotCanvas.setVectorFieldData([])
                                }
                            }
                        }
                    }
                    Rectangle{
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }
                    Label{
                        text: "2D View Control"
                        font.bold: true
                        font.pixelSize: 14
                    }

                    RowLayout{
                        Layout.fillWidth: true
                        spacing: 10
                        Button{
                            text: "Zoom +"
                            Layout.fillWidth: true
                            onClicked:{
                                plotCanvas.zoomIn()
                                needUpdate2D = true
                                if(plotCanvas.showVectorField){
                                    needUpdateVector = true
                                }
                                update2DTimer.start()
                            }
                        }
                        Button{
                            text: "Zoom -"
                            Layout.fillWidth: true
                            onClicked:{
                                plotCanvas.zoomOut()
                                needUpdate2D = true
                                if (plotCanvas.showVectorField){
                                    needUpdateVector = true
                                }
                                update2DTimer.start()
                            }
                        }
                        Button{
                            text: "Reset View"
                            Layout.fillWidth: true
                            onClicked:{
                                plotCanvas.resetView()
                                needUpdate2D = true
                                if(plotCanvas.showVectorField){
                                    needUpdateVector = true
                                }
                                update2DTimer.start()
                            }
                        }
                    }
                }

                //3D模式
                ColumnLayout{
                    visible: currentGraphMode === 1
                    spacing: 10

                    Label{
                        text: "3D Functions"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                        font.pixelSize: 15
                        ToolTip{
                            visible: tooltip3D.hovered
                            text: "支持多个 3D 函数同时显示\n"
                        }
                        HoverHandler{ id: tooltip3D }
                    }

                    Button{
                        text: "+ Add 3D Function"
                        Layout.alignment: Qt.AlignLeft
                        onClicked: add3DFunction()
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }

                    ScrollView{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        clip: true

                        ColumnLayout{
                            width: parent.width
                            spacing: 8

                            Repeater{
                                model: function3DListModel
                                RowLayout{
                                    Layout.fillWidth: true
                                    spacing: 8

                                    TextField{
                                        Layout.fillWidth: true
                                        text: model.expr
                                        placeholderText: "eg: sin(x)*cos(y)"
                                        onEditingFinished:{
                                            update3DFunction(index, text)
                                        }
                                    }

                                    Button{
                                        text: "Delete"
                                        onClicked: remove3DFunction(index)
                                        enabled: function3DListModel.count > 1
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }

                    Label{
                        text: "3D View Control"
                        font.bold: true
                        font.pixelSize: 14
                    }

                    RowLayout{
                        Layout.fillWidth: true
                        spacing: 10
                        Button{
                            text: "Zoom +"
                            Layout.fillWidth: true
                            onClicked:{
                                if(graph3DLoader.item){
                                    graph3DLoader.item.zoomIn()
                                }
                            }
                        }
                        Button{
                            text: "Zoom -"
                            Layout.fillWidth: true
                            onClicked:{
                                if(graph3DLoader.item){
                                    graph3DLoader.item.zoomOut()
                                }
                            }
                        }
                        Button{
                            text: "Reset View"
                            Layout.fillWidth: true
                            onClicked:{
                                if(graph3DLoader.item){
                                    graph3DLoader.item.resetView()
                                }
                            }
                        }
                    }
                }
                Item { Layout.fillHeight: true }
            }
        }

        //右侧绘图区域
        StackLayout {
            id: graphsContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: currentGraphMode
            // 2D 视图
            Item {
                My2DCanvas{
                    id: plotCanvas
                    anchors.fill: parent
                    xMin: -5
                    xMax: 5
                    yMin: -5
                    yMax: 5
                    showVectorField: false

                    onXMinChanged:{
                        if(currentGraphMode === 0){
                            needUpdate2D = true
                            if(showVectorField){
                                needUpdateVector = true
                            }
                            update2DTimer.start()
                        }
                    }
                    onXMaxChanged:{
                        if(currentGraphMode === 0){
                            needUpdate2D = true
                            if(showVectorField){
                                needUpdateVector=true
                            }
                            update2DTimer.start()
                        }
                    }
                    onYMinChanged:{
                        if(currentGraphMode === 0){
                            needUpdate2D = true
                            if(showVectorField){
                                needUpdateVector = true
                            }
                            update2DTimer.start()
                        }
                    }
                    onYMaxChanged:{
                        if(currentGraphMode === 0){
                            needUpdate2D = true
                            if(showVectorField){
                                needUpdateVector = true
                            }
                            update2DTimer.start()
                        }
                    }
                    onShowVectorFieldChanged:{
                        if(currentGraphMode === 0 && showVectorField){
                            create2DVectorField()
                        } else if(!showVectorField){
                            setVectorFieldData([])
                        }
                    }
                }

                WheelHandler{
                    id: wheelHandler2D
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: (event) => {
                                 if(event.angleDelta.y > 0){
                                     plotCanvas.zoomIn()
                                 }else{
                                     plotCanvas.zoomOut()
                                 }
                                 needUpdate2D = true
                                 if(plotCanvas.showVectorField){
                                     needUpdateVector = true
                                 }
                                 update2DTimer.start()
                             }
                }
            }

            // 3D 视图
            Item {
                id: surface3Dview
                Loader {
                    id: graph3DLoader
                    anchors.fill: parent
                    sourceComponent: graph3DComponent
                }
                Component {
                    id: graph3DComponent
                    Graph3DViewWrapper{
                        id: graph3DWrapper
                        anchors.fill: parent
                        onReady:{
                            var validFunctions = []
                            for(var i=0;i<function3DListModel.count;i++){
                                var expr = function3DListModel.get(i).expr
                                if(expr&&expr.trim() !== ""){
                                    validFunctions.push(expr.trim())
                                }
                            }
                            if(validFunctions.length > 0){
                                graph3DWrapper.addFunctions(validFunctions)
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:{
        currentGraphMode = 0
        create2DPoints()
        console.log("Content.qml loaded")
    }
}