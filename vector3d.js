// File: vector3d.js
// Created: suqian2024051604029 3236863614@qq.com      2026-07-21
// Version: 1.0      License: AGPLv3
//     [v0.1.1] suqian2024051604029 3236863614@qq.com   2026-07-21 16:32:35
//         * 主要算法还是使用和2d一样的功能，单独放在一个文件看上去稍微简洁很多
//     [v0.1.2] lilin2024051604098，2293779871@qq.com   2026-07-21 16:33:38
//         * 主要添加了3d矢量场相关的函数
//     [v0.1.2] 黄钰琳2024051604104 <389930006@qq.com>   2026-07-21 16:34:25
//         * 主要参与了3d矢量场的一些调试功能
const minus0Hack = (value) => (Object.is(value, -0) ? '-0' : value);

const functionNames = ['sin', 'cos', 'tan', 'log', 'exp', 'sqrt', 'asin', 'acos', 'atan', 'sinh', 'cosh', 'tanh', 'log10', 'log2','min','max'];

const sortedFunctionNames = functionNames.slice().sort((a, b) => b.length - a.length);

const operators = {
    '+': { func: (x, y) => `${minus0Hack(Number(x) + Number(y))}`, precedence: 1, associativity: 'left', arity: 2 },
    '-': { func: (x, y) => `${minus0Hack(Number(x) - Number(y))}`, precedence: 1, associativity: 'left', arity: 2 },
    '*': { func: (x, y) => `${minus0Hack(Number(x) * Number(y))}`, precedence: 2, associativity: 'left', arity: 2 },
    '/': { func: (x, y) => `${minus0Hack(Number(x) / Number(y))}`, precedence: 2, associativity: 'left', arity: 2 },
    '%': { func: (x, y) => `${minus0Hack(Number(x) % Number(y))}`, precedence: 2, associativity: 'left', arity: 2 },
    '^': { func: (x, y) => `${minus0Hack(Math.pow(Number(x), Number(y)))}`, precedence: 3, associativity: 'right', arity: 2 },
    min: { func: (x, y) => `${minus0Hack(Math.min(Number(x), Number(y)))}`, arity: 2 },
    max: { func: (x, y) => `${minus0Hack(Math.max(Number(x), Number(y)))}`, arity: 2 },
    sin: { func: x => `${minus0Hack(Math.sin(Number(x)))}`, arity: 1 },
    cos: { func: x => `${minus0Hack(Math.cos(Number(x)))}`, arity: 1 },
    tan: { func: x => `${minus0Hack(Math.tan(Number(x)))}`, arity: 1 },
    log: { func: x => `${Math.log(Number(x))}`, arity: 1 },
    exp: { func: x => `${minus0Hack(Math.exp(Number(x)))}`, arity: 1 },
    sqrt: { func: x => `${minus0Hack(Math.sqrt(Number(x)))}`, arity: 1 },
    asin: { func: x => `${minus0Hack(Math.asin(Number(x)))}`, arity: 1 },
    acos: { func: x => `${minus0Hack(Math.acos(Number(x)))}`, arity: 1 },
    atan: { func: x => `${minus0Hack(Math.atan(Number(x)))}`, arity: 1 },
    sinh: { func: x => `${minus0Hack(Math.sinh(Number(x)))}`, arity: 1 },
    cosh: { func: x => `${minus0Hack(Math.cosh(Number(x)))}`, arity: 1 },
    tanh: { func: x => `${minus0Hack(Math.tanh(Number(x)))}`, arity: 1 },
    log10: { func: x => `${minus0Hack(Math.log10(Number(x)))}`, arity: 1 },
    log2: { func: x => `${minus0Hack(Math.log2(Number(x)))}`, arity: 1 }
};

