<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateTestModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Punctuation</title>
    <style type="text/css">
        .gray
        {
            color: #4D4D4D;
        }
        .question_edit_tab
        {
            padding: 6px 0 0 35px;
            background: white;
            float: left;
            width: 140px;
            border-top: 1px solid #C7C7C7;
            border-left: 1px solid #C7C7C7;
            border-right: 1px solid #C7C7C7;
        }
        .question_preview_tab
        {
            padding: 6px 0 0 35px;
            background: whiteSmoke;
            float: left;
            width: 140px;
            border-top: 1px solid #E2E2E2;
            border-left: 1px solid #E2E2E2;
            border-right: 1px solid #E2E2E2;
            border-bottom: 1px solid #C7C7C7;
        }
        .boxinline
        {
            border: 1px solid #D0D2D2;
            background: url(../images/grad_inline.gif) bottom left repeat-x;
            margin: 10px 0 10px 0;
            padding: 10px;
            width: 500px;
        }
        p
        {
            display: block;
            -webkit-margin-before: 1em;
            -webkit-margin-after: 1em;
            -webkit-margin-start: 0px;
            -webkit-margin-end: 0px;
        }
        .titlename
        {
            font-size: 1.1em;
            line-height: 1.3em;
        }
        .toolbar
        {
            margin: 0;
            padding: 2px 2px 2px 0;
        }
        .dotted
        {
            color: white;
            clear: both;
            float: none;
            height: 1px;
            margin: 5px 0 10px 0;
            padding: 0;
            border-bottom: 1px dotted #D2D2D2;
        }
        .answholder
        {
            font-size: 1.125em;
        }
        .qsholder td, .answholder td
        {
            vertical-align: top;
        }
    </style> 
    <script type="text/javascript">
        function SavepQuestion() {
            ClearMsg();
            var msg;
            msg = "";
            if ($('#questionp').val().length == 0) {
                msg = msg + 'You must fill in the incorrect version of your sentence.<br/>';
            }
            if ($('#pans').val().length == 0) {
                msg = msg + 'You must fill in the correct version of your sentence.<br/>';
            }
            if ($("#CategoryId").val() == "") {
                msg = msg + 'Please select Category for this question.<br/>';
            }
            if ($("#points").val() == "") {
                msg = msg + 'Please enter points for this question';
            }
            if (msg != "") {
                Failure(msg);
                return false;
            }
            $.ajax({
                type: "POST",
                traditional: true,
                url: "/OnlineTest/SavePQuestion",
                data: {
                    TestId: $("#hdnValTestId").val(),
                    Question: $("#questionp").val(),
                    QuestionType: $("#hdnQtypeId").val(),
                    Answer1: $("#pans").val(),
                    CategoryId: $("#CategoryId").val(),
                    Points: $("#points").val()
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        ClearMsg();
                        Success(result.message);
                        $("#questionp").val("");
                        $("#pans").val("");
                        $("#CategoryId").val("");
                        $("#points").val("1");
                    }
                    else {
                        Failure(result.message);
                    }
                    $.unblockUI();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    Error(XMLHttpRequest, textStatus, errorThrown);
                }
            });
        }
    </script>
</head>
<body>
    <div id="obj_ref" style="display: none;">
    </div>
    <div id="basic-modal-content">
    </div>
    <%= Html.HiddenFor(m => m.Test, new { id = "hdnValTestId" })%>
    <%= Html.HiddenFor(m => m.Qtype, new { id="hdnQtypeId"})%>
    <div class="clear">
        <h2>
            Add Punctuation Question</h2>
        <div class="question_edit_tab" id="question_edit_tab1">
            <p>
                <a href="#"><span>Edit Question</span></a></p>
        </div>
        <div class="question_preview_tab" id="question_preview_tab1">
            <p>
                <a href="#"><span>Preview Question</span></a></p>
        </div>
        <div id="divEditQuestion">
            <div class="clear">
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Incorrect version</strong></p>
                    <p class="titlename">
                        Add a sentence with incorrect punctuation or grammar.</p>
                    <p>
                        <input type="text" name="question" size="60" id="questionp" value="" /></p>
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Correct version (users will not see this during the test)</strong></p>
                    <p class="titlename">
                        ClassMarker will compare corrections made to the sentence above with the correct
                        version you add here.</p>
                    <p>
                        <input type="text" name="pans" size="60" id="pans" value="" /></p>
                </div>
            </div>
        </div>
        <div id="divPreviewQuestion">
        </div>
        <div class="boxinline">
            <p class="titlename">
                <strong>Category</strong></p>
            <p>
                Select the category for this question</p>
            <p class="gray">
                Add categories via the "Online Test / Categories" section.</p>
            <%= Html.DropDownListFor(m => m.CategoryId, Model.Categories, "Select Category", new { title = "Select the Category" })%>
        </div>
        <div class="boxinline">
            <p class="titlename">
                <strong>Points available</strong></p>
            <p class="gray">
                Decimals are allowed<br />
                Examples: 1 or 2.5</p>
            <p class="titlename">
                <input type="text" maxlength="5" value="1" id="points" name="points" /></p>
        </div>
        <input type="button" class="rg_button_red" title="Save" value="Save Question" onclick="SavepQuestion();" />
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#question_edit_tab1").click(function () {
                $("#divEditQuestion").show();
                $("#divPreviewQuestion").hide();
                $("#question_preview_tab1").attr("class", "question_preview_tab");
                $("#question_edit_tab1").attr("class", "question_edit_tab");
            });
            $("#question_preview_tab1").click(function () {
                $("#divEditQuestion").hide();
                $("#divPreviewQuestion").show();
                $("#question_edit_tab1").attr("class", "question_preview_tab");
                $("#question_preview_tab1").attr("class", "question_edit_tab");
                preview_html = '<div class="clear"><h3>Preview question</h3>';

                preview_html += '<p class="col600 qsholder">';
                /* question */
                if ($('#question').length && $('#question').val().length) {
                    preview_html += bbCode(replaceLineBreak($('#question').val()));
                }
                /* MC Answers */
                preview_html += '</p><div class="dotted"></div>';
                preview_html += '<table class="answholder" cellpadding="0" cellspacing="0">';

                if ($('#pans').length && $('#pans').val().length) {
                    preview_html += '<tr class="qs"><td></td><td class="answer" colspan="2"><p class="gray">Correct version for checking users answer against</p></td></tr>';
                    preview_html += '<tr class="qs"><td><img src="' + webpath_img + 'correct.gif" alt="Correct"></td><td class="answer" colspan="2">' + $('#pans').val() + '</td></tr>';
                }
                preview_html += '</table><div class="clearheight"></div></div>';
                $("#divPreviewQuestion").html('');
                $("#divPreviewQuestion").html(preview_html);
            });
        });
    </script>
</body>
</html>
