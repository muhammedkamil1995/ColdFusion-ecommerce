<cfinclude template="includes/session.cfm"> 
<cfinclude template="includes/header.cfm">

<style>
/* Base Styles */
li,
ul {
    list-style: none;
    padding: 0;
    margin: 0;

}

/* Section Styles */
.sec-title {
    position: relative;
    padding-bottom: 20px;
}

.sec-title .title {
    position: relative;
    color: #00b8ca;
    font-size: 18px;
    font-weight: 700;
    padding-right: 50px;
    margin-bottom: 15px;
    display: inline-block;
    text-transform: capitalize;
}

.sec-title .title:before {
    position: absolute;
    content: '';
    right: 0;
    bottom: 7px;
    width: 40px;
    height: 1px;
    background-color: #bbb;
}

.sec-title h2 {
    position: relative;
    color: #252525;
    font-size: 36px;
    font-weight: 700;
    line-height: 1.5em;
    display: block;
}

.sec-title.light h2 {
    color: #fff;
}

/* Contact Page Styles */
.contact-page-section {
    position: relative;
    /* padding-top: 110px; */
    padding-bottom: 110px;
}

.contact-page-section .inner-container {
    position: relative;
    z-index: 1;
    background-color: #708090;
    box-shadow: 0 0 15px 5px rgba(0, 0, 0, 0.1);
}

.contact-page-section .form-column {
    position: relative;
    padding: 0 0 0 15px;
}

.contact-page-section .form-column .inner-column {
    position: relative;
    padding: 60px 45px 30px;
    background-color: #fff;
}

.contact-page-section .info-column {
    position: relative;
}

.contact-page-section .info-column .inner-column {
    position: relative;
    padding: 60px 35px;
}

.contact-page-section .info-column h2 {
    position: relative;
    color: #fff;
    font-size: 30px;
    font-weight: 700;
    line-height: 1.4em;
    margin-bottom: 45px;
}

.contact-page-section .info-column .list-info {
    position: relative;
    margin-bottom: 60px;
}

.contact-page-section .info-column .list-info li {
    position: relative;
    margin-bottom: 25px;
    font-size: 18px;
    color: #fff;
    line-height: 1.8em;
    padding-left: 45px;
}

.contact-page-section .info-column .list-info li:last-child {
    margin-bottom: 0;
}

.contact-page-section .info-column .list-info li i {
    position: absolute;
    left: 0;
    top: 8px;
    color: #fff;
    font-size: 30px;
}

.contact-form {
    position: relative;
}

.contact-form .form-group {
    position: relative;
    margin-bottom: 20px;
}

.contact-form input[type=text],
.contact-form input[type=email],
.contact-form textarea {
    position: relative;
    display: block;
    width: 100%;
    height: 60px;
    color: #222;
    font-size: 14px;
    line-height: 38px;
    padding: 10px 30px;
    border: 2px solid #000000;
    background-color: #fff;
    transition: all .3s ease;
}

.contact-form input[type=text]:focus,
.contact-form input[type=email]:focus,
.contact-form textarea:focus {
    border-color: rgb(51, 51, 51);
}

.contact-form textarea {
    height: 250px;
    resize: none;
}

.contact-form .theme-btn {
    font-size: 16px;
    font-weight: 700;
    margin-top: 10px;
    text-transform: capitalize;
    padding: 16px 39px;
    border: 2px solid #708090;
    font-family: Arimo, sans-serif;
    background: #708090;
    display: inline-block;
    position: relative;
    line-height: 24px;
    cursor: pointer;
    color: #fff;
}

.contact-form .theme-btn:hover {
    color: #00b8ca;
    border-color: #00b8ca;
    background: transparent;
}

.contact-form input.error,
.contact-form select.error,
.contact-form textarea.error {
    border-color: red !important;
}

.contact-form label.error {
    display: block;
    line-height: 24px;
    padding: 5px 0 0;
    margin: 0;
    text-transform: uppercase;
    font-size: 12px;
    color: red;
    font-weight: 500;
}

/* Social Icon Styles */
.social-icon-four {
    position: relative;
}