const functions = {
    min: { func: (x, y) => `${minus0Hack(Math.min(Number(x), Number(y)))}`, arity: 2 },
    max: { func: (x, y) => `${minus0Hack(Math.max(Number(x), Number(y)))}`, arity: 2 },
    sin: { func: x => `${minus0Hack(Math.sin(Number(x)))}`, arity: 1 },
    cos: { func: x => `${minus0Hack(Math.cos(Number(x)))}`, arity: 1 },
    tan: { func: x => `${minus0Hack(Math.tan(Number(x)))}`, arity: 1 },
    log: { func: x => `${Math.log(Number(x))}`, arity: 1 },
    exp: { func: x => `${minus0Hack(Math.exp(Number(x)))}`, arity: 1 },
    sqrt: { func: x => `${minus0Hack(Math.sqrt(Number(x)))}`, arity: 1 },
    asin: { func: x => `${minus0Hack(Math.asin(Number(x)))}`, arity: 1 },
    acos: { func: x => `${minus0Hack(Math.acos(Number(x)))}`, arity: 1 },
    atan: { func: x => `${minus0Hack(Math.atan(Number(x)))}`, arity: 1 },
    sinh: { func: x => `${minus0Hack(Math.sinh(Number(x)))}`, arity: 1 },
    cosh: { func: x => `${minus0Hack(Math.cosh(Number(x)))}`, arity: 1 },
    tanh: { func: x => `${minus0Hack(Math.tanh(Number(x)))}`, arity: 1 },
    log10: { func: x => `${minus0Hack(Math.log10(Number(x)))}`, arity: 1 },
    log2: { func: x => `${minus0Hack(Math.log2(Number(x)))}`, arity: 1 }
};

function shuntingYard(tokens) {
    const output = [];
    const operatorStack = [];

    for (const token of tokens) {
        if (functions[token] !== undefined) {
            operatorStack.push(token);
        } else if (token === ',') {
            while (operatorStack.length > 0 && operatorStack[operatorStack.length - 1] !== '(') {
                output.push(operatorStack.pop());
            }
            if (operatorStack.length === 0) {
                throw new Error("Misplaced ','");
            }
        } else if (operators[token] !== undefined) {
            const o1 = token;
            while (
                operatorStack.length > 0 &&
                operatorStack[operatorStack.length - 1] !== undefined &&
                operatorStack[operatorStack.length - 1] !== '(' &&
                (operators[operatorStack[operatorStack.length - 1]].precedence > operators[o1].precedence ||
                 (operators[o1].precedence === operators[operatorStack[operatorStack.length - 1]].precedence &&
                  operators[o1].associativity === 'left'))
                ) {
                output.push(operatorStack.pop());
            }
            operatorStack.push(o1);
        } else if (token === '(') {
            operatorStack.push(token);
        } else if (token === ')') {
            while (operatorStack.length > 0 && operatorStack[operatorStack.length - 1] !== '(') {
                output.push(operatorStack.pop());
            }
            if (operatorStack.length > 0 && operatorStack[operatorStack.length - 1] === '(') {
                operatorStack.pop();
            } else {
                throw new Error('Parentheses mismatch');
            }
            if (functions[operatorStack[operatorStack.length - 1]] !== undefined) {
                output.push(operatorStack.pop());
            }
        } else {
            output.push(token);
        }
    }

    while (operatorStack.length > 0) {
        const operator = operatorStack[operatorStack.length - 1];
        if (operator === '(') {
            throw new Error('Parentheses mismatch');
        } else {
            output.push(operatorStack.pop());
        }
    }

    return output;
}

function evalReversePolishNotation(tokens) {
    const stack = [];
    var ops = operators;

    for (const token of tokens) {
        const op = ops[token];

        if (op !== undefined) {
            const parameters = [];
            for (let i = 0; i < op.arity; i++) {
                parameters.push(stack.pop());
            }
            stack.push(op.func(...parameters.reverse()));
        } else {
            stack.push(token);
        }
    }

    if (stack.length > 1) {
        throw new Error('Insufficient operators');
    }

    return Number(stack[0]);
}

