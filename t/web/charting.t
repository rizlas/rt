use strict;
use warnings;

BEGIN {
    require RT::Test;

    if (eval { require GD; 1 }) {
        RT::Test->import(plan => 'no_plan');
    }
    else {
        RT::Test->import(skip_all => 'GD required.');
    }
}

for my $n (1..7) {
    my $ticket = RT::Ticket->new( RT->SystemUser );
    my $req = 'root' . ($n % 2) . '@localhost';
    my ( $ret, $msg ) = $ticket->Create(
        Subject   => "base ticket $_",
        Queue     => "General",
        Owner     => "root",
        Requestor => $req,
        MIMEObj   => MIME::Entity->build(
            From    => $req,
            To      => 'rt@localhost',
            Subject => "base ticket $_",
            Data    => "Content $_",
        ),
    );
    ok( $ret, "ticket $n created: $msg" );
}

my ($url, $m) = RT::Test->started_ok;
ok( $m->login, "Logged in" );

# Test that defaults work
$m->get_ok( "/Search/Chart.html?Query=id>0" );
$m->content_like(qr{<th[^>]*>Queue\s*</th>\s*<th[^>]*>Tickets\s*</th>}, "Grouped by queue");
$m->content_like(qr{General</a>\s*</td>\s*<td[^>]*>\s*<a[^>]*>7</a>}, "Found results in table");
$m->content_like(qr{<img src="/Search/Chart\?}, "Found image");

$m->get_ok( "/Search/Chart?Query=id>0" );
is( $m->content_type, "image/png" );
ok( length($m->content), "Has content" );


# Group by Queue
$m->get_ok( "/Search/Chart.html?Query=id>0&GroupBy=Queue" );
$m->content_like(qr{<th[^>]*>Queue\s*</th>\s*<th[^>]*>Tickets\s*</th>}, "Grouped by queue");
$m->content_like(qr{General</a>\s*</td>\s*<td[^>]*>\s*<a[^>]*>7</a>}, "Found results in table");
$m->content_like(qr{<img src="/Search/Chart\?}, "Found image");

$m->get_ok( "/Search/Chart?Query=id>0&GroupBy=Queue" );
is( $m->content_type, "image/png" );
ok( length($m->content), "Has content" );


# Group by Requestor email
$m->get_ok( "/Search/Chart.html?Query=id>0&GroupBy=Requestor.EmailAddress" );
$m->content_like(qr{<th[^>]*>Requestor\s+EmailAddress</th>\s*<th[^>]*>Tickets\s*</th>},
                 "Grouped by requestor");
$m->content_like(qr{root0\@localhost</a>\s*</td>\s*<td[^>]*>\s*<a[^>]*>3</a>}, "Found results in table");
$m->content_like(qr{<img src="/Search/Chart\?}, "Found image");

$m->get_ok( "/Search/Chart?Query=id>0&GroupBy=Requestor.Email" );
is( $m->content_type, "image/png" );
ok( length($m->content), "Has content" );


# Group by Requestor phone -- which is bogus, and falls back to queue
$m->get_ok( "/Search/Chart.html?Query=id>0&GroupBy=Requestor.Phone" );
$m->content_like(qr{General</a>\s*</td>\s*<td[^>]*>\s*<a[^>]*>7</a>},
                 "Found queue results in table, as a default");
$m->content_like(qr{<img src="/Search/Chart\?}, "Found image");

$m->get_ok( "/Search/Chart?Query=id>0&GroupBy=Requestor.Phone" );
is( $m->content_type, "image/png" );
ok( length($m->content), "Has content" );
