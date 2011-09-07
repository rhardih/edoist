# Add more folders to ship with the application, here
folder_01.source = qml/eDoist
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

VERSION = 1.0.0

#CONFIG += qt-components # This does not work


symbian {
  #TARGET.UID3 = 0xE78A23F5
  TARGET.UID3 = 0x20047681

  # Smart Installer package's UID
  # This UID is from the protected range and therefore the package will
  # fail to install if self-signed. By default qmake uses the unprotected
  # range value if unprotected UID is defined for the application and
  # 0x2002CCCF value if protected UID is given to the application
  DEPLOYMENT.installer_header = 0x2002CCCF

  vendorinfo = "%{\"éncoder\"}" ":\"éncoder-EN\""
  vendor_deploy.pkg_prerules += vendorinfo
  DEPLOYMENT += vendor_deploy
  # Allow network access on Symbian
  TARGET.CAPABILITY += NetworkServices
  SOURCES += eDoist_en.ts # For the remote compiler
  TRANSLATIONS += eDoist_en.ts
  CONFIG += localize_deployment
  ICON = eDoist.svg
  deploy.pkg_prerules += "(0x200346DE), 1, 0, 0, {\"Qt Components\"}"
  DEPLOYMENT += deploy
}

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

HEADERS +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

RESOURCES +=