function tokenize(expression) {
    const expr = expression.replace(/\s+/g, '');
    const tokens = [];
    let i = 0;

    while (i < expr.length) {
        const c = expr.charAt(i);

        let matchedFn = null;
        for (const fn of sortedFunctionNames) {
            if (expr.substring(i, i + fn.length) === fn) {
                const nextChar = expr.charAt(i + fn.length);
                if (!nextChar || nextChar === '(') {
                    matchedFn = fn;
                    break;
                }
            }
        }

        if (matchedFn) {
            tokens.push(matchedFn);
            i += matchedFn.length;
            continue;
        }

        if (/\d/.test(c)) {
            let num = '';
            while (i < expr.length && /\d/.test(expr.charAt(i))) {
                num += expr.charAt(i);
                i++;
            }
            if (i < expr.length && expr.charAt(i) === '.') {
                num += '.';
                i++;
                while (i < expr.length && /\d/.test(expr.charAt(i))) {
                    num += expr.charAt(i);
                    i++;
                }
            }
            if (i < expr.length && (expr.charAt(i) === 'e' || expr.charAt(i) === 'E')) {
                num += expr.charAt(i);
                i++;
                if (i < expr.length && (expr.charAt(i) === '+' || expr.charAt(i) === '-')) {
                    num += expr.charAt(i);
                    i++;
                }
                while (i < expr.length && /\d/.test(expr.charAt(i))) {
                    num += expr.charAt(i);
                    i++;
                }
            }
            tokens.push(num);
            continue;
        }

        if (['+', '-', '*', '/', '%', '^', '(', ')', ','].includes(c)) {
            tokens.push(c);
            i++;
            continue;
        }

        if (c === 'x' || c === 'y' || c === 'z') {
            tokens.push(c);
            i++;
            continue;
        }

        i++;
    }

    if (tokens.length > 0 && (tokens[0] === '+' || tokens[0] === '-')) {
        tokens.unshift('0');
    }

    var result = [];
    for (var k = 0; k < tokens.length; k++) {
        var tok = tokens[k];
        if (tok === '(' && k + 1 < tokens.length && (tokens[k + 1] === '+' || tokens[k + 1] === '-')) {
            result.push('(');
            result.push('0');
        } else {
            result.push(tok);
        }
    }

    return result;
}

function calculate(expression) {
    const tokens = tokenize(expression);
    const rpn = shuntingYard(tokens);
    return evalReversePolishNotation(rpn);
}

//3d矢量场
function calculate3D(expr,x,y,z){//计算某点具体值
    var filled = expr.replace(/x/g,"("+x+")")
    .replace(/y/g,"("+y+")")
    .replace(/z/g,"("+z+")");
    if(filled.indexOf('=')!==-1){
        var parts=filled.split('=');
        if(parts.length===2){
            filled="("+parts[0].trim()+")-("+parts[1].trim()+")";
        }
    }
    return calculate(filled);
}

function computeGradient3D(expr,x,y,z){
    try{
        var f0=calculate3D(expr,x,y,z);
        if(!isFinite(f0)||isNaN(f0)) return null;
        var h=0.001;//中心差分法公式
        var fx=(calculate3D(expr,x+h,y,z)-calculate3D(expr,x-h,y,z))/(2*h);
        var fy=(calculate3D(expr,x,y+h,z)-calculate3D(expr,x,y-h,z))/(2*h);
        var fz=(calculate3D(expr,x,y,z+h)-calculate3D(expr,x,y,z-h))/(2*h);
        if(!isFinite(fx)||!isFinite(fy)||!isFinite(fz)||isNaN(fx)||isNaN(fy)||isNaN(fz)) return null;
        return {
            dx:fx,
            dy:fy,
            dz:fz,
            f0:f0
        };
    }catch(e){
        return null;
    }
}

function getVectorColor3D(magnitude,maxMagnitude){
    if(maxMagnitude===0||!isFinite(maxMagnitude)) return "red";
    var t=Math.min(magnitude/maxMagnitude,1.0);
    if(t<0.2) return "blue";
    if(t<0.4) return "cyan";
    if(t<0.6) return "lime";
    if(t<0.8) return "orange";
    return "red";
}

