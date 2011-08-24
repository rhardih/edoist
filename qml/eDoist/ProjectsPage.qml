import QtQuick 1.0
import com.nokia.symbian 1.0
import "backend.js" as Todoist

Page {

    id: projectsPage

    property ListModel projectsListModelProperty: projectsListModel
    property variant indicesBeforeReorder
    property variant projectData


    function getProjectsSuccess(data) {
        //console.log(data)
        projectsListModel.clear();
        var projects = JSON.parse(data);
        for(var i = 0; i < projects.length; i++) {
            // NOTE: This assumes projects are sorted already
            projectsListModel.append(projects[i]);
        }
        listView.model = projectsListModel;
        listView.visible = true;
        infoBanner.close();
    }

    function getProjectsError(data) {
        infoBanner.close();
        errorBanner.text = "Error getting projects.";
        errorBanner.open();
    }

    function addProjectSuccess(data) {
        //console.log(data);
        if(data === '"ERROR_NAME_IS_EMPTY"') {
            // Only here for reference. Empty project name should not be submitted.
        } else {
            var project = JSON.parse(data);
            projectsListModel.append(project);
            listView.positionViewAtIndex(projectsListModel.count - 1, ListView.End);
            listView.currentIndex = projectsListModel.count - 1;
            listView.currentItem.highlightRunning = true;
            // TODO: Check if this works in QtQuick 1.1
            //listView.positionViewAtEnd();
        }
        infoBanner.close();
    }

    function addProjectError(data) {
        infoBanner.close();
        errorBanner.text = "Error adding project."
        errorBanner.open();
    }

    function updateProjectOrdersSuccess(data) {
        infoBanner.close();
        if(data == "'ERROR_PROJECT_NOT_FOUND'") {
            updateProjectOrdersError(data);
        }
    }

    function updateProjectOrdersError(data) {
        projectsListModel.move(indicesBeforeReorder.old_index, indicesBeforeReorder.new_index, 1);
        infoBanner.close();
        errorBanner.text = "Error updating project order."
        errorBanner.open();
    }

    Component.onCompleted: {
        infoBanner.text = "Getting projects.";
        infoBanner.open();
        Todoist.getProjects({ token: main.api_token }, getProjectsSuccess, getProjectsError);
    }

    anchors.fill: parent
    tools: ToolBarLayout {

        ToolButton { visible: false }

        ToolButton { iconSource: "toolbar-add"; onClicked: addProjectDialog.open() }

        ToolButton { visible: false }

        ToolButton {

            id: reorderingButton

            iconSource: "images/up-down.svg";
            checkable: true

        }

        ToolButton { iconSource: "toolbar-menu"; onClicked: menu.open(); }

    }

    Component {

        id: projectEditPage

        ProjectEditPage {

            name: projectData.name
            color: projectData.color
            indent: projectData.indent
            project_id: projectData.project_id
            index: projectData.index

            projectsListModel: projectsListModelProperty

        }

    }

    Component {

        id: tasksPage

        TasksPage {

            project_id: projectData.project_id
        }

    }

    Component {

        id: listDelegate

        ListItem {

            id: listItem

            property alias highlightRunning: highlightAnimation.running

            subItemIndicator: true

            Rectangle {

                id: background

                anchors.fill: parent
                color: "white"
                visible: false
                opacity: 0.8

            }

            Rectangle {

                id: colorRect

                width: 35; height: 35
                radius: 5
                // Workaround due to property "shadowing" of color.
                // Fallback necessary because deleting and item from the list model
                // triggers a binding update, where projectsListModel.get(index) is undefined
                // See also TasksPage.qml (id: checkBox)
                color: projectsListModel.get(index) ? projectsListModel.get(index).color : Todoist.colors[0]

                anchors.left: parent.left
                anchors.leftMargin: indent * platformStyle.paddingLarge
                anchors.verticalCenter: parent.verticalCenter

                SequentialAnimation {

                    id: highlightAnimation

                    loops: 3

                    PropertyAnimation {
                        target: colorRect
                        property: "opacity"
                        to: 0
                        duration: 250
                    }

                    PropertyAnimation {
                        target: colorRect
                        property: "opacity"
                        to: 1
                        duration: 250
                    }

                }

            }

            ListItemText {

                id: listItemText

                mode: listItem.mode
                role: "Title"
                text: name // Title text from model
                width: parent.width
                anchors.left: colorRect.right
                anchors.right: listItem.paddingItem.right
                anchors.leftMargin: platformStyle.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {

                if(reorderingButton.checked) {

                } else {

                    // Somehow this doesn't work
                    //if(projectData) {
                    //    projectData.project_id = id;
                    //} else {
                    //    projectData = { project_id: id };
                    //}
                    // see also TasksPage.qml 357
                    projectData = { project_id: id };
                    pageStack.push(tasksPage);
                }

            }

            onPressAndHold: {

                projectData = {
                    name: name,
                    color: projectsListModel.get(index).color,
                    indent: indent,
                    project_id: id,
                    index: index
                }
                pageStack.push(projectEditPage);

            }

            MouseArea {

                anchors.fill: parent
                enabled: reorderingButton.checked
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: listView.contentHeight

                onPressed: {
                    listItem.z = 2;
                    drag.target = listItem;
                    listView.interactive = false;
                    listItemText.color = platformStyle.colorNormalDark;
                    background.visible = true;
                }

                onReleased: {
                    listItem.z = 1;
                    drag.target = null;
                    listView.interactive = true;
                    listItemText.color = platformStyle.colorNormalLight;
                    background.visible = false;

                    var new_index = Math.floor(listItem.y / listItem.height)
                    new_index = Math.min(new_index, projectsListModel.count - 1);
                    indicesBeforeReorder = {};
                    indicesBeforeReorder.old_index = index;
                    indicesBeforeReorder.new_index = new_index;
                    projectsListModel.move(index, new_index, 1);

                    var project_ids = new Array(projectsListModel.count);
                    for(var i = 0; i < projectsListModel.count; i++) {
                        project_ids[i] = projectsListModel.get(i).id;
                    }

                    // Use if moving after successfull return.
                    //var project_id = project_ids.splice(index, 1)[0];
                    //project_ids.splice(orderSlider.value - 1, 0, project_id);

                    var update_order_data = {
                        token: main.api_token,
                        id_list: JSON.stringify(project_ids)
                    }

                    infoBanner.text = "Updating order of projects"
                    infoBanner.open();

                    Todoist.updateProjectOrders(update_order_data, updateProjectOrdersSuccess, updateProjectOrdersError);

                }

            }

        }

    }

    Rectangle {

        id: notifyUpdateRect

        x: -2;
        width: {
            if(listView.contentY > -main.listRefreshBound) {
                return 2 + parent.width * (1 + (listView.contentY / main.listRefreshBound));
            } else {
                return 2;
            }
        }
        height: 6
        radius: 2
        opacity: {
            if(listView.contentY > -main.listRefreshBound) {
                return 0 + (listView.contentY / -main.listRefreshBound);
            } else {
                return 1;
            }

        }
        anchors.top: parent.top
        color: platformStyle.colorNormalLight

    }

    Text {

        id: notifyUpdateText

        anchors.top: notifyUpdateRect.bottom
        anchors.topMargin: platformStyle.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Keep pulling to refresh list ..."
        font.family: platformStyle.fontFamilyRegular
        font.pixelSize: platformStyle.fontSizeSmall
        color: platformStyle.colorNormalLight
        opacity:  notifyUpdateRect.opacity

    }

    ListView {

        id: listView

        property int contentYMin: 0

        header: ListHeading {

            id: listHeading

            ListItemText {
                id: headingText
                anchors.fill: listHeading.paddingItem
                role: "Heading"
                text: "Projects"
                font.pixelSize: platformStyle.fontSizeLarge
            }

        }

        model: ListModel { id: projectsListModel; }
        delegate: listDelegate
        anchors.fill: parent
        boundsBehavior: Flickable.DragOverBounds

        onContentYChanged: {
            if(contentY < -main.listRefreshBound) {
                listView.visible = false; // This is to intercept ongoing tap / hold
                infoBanner.text = "Updating list of projects.";
                infoBanner.open();
                listView.model = null;
                Todoist.getProjects({ token: main.api_token }, getProjectsSuccess, getProjectsError);
            }
        }

    }

    ScrollDecorator {
        id: scrolldecorator
        flickableItem: listView
    }

    Dialog {

        id: addProjectDialog

        title: Text {
            text: "New project"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: platformStyle.paddingLarge
            font.family: platformStyle.fontFamilyRegular
            font.pixelSize: platformStyle.fontSizeLarge
            color: platformStyle.colorNormalLink
        }

        content: TextField {

            id: newProjectDialogTextField

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: platformStyle.paddingMedium
            font.family: platformStyle.fontFamilyRegular
            placeholderText: "Input project name"

        }

        buttons: ToolBar {

            id: newProjectDialogToolbar

            anchors.left: parent.left
            anchors.right: parent.right

            Button {
                text: "Cancel"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: platformStyle.paddingMedium
                width: (parent.width - (3 * platformStyle.paddingMedium)) / 2
                onClicked: {
                    newProjectDialogTextField.text = ""
                    addProjectDialog.close();
                }
            }

            Button {

                text: "Ok"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: platformStyle.paddingMedium
                width: (parent.width - (3 * platformStyle.paddingMedium)) / 2
                enabled: newProjectDialogTextField.text

                onClicked: {

                    infoBanner.text = "Adding project..."
                    infoBanner.open();

                    var add_data = {
                        token: main.api_token,
                        name: newProjectDialogTextField.text
                    };
                    Todoist.addProject(add_data, addProjectSuccess, addProjectError);

                    addProjectDialog.close();
                    newProjectDialogTextField.text = "";

                }

            }

        }

    }

    Menu {

        id: menu

        content: MenuLayout {

            MenuItem {

                text: "Settings"

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                }
            }

            MenuItem {

                text: "Help"

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("HelpPage.qml"));
                }

            }

            MenuItem {

                text: "About"

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                }

            }

            MenuItem {

                text: "Quit"

                onClicked: {
                    Qt.quit();
                }

            }

        }

    }

}
