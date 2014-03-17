<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.CreateTestModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MultipleChoiceQuestion</title>
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
        function SaveQuestion() {
            ClearMsg();
            if ($('#editText_tc').length && $('#editText_tc').val().length) {
                var msg;
                msg = ""
                if ($("input[type=checkbox]:checked").length == 0) {
                    msg = msg + 'You must select an answer.<br/>';

                }
                fail = false;
                $("input[type=checkbox]:checked").each(function (index) {
                    if ($('#ans' + $(this).val()).val().length == 0) {
                        fail = letters[$(this).val() - 1];
                        return false;
                    }
                });
                if (fail != false) {
                    msg = msg + 'You have selected ' + fail + ') as a correct answer, however, you have not added an answer for it.<br/>';
                }
                /* Ans 1 and 2 must have values */
                if ($('#ans1').val().length == 0 || $('#ans2').val().length == 0) {
                    msg = msg + 'You must fill in the first two answer boxes.<br/>';
                }
                /* If a answer is blank yet one after has value give a missing answer error */
                prev_answer_blank = false;
                fail = false;
                $('[id^="ans"]').each(function (index) {
                    if ($(this).val().length > 0 && prev_answer_blank == true) {
                        fail = letters[index];
                        return false;
                    }
                    if ($(this).val().length == 0) {
                        prev_answer_blank = true;
                    }
                });
                if (fail != false) {
                    msg = msg + 'You have an answer missing before your answer ' + fail + '). Answers must be entered directly after each other.<br/>';
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
                    url: "/OnlineTest/SaveMultipleQuestion",
                    data: {
                        TestId: $("#hdnValTestId").val(),
                        Question: $("#editText_tc").val(),
                        QuestionType: $("#hdnQtypeId").val(),
                        Answer1: $("#ans1").val(),
                        CorrectAnswer1: $("input[type=checkbox][name=correct1]").is(':checked'),
                        Answer2: $("#ans2").val(),
                        CorrectAnswer2: $("input[type=checkbox][name=correct2]").is(':checked'),
                        Answer3: $("#ans3").val(),
                        CorrectAnswer3: $("input[type=checkbox][name=correct3]").is(':checked'),
                        Answer4: $("#ans4").val(),
                        CorrectAnswer4: $("input[type=checkbox][name=correct4]").is(':checked'),
                        Answer5: $("#ans5").val(),
                        CorrectAnswer5: $("input[type=checkbox][name=correct5]").is(':checked'),
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
                            $("#editText_tc").val("");
                            $('[id^="ans"]').each(function (index) {
                                num = this.id.substring(3);
                                $(this).val("");
                                /* Uncheck all checkboxes */
                                $("input[type=checkbox][name=correct" + num + "]").attr("checked", false);
                            });
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
            else {
                Failure("You have not entered a question.");
                return false;
            }
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
            Add Multiple Choice/Multiple Answer Question</h2>
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
                        <strong>Question</strong></p>
                    <div id="tb_editText_tc" class="edtoolbar">
                    </div>
                    <textarea id="editText_tc" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Answer(A)</strong></p>
                    <input type="checkbox" id="a1" name="correct1" value="1" />
                    This is correct answer
                    <div id="tb_ans1" class="edtoolbar">
                    </div>
                    <textarea id="ans1" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Answer(B)</strong></p>
                    <input type="checkbox" id="a2" name="correct2" value="2" />
                    This is correct answer
                    <div id="tb_ans2" class="edtoolbar">
                    </div>
                    <textarea id="ans2" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Answer(C)</strong></p>
                    <input type="checkbox" id="a3" name="correct3" value="3" />
                    This is correct answer
                    <div id="tb_ans3" class="edtoolbar">
                    </div>
                    <textarea id="ans3" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Answer(D)</strong></p>
                    <input type="checkbox" id="a4" name="correct4" value="4" />
                    This is correct answer
                    <div id="tb_ans4" class="edtoolbar">
                    </div>
                    <textarea id="ans4" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
                </div>
                <div class="boxinline">
                    <p class="titlename">
                        <strong>Answer(E)</strong></p>
                    <input type="checkbox" id="a5" name="correct5" value="5" />
                    This is correct answer
                    <div id="tb_ans5" class="edtoolbar">
                    </div>
                    <textarea id="ans5" style="width: 265px; margin-bottom: 10px;" rows="3" cols="5"></textarea><br />
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
        <input type="button" class="rg_button_red" title="Save" value="Save Question" onclick="SaveQuestion();" />
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".edtoolbar").each(function (e) {
                id = this.id.substring(3);
                tooBarHtml = "<div class=\"toolbar\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/bold.gif\" name=\"btnBold\" alt=\"Bold\" onclick=\"doAddTags('[b]','[/b]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/italic.gif\" name=\"btnItalic\" alt=\"Italic\" onclick=\"doAddTags('[i]','[/i]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/underline.gif\" name=\"btnUnderline\" alt=\"Underline\" onclick=\"doAddTags('[u]','[/u]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/strike.gif\" name=\"btnStrike\" alt=\"Line-through\" onclick=\"doAddTags('[s]','[/s]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/sub.gif\" name=\"btnSub\" alt=\"Subscript\" onclick=\"doAddTags('[sub]','[/sub]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/sup.gif\" name=\"btnSup\" alt=\"Superscript\" onclick=\"doAddTags('[sup]','[/sup]','" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/sqroot.gif\" name=\"btnSqr\" alt=\"Square root\" onclick=\"sqRoot('" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/link.gif\" name=\"btnLink\" alt=\"Insert URL Link\" onclick=\"doURL('" + id + "')\">"
                //"<img class=\"toolbar\" src=\"../../images/BBCode_Images/color.gif\" name=\"btnColor\" alt=\"Text color\" onclick=\"doColor('" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/color.gif\" name=\"btnColor\" alt=\"Text color\" id=\"selectColor_" + id + "\" onclick=\"ChooseColorPopUp('" + id + "');\">"
                //"<img class=\"button\" src=\"../../images/BBCode_Images/img.gif\" name=\"btnPicture\" alt=\"Insert Image\" onclick=\"doImage('" + id + "')\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/img.gif\" name=\"btnPicture\" alt=\"Insert Image\" id=\"selectDoc_" + id + "\" onclick=\"ChooseYTPopUp('" + id + "');\">"
		+ "<img class=\"toolbar\" src=\"../../images/BBCode_Images/youtube.gif\" name=\"btnYouTube\" alt=\"YouTube ID\" id=\"selectYt_" + id + "\" onclick=\"ChooseYTPopUp('" + id + "');\">"
		+ "</div>";
                $(this).html(tooBarHtml);
            });

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
                if ($('#editText_tc').length && $('#editText_tc').val().length) {
                    preview_html += bbCode(replaceLineBreak($('#editText_tc').val()));
                }
                //            /* P question */
                //            if ($('#questionp').length && $('#questionp').val().length) {
                //                preview_html += '<p class="gray">Correct this punctuation</p><p>' + $('#questionp').val() + '</p>';
                //            }
                /* MC Answers */
                preview_html += '</p><div class="dotted"></div>';
                preview_html += '<table class="answholder" cellpadding="0" cellspacing="0">';

                /* MC - Loop through existing ans fields on the page */
                $('[id^="ans"]').each(function (index) {
                    num = this.id.substring(3);
                    if ($(this).val().length) {

                        /* See if checkbox is checked */
                        if ($("input[type=checkbox][name=correct" + num + "]").is(':checked')) {
                            gif = '<img src="' + webpath_img + 'correct.gif" alt="Correct">';
                        } else {
                            gif = '';
                        }
                        preview_html += '<tr class="qs"><td>' + gif + '</td><td class="number">' + letters[num - 1] + ')</td><td class="answer">' + bbCode(replaceLineBreak($(this).val())) + '</td></tr>';
                    }
                });
                preview_html += '</table><div class="clearheight"></div></div>';
                $("#divPreviewQuestion").html('');
                $("#divPreviewQuestion").html(preview_html);
            });
        });
    </script>
</body>
</html>
