import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import "backend.js" as Todoist

Page {

    id: tasksPage

    property string project_id
    property bool items_loaded: false
    property ListModel tasksListModelProperty: tasksListModel
    // Circumvent the "delayed" binding of properties on
    // pageStack.push(), by binding them before the page is
    // pushed. All relevant databindings goes in here.
    property variant taskData // javascript object

    function getUncompletedTasksSuccess(data) {
        //console.log(data);
        if(data === '"ERROR_PROJECT_NOT_FOUND"') {
            // TODO: Proper error handling
        } else {
            tasksListModel.clear();
            var tasks = JSON.parse(data);
            for(var i = 0; i < tasks.length; i++) {
                tasksListModel.append(tasks[i]);
            }
            items_loaded = true;
            listView.model = tasksListModel;
            listView.visible = true;
            infoBanner.close();
        }

    }

    function getUncompletedTasksError(data) {
        infoBanner.close();
        errorBanner.text = "Error fetching uncomplete items."
        errorBanner.open();
    }

    function getCompletedTasksSuccess(data) {
        //console.log(data);
        if(data === '"ERROR_PROJECT_NOT_FOUND"') {
            // TODO: Proper error handling
        } else {

            var i;

            // Prune old completed tasks, if any exist
            for(i = tasksListModel.count - 1; i > 0 ; i--) {
                if(tasksListModel.get(i).checked) {
                    tasksListModel.remove(i);
                }
            }

            var tasks = JSON.parse(data);
            for(i = 0; i < tasks.length; i++) {
                tasksListModel.append(tasks[i]);
            }
            infoBanner.close();

        }

    }

    function getCompletedTasksError(data) {
        infoBanner.close();
        errorBanner.text = "Error fetching completed items."
        errorBanner.open();
    }


    function completeItemsSuccess(data) {
        if(data === '"ok"') {
            infoBanner.close();
            tasksListModel.set(taskData.checked_task_index, { checked: 1 });
            tasksListModel.append(tasksListModel.get(taskData.checked_task_index));
            tasksListModel.remove(taskData.checked_task_index);
            //tasksListModel.move(taskData.checked_task_index, tasksListModel.count - 1, 1);
        } else {
            completeItemsError(data);
        }
    }

    function completeItemsError(data) {
        infoBanner.close();
        errorBanner.text = "Error completing item."
        errorBanner.open();
    }

    function uncompleteItemsSuccess(data) {
        if(data === '"ok"') {
            infoBanner.close();
            tasksListModel.set(taskData.checked_task_index, { checked: 0 });
        } else {
            completeItemsError(data);
        }
    }

    function uncompleteItemsError(data) {
        infoBanner.close();
        errorBanner.text = "Error uncompleting item."
        errorBanner.open();
    }

    function updateOrdersSuccess(data) {
        if(data === '"ok"') {
            infoBanner.close();
        } else {
            completeItemsError(data);
        }
    }

    function updateOrdersError(data) {
        infoBanner.close();
        errorBanner.text = "Error updating task orders."
        errorBanner.open();
    }

    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolButton {
            iconSource: "toolbar-add"
            onClicked: {
                pageStack.push(taskAddPage, { project_id: project_id });
            }
        }

        ToolButton {

            iconSource: "toolbar-list"
            flat: true

            onClicked: {

                infoBanner.text = "Getting completed tasks."
                infoBanner.open();
                var completed_data = {
                    token: main.api_token,
                    project_id: tasksPage.project_id
                };
                Todoist.getCompletedItems(completed_data, getCompletedTasksSuccess, getCompletedTasksError);

            }

        }

        ToolButton {

            id: reorderingButton

            iconSource: "images/up-down.svg";
            checkable: true

        }

        ToolButton {
            iconSource: "toolbar-menu"
            //onClicked: menu.open()
            visible: false
        }

    }

    Component {

        id: taskAddPage

        TaskAddPage {
            tasksListModel: tasksListModelProperty
            tasksListView: listView
        }

    }

    Component {

        id: editTaskPage

        TaskEditPage {

            content: taskData.content
            due_date: taskData.due_date
            priority: taskData.priority
            task_id: taskData.task_id
            project_id: taskData.project_id
            tasksListModel: tasksListModelProperty
            index: taskData.index
            indent: taskData.indent
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

        z: 1

        header: ListHeading {

            id: listHeading

            ListItemText {
                id: headingText
                anchors.fill: listHeading.paddingItem
                role: "Heading"
                text: "Tasks"
                font.pixelSize: platformStyle.fontSizeLarge
            }

        }

        model: ListModel { id: tasksListModel; }
        delegate: listDelegate
        anchors.fill: parent
        boundsBehavior: Flickable.DragOverBounds

        onContentYChanged: {
            if(contentY < -main.listRefreshBound) {
                listView.visible = false; // This is to intercept ongoing tap / hold
                infoBanner.text = "Updating list of tasks."
                infoBanner.open();
                listView.model = null;
                var items_data = {
                    token: main.api_token,
                    project_id: tasksPage.project_id
                };
                Todoist.getUncompletedItems(items_data, getUncompletedTasksSuccess, getUncompletedTasksError);
            }
        }

    }

    ScrollDecorator {

        id: scrolldecorator

        flickableItem: listView

    }

    Component {

        id: listDelegate

        ListItem {

            id: listItem

            property alias highlightRunning: highlightAnimation.running

            // Doesn't work properly
            //mode: checkBox.checked ? "disabled" : "normal"

            Rectangle {

                id: background

                anchors.fill: parent
                color: "white"
                visible: false
                opacity: 0.8

            }

            Row {

                spacing: platformStyle.paddingMedium
                anchors.left: listItem.paddingItem.left
                anchors.right: checkBox.left
                anchors.rightMargin: platformStyle.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: (indent - 1) * platformStyle.paddingLarge

                Column {

                    id: priorityColumn

                    spacing: platformStyle.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {

                        model: priority

                        Rectangle {

                            width: 9
                            height: 9
                            radius: 2
                            color: checkBox.checked ? platformStyle.colorDisabledMid : Todoist.colors[priority * 3 - 1]

                        }

                    }

                    SequentialAnimation {

                        id: highlightAnimation

                        loops: 3

                        PropertyAnimation {
                            target: priorityColumn
                            property: "opacity"
                            to: 0
                            duration: 250
                        }

                        PropertyAnimation {
                            target: priorityColumn
                            property: "opacity"
                            to: 1
                            duration: 250
                        }

                    }

                }

                Column {

                    width: parent.width - priorityColumn.width - platformStyle.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter

                    ListItemText {

                        id: listItemText

                        mode: checkBox.checked ? "disabled" : "normal"
                        role: "Title"
                        text: content
                        width: parent.width
                    }

                    ListItemText {

                        mode: checkBox.checked ? "disabled" : "normal"
                        role: "SubTitle"
                        text: due_date ? due_date : ""
                        visible: due_date ? true : false
                        width: parent.width

                    }

                }

            }

            CheckBox {

                id: checkBox

                anchors.right: listItem.paddingItem.right
                anchors.verticalCenter: parent.verticalCenter

                // Workaround due to property "shadowing" of checked.
                // Fallback necessary because deleting and item from the list model
                // triggers a binding update, where tasksListModel.get(index) is undefined
                // See also ProjectsPage.qml (id: colorRect)
                checked: tasksListModel.get(index) ? tasksListModel.get(index).checked : true

                onClicked: {

                    var item_data = {
                        token: main.api_token,
                        ids: JSON.stringify([id])
                    };

                    // Somehow this doesn't work
                    //if(tasksPage.taskData) {
                    //    tasksPage.taskData.checked_task_index. = index;
                    //} else {
                    //    tasksPage.taskData = { 'checked_task_index': index };
                    //}
                    tasksPage.taskData = { 'checked_task_index': index };

                    if(checked) {
                        infoBanner.text = "Completing task";
                        infoBanner.open();
                        Todoist.completeItems(item_data, completeItemsSuccess, completeItemsError);
                    } else {
                        infoBanner.text = "Uncompleting task";
                        infoBanner.open();
                        Todoist.uncompleteItems(item_data, uncompleteItemsSuccess, uncompleteItemsError);
                    }

                }

            }

            onPressAndHold: {
                tasksPage.taskData = {
                        content: content,
                        due_date: (due_date ? new Date(due_date) : null),
                        task_id: id,
                        priority: priority,
                        project_id: project_id,
                        index: index,
                        indent: indent
                };
                pageStack.push(editTaskPage);
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
                    new_index = Math.min(new_index, tasksListModel.count - 1);
                    indicesBeforeReorder = {};
                    indicesBeforeReorder.old_index = index;
                    indicesBeforeReorder.new_index = new_index;
                    tasksListModel.move(index, new_index, 1);

                    var task_ids = new Array(tasksListModel.count);
                    for(var i = 0; i < tasksListModel.count; i++) {
                        task_ids[i] = tasksListModel.get(i).id;
                    }

                    // Use if moving after successfull return.
                    //var project_id = project_ids.splice(index, 1)[0];
                    //project_ids.splice(orderSlider.value - 1, 0, project_id);

                    var update_order_data = {
                        token: main.api_token,
                        project_id: project_id,
                        item_id_list: JSON.stringify(task_ids)
                    }

                    infoBanner.text = "Updating order of tasks."
                    infoBanner.open();

                    Todoist.updateOrders(update_order_data, updateOrdersSuccess, updateOrdersError);

                }

            }

        }

    }

    Component.onCompleted: {

        infoBanner.text = "Getting tasks"
        infoBanner.open();
        var items_data = {
            token: main.api_token,
            project_id: tasksPage.project_id
        };
        Todoist.getUncompletedItems(items_data, getUncompletedTasksSuccess, getUncompletedTasksError);

    }

}
