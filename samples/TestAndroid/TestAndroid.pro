TEMPLATE = app

QT += qml quick sensors multimedia positioning


#LIBS += /home/charby/Developpement/OpenCV-2.4.10-android-sdk/sdk/native/libs/armeabi-v7a/*

#INCLUDEPATH += /home/charby/Developpement/OpenCV-2.4.10-android-sdk/sdk/native/jni/include/

SOURCES += main.cpp \
    satellitemodel.cpp

HEADERS += \
    satellitemodel.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += \
    android/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
