function ajax(url, settings) {
    settings = settings || {}
    settings.type = settings.type || "GET"
    settings.contentType = settings.contentType || "application/x-www-form-urlencoded"
    settings.data = settings.data || ""

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        switch(xhr.readyState) {
            case XMLHttpRequest.UNSENT:
                break;
            case XMLHttpRequest.OPENED:
                break;
            case XMLHttpRequest.HEADERS_RECEIVED:
                break;
            case XMLHttpRequest.LOADING:
                break;
            case XMLHttpRequest.DONE:
                //console.log("status:", xhr.status);
                if(xhr.status == 200) {
                    if(settings.success) {
                        settings.success(xhr.responseText);
                    }
                } else {
                    if(settings.error) {
                        settings.error(xhr.responseText);
                    }
                }
                break;
        }
    }
    xhr.open(settings.type, url);
    xhr.setRequestHeader("Content-type", settings.contentType);
    xhr.send(settings.data);
}
