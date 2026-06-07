#pragma once

#include <QtCanvasPainter>
#include <QCanvasPainterItem>
#include  <QtQml/qqmlregistration.h>

class My2DCanvas : public QCanvasPainterItem
{
    Q_OBJECT
    QML_ELEMENT
    //一个简单的范围,直接使用重构生成
    Q_PROPERTY(double xMin READ xMin WRITE setXMin NOTIFY rangeChanged)
    Q_PROPERTY(double xMax READ xMax WRITE setXMax NOTIFY rangeChanged)
    Q_PROPERTY(double yMin READ yMin WRITE setYMin NOTIFY rangeChanged)
    Q_PROPERTY(double yMax READ yMax WRITE setYMax NOTIFY rangeChanged)

public:
    explicit My2DCanvas(QQuickItem *parent = nullptr);


    // QML 可调用的缩放方法
    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE void resetView();

    double xMax() const;
    void setXMax(double newXMax);

    double xMin() const;
    void setXMin(double newXMin);

    double yMin() const;
    void setYMin(double newYMin);

    double yMax() const;
    void setYMax(double newYMax);

signals:
    void rangeChanged();

protected:
    QCanvasPainterItemRenderer *createItemRenderer() const override;//编写自己的绘制项目，就需要实现其唯一的纯虚拟公共函数

private:
    double m_xMin = -5.0f;
    double m_xMax = 5.0f;
    double m_yMin = -5.0f;
    double m_yMax = 5.0f;
};

