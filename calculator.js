// File: calculator.js
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-16 01:57:51
//         * 主要是参考了equation程序里面的js计算文件，但是由于包含的函数太少，最后添加了很多比较常用到的函数
// Change Log:
//     [v0.1.1]  黄钰琳2024051604104 <389930006@qq.com>   2026-07-16 01:58:56
//         * 主要是添加了矢量场相关的功能
// Change Log:
//     [v0.1.2] lilin2024051604098，2293779871@qq.com  2026-07-16 01:59:38
//         * 主要负责测试和完善

// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

// https://gist.github.com/tkrotoff/b0b1d39da340f5fc6c5e2a79a8b6cec0

// parseFloat('-0') => -0 vs parseFloat(-0) => 0
// -0 === 0 => true vs Object.is(-0, 0) => false

const minus0Hack = (value) => (Object.is(value, -0) ? '-0' : value);

// 定义所有函数名数组
const functionNames = ['sin', 'cos', 'tan', 'log', 'exp', 'sqrt', 'asin', 'acos', 'atan', 'sinh', 'cosh', 'tanh', 'log10', 'log2','min','max'];

// 按长度降序排序，优先匹配更长的函数名
const sortedFunctionNames = functionNames.slice().sort((a, b) => b.length - a.length);

// 存储所有运算符和函数的配置
const operators = {
    '+': {
        func: (x, y) => `${minus0Hack(Number(x) + Number(y))}`,
        precedence: 1,
        associativity: 'left',
        arity: 2
    },
    '-': {
        func: (x, y) => `${minus0Hack(Number(x) - Number(y))}`,
        precedence: 1,
        associativity: 'left',
        arity: 2
    },
    '*': {
        func: (x, y) => `${minus0Hack(Number(x) * Number(y))}`,
        precedence: 2,
        associativity: 'left',
        arity: 2
    },
    '/': {
        func: (x, y) => `${minus0Hack(Number(x) / Number(y))}`,
        precedence: 2,
        associativity: 'left',
        arity: 2
    },
    '%': {
        func: (x, y) => `${minus0Hack(Number(x) % Number(y))}`,
        precedence: 2,
        associativity: 'left',
        arity: 2
    },
    '^': {
        func: (x, y) => `${minus0Hack(Math.pow(Number(x), Number(y)))}`,
        precedence: 3,
        associativity: 'right',
        arity: 2
    },
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

const functionsKeys = Object.keys(functions);

/**
 * Shunting yard algorithm: converts infix expression to postfix expression (reverse Polish notation)//算符优先算法，将中缀表达式转换为后缀表达式
 *
 * Example: ['1', '+', '2'] => ['1', '2', '+']//计算器更容易处理后缀表达式，因为不需要括号和优先级
 *
 * https://en.wikipedia.org/wiki/Shunting_yard_algorithm
 * https://github.com/poteat/shunting-yard-typescript
 * https://blog.kallisti.net.nz/2008/02/extension-to-the-shunting-yard-algorithm-to-allow-variable-numbers-of-arguments-to-functions/
 */
//调度场算法
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

        // 检查是否是已知函数名
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

        // 数字
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

        // 运算符或括号
        if (['+', '-', '*', '/', '%', '^', '(', ')', ','].includes(c)) {
            tokens.push(c);
            i++;
            continue;
        }

        // 变量 x 或 y 或 z
        if (c === 'x' || c === 'y' || c === 'z') {
            tokens.push(c);
            i++;
            continue;
        }
        if (/[a-zA-Z]/.test(c)) {
            let unknown = '';
            while (i < expr.length && /[a-zA-Z]/.test(expr.charAt(i))) {
                unknown += expr.charAt(i);
                i++;
            }
            throw new Error("Unknown function or variable: '" + unknown + "'");
        }

        i++;
    }

    // 处理开头的一元运算符
    if (tokens.length > 0 && (tokens[0] === '+' || tokens[0] === '-')) {
        tokens.unshift('0');
    }

    // 处理括号内的一元运算符
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



