#!/usr/bin/perl -w
use strict;
$|++;
use File::Basename;
use WWW::Mechanize 1.72;

my @scannedLinks;
my @emails;
my @linksWithEmail;

my $mech = WWW::Mechanize->new( autocheck => 0 );
my $input = "http://www.mininghome.com/mine_country_activity.html";

open my $emailsFH, ">emails.txt";
&fandLinksWithContry($input);
print $emailsFH, @emails;

sub fandLinksWithContry() {
	my $inputUrl = shift;
	$mech->get($inputUrl);
	my @links = $mech->find_all_links(tag => "a", url_regex => qr/mine\&activity\=/i);
	print scalar @links;
	foreach ( @links ) {
		my $url = $_;		# Get the link with contry name
		findCompanyLink($url);
	}
}

sub findCompanyLink() {
	my $companyLink = shift;
	$mech->get($companyLink);
	unless ($mech->success) {
		print "Can't get SU response from $companyLink->url_abs \n";
	}
	my @links = $mech->find_all_links(tag => "a", url_regex => qr/company\=mine\&companyid\=/i);
	foreach	( @links ) {
		my $url = $_;
		getEmailsFromPage($url);
	}	
}

sub getEmailsFromPage() {
	my $url = shift;
	$mech->get($url);
	my @tempEmails = $mech->find_all_links(tag => "a", url_regex => qr/mailto/i);
	foreach my $email (@tempEmails) {
		my $emailText = $email->text;
		if ($emailText !~ m/^Contact Us|^Email Us/ig) {
		print $emailText."\n";
		push @emails, $emailText;
		}
	}
}

