<cfoutput>
  <header class="main-header">
    <!-- Logo -->
    <a href="#" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini"><b>C</b>P</span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg"><b>Afri</b>Comm</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- User Account: style can be found in dropdown.less -->
                <li class="dropdown user user-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img src="#(NOT Empty(admin['photo']) ? '../images/' & admin['photo'] : '../images/profile.jpg')#"
                            class="user-image" alt="User Image">
                        <span class="hidden-xs">#admin['firstname']# #admin['lastname']#</span>
                    </a>
                    <ul class="dropdown-menu">
                        <!-- User image -->
                        <li class="user-header">
                            <img src="#(NOT Empty(admin['photo']) ? '../images/' & admin['photo'] : '../images/profile.jpg')#"
                                class="img-circle" alt="User Image">

                            <p>
                                #admin['firstname']# #admin['lastname']#
                                <small>Member since #DateFormat(admin['created_on'], 'MMM. YYYY')#</small>
                            </p>
                        </li>
                        <li class="user-footer">
                            <div class="pull-left">
                                <a href="#profile" data-toggle="modal" class="btn btn-default btn-flat"
                                    id="admin_profile">Update</a>
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
<cfinclude template="includes/profile_modal.cfm">
