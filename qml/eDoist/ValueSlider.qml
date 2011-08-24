import QtQuick 1.0
import com.nokia.symbian 1.0


Row {

    property alias maximumValue: indentSlider.maximumValue
    property alias minimumValue: indentSlider.minimumValue
    property alias value: indentSlider.value
    property alias stepSize: indentSlider.stepSize

    spacing: platformStyle.paddingMedium

    Slider {

        id: indentSlider

        width: parent.width - indentValueTextField.width - platformStyle.paddingMedium
        anchors.verticalCenter: parent.verticalCenter

    }

    TextField {

        id: indentValueTextField

        text: indentSlider.value
        enabled: false
        platformLeftMargin: platformStyle.paddingLarge
        anchors.verticalCenter: parent.verticalCenter

    }

}
