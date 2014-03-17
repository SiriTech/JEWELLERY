<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ManageTestModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ManageTest</title>
    <script src="../../Scripts/OTEditor.js" type="text/javascript"></script>
    <script type="text/javascript">

        function AddQuestion() {
            var testId = $("#hdnTestId").val();
            LoadContentByActionAndControllerForEdit("AddQuestions", "OnlineTest", "Adding Questions", testId);
        }
        function EditQuestion(obj) {
            var qid = $(obj).parent().children("input[type=hidden]").val();
            LoadContentByActionAndControllerForEdit("EditQuestion", "OnlineTest", "Updating Questions", qid);
        }
        function manageTest(id) {
            LoadContentByActionAndControllerForEdit("ManageTest", "OnlineTest", "Manage Test", id);
        }
        function ShowTests(obj) {
            var qid = $(obj).parent().children("input[type=hidden]").val();
            $("#divShowTests").modal({ minHeight: 300 });
            GetContentByActionAndControllerForEdit('ShowTests', 'OnlineTest', 'Manage Test',qid, '#divShowTests');
        }
        function REmoveQuestion(obj) {
            var qid = $(obj).parent().children("input[type=hidden]").val();
            var testId = $("#hdnTestId").val();
            $.ajax({
                type: "POST",
                traditional: true,
                url: "/OnlineTest/RemoveQuestionFromTest",
                data: {
                    TestId: testId,
                    CategoryId: qid
                },
                dataType: "json",
                beforeSend: function () {
                    $.blockUI();   //this is great plugin - 'blockUI'
                },
                success: function (result) {
                    if (result.success) {
                        ClearMsg();
                        setTimeout("manageTest(" + testId + ")", 1000);
                        Success(result.message);
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
            return false;
        }
    </script>
    <style type="text/css">
        .qbox
        {
            margin: 35px 0 12px 0;
            padding: 9px 20px 5px 20px;
            background: url(../images/testgrad.gif) top left repeat-x;
            border: 1px solid #D0D2D2;
        }
        .col600
        {
            float: none;
            margin-bottom: 20px;
        }
        .col600 a
        {
            color:#DE3E00;
            text-decoration:none;
        }
        .qsholder
        {
            width: 600px;
            font-size: 1.125em;
        }
        h4
        {
            padding: 0;
            margin: 0;
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
        p, ul, a, label
        {
            margin: 0 0 1.2em 0;
            list-style: none;
        }
        .answholder
        {
            font-size: 1.125em;
        }
        td.number
        {
            width: 30px;
            font-weight: bold;
            padding-bottom: 12px;
        }
        .qsholder td, .answholder td
        {
            vertical-align: top;
        }
        .gray, .active
        {
            color: #4D4D4D;
        }
    </style>
</head>
<body>
    <div id="obj_ref" style="display: none;">
    </div>
    <div id="basic-modal-content">
    </div>
    <div id="divShowTests">
    </div>
    <div class="clear">
        <div id="ManageTest">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestName');">
                    <span class="divHeading">Test Name</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divTestName">
                        <div class="clear" style="text-align: center; margin-top: 10px;">
                            <span id="spnTestName" style="font-size: 25px; font-family: Arial,Sans-Serif;">
                                <%=Html.Encode(Model.TestName) %></span>
                            <%--<input type="button" class="g-button g-button-submit" id="btnEditTest" value="Edit"
                                style="margin-right: 5px;" />--%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestComments');">
                    <span class="divHeading">Test Comments</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divTestComments">
                        <div class="clear" style="text-align: center; margin-top: 10px;">
                            <span id="spnTestComments" style="font-size: 15px; font-family: Arial,Sans-Serif;
                                display: block;">
                                <%=Html.Encode(Model.TestComments) %>
                            </span>
                            <br />
                            <input type="button" class="g-button g-button-submit" id="btnEditTestComments" value="Edit Comments"
                                style="margin-right: 5px;" />
                            <div id="tb_editText_tc" class="edtoolbar" style="display: none;">
                            </div>
                            <textarea id="editText_tc" style="width: 265px; display: none; margin-bottom: 10px;"
                                rows="5" cols="5"></textarea><br />
                            <input type="button" class="rg_button_red" id="TCUpdate" value="Update Comments"
                                style="margin-right: 5px; display: none;" />
                            <input type="button" class="rg_button" id="TCCancel" value="Cancel" style="display: none;" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestQuestions');">
                    <span class="divHeading">Questions</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divTestQuestions">
                        <div class="clear" style="text-align: left; margin-top: 10px;">
                            <input type="button" value="Add Questions" class="rg_button_red" onclick="AddQuestion();" />
                            <%= Html.HiddenFor(m => m.TestId, new { id="hdnTestId" })%>
                        </div>
                        <div class="dotted">
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                No. of Static questions in this test
                            </div>
                            <div class="editor-field" style="text-align: left;">
                                <%= Html.Encode(Model.NoofQuestions) %>
                            </div>
                        </div>
                        <div class="clear">
                            <% string QuestionName = string.Empty;
                               int qno = 0;
                               int optionvar = 0;
                               int cnt = 0;
                               foreach (var p in Model.question)
                               {
                                   cnt += 1;
                                   if (QuestionName != p.Question)
                                   {
                                       optionvar = 1;
                                       qno += 1;
                                       if (QuestionName != "")
                                       {%>
                            </table>
                            <div class="dotted">
                            </div>
                            <p class="gray">
                                Type:
                                <%=Html.Encode((Model.question).ToList()[cnt - 2].QuestionType)%><br />
                                Category:
                                <%=Html.Encode((Model.question).ToList()[cnt - 2].Category)%><br />
                                Points: <%=Html.Encode((Model.question).ToList()[cnt - 2].Points)%></p>
                        </div>
                        <% } QuestionName = p.Question; %>
                        <div class="qbox">
                            <h4>
                                Question
                                <%=Html.Encode(qno)%></h4>
                        </div>
                        <div class="col600">
                            <div class="qsholder"><%=Html.Encode(p.Question)%></div>
                            <div class="dotted">
                            </div>
                            <p id="ppp">
                            <%=Html.HiddenFor(m => m.question.ToList()[cnt-1].QuestionId, new{ id="hdnQid" }) %>
                                <a href="#" onclick="EditQuestion(this);">Edit question</a> | <a href="#" id="remove" onclick="REmoveQuestion(this);">Remove
                                    question from test</a> | <a id="sqit-3972002" href="#" onclick="ShowTests(this);">Show tests</a></p>
                            <%if (p.QuestionTypeId != 5)
                              {
                                 
                            %>
                            <table class="answholder" cellpadding="0" cellspacing="0">
                                <tr class="qs">
                                    <td>
                                        <%if ((bool)p.IsCorrect == true)
                                          { %>
                                        <img src="http://img.classmarker.com/a/correct.gif" alt="Correct" />
                                        <%} %>
                                    </td>
                                    <td class="number">
                                        A)
                                    </td>
                                    <td class="answer">
                                        <%=Html.Encode(p.Answer)%>
                                    </td>
                                </tr>
                                <%
                              }
                                   }
                                   else
                                   {
                                       if (p.QuestionTypeId != 5)
                                       {
                                           optionvar += 1;
                                           string Option = string.Empty;
                                           switch (optionvar)
                                           {
                                               case 1:
                                                   Option = "A)";
                                                   break;
                                               case 2:
                                                   Option = "B)";
                                                   break;
                                               case 3:
                                                   Option = "C)";
                                                   break;
                                               case 4:
                                                   Option = "D)";
                                                   break;
                                               case 5:
                                                   Option = "E)";
                                                   break;
                                           }%>
                                <tr class="qs">
                                    <td>
                                        <%if ((bool)p.IsCorrect == true)
                                          { %>
                                        <img src="http://img.classmarker.com/a/correct.gif" alt="Correct" />
                                        <%} %>
                                    </td>
                                    <td class="number">
                                        <%=Html.Encode(Option)%>
                                    </td>
                                    <td class="answer">
                                        <%=Html.Encode(p.Answer)%>
                                    </td>
                                </tr>
                                <%}
                                   }
                               } %>
                                </table>
                            <div class="dotted">
                            </div>
                            <p class="gray">
                                Type:
                                <%=Html.Encode((Model.question).ToList()[Model.question.Count() -1].QuestionType)%><br />
                                Category:
                                <%=Html.Encode((Model.question).ToList()[Model.question.Count() - 1].Category)%><br />
                                Points: <%=Html.Encode((Model.question).ToList()[Model.question.Count() - 1].Points)%></p>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".qsholder").each(function (e) {
               $(this).html(bbCode(replaceLineBreak($(this).html())));
            });
            $(".answer").each(function (e) {
                bbCode(replaceLineBreak($(this).val()));
            });
            $("#spnTestComments").html(bbCode($("#spnTestComments").text()));
            $("#btnEditTestComments").click(function () {
                this.style.display = "none";
                $("#spnTestComments").css("display", "none");
                $("#tb_editText_tc").css("display", "block");
                $("#editText_tc").css("display", "inline-block");
                $("#TCUpdate").css("display", "inline-block");
                $("#TCCancel").css("display", "inline-block");
                $.ajax({
                    type: "POST",
                    url: "/OnlineTest/GetTestComments?Id=" + $("#hdnTestId").val(),
                    data: {},
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        $("#editText_tc").val(result.comments);
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        Error(XMLHttpRequest, textStatus, errorThrown);
                    }
                });
            });
            $("#TCCancel").click(function () {
                this.style.display = "none";
                $("#spnTestComments").css("display", "inline-block");
                $("#tb_editText_tc").css("display", "none");
                $("#editText_tc").css("display", "none");
                $("#editText_tc").val("");
                $("#TCUpdate").css("display", "none");
                $("#btnEditTestComments").css("display", "inline-block");
            });
            $("#TCUpdate").click(function () {
                var txt = $("#editText_tc").val();
                if (txt != '') {
                    var conv = bbCode(txt);
                    $("#spnTestComments").html(conv);
                }
                this.style.display = "none";

                $.ajax({
                    type: "POST",
                    url: "/OnlineTest/UpdateTestComments?Comments=" + txt + "&Id=" + $("#hdnTestId").val(),
                    data: {},
                    dataType: "json",
                    beforeSend: function () {
                        $.blockUI();   //this is great plugin - 'blockUI'
                    },
                    success: function (result) {
                        $("#spnTestComments").css("display", "inline-block");
                        $("#tb_editText_tc").css("display", "none");
                        $("#editText_tc").css("display", "none");
                        $("#editText_tc").val("");
                        $("#TCCancel").css("display", "none");
                        $("#btnEditTestComments").css("display", "inline-block");
                        $.unblockUI();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.unblockUI();
                        Error(XMLHttpRequest, textStatus, errorThrown);
                    }
                });
            });
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
        });
    </script>
</body>
</html>
