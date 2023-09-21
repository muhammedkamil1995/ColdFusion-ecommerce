<cfoutput>
  <header class="main-header">
    <!-- Logo -->
    <a href="##" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini"><b>C</b>P</span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg"><b>Afri</b>Comm</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="##" class="sidebar-toggle" data-toggle="push-menu" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>

        <cfset image = (len(trim(getAdminresult.photo)) GT 0) ? '../images/' & getAdminresult.photo : '../images/profile.jpg'>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- User Account: style can be found in dropdown.less -->
                <li class="dropdown user user-menu">
                    <a href="##" class="dropdown-toggle" data-toggle="dropdown">
                        
                        <cfoutput><img src="#image#"
                            class="user-image" alt="User Image">
                        <span class="hidden-xs">#getAdminresult.firstname# #getAdminresult.lastname#</span>
                        </cfoutput>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- User image -->
                        <li class="user-header">
                           <cfoutput> <img src="#image#"
                                class="img-circle" alt="User Image">

                            <p>
                                #getAdminresult.firstname# #getAdminresult.lastname#
                                <small>Member since #DateFormat(getAdminresult.created_on, 'MMM. YYYY')#</small>
                            </p></cfoutput>
                        </li>
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="##profile" data-toggle="modal" class="btn btn-default btn-flat"
                                    id="getAdminresult_profile">Update</a>
                            </div>
                            <div class="pull-right">
                                <a href="../logout.cfm" class="btn btn-default btn-flat">Sign out</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
</header>
</cfoutput>
<cfinclude template="profile_modal.cfm">
