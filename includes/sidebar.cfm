<div class="row">
    <div class="box box-solid">
        <div class="box-header with-border">
            <h3 class="box-title"><b>Most Viewed Today</b></h3>
        </div>
        <div class="box-body">
            <ul id="trending">
                <cfset now = dateFormat(now(), 'yyyy-mm-dd')>
                <cftry>
                    <cfquery name="getMostViewed" datasource="fashion">
                        SELECT * FROM products WHERE date_view = #now# ORDER BY counter DESC LIMIT 10
                    </cfquery>
                    <cfloop query="getMostViewed">
                        <cfoutput><li><a href="product.cfm?product=#slug#">#name#</a></li></cfoutput>
                    </cfloop>
                    <cfcatch type="any">
                        <cfoutput>There is some problem in connection: #cfcatch.message#</cfoutput>
                    </cfcatch>
                </cftry>
            </ul>
        </div>
    </div>
</div>

<div class="row">
    <div class="box box-solid">
        <div class="box-header with-border">
            <h3 class="box-title"><b>Become a Subscriber</b></h3>
        </div>
        <div class="box-body">
            <p>Get free updates on the latest products and discounts, straight to your inbox.</p>
            <form method="POST">
                <div class="input-group">
                    <input type="email" name="email" class="form-control">
                    <span class="input-group-btn">
                        <button type="button" name="news_letter" class="btn btn-info btn-flat"><i
                                class="fa fa-envelope"></i>
                        </button>
                    </span>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="row">
    <div class='box box-solid'>
        <div class='box-header with-border'>
            <h3 class='box-title'><b>Follow us on Social Media</b></h3>
        </div>
        <div class='box-body'>
            <a class="btn btn-social-icon btn-facebook"><i class="fa fa-facebook"></i></a>
            <a class="btn btn-social-icon btn-twitter"><i class="fa fa-twitter"></i></a>
            <a class="btn btn-social-icon btn-instagram"><i class="fa fa-instagram"></i></a>
            <a class="btn btn-social-icon btn-google"><i class="fa fa-google-plus"></i></a>
            <a class="btn btn-social-icon btn-linkedin"><i class="fa fa-linkedin"></i></a>
        </div>
    </div>
</div>

<script>
    const news_letter = document.getElementsByName('news_letter')[0];
    news_letter.addEventListener('click', e => {
        e.preventDefault();
        const email = document.querySelector('input[name="email"]');
        const emailValue = email.value.trim();
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (emailValue === '') {
            alert('Please enter an email address.');
            return;
        }

        if (!emailPattern.test(emailValue)) {
            alert('Please enter a valid email address.');
            return;
        }

        const url = 'subscriber_list.cfm';
        const data = {
            email: emailValue
        };

        fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(res => res.json())
            .then(data => {
                if (data.status) {
                    alert(data.MESSAGE);
                    return;
                }
                alert(data.MESSAGE);
                return;
            })
            .catch(function(error) {
                console.error(error);
            });
    });
</script>