//显式函数矢量场
function produceExplicitVecField(expr,gridSize,arrowScale){
    var arrows=[];
    var scale=arrowScale||0.15;
    var h=0.001;
    var range=5;
    var grid=Math.min(gridSize,15);
    var step=(2*range)/grid;
    var maxMag=0.001;
    var tempArrows=[];
    for(var i=0;i<=grid;i++){
        var x=-range+i*step;
        for(var j=0;j<=grid;j++){
            var y=-range+j*step;//遍历所有的(x,y)点
            try{
                var filled=expr.replace(/x/g,"("+x+")").replace(/y/g,"("+y+")");
                var z=calculate(filled);
                if(!isFinite(z)||isNaN(z)) continue;
                var filledXp=expr.replace(/x/g,"("+(x+h)+")").replace(/y/g,"("+y+")");//p表示previous
                var filledXn=expr.replace(/x/g,"("+(x-h)+")").replace(/y/g,"("+y+")");//n表示next
                var filledYp=expr.replace(/x/g,"("+x+")").replace(/y/g,"("+(y+h)+")");
                var filledYn=expr.replace(/x/g,"("+x+")").replace(/y/g,"("+(y-h)+")");
                var zXp=calculate(filledXp);
                var zXn=calculate(filledXn);
                var zYp=calculate(filledYp);
                var zYn=calculate(filledYn);
                if(!isFinite(zXp)||!isFinite(zXn)||!isFinite(zYp)||!isFinite(zYn)) continue;
                var dzdx=(zXp-zXn)/(2*h);
                var dzdy=(zYp-zYn)/(2*h);
                var gx=dzdx;
                var gy=dzdy;
                var gz=0.0;
                var mag=Math.sqrt(gx*gx+gy*gy+gz*gz);
                if(mag<0.001||mag>20) continue;
                if(mag>maxMag) maxMag=mag;
                tempArrows.push({x:x,y:y,z:z,gx:gx,gy:gy,gz:gz,mag:mag});
            }catch(e){}
        }
    }
    for(var k=0;k<tempArrows.length;k++){
        var v=tempArrows[k];
        var len=scale*(0.1+1.9*(v.mag/(maxMag||1)));
        var unitVector=1.0/v.mag;
        arrows.push({
                        fromX:v.x,fromY:v.y,fromZ:v.z,//起点
                        toX:v.x+v.gx*unitVector*len,//终点
                        toY:v.y+v.gy*unitVector*len,
                        toZ:v.z,
                        color:getVectorColor3D(v.mag,maxMag),//根据大小选择颜色
                        magnitude:v.mag
                    });
    }
    console.log("3D vector field has:",arrows.length,"arrow");
    return {vectors:arrows,maxMagnitude:maxMag};
}
//找隐时方程的所有点
function findSurfacePoints(expr,gridSize){
    var points=[];
    var range=5;
    var step=(2*range)/gridSize;
    for(var i=0;i<gridSize;i++){//遍历所有小立方体
        for(var j=0;j<gridSize;j++){
            for(var k=0;k<gridSize;k++){
                var x0=-range+i*step;
                var y0=-range+j*step;
                var z0=-range+k*step;
                var corners=[{x:x0,y:y0,z:z0},//存储八个顶点
                             {x:x0+step,y:y0,z:z0},
                             {x:x0,y:y0+step,z:z0},
                             {x:x0+step,y:y0+step,z:z0},
                             {x:x0,y:y0,z:z0+step},
                             {x:x0+step,y:y0,z:z0+step},
                             {x:x0,y:y0+step,z:z0+step},
                             {x:x0+step,y:y0+step,z:z0+step}];
                var values=[];
                var positive=false;
                var negative=false;
                for(var c=0;c<8;c++){
                    try{
                        var v=calculate3D(expr,corners[c].x,corners[c].y,corners[c].z);
                        if(isFinite(v)&&!isNaN(v)){
                            values.push(v);
                            if(v>0) positive=true;//在曲面外
                            if(v<0) negative=true;//在曲面内
                        }else{
                            values.push(null);
                        }
                    }catch(e){
                        values.push(null);
                    }
                }
                if(positive&&negative){
                    var edges=[
                                [0,1],[0,2],[0,4],[1,3],[1,5],[2,3],[2,6],[3,7],[4,5],[4,6],[5,7],[6,7]
                            ];
                    for(var e=0;e<edges.length;e++){
                        var index1=edges[e][0];
                        var index2=edges[e][1];
                        var v1=values[index1];
                        var v2=values[index2];
                        if(v1!==null&&v2!==null&&v1*v2<0){//判断曲面是否穿过这条边
                            var t=-v1/(v2-v1);//线性插值
                            if(t>=0&&t<=1){
                                var px=corners[index1].x+t*(corners[index2].x-corners[index1].x);
                                var py=corners[index1].y+t*(corners[index2].y-corners[index1].y);
                                var pz=corners[index1].z+t*(corners[index2].z-corners[index1].z);
                                var duplicate=false;
                                for(var d=0;d<points.length;++d){
                                    var dx=points[d].x-px;
                                    var dy=points[d].y-py;
                                    var dz=points[d].z-pz;
                                    if(dx*dx+dy*dy+dz*dz<step*step*0.25){
                                        duplicate=true;//重复点
                                        break;
                                    }
                                }
                                if(!duplicate) points.push({x:px,y:py,z:pz});
                            }
                        }
                    }
                }
            }
        }
    }
    return points;
}
//隐氏函数矢量场
function produceImplicitVecField(expr,gridSize,arrowScale){
    var arrows=[];
    var scale=arrowScale||0.15;
    var h=0.001;
    var surfacePoints=findSurfacePoints(expr,gridSize);
    if(surfacePoints.length===0){
        console.log("No surface points were found.");
        return {vectors:[],maxMagnitude:0};
    }
    var maxPoints=300;//采样少一些，保证性能
    if(surfacePoints.length>maxPoints){
        var sample=[];
        var step=Math.floor(surfacePoints.length/maxPoints);
        for(var s=0;s<surfacePoints.length&&sample.length<maxPoints;s+=Math.max(1,step)){
            sample.push(surfacePoints[s]);
        }
        surfacePoints=sample;
    }
    var maxMag=0.001;
    var tempArrows=[];
    for(var i=0;i<surfacePoints.length;i++){//计算梯度
        var p=surfacePoints[i];
        var grad=computeGradient3D(expr,p.x,p.y,p.z);
        if(!grad) continue;
        var mag=Math.sqrt(grad.dx*grad.dx+grad.dy*grad.dy+grad.dz*grad.dz);
        if(mag<0.001||mag>20) continue;
        if(mag>maxMag) maxMag=mag;
        tempArrows.push({x:p.x,y:p.y,z:p.z,gx:grad.dx,gy:grad.dy,gz:grad.dz,mag:mag});
    }
    for(var idx=0;idx<tempArrows.length;idx++){
        var v=tempArrows[idx];
        var len=scale*(0.1+0.9*(v.mag/(maxMag||1)));
        var unitVector=1.0/v.mag;
        arrows.push({
                        fromX:v.x,fromY:v.y,fromZ:v.z,
                        toX:v.x+v.gx*unitVector*len,
                        toY:v.y+v.gy*unitVector*len,
                        toZ:v.z+v.gz*unitVector*len,
                        color:getVectorColor3D(v.mag,maxMag),
                        magnitude:v.mag
                    });
    }
    console.log("implict vector feild has:",arrows.length,"arrows");
    return {vectors:arrows,maxMagnitude:maxMag};
}

