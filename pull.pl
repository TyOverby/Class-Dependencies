#!/usr/bin/perl

use strict;
use warnings;
use LWP;

# $prerequisites->{course}->{requirement}
my $prerequisites = {};

my $ua = LWP::UserAgent->new();
my $response = $ua->get("http://www.washington.edu/students/crscat/cse.html");

die "Error: ", $response->status_line unless $response->is_success;


print "var classes = [\n";

foreach my $line (split /^/, $response->content()) {
   next unless $line =~ /^<P><B><A NAME="(cse\d{3})">(CSE \d{3}) <\/A> ([\w\s]+) \((\d+)\) <\/B><BR>(.+) Prerequisite: ([^\.]+)/;

   my $short_name  = $1;
   $short_name =~ s/\"/\\\"/g;
   $short_name =~ s/^\s+//;
   $short_name =~ s/\s+$//;

   my $course      = $2;
   $course =~ s/\"/\\\"/g;
   $course =~ s/^\s+//;
   $course =~ s/\s+$//;

   my $name        = $3;
   $name =~ s/\"/\\\"/g;
   $name =~ s/^\s+//;
   $name =~ s/\s+$//;

   my $credits     = $4;
   $credits =~ s/\"/\\\"/g;
   $credits =~ s/^\s+//;
   $credits =~ s/\s+$//;

   my $description = $5;
   $description =~ s/\"/\\\"/g;
   $description =~ s/^\s+//;
   $description =~ s/\s+$//;

   print "{\n";

   print "code: \"$1\"\n,";
   print "course: \"$2\"\n,";
   print "name: \"$3\"\n,";
   print "credits: \"$4\"\n,";
   print "description: \"$5\"\n,";
   print "prerequisite: \"$6\"\n";

   print "},\n\n";
}

print "]";
