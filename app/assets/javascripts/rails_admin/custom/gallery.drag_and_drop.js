
function dodrop(event)
{
    console.log("dodrop: event: ", event)
    var dt = event.dataTransfer || event.originalEvent.dataTransfer;
    var files = dt.files;
    console.log("file: ", files[0])

    var count = files.length;
    output("File Count: " + count + "\n");

    for (var i = 0; i < files.length; i++) {
        //output(" File " + i + ":\n(" + (typeof files[i]) + ") : <" + files[i] + " > " +
        //    files[i].name + " " + files[i].size + "\n");
        upload_file(files[0], $(".gallery-images"))
    }
}

function output(text)
{
    //document.getElementById("output").textContent += text;
    //dump(text);
    console.log(text)
}

$document.on("dragenter", function(e){
    $('.multiupload-container').addClass("show-hover")

    e.stopPropagation();
    e.preventDefault();
})

$document.on("dragover", function (e) {
    e.stopPropagation();
    e.preventDefault();
    //$('.multiupload-container').removeClass("show-hover")
})

$document.on("dragexit dragend", function (e) {
    e.stopPropagation();
    e.preventDefault();

    $('.multiupload-container').removeClass("show-hover")
})

$document.on("drop", function (e) {
    e.stopPropagation();
    e.preventDefault();
    dodrop(e)
    $('.multiupload-container').removeClass("show-hover")
})

$(window).on("blur", function () {
    $('.multiupload-container').removeClass("show-hover")
})


function upload_file (file, fileList) {
    var li = $("<div class='gallery-image'>"),
        div = document.createElement("div"),
        img,
        progressBarContainer = document.createElement("div"),
        progressBar = document.createElement("div"),
        reader,
        xhr,
        fileInfo = '';

    li.append("<div class='delete-gallery-image'>delete</div>")

    li.append(div);

    progressBarContainer.className = "progress-bar-container";
    progressBar.className = "progress-bar";
    progressBarContainer.appendChild(progressBar);
    li.append(progressBarContainer);

    /*
     If the file is an image and the web browser supports FileReader,
     present a preview in the file list
     */

    if (typeof FileReader !== "undefined" && (/image/i).test(file.type)) {
        img = document.createElement("img");
        var img_wrap = $("<div class='fancybox'>")
        img_wrap.append(img)
        li.append(img_wrap);
        reader = new FileReader();
        reader.onload = (function (theImg) {
            return function (evt) {
                theImg.src = evt.target.result;
            };
        }(img));
        reader.readAsDataURL(file);
    }

    // Uploading - for Firefox, Google Chrome and Safari
    var $form = fileList.closest("form")
    var upload_url = $form.attr("action")
    xhr = new XMLHttpRequest();

    // Update progress bar
    xhr.upload.addEventListener("progress", function (evt) {
        if (evt.lengthComputable) {
            progressBar.style.width = (evt.loaded / evt.total) * 100 + "%";
        }
        else {
            // No data to calculate on
        }
    }, false);

    // File uploaded
    xhr.addEventListener("load", function () {
        progressBarContainer.className += " uploaded";
        progressBar.innerHTML = "Uploaded!";
    }, false);


    xhr.open("post", upload_url, true);

    // Set appropriate headers
    xhr.setRequestHeader("Content-Type", "multipart/form-data");
    xhr.setRequestHeader("X-File-Name", file.name);
    xhr.setRequestHeader("X-File-Size", file.size);
    xhr.setRequestHeader("X-File-Type", file.type);

    // Send the file (doh)
    //xhr.send(file);

    var data = new FormData()
    //jQuery.each(jQuery('#file')[0].files, function(i, file) {
    //    data.append('file-'+i, file);
    //});
    data.append("gallery_album[images_attributes][][file]", file)

    $.ajax({
        type: "post",
        url: upload_url,
        data: data,
        cache: false,
        contentType: false,
        processData: false
    })

    // Present file info and append it to the list of files
    //fileInfo = "<div><strong>Name:</strong> " + file.name + "</div>";
    //fileInfo += "<div><strong>Size:</strong> " + parseInt(file.size / 1024, 10) + " kb</div>";
    //fileInfo += "<div><strong>Type:</strong> " + file.type + "</div>";
    div.innerHTML = fileInfo;

    fileList.append(li);
}
