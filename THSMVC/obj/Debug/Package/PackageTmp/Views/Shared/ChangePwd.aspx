<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<THSMVC.Models.ChangePwdModel>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ChangePwd</title>
   
</head>
<body>
   <div id="ChangePwd">
    <div id="validationDiv" style="margin-top: 10px; font-weight: bold; color: Red;">
            </div>
            <div id="statusDiv" style="margin-top: 10px;">
                <center>
                    <span id="_status" style="font-size: 1px; font-weight: bold;"></span>
                </center>
            </div>
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divChangePwd');">
                    <span class="divHeading">Change Password</span> <span class="divRightHeading"><span
                        class="ValidationSpan">*</span> Indicates mandatory fields</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divChangePwd">
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Old Password
                            </div>
                            <div class="editor-field">
                                <input type="password" id="OldPassword" />
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> New Password
                            </div>
                            <div class="editor-field">
                                <input type="password" id="NewPassword" />
                            </div>
                        </div>
                        <div class="clear">
                            <div class="editor-label FloatLeft" style="width: 40%;">
                                <span class="ValidationSpan">*</span> Confirm Password
                            </div>
                            <div class="editor-field">
                               <input type="password" id="ConfirmPassword" />
                            </div>
                        </div>
                       
                        <div id="divButtons" class="clear" style="margin-top: 10px;">
                            <center>
                                <input type="button" value="Change" class="rg_button_red" onclick="submitChangePwd();return false;" />
                                <input type="button" value="Clear" class="rg_button" onclick="ChangePwdClear();return false;" />
                            </center>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
        
</body>
</html>
