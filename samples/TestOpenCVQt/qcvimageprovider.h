#ifndef QCVIMAGEPROVIDER_H
#define QCVIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <opencv2/opencv.hpp>

class QCVImageProvider : public QQuickImageProvider
{

public:
    QCVImageProvider() : QQuickImageProvider(QQuickImageProvider::Image){
    }
    QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize);


private:
    static IplImage* qImage2CvImage(const QImage& qImage);
    static QImage CvImage2QImage(const IplImage *iplImage);
    static QImage CvImage2QImage(cv::Mat Image);

};

#endif // QCVIMAGEPROVIDER_H
