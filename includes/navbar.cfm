<header class="main-header">
    <nav class="navbar navbar-static-top">
        <div class="container">
            <div class="navbar-header">
                <a href="index.cfm" class="navbar-brand"><b>Afri</b> Comm</a>
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#navbar-collapse">
                    <i class="fa fa-bars"></i>
                </button>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse pull-left" id="navbar-collapse">
                <ul class="nav navbar-nav">
                    <li><a href="index.cfm">HOME</a></li>
                    <li><a href="about.cfm">ABOUT US</a></li>
                    <li><a href="contact.cfm"> CONTACT US</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">CATEGORY <span
                                class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <cftry>
                                <cfquery name="getCategories" datasource="fashion">
                                    SELECT * FROM category
                                </cfquery>
                                <cfloop query="getCategories">
                                    <cfoutput><li><a href="category.cfm?category=#cat_slug#">#name#</a></li></cfoutput>
                                </cfloop>
                                <cfcatch type="any">
                                    <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
                                </cfcatch>
                            </cftry>
                        </ul>
                    </li>
                </ul>
                <form method="POST" class="navbar-form navbar-left" action="search.cfm">
                    <div class="input-group">
                        <input type="text" class="form-control" id="navbar-search-input" name="keyword"
                            placeholder="Search for Product" required>
                        <span class="input-group-btn" id="searchBtn" style="display:none;">
                            <button type="submit" class="btn btn-default btn-flat"><i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
                </form>
            </div>
            <!-- /.navbar-collapse -->
            <!-- Navbar Right Menu -->
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown messages-menu">
                        <!-- Menu toggle button -->
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-shopping-cart"></i>
                            <span class="label label-success cart_count"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">You have <span class="cart_count"></span> item(s) in cart</li>
                            <li>
                                <ul class="menu" id="cart_menu">
                                </ul>
                            </li>
                            <li class="footer"><a href="cart_view.cfm">Go to Cart</a></li>
                        </ul>
                    </li>
                    <cfif structKeyExists(session, "user")>
                    <cfset image = (not isEmpty(user['photo'])) ? 'images/' & user['photo'] : 'images/profile.jpg'>
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img src="#image#" class="user-image" alt="User Image">
                        <span class="hidden-xs">#user['firstname']# #user['lastname']#</span>
                    </a>
                    <ul class="dropdown-menu">
                            <!-- User image -->
                        <li class="user-header">
                        <img src="#image#" class="img-circle" alt="User Image">
                    <p>
                    #user['firstname']# #user['lastname']#
                    <small>Member since #dateFormat(user['created_on'], 'MMM. Y')#</small>
                </p>
            </li>
            <li class="user-footer">
                <div class="pull-left">
                    <a href="profile.cfm" class="btn btn-default btn-flat">Profile</a>
                </div>
                <div class="pull-right">
                    <a href="logout.cfm" class="btn btn-default btn-flat">Sign out</a>
                </div>
            </li>
        </ul>
    </li>
<cfelse>
    <li><a href="login.cfm">LOGIN</a></li>
    <li><a href="signup.cfm">SIGNUP</a></li>
</cfif>

                </ul>
            </div>
        </div>
    </nav>
</header>
