#include "qcvimageprovider.h"
#include <QDebug>

QImage QCVImageProvider::requestImage(const QString &id, QSize *size, const QSize& requestedSize)
{
    qDebug() << "Image ID : " << id;
    qDebug() << "Size : " << size->width() << "x" << size->height();
    qDebug() << "Requested size : " << requestedSize.width() << "x" << requestedSize.height();

    //load image using opencv
    QImage img;
    img.load(":/fox.png");

    cv::Mat inputImage(qImage2CvImage(img));
    //cv::Mat inputImage = cv::imread("/home/charby/IMG_21032014_094834.png");
    //cv::imshow("Display Image", inputImage);

    return CvImage2QImage(inputImage);


}

//Convert QImage to iplImage (cf http://developer.nokia.com/community/wiki/Using_OpenCV_with_Qt)
IplImage* QCVImageProvider::qImage2CvImage(const QImage& qImage)
{
    int width = qImage.width();
    int height = qImage.height();

    // Creates a iplImage with 3 channels
    IplImage *img = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
    char * imgBuffer = img->imageData;

    //Remove alpha channel
    int jump = (qImage.hasAlphaChannel()) ? 4 : 3;

    for (int y=0;y<img->height;y++)
    {
        QByteArray a((const char*)qImage.scanLine(y), qImage.bytesPerLine());
        for (int i=0; i<a.size(); i+=jump)
        {
            //Swap from RGB to BGR
            imgBuffer[2] = a[i];
            imgBuffer[1] = a[i+1];
            imgBuffer[0] = a[i+2];
            imgBuffer+=3;
        }
    }

    return img;
}

QImage QCVImageProvider::CvImage2QImage(const IplImage *iplImage)
{
    int height = iplImage->height;
    int width = iplImage->width;

    if  (iplImage->depth == IPL_DEPTH_8U && iplImage->nChannels == 3)
    {
        const uchar *qImageBuffer = (const uchar*)iplImage->imageData;
        QImage img(qImageBuffer, width, height, QImage::Format_RGB888);

        return img.rgbSwapped();
    }
    else if  (iplImage->depth == IPL_DEPTH_8U && iplImage->nChannels == 1)
    {
        const uchar *qImageBuffer = (const uchar*)iplImage->imageData;
        QImage img(qImageBuffer, width, height, QImage::Format_Indexed8);

        QVector<QRgb> colorTable;
        for (int i = 0; i < 256; i++)
        {
            colorTable.push_back(qRgb(i, i, i));
        }
        img.setColorTable(colorTable);
        return img;
    }
    else
    {
      return QImage();
    }
}


QImage QCVImageProvider::CvImage2QImage(cv::Mat Image)
{
    int height = Image.rows;
    int width = Image.cols;

    //if (Image.depth() != IPL_DEPTH_8U) return QImage();

    if  ( Image.channels() == 3)
    {
        return QImage((const unsigned char*)(Image.data),
                                      width, height,
                                      Image.step, QImage::Format_RGB888).rgbSwapped();
    }
    else if  ( Image.channels() == 1)
    {
        return QImage((const unsigned char*)(Image.data),
                                      width, height,
                                      Image.step, QImage::Format_Indexed8);
    }
    else
    {
      return QImage();
    }
}
