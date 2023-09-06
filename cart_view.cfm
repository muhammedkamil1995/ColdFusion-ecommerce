<cfinclude template="includes/session.cfm">
<cfinclude template="includes/header.cfm">

<body class="hold-transition skin-blue layout-top-nav">
    <div class="wrapper">

        <cfinclude template="includes/navbar.cfm">

        <div class="content-wrapper">
            <div class="container">

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <div class="col-sm-9">
                            <h1 class="page-header">YOUR CART</h1>
                            <div class="callout" id="callout" style="display:none">
                                <button type="button" class="close"><span aria-hidden="true">&times;</span></button>
                                <span class="message"></span>
                            </div>
                            <div class="box box-solid">
                                <div class="box-body">
                                    <table class="table table-bordered">
                                        <thead>
                                            <th></th>
                                            <th>Photo</th>
                                            <th>Name</th>
                                            <th>Price</th>
                                            <th width="20%">Quantity</th>
                                            <th>Subtotal</th>
                                        </thead>
                                        <tbody id="tbody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <cfoutput>
                                <cfif structKeyExists(session, "user")>
                                    <div id='paypal-button'></div>
                                <cfelse>
                                    <h4>You need to <a href='login.cfm'>Login</a> to checkout.</h4>
                                </cfif>
                            </cfoutput>
                        </div>
                        <div class="col-sm-3">
                            <cfinclude template="includes/sidebar.cfm">
                        </div>
                    </div>
                </section>

            </div>
        </div>
        <cfinclude template="includes/footer.cfm">
    </div>

    <cfinclude template="includes/scripts.cfm">
    <script>
    var total = 0;
    $(function() {
        $(document).on('click', '.cart_delete', function(e) {
            e.preventDefault();
            var id = $(this).data('id');
            $.ajax({
                type: 'POST',
                url: 'cart_delete.cfm',
                data: {
                    id: id
                },
                dataType: 'json',
                success: function(response) {
                    $('#callout').show();
                    $('.message').text(response.MESSAGE);
                    if (!response.ERROR) {
                        $('#callout').removeClass('callout-danger').addClass(
                            'callout-success');
                        getDetails();
                        getCart();
                        getTotal();
                    } else {
                        $('#callout').removeClass('callout-success').addClass(
                            'callout-danger');
                    }

                }
            });
        });

        $(document).on('click', '.minus', function(e) {
            e.preventDefault();
            var id = $(this).data('id');
            var qty = $('#qty_' + id).val();
            if (qty > 1) {
                qty--;
            }
            $('#qty_' + id).val(qty);
            $.ajax({
                type: 'POST',
                url: 'cart_update.cfm',
                data: {
                    id: id,
                    qty: qty,
                },
                dataType: 'json',
                success: function(response) {
                    $('#callout').show();
                    $('.message').text(response.MESSAGE);
                    if (!response.ERROR) {
                        $('#callout').removeClass('callout-danger').addClass(
                            'callout-success');
                        getDetails();
                        getCart();
                        getTotal();
                    } else {
                        $('#callout').removeClass('callout-success').addClass(
                            'callout-danger');
                    }
                }
            });
        });

        $(document).on('click', '.add', function(e) {
            e.preventDefault();
            var id = $(this).data('id');
            var qty = $('#qty_' + id).val();
            qty++;
            $('#qty_' + id).val(qty);
            $.ajax({
                type: 'POST',
                url: 'cart_update.cfm',
                data: {
                    id: id,
                    qty: qty,
                },
                dataType: 'json',
                success: function(response) {
                    $('#callout').show();
                    $('.message').text(response.MESSAGE);
                    if (!response.ERROR) {
                        $('#callout').removeClass('callout-danger').addClass(
                            'callout-success');
                        getDetails();
                        getCart();
                        getTotal();
                    } else {
                        $('#callout').removeClass('callout-success').addClass(
                            'callout-danger');
                    }
                }
            });
        });

        getDetails();
        getTotal();

    });

    function getDetails() {
        $.ajax({
            type: 'POST',
            url: 'cart_details.cfm',
            dataType: 'json',
            success: function(response) {
                // isempty
                $('#tbody').html(response);
                console.log(response)
                getCart();
            }
        });
    }

    function getTotal() {
        $.ajax({
            type: 'POST',
            url: 'cart_total.cfm',
            dataType: 'json',
            success: function(response) {
                total = response;
            }
        });
    }
    </script>
    <!-- Paypal Express -->
    <script>
    paypal.Button.render({
        env: 'sandbox', // change for production if app is live,

        client: {
            sandbox: 'ASb1ZbVxG5ZFzCWLdYLi_d1-k5rmSjvBZhxP2etCxBKXaJHxPba13JJD_D3dTNriRbAv3Kp_72cgDvaZ',
            //production: 'AaBHKJFEej4V6yaArjzSx9cuf-UYesQYKqynQVCdBlKuZKawDDzFyuQdidPOBSGEhWaNQnnvfzuFB9SM'
        },

        commit: true, // Show a 'Pay Now' button

        style: {
            color: 'gold',
            size: 'small'
        },

        payment: function(data, actions) {
            return actions.payment.create({
                payment: {
                    transactions: [{
                        //total purchase
                        amount: {
                            total: total,
                            currency: 'USD'
                        }
                    }]
                }
            });
        },

        onAuthorize: function(data, actions) {
            return actions.payment.execute().then(function(payment) {
                window.location = 'sales.cfm?pay=' + payment.id;
            });
        },

    }, '#paypal-button');
    </script>
</body>

</html>