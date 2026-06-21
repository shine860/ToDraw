#include "my2dcanvasrenderer.h"
#include "my2dcanvas.h"
#include <QString>
#include <QtMath>
#include <QColor>
#include <QPointF>

//同步数据
void My2DCanvasRenderer::synchronize(QCanvasPainterItem *item)
{
    My2DCanvas *canvas = static_cast<My2DCanvas *>(item);
    if (canvas) {
        m_xMin = canvas->xMin();
        m_xMax = canvas->xMax();
        m_yMin = canvas->yMin();
        m_yMax = canvas->yMax();
        m_width = width();
        m_height = height();
        m_multiFunctionData = canvas->multiFunctionData();
    }
}

void My2DCanvasRenderer::paint(QCanvasPainter *p)
{
    if (m_width <= 0 || m_height <= 0) return;
    if (m_xMax <= m_xMin || m_yMax <= m_yMin) return;

    // 1. 白色背景
    p->setFillStyle(QColorConstants::White);
    p->fillRect(0, 0, m_width, m_height);

    drawGrid(p);
    drawAxes(p);
    drawScail(p);
    drawMultiFunctions(p);

    drawRangeInfo(p);
}
//转化成像素坐标
double My2DCanvasRenderer::toCanvasX(double x) const
{
    return (x - m_xMin) / (m_xMax - m_xMin) * m_width;
}

double My2DCanvasRenderer::toCanvasY(double y) const
{
    return m_height - (y - m_yMin) / (m_yMax - m_yMin) * m_height;
}

double My2DCanvasRenderer::adjustStepSize(double step) const
{
    if (step <= 0) return 1.0;
    double magnitude = 1.0;
    while (step / magnitude >= 10) {
        magnitude *= 10;
    }
    while (step / magnitude < 1) {
        magnitude /= 10;
    }
    double ratio = step / magnitude;

    if (ratio < 1.5) return magnitude;
    if (ratio < 3.5) return 2.0 * magnitude;
    if (ratio < 7.0) return 5.0 * magnitude;
    return 10.0 * magnitude;
}

