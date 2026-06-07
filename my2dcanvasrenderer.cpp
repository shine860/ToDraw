#include "my2dcanvasrenderer.h"
#include "my2dcanvas.h"
// #include <QtMath>
// #include <QFont>
// #include <cmath>
#include <QString>
// #include <QColor>

// 数据同步函数
void My2DCanvasRenderer::synchronize(QCanvasPainterItem *item)
{
    My2DCanvas *canvas = static_cast<My2DCanvas*>(item);
    if (canvas) {
        m_xMin = canvas->xMin();
        m_xMax = canvas->xMax();
        m_yMin = canvas->yMin();
        m_yMax = canvas->yMax();
        m_width = width();
        m_height = height();
    }
}

void My2DCanvasRenderer::paint(QCanvasPainter *p)
{
    if (m_width <= 0 || m_height <= 0)
        return;

    // 安全检查：防止坐标范围为0，除零崩溃
    if (m_xMax <= m_xMin || m_yMax <= m_yMin)
        return;

    // 1. 白色背景
    p->setFillStyle(QColorConstants::White);
    p->fillRect(0, 0, m_width, m_height);

    // 2. 画网格
    drawGrid(p);

    // 3. 画坐标轴
    drawAxes(p);

    // 4. 显示范围信息
    drawRangeInfo(p);
}

// 数学坐标x转换成屏幕像素
double My2DCanvasRenderer::toCanvasX(double x) const
{
    return (x - m_xMin) / (m_xMax - m_xMin) * m_width;
}

// 数学坐标y转换成屏幕像素
double My2DCanvasRenderer::toCanvasY(double y) const
{
    return m_height - (y - m_yMin) / (m_yMax - m_yMin) * m_height;
}

double My2DCanvasRenderer::adjustStepSize(double step) const
{
    if (step <= 0)
        return 1.0;

    double magnitude = std::pow(10.0, std::floor(std::log10(step)));
    double residual = step / magnitude;

    if (residual < 1.5)
        return magnitude;
    if (residual < 3.5)
        return 2.0 * magnitude;
    if (residual < 7.0)
        return 5.0 * magnitude;

    return 10.0 * magnitude;
}

void My2DCanvasRenderer::drawGrid(QCanvasPainter *p)
{
    double xRange = m_xMax - m_xMin;
    double yRange = m_yMax - m_yMin;

    double xStepWorld = adjustStepSize(xRange / 8.0);
    double yStepWorld = adjustStepSize(yRange / 8.0);

    p->setLineWidth(1);
    p->setStrokeStyle(QColorConstants::Gray);

    // 竖线网格
    double xStart = std::ceil(m_xMin / xStepWorld) * xStepWorld;
    int xCount = static_cast<int>(std::ceil((m_xMax - xStart) / xStepWorld)) + 1;

    for (int i = 0; i < xCount; ++i) {  // 改为 < 更安全
        double x = xStart + i * xStepWorld;
        if (x > m_xMax) break;

        double cx = toCanvasX(x);
        if (cx >= 0 && cx <= m_width) {
            p->beginPath();
            p->moveTo(cx, 0);
            p->lineTo(cx, m_height);
            p->stroke();
        }
    }

    // 横线网格
    double yStart = std::ceil(m_yMin / yStepWorld) * yStepWorld;
    int yCount = static_cast<int>(std::ceil((m_yMax - yStart) / yStepWorld)) + 1;

    for (int i = 0; i < yCount; ++i) {  // 改为 < 更安全
        double y = yStart + i * yStepWorld;
        if (y > m_yMax) break;

        double cy = toCanvasY(y);
        if (cy >= 0 && cy <= m_height) {
            p->beginPath();
            p->moveTo(0, cy);
            p->lineTo(m_width, cy);
            p->stroke();
        }
    }
}

void My2DCanvasRenderer::drawAxes(QCanvasPainter *p)
{
    p->setLineWidth(2);
    p->setStrokeStyle(QColorConstants::Black);

    // X轴
    double y0 = toCanvasY(0);
    if (y0 >= 0 && y0 <= m_height) {
        p->beginPath();
        p->moveTo(0, y0);
        p->lineTo(m_width, y0);
        p->stroke();
    }

    // Y轴
    double x0 = toCanvasX(0);
    if (x0 >= 0 && x0 <= m_width) {
        p->beginPath();
        p->moveTo(x0, 0);
        p->lineTo(x0, m_height);
        p->stroke();
    }
}

void My2DCanvasRenderer::drawRangeInfo(QCanvasPainter *p)
{
    p->setFont(QFont("Arial", 11));
    p->setFillStyle(QColorConstants::Gray);

    QString info = QString("x: [%1, %2]  y: [%3, %4]")
                       .arg(m_xMin, 0, 'f', 2)
                       .arg(m_xMax, 0, 'f', 2)
                       .arg(m_yMin, 0, 'f', 2)
                       .arg(m_yMax, 0, 'f', 2);

    p->fillText(info, 10, 25);
}
