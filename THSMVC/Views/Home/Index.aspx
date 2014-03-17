<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home Page
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="dicScroller" style="border: solid 4px #72A9D3;">
        <center>
            <div id="desSlideshow1" class="desSlideshow">
                <div class="switchBigPic">
                    <div>
                        <a title="" href="#">
                            <img alt="Edu Book" class="pic" src="../../images/002.jpg" /></a>
                        <p>
                            <strong>EDU BOOK</strong><br />
                            A Complete School/College Management Suite
                        </p>
                    </div>
                    <div>
                        <a title="" href="#">
                            <img alt="User Profiles" class="pic" src="../../images/001.jpg" /></a>
                        <p>
                            <strong>USER PROFILES</strong><br />
                            Manage User Profile data in easy way as never before
                        </p>
                    </div>
                    <div>
                        <a title="" href="#">
                            <img alt="Attendance" class="pic" src="../../images/002.jpg" /></a>
                        <p>
                            <strong>ATTENDANCE</strong><br />
                            Automated Time keeping and attendance tracking system
                        </p>
                    </div>
                    <div>
                        <a title="" href="#">
                            <img alt="Payroll" class="pic" src="../../images/001.jpg" /></a>
                        <p>
                            <strong>PAYROLL</strong><br />
                            Streamlines all aspects of payroll and reduces the work load on administrators
                        </p>
                    </div>
                    <div>
                        <a title="" href="#">
                            <img alt="Edu Book" class="pic" src="../../images/002.jpg" /></a>
                        <p>
                            <strong>MORE...</strong><br />
                            Online Test, Leave Management System, Timetables, Security etc,.
                        </p>
                    </div>
                </div>
                <ul class="nav">
                    <li><a href="#">Edu Book</a></li>
                    <li><a href="#">Profiles</a></li>
                    <li><a href="#">Attendance</a></li>
                    <li><a href="#">Payroll</a></li>
                    <li><a href="#">More...</a></li>
                </ul>
            </div>
        </center>
    </div>
    <div style="padding-top: 15px;">
        <div class="clear">
            <div style="width: 70%; float: left;">
                <div class="divHead">
                    <span class="divHeading">EDU BOOK</span>
                </div>
                <div class="clear">
                    <div class="divBorder">
                        <p>
                            <font style="font-size: large">Edu Book</font> is an Online Management tool for
                            Schools/Colleges in the world. User data management, Attendance Management, Leave
                            management, Pay roll system, Automatic Timetable generation etc., in a secured way.
                            Edu Book provides value to your school/college.</p>
                        <p>
                            Edu Book collaborates Students, Parents and Teachers, So that the parents can enhance
                            their children's performance . Edu Book is a cloud based application, Which can
                            be accessed from anywhere in the world.</p>
                        <p>
                            Edu Book is providing <a style="color: Green;" href="/Home/ContactUS"><b>1 Month Free
                                Trail</b></a> for any school/college. Your Data during the trial period can
                            be maintained upto 30 days from your trial period expiration date.</p>
                        <p>
                            Edu Book is very cheap as never before, than any of the other school/college management
                            softwares.</p>
                    </div>
                </div>
            </div>
            <div style="width: 28%; float: right;">
                <div class="divHead">
                    <span class="divHeading">Testimonials</span>
                </div>
                <div class="clear">
                    <div class="divBorder" style="height: 100px;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        document.getElementById('Home').className = 'menuChange';
    </script>
    <script type="text/javascript">
        $(function () {
            // document.getElementById("main").style.paddingTop = "0px";
            // document.getElementById("main").style.paddingLeft = "0px";
            // document.getElementById("main").style.paddingRight = "0px";
            var wid = 0;
            if (document.getElementById("dicScroller").offsetWidth < 1100) {
                wid = document.getElementById("dicScroller").offsetWidth - 20;
            }
            else {
                wid = document.getElementById("dicScroller").offsetWidth - 6;
            }
            var thumbWidth;
            if (wid - 1000 > 250) {
                thumbWidth = 250;
            }
            else {
                thumbWidth = wid - 1000;
            }
            $("#desSlideshow1").desSlideshow({
                autoplay: 'enable', //option:enable,disable
                slideshow_width: wid + "px", //slideshow window width
                slideshow_height: '249', //slideshow window height
                thumbnail_width: thumbWidth, //thumbnail width
                time_Interval: '8000', //Milliseconds
                directory: 'images/'// flash-on.gif and flashtext-bg.jpg directory
            });

        });
    </script>
</asp:Content>
