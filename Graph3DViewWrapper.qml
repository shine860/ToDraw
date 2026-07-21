// File: Graph3DViewWrapper.qml
// Created: lilin2024051604098，2293779871@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.1] lilin2024051604098，2293779871@qq.com  2026-07-16 02:11:45
//         * 完成了主要的3维的中心窗口,同时新增的3d矢量场的相关数据
//     [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-21 16:35:56
//         * 主要负责修改调试
//     [v0.1.3] 添加3D矢量场箭头叠加层
//         * 新增矢量场箭头绘制功能

import QtQuick
import QtQuick.Layouts
import org.kde.analitza

Item{
    id:root
    signal ready()
    property var currentFunctions:[]
    property bool isReady:false
    //矢量场相关属性
    property var vectorData:[]
    property bool showVector:false
    property real rotationX:20
    property real rotationY:-30
    property real zoomLevel:1.0

    Graph3DView{
        id:graphView
        anchors.fill:parent

        function initView(){
            rotationX=20
            rotationY=-30
            zoomLevel=1.0
            root.isReady=true
            root.ready()
            if(showVector&&vectorData.length>0){
                vectorCanvas.requestPaint()
            }
        }
        Component.onCompleted:{
            console.log("Graph3DView created")
            root.isReady=true
            root.ready()
            Qt.callLater(initView,300)
        }

        //第三方库没有这个功能，只能覆盖
        Rectangle{
            id:overlay
            anchors.fill:parent
            color:"transparent"
            visible:root.showVector
            Canvas{
                id:vectorCanvas
                anchors.fill:parent

                onPaint:{
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    var data = root.vectorData
                    if(!data || data.length === 0) return
                    var w = width
                    var h = height
                    for(var i = 0;i < data.length;i++){
                        var v = data[i]
                        if(!v) continue

                        var from = projectToScreen(v.fromX, v.fromY, v.fromZ, w, h)
                        var to = projectToScreen(v.toX, v.toY, v.toZ, w, h)

                        if(!from || !to) continue
                        if(from.x<-50||from.x>w + 50||from.y<-50||from.y>h+50) continue
                        if(to.x<-50||to.x>w+50||to.y<-50||to.y>h + 50) continue
                        var color = v.color || "red"
                        drawArrow2D(ctx, from.x, from.y, to.x, to.y, color)
                    }
                }

                //投影到2d上面
                function projectToScreen(wx,wy,wz,w,h){
                    //转化成弧度，方便sin,cos识别
                    var ax=root.rotationX*Math.PI/180
                    var ay=root.rotationY*Math.PI/180
                    //旋转矩阵乘法
                    var cosY=Math.cos(ay)
                    var sinY=Math.sin(ay)
                    var rx=wx*cosY+wz*sinY
                    var rz=-wx*sinY+wz*cosY
                    var ry=wy
                    // X轴旋转
                    var cosX=Math.cos(ax)
                    var sinX=Math.sin(ax)
                    var ry2=ry*cosX-rz*sinX
                    var rz2=ry*sinX+rz*cosX
                    // 正交投影缩放
                    var range=6.0
                    var scale=Math.min(w,h)/(2*range)*root.zoomLevel

                    var sx=w/2+rx*scale
                    var sy=h/2-ry2*scale

                    return Qt.point(sx,sy)
                }
                //绘制箭头
                function drawArrow2D(ctx,x1,y1,x2,y2,color){//逻辑和2d矢量场差不多
                    var dx=x2-x1
                    var dy=y2-y1
                    var len=Math.sqrt(dx*dx+dy*dy)
                    // 太短就画一条线
                    if(len<6){
                        ctx.strokeStyle=color
                        ctx.lineWidth=2.0
                        ctx.beginPath()
                        ctx.moveTo(x1,y1)
                        ctx.lineTo(x2,y2)
                        ctx.stroke()
                        return
                    }

                    var angle=Math.atan2(dy,dx)
                    var arrowSize=9.0
                    var arrowAngle=0.5

                    //画箭杆
                    ctx.strokeStyle=color
                    ctx.lineWidth=2.2
                    ctx.beginPath()
                    ctx.moveTo(x1,y1)
                    ctx.lineTo(x2,y2)
                    ctx.stroke()

                    // 画两个翼
                    var leftX=x2-arrowSize*Math.cos(angle-arrowAngle)
                    var leftY=y2-arrowSize*Math.sin(angle-arrowAngle)
                    var rightX=x2-arrowSize*Math.cos(angle+arrowAngle)
                    var rightY=y2-arrowSize*Math.sin(angle+arrowAngle)

                    ctx.lineWidth=1.8

                    ctx.beginPath()
                    ctx.moveTo(x2,y2)
                    ctx.lineTo(leftX,leftY)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.moveTo(x2,y2)
                    ctx.lineTo(rightX,rightY)
                    ctx.stroke()

                }
            }
        }
    }

    //添加函数
    function addFunctions(expressions){
        console.log("Adding functions:",expressions)
        if(!expressions||expressions.length===0){
            console.log("No functions to add")
            return
        }
        currentFunctions=[]
        for(var i=0;i<expressions.length;i++){
            var expr=expressions[i]
            if(!expr||expr.trim()==="") continue

            var t=expr.trim()
            console.log("Adding function "+i+": "+t)
            try{
                var result=graphView.addFunction(t)
                if(result!==undefined&&result!==null){
                    currentFunctions.push(t)
                    console.log("Function added successfully")
                }
            }catch(e){
                console.log("error adding function:",t,e)
            }
        }
        // 重置视角
        resetView()
    }
    function zoomIn(){
        try{
            graphView.scale(0.9)
            updateZoom(0.9)
        }catch(e){
            console.log("Zoomin error:",e)
        }
    }

    function zoomOut(){
        try{
            graphView.scale(1.1)
            updateZoom(1.1)
        }catch(e){
            console.log("Zoomout error:",e)
        }
    }
    function resetView(){
        try{
            graphView.resetViewport()
        }catch(e){
            console.log("Reset error:",e)
        }
        rotationX=20
        rotationY=-30
        zoomLevel=1.0
        if(showVector){
            vectorCanvas.requestPaint()
        }
    }

    //同步更新canvas的投影角度
    function updateRotation(dx,dy){
        rotationY+=dx*0.3
        rotationX+=dy*0.3
        if(rotationX>85) rotationX=85
        if(rotationX<-85) rotationX=-85
        if(showVector){
            vectorCanvas.requestPaint()
        }
    }

    function updateZoom(num){
        zoomLevel*=num
        if(showVector){
            vectorCanvas.requestPaint()
        }
    }

    //强制同步矢量场
    function forceSyncVectorField(){
        if(showVector&&vectorData.length>0){
            vectorCanvas.requestPaint()
        }
    }

    //设置矢量场数据
    function setVectorFieldData(data){
        vectorData=data||[]
        if(showVector){
            forceSyncVectorField()
        }
    }

    //切换矢量场显示
    function toggleVectorField(show){
        showVector=show
        overlay.visible=show
        if(show){
            forceSyncVectorField()
        }
    }
    DragHandler{
        id:dragHandler
        acceptedDevices:PointerDevice.Mouse|PointerDevice.TouchPad
        grabPermissions:PointerHandler.CanTakeOverFromItems|PointerHandler.CanTakeOverFromHandlersOfDifferentType

        property point lastPos:Qt.point(0,0)
        onActiveChanged:{
            if(active){
                lastPos=Qt.point(centroid.position.x,centroid.position.y)
                graphView.forceActiveFocus()
            }
        }
        onTranslationChanged:{
            var currentX=centroid.position.x
            var currentY=centroid.position.y
            var dx=currentX-lastPos.x
            var dy=currentY-lastPos.y

            if((dx!==0||dy!==0)&&active){
                try{
                    graphView.rotate(dx,dy)
                    //同步旋转
                    root.updateRotation(dx,dy)
                }catch(e){}
            }
            lastPos=Qt.point(currentX,currentY)
        }
    }

    //滚轮缩放
    WheelHandler{
        id:wheelHandler3D
        acceptedDevices:PointerDevice.Mouse|PointerDevice.TouchPad
        onWheel:(event)=>{
                    try{
                        if(event.angleDelta.y>0){
                            graphView.scale(1.1)
                            root.updateZoom(1.1)
                        }else{
                            graphView.scale(0.9)
                            root.updateZoom(0.9)
                        }
                    }catch(e){}
                }
    }
}