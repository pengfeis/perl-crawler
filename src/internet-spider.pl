#!/user/bin/perl

use strict;
use warnings;
use Encode;
use LWP;


my $url = 'http://www.ferroalloynet.com/trade/1/supply.html';
my @urls = ();
push @urls, $url;

open my $fh,">link_list.txt";
open my $fh2,">emails.txt";
my @emails = ();
my $browser = LWP::UserAgent->new;
$browser->agent('Mozilla/4.0 (compatible; MISE 5.12; Mac_PowerPC');
$browser->timeout(7);

my $count = 1;
while(scalar @urls < 10) {
	print "".$count++;
	my $tmpUrl = shift @urls;
	my $resp = $browser->get($tmpUrl);
	unless ($resp->is_success) {
		print "Can not get su response via $tmpUrl", $resp->status_line, "\n";
		next;
	}
	my $html=$resp->content;
	my $count2 = 0;
	while($html=~m/<a href=\"(.*?)\"/ig){
		print "In 2nd while loop -->".$count2++."---->$1\n";
		push @urls, URI->new_abs($1, $resp->base);
	}
}
print  $fh join("\n", @urls);
close  $fh;
print scalar @urls;
my $count3 = 0;
while (scalar @urls > 0) {
	print "".$count3++."\n";
	my $tmp2 = shift @urls;
	my $response = $browser->get($tmp2);
	unless ($response->is_success) {
		print "Failed===============\n";
	}
	my $html2 = $response->content;
	if ($html2 =~ m/([^\s]+@[^\s]{2,8}\.com)/ig) {
		push @emails, $1;
	}
}


print  $fh2 join("\n",@emails);
close  $fh2
