/*****************************************
* Name: Javascript Textarea BBCode Markup Editor
* Version: 1.3
* Author: Balakrishnan
* Last Modified Date: 25/jan/2009
* License: Free
* URL: http://www.corpocrat.com
******************************************/

function bbCode(str) {
	if( str.indexOf("[") == -1) {
		return str;
	}

	for(i = 0; i < search.length; i++) {
		str = str.replace(search[i],replace[i]);
	}
	return str;
}

/**
 * User to create paths for images from BBCode
*/
asset_ref_dir = new Array(
		/(0\/)/
		);
asset_actual_dir = new Array(
		'http://0cm.classmarker.com/'
		);

/**
 * Used in docSelector when adding image to questions or certs, themes etc
 **/

function getDocPathForDropDown(str){

	for(i = 0; i < asset_ref_dir.length; i++) {
		str = str.replace(asset_ref_dir[i],asset_actual_dir[i]);
	}

	return str;
}


search = new Array(
		/\[img\](http.[^ \\"\n\r\t<]*?)\[\/img\]/ig,
		/\[cmimg\]0\/([^ \\"\n\r\t<]*?)\[\/cmimg\]/ig,		
		/\[img alt=([#a-zA-Z0-9]*?)\](http.[^ \\"\n\r\t<]*?)\[\/img\]/ig,
		/\[cmimg alt=([#a-zA-Z0-9]*?)\]0\/([^ \\"\n\r\t<]*?)\[\/cmimg\]/ig,
		/\[cmdoc=0\/([^ \\"\n\r\t<]*?)\](.*?)\[\/cmdoc\]/ig,		

		/\[url\](http.[^ \\"\n\r\t<]*?)\[\/url\]/ig,
		/\[url\](mailto:.[^ \\"\n\r\t<]*?)\[\/url\]/ig,
		/\[url=(http.[^ \\"\n\r\t<]*?)\](.*?)\[\/url\]/ig,
		/\[url=(mailto:.[^ \\"\n\r\t<]*?)\](.*?)\[\/url\]/ig,
		
		/\[b\](.[\s\S]*?)\[\/b\]/ig,
		/\[i\](.[\s\S]*?)\[\/i\]/ig,
		/\[u\](.[\s\S]*?)\[\/u\]/ig,
		/\[s\](.[\s\S]*?)\[\/s\]/ig,
		/\[sup\](.*?)\[\/sup\]/ig,
		/\[sub\](.*?)\[\/sub\]/ig,
		/\[color=([#a-zA-Z0-9]*?)\](.[\s\S]*?)\[\/color\]/ig,
		/\[yt\](.{11,11})\[\/yt\]/ig,
		/\[sqr\](.[\s\S]*?)\[\/sqr\]/ig		
		);///\n/g

replace = new Array(
		"<img src=\"$1\" class=\"imgw\" alt=\"\" border=\"0\">",
		"<img src=\"http:\/\/0cm.classmarker.com\/$1\" class=\"imgw\" alt=\"\" border=\"0\">",
		"<img src=\"$2\" class=\"imgw\" alt=\"$1\" border=\"0\">",
		"<img src=\"http:\/\/0cm.classmarker.com\/$2\" class=\"imgw\" alt=\"$1\" border=\"0\">",
		"<a href=\"http:\/\/0cm.classmarker.com\/$1\" class=\"popup\">$2</a>",		
		
		"<a href=\"$1\" class=\"popup\">$1</a>",		
		"<a href=\"$1\">$1</a>",
		"<a href=\"$1\" class=\"popup\">$2</a>",
		"<a href=\"$1\">$2</a>",
		
		"<strong>$1</strong>",
		"<i>$1</i>",
		"<u>$1</u>",
		"<del>$1</del>",
		"<sup>$1</sup>",
		"<sub>$1</sub>",
		"<span style='color:$1;'>$2</span>",
		"<br /><object width='415' height='336'><param name='movie' value='http://www.youtube.com/v/$1&amp;rel=0&amp;showsearch=0&amp;showinfo=0'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='http://www.youtube.com/v/$1&amp;rel=0&amp;showsearch=0&amp;showinfo=0' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='415' height='336'></embed></object>",
		"&radic;<span class='sqr'> $1</span>"		
		);//"<br />"


var textarea;
var content;




function sqRoot(obj)
{
	textarea = document.getElementById(obj);

	if (document.selection){
		textarea.focus();
		var selected_text_object = document.selection.createRange();
		var selected_text = selected_text_object.text;

	} else {

		var len = textarea.value.length;
		var start = textarea.selectionStart;
		var end = textarea.selectionEnd;

		var selected_text = textarea.value.substring(start, end);

	}
	var squareroot = prompt('Enter content to place under the Square root line:\n',selected_text);
	var scrollTop = textarea.scrollTop;
	var scrollLeft = textarea.scrollLeft;

	if (squareroot != '' && squareroot != null) {

		if (document.selection)
				{
					textarea.focus();
					var sel = document.selection.createRange();

				if(squareroot==""){
					sel.text = '[sqr]' + sel.text + '[/sqr]';
				} else {
					sel.text = '[sqr]' + squareroot + '[/sqr]';
				}

				}
	   else
		{
			var len = textarea.value.length;
			var start = textarea.selectionStart;
			var end = textarea.selectionEnd;

			var sel = textarea.value.substring(start, end);

			if(squareroot==""){
				var rep = '[sqr]' + sel + '[/sqr]';
			} else{
				var rep = '[sqr]' + squareroot + '[/sqr]';
			}

			textarea.value =  textarea.value.substring(0,start) + rep + textarea.value.substring(end,len);


			textarea.scrollTop = scrollTop;
			textarea.scrollLeft = scrollLeft;
		}
	}

}
function replaceLineBreak(str) {

    if (str.length) {
        str = str.replace(/\</g, '&lt;');
        str = str.replace(/\>/g, '&gt;');
        return str.replace(/\r?\n/g, '<br />');
    } else {
        return str;
    }

}

function doURL(obj)
{
textarea = document.getElementById(obj);
var url = prompt('Enter the URL:\nYou can highlight some text then select the link button to hyperlink text','http://');
var scrollTop = textarea.scrollTop;
var scrollLeft = textarea.scrollLeft;

if (url != '' && url != null) {

	if (document.selection)
			{
				textarea.focus();
				var sel = document.selection.createRange();

			if(sel.text==""){
					sel.text = '[url]'  + url + '[/url]';
					} else {
					sel.text = '[url=' + url + ']' + sel.text + '[/url]';
					}

			}
   else
    {
		var len = textarea.value.length;
	    var start = textarea.selectionStart;
		var end = textarea.selectionEnd;

        var sel = textarea.value.substring(start, end);

		if(sel==""){
				var rep = '[url]' + url + '[/url]';
				} else
				{
				var rep = '[url=' + url + ']' + sel + '[/url]';
				}

        textarea.value =  textarea.value.substring(0,start) + rep + textarea.value.substring(end,len);


		textarea.scrollTop = scrollTop;
		textarea.scrollLeft = scrollLeft;
	}
 }
}

function doAddTags(tag1,tag2,obj)
{
textarea = document.getElementById(obj);
	// Code for IE
		if (document.selection)
			{
				textarea.focus();
				var sel = document.selection.createRange();
				//alert(sel.text);
				sel.text = tag1 + sel.text + tag2;
			}
   else
    {  // Code for Mozilla Firefox
		var len = textarea.value.length;
	    var start = textarea.selectionStart;
		var end = textarea.selectionEnd;


		var scrollTop = textarea.scrollTop;
		var scrollLeft = textarea.scrollLeft;


        var sel = textarea.value.substring(start, end);

		var rep = tag1 + sel + tag2;
        textarea.value =  textarea.value.substring(0,start) + rep + textarea.value.substring(end,len);

		textarea.scrollTop = scrollTop;
		textarea.scrollLeft = scrollLeft;


	}
}

function doList(tag1,tag2,obj){
textarea = document.getElementById(obj);
// Code for IE
		if (document.selection)
			{
				textarea.focus();
				var sel = document.selection.createRange();
				var list = sel.text.split('\n');

				for(i=0;i<list.length;i++)
				{
				list[i] = '[*]' + list[i];
				}
				//alert(list.join("\n"));
				sel.text = tag1 + '\n' + list.join("\n") + '\n' + tag2;
			} else
			// Code for Firefox
			{

		var len = textarea.value.length;
	    var start = textarea.selectionStart;
		var end = textarea.selectionEnd;
		var i;

		var scrollTop = textarea.scrollTop;
		var scrollLeft = textarea.scrollLeft;


        var sel = textarea.value.substring(start, end);

		var list = sel.split('\n');

		for(i=0;i<list.length;i++)
		{
		list[i] = '[*]' + list[i];
		}


		var rep = tag1 + '\n' + list.join("\n") + '\n' +tag2;
		textarea.value =  textarea.value.substring(0,start) + rep + textarea.value.substring(end,len);

		textarea.scrollTop = scrollTop;
		textarea.scrollLeft = scrollLeft;
 }
}

/*****************************************
* END Javascript Textarea BBCode Markup Editor
******************************************/