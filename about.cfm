<cfinclude template="includes/session.cfm"> 
<cfinclude template="includes/header.cfm">

<style>
.about {
    padding: 130px 0;
}

.about .heading h2 {
    font-size: 30px;
    font-weight: 700;
    margin: 0;
    padding: 0;
}

.about .heading h2 span {
    color: #F24259;
}

.about .heading p {
    font-size: 15px;
    font-weight: 400;
    line-height: 1.7;
    color: #999999;
    margin: 20px 0 60px;
    padding: 0;
}

.about h3 {
    font-size: 25px;
    font-weight: 700;
    margin: 0;
    padding: 0;
}

.about p {
    font-size: 15px;
    font-weight: 400;
    line-height: 1.7;
    color: #999999;
    margin: 20px 0 15px;
    padding: 0;
}

.about h4 {
    font-size: 15px;
    font-weight: 500;
    margin: 8px 0;
}

.about h4 i {
    color: #F24259;
    margin-right: 10px;
}
</style>

<body class="hold-transition skin-blue layout-top-nav">
    <div class="wrapper">

        <cfinclude template="includes/navbar.cfm">

        <div class="content-wrapper">
            <div class="container">

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <div class="col-sm-9">
                            <cfoutput>
                                <cfif structKeyExists(session, "error")>
                                    <div class="alert alert-danger">
                                        #session.error#
                                    </div>
                                    <cfset structDelete(session, "error")>
                                </cfif>
                            </cfoutput>

                            <body>
                                <section class="about" id="about">
                                    <div class="container">
                                        <div class="heading text-center">
                                            <h2>About <span>Us</span></h2>
                                            <p>Welcome to Afri Comm! We are dedicated to providing you with the latest
                                                and greatest gadgets and accessories to enhance your digital lifestyle.
                                            </p>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-6">
                                                <img src="https://img.freepik.com/premium-vector/bundle-nine-branding-elements-icons-illustration_18591-70780.jpg"
                                                    alt="about" class="img-fluid" width="100%">
                                            </div>
                                            <div class="row">
                                                <div class="col-lg-6">
                                                    <h3>Enhancing Your Digital Lifestyle</h3>
                                                    <p>At Afri Comm, we strive to create a seamless digital experience
                                                        for
                                                        our customers. Our mission is to provide innovative and
                                                        high-quality
                                                        gadgets and accessories that enhance your digital lifestyle. At
                                                        our
                                                        company, we understand the importance of high-quality
                                                        accessories
                                                        that complement your devices. Whether you're looking for
                                                        protective
                                                        cases, stylish headphones, reliable chargers, or innovative
                                                        smart
                                                        devices, we have you covered. Our team consists of tech
                                                        enthusiasts
                                                        who carefully curate a wide range of products from top brands in
                                                        the
                                                        industry. We prioritize quality, functionality, and design to
                                                        ensure
                                                        that every item we offer meets the highest standards.</p>
                                                    <p>Welcome to Afri Comm! We are dedicated to providing you with the
                                                        latest and greatest gadgets and accessories to enhance your
                                                        digital
                                                        lifestyle.</p>
                                                    <p>Shopping with us is a breeze. Our user-friendly website allows
                                                        you to
                                                        browse our extensive catalog, read detailed product
                                                        descriptions,
                                                        and make secure purchases with ease. We also offer fast and
                                                        reliable
                                                        shipping to ensure your items reach you in no time. Customer
                                                        satisfaction is our top priority. Our dedicated support team is
                                                        always ready to assist you with any inquiries or concerns you
                                                        may
                                                        have. We strive to provide excellent customer service and make
                                                        your
                                                        shopping experience enjoyable and stress-free. Stay up to date
                                                        with
                                                        the latest trends and advancements in technology by following
                                                        our
                                                        blog and social media channels. We regularly share informative
                                                        articles, product reviews, and exciting offers to keep you
                                                        informed
                                                        and help you make the best purchasing decisions.</p>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>Exceptional Tchnology Product
                                                            </h4>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>Creative Solutions</h4>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>Brand New and U.K use Product
                                                            </h4>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>All Kind Of Digital Product &
                                                                Brand</h4>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>Outstanding Customer Service
                                                            </h4>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h4><i class="far fa-star"></i>Speed And Flexibility</h4>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="container mt-4">
                                                <p>Thank you for choosing our technology accessories company. We look
                                                    forward to serving you and providing you with exceptional products
                                                    that
                                                    enhance your digital life.</p>
                                            </div>
                                        </div>
                                </section>

                                <cfinclude template="includes/scripts.cfm">
                            </body>