//画网格
void My2DCanvasRenderer::drawGrid(QCanvasPainter *p)
{
    double xRange = m_xMax - m_xMin;
    double yRange = m_yMax - m_yMin;

    if (xRange <= 0 || yRange <= 0) return;

    double xStep = adjustStepSize(xRange / 10.0);
    double yStep = adjustStepSize(yRange / 10.0);

    p->setLineWidth(1);
    p->setStrokeStyle(QColor(200, 200, 200, 200));

    if (xStep > 0) {
        double xStart = std::floor(m_xMin / xStep) * xStep;
        // 计算需要画多少条线
        int xCount = static_cast<int>(std::floor((m_xMax - xStart) / xStep)) + 1;

        for (int i = 0; i < xCount; ++i) {
            double x = xStart + i * xStep;
            if (x > m_xMax + xStep * 0.001) break;

            if (x > -xStep*0.1 && x < xStep * 0.1) continue;

            double cx = toCanvasX(x);
            if (cx >= 0 && cx <= m_width) {
                p->beginPath();
                p->moveTo(cx, 0);
                p->lineTo(cx, m_height);
                p->stroke();
            }
        }
    }

    if (yStep > 0) {
        double yStart = std::floor(m_yMin / yStep) * yStep;
        int yCount = static_cast<int>(std::floor((m_yMax - yStart) / yStep)) + 1;

        for (int j = 0; j < yCount; ++j) {
            double y = yStart + j * yStep;
            if (y > m_yMax + yStep * 0.001) break;
            if (y > -yStep * 0.1 && y < yStep * 0.1) continue;

            double cy = toCanvasY(y);
            if (cy >= 0 && cy <= m_height) {
                p->beginPath();
                p->moveTo(0, cy);
                p->lineTo(m_width, cy);
                p->stroke();
            }
        }
    }
}
//画坐标轴
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
//画刻度
void My2DCanvasRenderer::drawScail(QCanvasPainter *p)
{
    // 计算步长
    double xStep = adjustStepSize((m_xMax - m_xMin) / 10.0);
    double yStep = adjustStepSize((m_yMax - m_yMin) / 10.0);

    //设置画笔
    p->setStrokeStyle(QColor(50, 50, 50));
    p->setLineWidth(1.5);
    p->setFillStyle(QColor(50, 50, 50));
    p->setFont(QFont("Arial", 10));

    // 获取坐标轴位置
    double x0 = toCanvasX(0);  // Y轴在画布上的x位置
    double y0 = toCanvasY(0);  // X轴在画布上的y位置
    int tickLength = 6;

    //计算起始位置
    double xStart = std::floor(m_xMin / xStep) * xStep;
    double yStart = std::floor(m_yMin / yStep) * yStep;

    //X轴刻度
    if (xStep > 0 && y0 >= 0 && y0 <= m_height) {
        // 计算需要画多少条刻度线
        int xCount = static_cast<int>(std::floor((m_xMax - xStart) / xStep)) + 1;

        for (int i = 0; i < xCount; ++i) {
            double x = xStart + i * xStep;
            if (x > m_xMax + xStep * 0.001) break;

            if (x > -xStep * 0.1 && x < xStep * 0.1) continue;

            double cx = toCanvasX(x);
            if (cx >= 0 && cx <= m_width) {
                // 画刻度线
                p->beginPath();
                p->moveTo(cx, y0 - tickLength);
                p->lineTo(cx, y0 + tickLength);
                p->stroke();

                // 画刻度数值
                QString label = QString::number(x, 'g', 3);

                // 居中
                if (x >= 0) {
                    label = " " + label;
                }
                p->fillText(label, cx-10, y0 + tickLength + 16);
            }
        }
    }

    // Y轴刻度
    if (yStep > 0 && x0 >= 0 && x0 <= m_width) {
        int yCount = static_cast<int>(std::floor((m_yMax - yStart) / yStep)) + 1;

        for (int j = 0; j < yCount; ++j) {
            double y = yStart + j * yStep;
            if (y > m_yMax + yStep * 0.001) break;

            if (y > -yStep * 0.1 && y < yStep * 0.1) continue;

            double cy = toCanvasY(y);
            if (cy >= 0 && cy <= m_height) {
                // 画刻度线
                p->beginPath();
                p->moveTo(x0 - tickLength, cy);
                p->lineTo(x0 + tickLength, cy);
                p->stroke();

                // 画刻度数值
                QString label = QString::number(y, 'g', 3);
                p->fillText(label, x0 - 25, cy + 4);
            }
        }
    }

    p->fillText("0", x0 + 4, y0 - 4);
}
//画函数曲线
void My2DCanvasRenderer::drawMultiFunctions(QCanvasPainter *p)
{
    if (m_multiFunctionData.isEmpty()) return;

    for (int i = 0; i < m_multiFunctionData.size(); ++i) {
        QVariantMap funcData = m_multiFunctionData[i].toMap();
        QList<QVariant> pointsVar = funcData["points"].toList();
        QString color = funcData["color"].toString();
        QString expr = funcData["expr"].toString();
        if (pointsVar.isEmpty()) continue;

        p->setStrokeStyle(QColor(color));
        p->setLineWidth(2);
        p->beginPath();

        bool firstPoint = true;
        int pointCount = pointsVar.size();
        for (int j = 0; j < pointCount; ++j) {
            QPointF point = pointsVar[j].toPointF();
            double cx = toCanvasX(point.x());
            double cy = toCanvasY(point.y());

            // 检查点是否在画布范围内
            if (cx >= 0 && cx <= m_width && cy >= 0 && cy <= m_height) {
                if (firstPoint) {
                    p->moveTo(cx, cy);
                    firstPoint = false;
                } else {
                    p->lineTo(cx, cy);
                }
            } else {
                // 如果点超出范围，断开曲线
                firstPoint = true;
            }
        }
        p->stroke();
    }
}
//显示文字信息
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