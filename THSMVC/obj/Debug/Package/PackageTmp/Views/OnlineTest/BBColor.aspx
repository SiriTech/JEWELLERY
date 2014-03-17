<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>BBColor</title>
   
</head>
<body>
    <div class="popupHead">
        <span>Select a color</span>
    </div>
    <div class="clear">
        <p>
            <span class="choosecolor" style="margin: 2px; float: left; background-color: red;
                width: 20px;" id="red">&nbsp;</span> <span class="choosecolor" style="margin: 2px;
                    float: left; background-color: blue; width: 20px;" id="blue">&nbsp;</span>
            <span class="choosecolor" style="margin: 2px; float: left; background-color: green;
                width: 20px;" id="green">&nbsp;</span> <span class="choosecolor" style="margin: 2px;
                    float: left; background-color: navy; width: 20px;" id="navy">&nbsp;</span>
            <span class="choosecolor" style="margin: 2px; float: left; background-color: purple;
                width: 20px;" id="purple">&nbsp;</span> <span class="choosecolor" style="margin: 2px;
                    float: left; background-color: maroon; width: 20px;" id="maroon">&nbsp;</span>
            <span class="choosecolor" style="margin: 2px; float: left; background-color: teal;
                width: 20px;" id="teal">&nbsp;</span> <span class="choosecolor" style="margin: 2px;
                    float: left; background-color: deeppink; width: 20px;" id="deeppink">&nbsp;</span>
            <span class="choosecolor" style="margin: 2px; float: left; background-color: orangered;
                width: 20px;" id="orangered">&nbsp;</span> <span class="choosecolor" style="margin: 2px;
                    float: left; background-color: gray; width: 20px;" id="gray">&nbsp;</span>
        </p>
        <br />
        <div class="popupHead clear">
            <span>Or type your own color</span>
        </div>
        <p>
            Example: #0033FF</p>
        <p>
            <strong>Color</strong><br />
            <input type="text" id="font_color" size="30" name="not_used2" /></p>
        <p>
            <input type="button" value="Use color" id="custom" class="rg_button_red choosecolor" /></p>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {

            $('.choosecolor').click(function () {

                var color;
                if (this.id == 'custom') {
                    color = $('#font_color').val();
                } else {
                    color = $(this).attr('id');
                }

                if (document.selection) {

                    if (sel.text == "") {
                        sel.text = '[color=' + color + '][/color]';
                    } else {
                        sel.text = '[color=' + color + ']' + sel.text + '[/color]';
                    }

                } else {

                    if (sel == "") {
                        var rep = '[color=' + color + '][/color]';
                    } else {
                        var rep = '[color=' + color + ']' + sel + '[/color]';
                    }
                    textarea.value = textarea.value.substring(0, start) + rep + textarea.value.substring(end, len);

                }
                $.modal.close();
            });

            var textarea = document.getElementById($('#obj_ref').text());
            if (document.selection) {
                textarea.focus();
                var sel = document.selection.createRange();
            } else {
                var len = textarea.value.length;
                var start = textarea.selectionStart;
                var end = textarea.selectionEnd;
                var sel = textarea.value.substring(start, end);

            }


        });

    </script>
</body>
</html>