// 2D 函数采样
function sample2DFunction(expr, xMin, xMax) {
    // 把x范围分成800份
    var step = (xMax - xMin) / 800;

    // 采样所有点
    var points = [];
    for (var i = 0; i <=800; i++){
        var x = xMin+i*step;
        try {
            var filled = expr.replace(/x/g, "(" +x+ ")");
            var y = calculate(filled);
            if (isFinite(y) && !isNaN(y)) {
                points.push({ x: x, y: y });
            }
        } catch(e) {}
    }

    // 分段处理处理间断点
    var segments=[];
    var current=[];
    for (var j=0;j<points.length;j++) {
        var p = points[j];
        if (current.length > 0) {
            var pre = current[current.length-1];
            var dx = p.x-pre.x;
            var dy = p.y-pre.y;
            var total = Math.sqrt(dx*dx + dy*dy);
            if (total > step * 5) {
                segments.push(current);
                current=[];
            }
        }
        current.push(p);
    }
    if (current.length > 1) {
        segments.push(current);
    }

    return {segments: segments,expression: expr};
}
//处理多个数据
function sampleMult2DFunctions(expressions, xMin, xMax) {
    var results = [];
    for (var i = 0; i < expressions.length; i++) {
        var expr = expressions[i];
        if (!expr || expr.trim() === "") continue;
        var result = sample2DFunction(expr, xMin, xMax);
        result.index = i;//根据序号分配颜色
        results.push(result);
    }
    return results;
}

// 2D 矢量场
function evalVectorField(pExpr, qExpr, x, y) {//计算单个点的矢量值
    try {
        var pFilled = pExpr.replace(/x/g, "("+x+")").replace(/y/g, "("+y+")");
        var qFilled = qExpr.replace(/x/g, "("+x+")").replace(/y/g, "("+y+")");
        var p = calculate(pFilled);
        var q = calculate(qFilled);

        if (!isFinite(p)||!isFinite(q)||isNaN(p)||isNaN(q)) {
            return null;
        }
        return { p: p, q: q, magnitude: Math.sqrt(p*p + q*q) };
    } catch (e) {
        return null;
    }
}

function sampleVector(pExpr, qExpr, xMin, xMax, yMin, yMax) {
    var vectors=[];//存放所有箭头的起点和终点
    var maxMagnitude=0;
    var tempVectors=[];

    var grid=20;
    var stepX=(xMax-xMin)/grid;
    var stepY=(yMax-yMin)/grid;

    for (var i = 0; i<=grid; i++) {
        var x = xMin+i * stepX;
        for (var j=0;j<= grid;j++) {
            var y = yMin+j*stepY;
            var result = evalVectorField(pExpr, qExpr, x, y);
            if (result) {
                tempVectors.push({
                                     x:x,
                                     y:y,
                                     p:result.p,
                                     q:result.q,
                                     magnitude:result.magnitude
                                 });
                if (result.magnitude>maxMagnitude) {
                    maxMagnitude=result.magnitude;
                }
            }
        }
    }
    var scale = 0.2;
    for (var le = 0; le < tempVectors.length; le++) {
        var v = tempVectors[le];
        var pV = v.p;
        var qV = v.q;
        var mag = v.magnitude;
        if (mag > 0) {
            var ratio=mag/maxMagnitude;
            var scaleLen=scale*(0.2+0.8*ratio)*(xMax-xMin)/10;
            pV = (pV/mag)*scaleLen;
            qV = (qV/mag) * scaleLen;
        }
        vectors.push({
                         fromX: v.x,
                         fromY: v.y,
                         toX: v.x + pV,
                         toY: v.y + qV,
                         magnitude: mag
                     });
    }

    return {vectors:vectors,maxMagnitude: maxMagnitude};
}

function vecColor(magnitude, maxMagnitude) {
    if (maxMagnitude === 0) return "blue";
    var t = magnitude / maxMagnitude;
    if (t < 0.2) return "blue";
    if (t < 0.4) return "cyan";
    if (t < 0.6) return "green";
    if (t < 0.8) return "orange";
    return "red";
}
















