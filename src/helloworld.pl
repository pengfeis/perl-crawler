#!/usr/bin/perl -w
use strict;
$|++;
use File::Basename;
use WWW::Mechanize 1.72;

my @scannedLinks;
my @emails;
my @linksWithEmail;

my $mech = WWW::Mechanize->new( autocheck => 1 );
my $input = "http://www.mininghome.com/mine_country_activity.html";

fandLinksWithContry($input);
sub fandLinksWithContry() {
	my $inputUrl = shift;
	$mech->get($inputUrl);
	my @links = $mech->find_all_links(tag => "a", url_regex => qr/mine/i);
	print scalar @links;
	foreach ( @links ) {
		my $url = $_;		# Get the link with contry name
		print $url."\n";
		findCompanyLink($url);
	}
}

sub findCompanyLink() {
	my $companyLink = shift;
	$mech->get($companyLink);
	my @links = $mech->find_all_links(tag => "a", url_regex => qr/company\=mine\&companyid\=/i);
	foreach	( @links ) {
		my $url = $_;
		getEmailsFromPage($url);
	}	
}

sub getEmailsFromPage() {
	my $url = shift;
	$mech->get($url);
	my $content = $mech->content;
	while ( $content =~ m/([^\s]+@[^\s]{2, 20}\.\w+)/ig) {
		print $1."\n";
		push @emails, $1;
	}
}
