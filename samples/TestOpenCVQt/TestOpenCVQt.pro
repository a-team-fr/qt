TEMPLATE = app

QT += qml quick widgets

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {

    message("Using android configuration")

    ANDROID_OPENCV = /home/charby/Developpement/OpenCV-2.4.9-android-sdk/sdk/native

    INCLUDEPATH += $$ANDROID_OPENCV/jni/include/
    LIBS+= $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_info.so \
        $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_highgui.a \
        $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_core.a \
        $$ANDROID_OPENCV/3rdparty/libs/armeabi-v7a/libtbb.a \

        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_java.so \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_ocl.a \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_photo.a \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_stitching.a \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_superres.a \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_ts.a \
        #$$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_videostab.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_contrib.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_legacy.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_ml.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_objdetect.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_calib3d.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_video.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_features2d.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_androidcamera.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_flann.a \
    #    $$ANDROID_OPENCV/libs/armeabi-v7a/libopencv_imgproc.a \
    #     $$ANDROID_OPENCV/3rdparty/libs/x86/libIlmImf.a \
    #    $$ANDROID_OPENCV/3rdparty/libs/armeabi-v7a/liblibjpeg.a \
    #    $$ANDROID_OPENCV/3rdparty/libs/armeabi-v7a/liblibpng.a \
    #    $$ANDROID_OPENCV/3rdparty/libs/armeabi-v7a/liblibtiff.a \
    #    $$ANDROID_OPENCV/3rdparty/libs/armeabi-v7a/liblibjasper.a \

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android \


    OTHER_FILES += \
        android/AndroidManifest.xml


    ANDROID_EXTRA_LIBS = \
        $$PWD/../../OpenCV-2.4.9-android-sdk/sdk/native/libs/armeabi-v7a/libopencv_info.so \
        $$PWD/../../OpenCV-2.4.9-android-sdk/sdk/native/libs/armeabi-v7a/libopencv_java.so

}
else {
    message("Using unix configuration")

    LIBS+= -lopencv_core -lopencv_highgui \
}


SOURCES += main.cpp \
    qcvimageprovider.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

#HEADERS += \
#    qcvimageprovider.h

HEADERS += \
    qcvimageprovider.h







