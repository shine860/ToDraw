// Module
// File: calculator.js  Version: 0.1.0   License: AGPLv3
// Created:huangyulin       2026-06-22 08:48:32
// Description:所有函数计算描写就在这，我们上网也查询了那些常用的函数表达式，尽量保证全面
//

// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

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

const functionsKeys = Object.keys(functions);//提取函数名键

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
    const output = [];//输出队列，存放最终的后缀表达式
    const operatorStack = [];//运算符栈，临时存放运算符和括号

    for (const token of tokens) {//遍历数组中的每个元素
        if (functions[token] !== undefined) {//处理函数名，不是没有定义的就直接压入运算符栈
            operatorStack.push(token);
        } else if (token === ',') {
            while (operatorStack.length > 0 && operatorStack[operatorStack.length - 1] !== '(') {//从栈顶弹出运算符，直接遇到（
                output.push(operatorStack.pop());//将弹出的运算符添加到输出队列
            }
            if (operatorStack.length === 0) {
                throw new Error("Misplaced ','");//丢出错误
            }
        } else if (operators[token] !== undefined) {
            const o1 = token;
            while (
                operatorStack.length > 0 &&
                operatorStack[operatorStack.length - 1] !== undefined &&
                operatorStack[operatorStack.length - 1] !== '(' &&
                (operators[operatorStack[operatorStack.length - 1]].precedence > operators[o1].precedence ||//栈顶运算符的优先级》当前运算符的优先级
                 (operators[o1].precedence === operators[operatorStack[operatorStack.length - 1]].precedence &&
                  operators[o1].associativity === 'left'))//优先级相等，且当前运算符是左结合
                ) {
                output.push(operatorStack.pop());
            }
            operatorStack.push(o1);//将当前运算符压入栈
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
            output.push(token);//如果不是任何特殊符号，直接输出到队列(数字或变量名字），
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
/**
 * Evaluates reverse Polish notation (RPN) (postfix expression).//计算后缀表达式，逆波兰表示法
 *
 * Example: ['1', '2', '+'] => 3
 *
 * https://en.wikipedia.org/wiki/Reverse_Polish_notation
 * https://github.com/poteat/shunting-yard-typescript
 */
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
/**
 * Breaks a mathematical expression into tokens.
 *
 * Example: "1 + 2" => [1, '+', 2]
 *
 * https://gist.github.com/tchayen/44c28e8d4230b3b05e9f
 */
function tokenize(expression) {
    // 移除所有空格
    const expr = expression.replace(/\s+/g, '');
    const tokens = [];
    let i = 0;

    while (i < expr.length) {
        const c = expr.charAt(i);

        // 检查是否匹配函数名
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

        // 变量 x 或 y
        if (c === 'x' || c === 'y') {
            tokens.push(c);
            i++;
            continue;
        }

        i++;
    }

    // 处理开头的一元运算符
    if (tokens.length > 0 && (tokens[0] === '+' || tokens[0] === '-')) {
        tokens.unshift('0');
    }

    // ========== 处理括号内的一元运算符 ==========
    var result = [];
    for (var k = 0; k < tokens.length; k++) {
        var tok = tokens[k];
        // 如果是 '(' 且下一个 token 是 '+' 或 '-'
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