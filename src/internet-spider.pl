#!/user/bin/perl

use strict;
use warnings;
use Encode;
use LWP;

my $url = $ARGV[0]; 
print $url."\n";
my @urls = ();
push @urls, $url;

open my $fh,">link_list.txt";
open my $fh2,">emails.txt";
my @emails = ();
my $browser = initBrowser();

my $count = 1;
if ( scalar @urls > 0 ) {
	print "".$count++;
	my $tmpUrl = shift @urls;
	my $resp = $browser->get($tmpUrl);
	unless ($resp->is_success) {
		print "Can not get su response via $tmpUrl", $resp->status_line, "\n";
		exit;
	}
	my $html=$resp->content;
	my $count2 = 0;
	while($html=~m/<a href=\"(.*?)\"/ig){
		print "In 1st while loop -->".$count2++."\n";
		push @urls, URI->new_abs($1, $resp->base);
	}
}
print  $fh join("\n", @urls);
close  $fh;
print "-------extract #---:".scalar @urls;
print "\n";

my $count3 = 1;
my $hashNum = 1;
my %scannedLinks = {};
# This 2nd loop is read links from array.
while (scalar @urls > 0) {
	print "This is 2nd while loop".$count3++."\n";
	my $tmp2 = shift @urls;
	my $response = $browser->get($tmp2);
	unless ($response->is_success) {
		print "Failed\n";
	}
	my $html2 = $response->content;
	my @urls2 =();
	while ($html2 =~ /<a href=\"(.*?)\"/ig) {
		my $tempVar = URI->new_abs($1, $response->base);
		push @urls2, $tempVar if $tempVar =~ m/companyid=/g;
		last if scalar @urls2 > 10;
		my $lastCount = 1;
		while ( scalar @urls2 > 0) {
			my $tmp3 = shift @urls2;
			next if exists $scannedLinks{$tmp3}; 
			$scannedLinks{$tempVar} = $hashNum++; 
			my $resp3 = $browser->get($tmp3);
			unless ($resp3->is_success) {
				print "Failed in last loop-------------\n";
			}
			my $html3 = $resp3->content;
			print ">>>>>Before regex email<<<<<<<<<<<", $lastCount++, "\n";
			while ($html3 =~ m/([^\s]+@[^\s]{2,20}\.\w+)/ig) {
				print $1;
				print "\n";
				push @emails, $1;
			}
		}
	}
}

##################################################
# This is refactory whole script use subroutine. #
##################################################
sub getUrlsByUrl {
	my $url = shift @_;
	my $brw = shift @_;
	my $resp = $brw->get($usr);
}

sub initBrowser {
	my $brw = LWP::UserAgent->new;
	$brw->agent('Mozilla/4.0 (compatible; MISE 5.12; Mac_PowerPC');
	$brw->timeout(7);

	return $brw;
}
print "We scanned: " ,scalar keys %scannedLinks, "\n";

print  $fh2 join("\n",@emails);
close  $fh2
