import QtQuick 1.0
import com.nokia.symbian 1.0
import "backend.js" as Todoist
import "storage.js" as Storage

Page {

    function loginSuccess(data) {
        infoBanner.close();
        var json_data = JSON.parse(data);
        if(json_data === "LOGIN_ERROR") {
            emailTextField.errorHighlight = true;
            passwordTextField.errorHighlight = true;
            errorBanner.text = "Wrong Email or Password."
            errorBanner.open()
        } else {
            commonToolBar.visible = true;
            main.api_token = json_data.api_token;

            Storage.initialize();
            Storage.setSetting("api_token", json_data.api_token);

            pageStack.push(Qt.resolvedUrl("ProjectsPage.qml"));
        }
    }

    function loginError(data) {

        infoBanner.close();
        errorBanner.text = "Error logging in."
        errorBanner.open();

    }

    tools: ToolBarLayout {

        ToolButton {
            visible: false
        }

        ToolButton {
            visible: false
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

                text: "<b>Login</b>"
                width: parent.width
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Rectangle {

                width: parent.width
                height: 1

            }

            Column {

                id: loginColumn

                width: parent.width
                spacing: platformStyle.paddingMedium

                Text {

                    id: infoText

                    width: parent.width
                    text: "Since this is the first time you are using the application, please login using this form."
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    wrapMode: Text.WordWrap

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

                Button {

                    anchors.right: parent.right
                    width: parent.width / 2
                    text: "Login"
                    enabled: emailTextField.text && passwordTextField.text

                    onClicked: {
                        infoBanner.text = "Logging in.";
                        infoBanner.open();
                        var login_data = {
                            email: emailTextField.text,
                            password: passwordTextField.text
                        };
                        Todoist.login(login_data, loginSuccess, loginError);
                    }

                }

            }

            Column {

                id: signUpColumn

                width: parent.width
                spacing: platformStyle.paddingMedium

                Rectangle {

                    id: middleDivider

                    width: parent.width
                    height: 1

                }

                Text {

                    width: parent.width
                    text: "If you don't have an account with todoist.com already, you need to sign up first."
                    font.family: platformStyle.fontFamilyRegular
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    wrapMode: Text.WordWrap

                }

                Button {

                    anchors.right: parent.right
                    width: parent.width / 2
                    text: "Sign up"

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("SignUpPage.qml"));
                    }

                }

            }

        }

    }

    states: [
        State {

            name: "Portrait"
            when: main.state === "Portrait"

            PropertyChanges {
                target: middleDivider
                visible: true
            }

        },
        State {

            name: "Landscape"
            when: main.state === "Landscape"

            PropertyChanges {
                target: loginColumn
                width: (parent.width  - platformStyle.paddingMedium) / 2
            }

            PropertyChanges {
                target: signUpColumn
                width: (parent.width  - platformStyle.paddingMedium) / 2
            }

            PropertyChanges {
                target: middleDivider
                visible: false
            }

        }

    ]

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

    Component.onCompleted: {

        commonToolBar.visible = true;

    }

}
