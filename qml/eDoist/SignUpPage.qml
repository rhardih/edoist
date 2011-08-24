import QtQuick 1.0
import com.nokia.symbian 1.0
import "backend.js" as Todoist
import "storage.js" as Storage

Page {

    id: signupPage

    property variant timezones
    property int chosenTimezoneIndex: 0

    function getTimezonesSuccess(data) {
        //console.log(data);
        infoBanner.close();
        signupPage.timezones = JSON.parse(data);
        for(var i = 0; i < timezones.length; i++) {
            timezoneListModel.append({"name": signupPage.timezones[i][1]});
        }
        timezoneTextField.ready = true;
    }

    function getTimezonesError(data) {
        infoBanner.close();
    }

    function registerSuccess(data) {
        infoBanner.close();

        emailTextField.errorHighlight = false;
        passwordTextField.errorHighlight = false;
        nameTextField.errorHighlight = false;

        if(data === '"ALREADY_REGISTRED"') {
            errorBanner.text = "User already registered.";
            errorBanner.open();
            emailTextField.errorHighlight = true;
        } else if(data === '"TOO_SHORT_PASSWORD"') {
            errorBanner.text = "Password should be at least 5 characters long.";
            errorBanner.open();
            passwordTextField.errorHighlight = true;
        } else if(data === '"INVALID_EMAIL"') {
            errorBanner.text = "Email is invalid.";
            errorBanner.open();
            emailTextField.errorHighlight = true;
        } else if(data === '"INVALID_TIMEZONE"') {
            errorBanner.text = "Timezone is invalid."; // should never be shown
            errorBanner.open();
        } else if(data === '"INVALID_FULL_NAME"') {
            errorBanner.text = "Name is invalid";
            errorBanner.open();
            nameTextField.errorHighlight = true;
        } else if(data === '"UNKNOWN_ERROR"') {
            errorBanner.text = "Unknown error occured.";
            errorBanner.open();
        } else {
            var user = JSON.parse(data);
            main.api_token = user.api_token;

            Storage.initialize();
            Storage.setSetting("api_token", user.api_token);

            pageStack.push(Qt.resolvedUrl("ProjectsPage.qml"));
        }

    }

    function registerError(data) {
        infoBanner.close();
        errorBanner.text = "Error trying to register"
        errorBanner.open();
    }

    Component.onCompleted: {
        infoBanner.text = "Retrieving available timezones";
        infoBanner.open();
        Todoist.getTimezones(getTimezonesSuccess, getTimezonesError);
    }

    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            flat: true
            onClicked: pageStack.pop()

        }

        ToolButton {
            text: "Submit"

            enabled: nameTextField.text &&
                     emailTextField.text &&
                     passwordTextField.text &&
                     timezoneTextField.text

            onClicked: {

                infoBanner.text = "Registering new user"
                infoBanner.open();

                var tz = signupPage.timezones[timezoneDialog.selectedIndex][0];

                var register_data = {
                    email: emailTextField.text,
                    full_name: nameTextField.text,
                    password: passwordTextField.text,
                    timezone: tz
                }

                Todoist.register(register_data, registerSuccess, registerError);

            }

        }

        ToolButton {
            iconSource: "toolbar-menu"

            onClicked: menu.open()

        }

    }


    Flickable {

        anchors.fill: parent
        anchors.margins: platformStyle.paddingMedium
        contentHeight: contentColumn.height


        Flow {

            id: contentColumn

            width: parent.width
            spacing: platformStyle.paddingMedium

            Text {

                id: titleText

                text: "<b>Registration</b>"
                width: parent.width
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
            }

            Rectangle {
                width: parent.width
                height: 1
            }

            Text {

                id: infoText

                width: parent.width
                text: "Please enter the following information:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap
            }

            Text {
                text: "Your name:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextField {
                id: nameTextField
                width: parent.width
            }

            Text {
                text: "Email:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextField {
                id: emailTextField
                width: parent.width
            }

            Text {
                text: "Password:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextField {
                id: passwordTextField
                echoMode: TextInput.Password
                width: parent.width
            }

            Text {
                text: "Timezone:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextField {

                id: timezoneTextField

                property bool ready: false

                width: parent.width
                enabled: false

                text: {
                    if(timezoneDialog.model.get(timezoneDialog.selectedIndex)) {
                        return timezoneDialog.model.get(timezoneDialog.selectedIndex).name;
                    } else {
                        return "";
                    }
                }

                placeholderText: "None chosen"


                MouseArea {

                    anchors.fill: parent

                    onClicked: {

                        if(timezoneTextField.ready) { timezoneDialog.open(); }

                    }

                }

                BusyIndicator {
                    running: true
                    anchors.right: parent.right
                    anchors.rightMargin: platformStyle.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !timezoneTextField.ready
                }

            }

        }

    }

    Menu {

        id: menu

        content: MenuLayout {

            MenuItem {

                text: "Quit"

                onClicked: {
                    Qt.quit();
                }

            }

        }

    }

    ListModel {

        id: timezoneListModel

    }

    SelectionDialog {
        id: timezoneDialog
        titleText: "Choose a timezone"
        model: timezoneListModel
    }

    states: [
        State {
            name: "Portrait"
            when: screen.currentOrientation === Screen.Portrait ||
                  screen.currentOrientation === Screen.PortraitInverted
        },
        State {
            name: "Landscape"
            when: screen.currentOrientation === Screen.Landscape ||
                  screen.currentOrientation === Screen.LandscapeInverted

        }

    ]

}
