/* Documentation for the todoist api is at: https://todoist.com/API
 *
 * This file implements all the necessary API calls.
 */

Qt.include("ajax.js");

var api_url = "https://todoist.com/API";
var api_token = "";

var colors = [
        "#bde876",
        "#ff8581",
        "#ffc472",
        "#faed75",
        "#a8c9e5",
        "#999999",
        "#e3a8e5",
        "#dddddd",
        "#fc603c",
        "#ffcc00",
        "#74e8d4",
        "#3cd6fc"
    ];

function login(data, success, error) {

    var url = api_url + "/login";
    var data_string = "email=" + data.email +
        "&password=" + data.password;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function getTimezones(success, error) {

    var url = api_url + "/getTimezones";

    ajax(url, {
         type: "GET",
         success: success,
         error: error
    });

}

function register(data, success, error) {

    var url = api_url + "/register";

    ajax(url, {
         type: "POST",
         data: "email=" + encodeURIComponent(data.email) +
         "&full_name=" + encodeURIComponent(data.full_name) +
         "&password=" + encodeURIComponent(data.password) +
         "&timezone=" + encodeURIComponent(data.timezone),
         success: success,
         error: error
    });

}

function updateUser() {}

function getProjects(data, success, error) {

    var url = api_url + "/getProjects";
    var data_string = "token=" + data.token;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function getProject() {}

function addProject(data, success, error) {

    var url = api_url + "/addProject";
    var data_string = "token=" + data.token +
        "&name=" + data.name;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateProject(data, success, error) {

    var url = api_url + "/updateProject";
    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&name=" + data.name +
        "&color=" + data.color +
        "&indent=" + data.indent;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error,
    });

}

function updateProjectOrders(data, success, error) {

    var url = api_url + "/updateProjectOrders";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&item_id_list=" + data.id_list,
         success: success,
         error: error
    });
}

function deleteProject(data, success, error) {

    var url = api_url + "/deleteProject";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });

}

function getLabels() {}
function updateLabel() {}
function deleteLabel() {}

function getUncompletedItems(data, success, error) {

    var url = api_url + "/getUncompletedItems";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });
}

function getCompletedItems(data, success, error) {

    var url = api_url + "/getCompletedItems";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });
}

function getItemsById() {}

function addItem(data, success, error) {

    var url = api_url + "/addItem";
    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&content=" + encodeURIComponent(data.content);

    if(data.date_string) {
        data_string += "&date_string=" + encodeURIComponent(data.date_string);
    }

    if(data.priority) {
        data_string += "&priority=" + data.priority;
    }

    if(data.js_date) {
        data_string += "&js_date=" + data.js_date;
    }

    // TODO: Ask for support for this in the backend
    //if(data.indent) {
    //    data_string += "&indent=" + data.indent
    //}

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateItem(data, success, error) {

    var url = api_url + "/updateItem";

    var data_string = "token=" + data.token + "&id=" + data.id;

    if(data.content) {
        data_string += "&content=" + data.content;
    }

    if(data.date_string) {
        data_string += "&date_string=" + data.date_string;
    }

    if(data.priority) {
        data_string += "&priority=" + data.priority;
    }

    if(data.indent) {
        data_string += "&indent=" + data.indent;
    }

    if(data.item_order) {
        data_string += "&item_order=" + data.item_order;
    }

    if(data.collapsed) {
        data_string += "&collapsed=" + data.collapsed;
    }

    if(data.js_date) {
    }

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateOrders(data, success, error) {

    var url = api_url + "/updateOrders";
    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&item_id_list=" + data.item_id_list;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function moveItems() {}
function updateRecurringDate() {}

function deleteItems(data, success, error) {

    var url = api_url + "/deleteItems";

    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function completeItems(data, success, error) {

    var url = api_url + "/completeItems";
    var data_string = "token=" + data.token +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function uncompleteItems(data, success, error) {

    var url = api_url + "/uncompleteItems";
    var data_string = "token=" + data.token +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function addNote() {}
function deleteNote() {}
function getNotes() {}
function query() {}
