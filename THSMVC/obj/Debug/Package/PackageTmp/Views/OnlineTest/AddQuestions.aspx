<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.AddQuestionsModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AddQuestions</title>
     <script src="../../Scripts/OTEditor.js" type="text/javascript"></script>
    <script type="text/javascript">
        function BackToTestSearch() {
            var testId = $("#hdnTestId").val();
            LoadContentByActionAndControllerForEdit("ManageTest", "OnlineTest", "Manage Test", testId);
        }
        function QuestionTypeChange(obj) {
            var action = $(obj).val();
            if (action != "") {
                $("#divQuestionType").show();
                var testid = $("#hdnTestId").val();
                var QtypeId = $("#QuestionTypeId").val();
                GetContentByActionAndControllerForEdit(action, 'OnlineTest', 'Add Question',testid+','+QtypeId, '#divQuestion');
                window.scroll(0, 0);
            }
            else {
                $("#divQuestionType").hide();
            }
        }
        
    </script>
</head>
<body>
    <div id="OnlineTestAddQuestion">
        <div id="divbackToSearch" style="float: left;">
            <input type="button" class="rg_button_red upper" title="Back to test" value="Back To test"
                onclick="BackToTestSearch()" />
                <%= Html.HiddenFor(m => m.TestId, new { id="hdnTestId" })%>
        </div>
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestDetails');">
                <span class="divHeading">Adding Questions to test</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divTestDetails">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            Test Name
                        </div>
                        <div class="editor-field" style="text-align: left;">
                            <%= Html.Encode(Model.TestName) %>
                        </div>
                    </div>
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                            No. of questions in this test
                        </div>
                        <div class="editor-field" style="text-align: left;">
                            <%= Html.Encode(Model.NoofQuestions) %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divQuestionAdd');">
                <span class="divHeading">Add Questions</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divQuestionAdd">
                    <div class="clear">
                        <div class="editor-label FloatLeft" style="width: 40%;">
                           Select Question Type
                        </div>
                        <div class="editor-field" style="text-align: left;">
                            <%= Html.DropDownListFor(m => m.QuestionTypeId, Model.QuestionTypes, "Select Question Type", new { title = "Select Question Type", onchange="QuestionTypeChange(this);" })%>
                        </div>
                    </div>
                    <div class="clear" id="divQuestionType" style="display:none;">
                    <div id="divQuestion"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        webpath_img = '../images/';
        letters = Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
</script>
</body>
</html>
