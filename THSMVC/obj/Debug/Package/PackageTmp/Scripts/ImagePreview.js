this.imagePreview = function () {
    /* CONFIG */
    xOffset = 200;
    yOffset = 10;
    // these 2 variable determine popup's distance from the cursor
    // you might want to adjust to get the right result
    /* END CONFIG */
    $("img.preview").hover(function (e) {

        this.t = this.title;
        this.title = "";
        var c = (this.t != "") ? "<br/>" + this.t : "";
        $("body").append("<p id='preview'><img src='" + this.src + "' alt='Image preview' height='200px' width='160px'  />" + c + "</p>");
        $("#preview")
			.css("top", (e.pageY - yOffset) + "px")
			.css("left", (e.pageX - xOffset) + "px")
			.fadeIn("fast");
    },
	function () {
	    this.title = this.t;
	    $("#preview").remove();
	});
    $("img.preview").mousemove(function (e) {
        $("#preview")
			.css("top", (e.pageY - yOffset) + "px")
			.css("left", (e.pageX - xOffset) + "px");
    });
};