.social-icon-four li {
    position: relative;
    margin-right: 18px;
    display: inline-block;
}

.social-icon-four li.follow {
    color: #fff;
    font-weight: 600;
    font-size: 24px;
    display: block;
    margin-bottom: 20px;
}

.social-icon-four li a {
    position: relative;
    font-size: 20px;
    color: #fff;
    transition: all .3s ease;
}

.social-icon-four li a:hover {
    color: #222;
}
</style>

<body class="hold-transition skin-blue layout-top-nav">
    <div class="wrapper">
        <cfinclude template="includes/navbar.cfm">

        <div class="content-wrapper">
            <div class="container">
                <section class="content">
                    <div class="row">
                        <div class="col-sm-5">

                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />


                            <section class="contact-page-section">
                                <div class="container">
                                    <cfoutput>
                                        <cfif structKeyExists(session, "error")>
                                            <div class="alert alert-danger">
                                                #session.error#
                                            </div>
                                            <cfset structDelete(session, "error")>
                                        </cfif>

                                        <cfif structKeyExists(session, "success")>
                                            <div class="callout callout-success text-center">
                                                <p>#session.success#</p>
                                            </div>
                                            <cfset structDelete(session, "success")>
                                        </cfif>
                                    </cfoutput>

                                    <div class="sec-title">
                                        <h2>Get in Touch With Us.</h2>
                                    </div>
                                    <div class="inner-container">
                                        <div class="row clearfix">
                                            <div class="form-column col-md-8 col-sm-12 col-xs-12">
                                                <div class="inner-column">
                                                    <div class="contact-form">
                                                        <form method="post" action="mail.php" id="contact-form">
                                                            <div class="row clearfix">
                                                                <div class="form-group col-md-6 col-sm-6 co-xs-12">
                                                                    <input type="text" name="name"
                                                                        value="<cfoutput>#session.name ?: ''#</cfoutput>" placeholder="Name" required>
                                                                </div>
                                                                <div class="form-group col-md-6 col-sm-6 co-xs-12">
                                                                    <input type="email" name="email"
                                                                        value="<cfoutput>#session.email ?: ''#</cfoutput>"
                                                                        placeholder="Email" required>
                                                                </div>
                                                                <div class="form-group col-md-6 col-sm-6 co-xs-12">
                                                                    <input type="text" name="subject"
                                                                        value="<cfoutput>#session.subject ?: ''#</cfoutput>"
                                                                        placeholder="Subject" required>
                                                                </div>
                                                                <div class="form-group col-md-12 col-sm-12 col-xs-12">
                                                                    <textarea name="message" placeholder="Message to send">
                                                                    <cfoutput>#session.message ?: ''#</cfoutput></textarea>
                                                                </div>

                                                                <div class="form-group col-md-12 col-sm-12 co-xs-12">
                                                                    <button type="submit"
                                                                        class="theme-btn btn-style-one">Send
                                                                        Now</button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="info-column col-md-4 col-sm-12 col-xs-12">
                                                <div class="inner-column">
                                                    <h2>Contact Info</h2>
                                                    <ul class="list-info">
                                                        <li><i class="fas fa-globe"></i>123 lorem ispum Abc,
                                                            Street Chandigarh.</li>
                                                        <li><i class="far fa-envelope"></i>Africomm@gmail.com
                                                        </li>
                                                        <li><i class="fas fa-phone"></i>1-234-567-890
                                                            <br>1-234-567-890
                                                        </li>
                                                    </ul>
                                                    <ul class="social-icon-four">
                                                        <li class="follow">Follow on: </li>
                                                        <li><a href="#"><i class="fab fa-facebook-f"></i></a>
                                                        </li>
                                                        <li><a href="#"><i class="fab fa-twitter"></i></a>
                                                        </li>
                                                        <li><a href="#"><i class="fab fa-google-plus-g"></i></a>
                                                        </li>
                                                        <li><a href="#"><i class="fab fa-dribbble"></i></a>
                                                        </li>
                                                        <li><a href="#"><i class="fab fa-pinterest-p"></i></a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </section>

                        <cfinclude template="includes/scripts.cfm">