function generateBallVectorField(radius){
    var arrows=[];
    var nTheta=8;//纬度
    var nPhi=12;//经度
    var arrowLen=radius*0.25;
    for(var ti=0;ti<nTheta;ti++){
        var theta=(ti+0.5)*Math.PI/nTheta;
        for(var pi=0;pi<nPhi;pi++){
            var phi=pi*2*Math.PI/nPhi;
            var x=radius*Math.sin(theta)*Math.cos(phi);
            var y=radius*Math.sin(theta)*Math.sin(phi);
            var z=radius*Math.cos(theta);
            var len=arrowLen*(0.4+0.6*Math.sin(theta));
            var dx=(x/radius)*len;
            var dy=(y/radius)*len;
            var dz=(z/radius)*len;
            var mag=1.0;
            arrows.push({
                            fromX:x,fromY:y,fromZ:z,
                            toX:x+dx,toY:y+dy,toZ:z+dz,
                            color:getVectorColor3D(mag,2.0),
                            magnitude:mag
                        });
        }
    }
    console.log("Ball surface vector feild has:",arrows.length,"arrows");
    return {vectors:arrows,maxMagnitude:1.0};
}

function detectBall(expr){
    var s = expr.replace(/\s/g,'');
    s = s.replace(/x\*x/g, 'x^2');
    s = s.replace(/y\*y/g, 'y^2');
    s = s.replace(/z\*z/g, 'z^2');
    var patterns = [
                /x\^2\+y\^2\+z\^2=([\d.]+)/,
                /x\^2\+z\^2\+y\^2=([\d.]+)/,
                /y\^2\+x\^2\+z\^2=([\d.]+)/,
                /y\^2\+z\^2\+x\^2=([\d.]+)/,
                /z\^2\+x\^2\+y\^2=([\d.]+)/,
                /z\^2\+y\^2\+x\^2=([\d.]+)/
            ];
    for(var i=0; i<patterns.length; i++){
        var m = s.match(patterns[i]);
        if(m){
            var r2 = parseFloat(m[1]);
            if(r2 > 0) return {isSphere: true, radius: Math.sqrt(r2)};
        }
    }
    return {isSphere: false, radius: 0};
}

function sampleVectorField3DAuto(expr, gridSize, arrowScale){
    gridSize = gridSize || 8;
    arrowScale = arrowScale || 0.15;
    var sphere = detectBall(expr);
    if(sphere.isSphere) return generateBallVectorField(sphere.radius);
    if(expr.indexOf('=') !== -1) return produceImplicitVecField(expr, gridSize, arrowScale);
    return produceExplicitVecField(expr, gridSize, arrowScale);
}

