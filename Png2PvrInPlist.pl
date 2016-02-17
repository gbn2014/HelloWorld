#!/usr/bin/perl
my $file = shift @ARGV;
@ARGV = $file;
local $^I='';
print("$file\n");
my $start = rindex($file,"\/");
my $end = rindex($file,"\.");
my $name = substr($file,$start + 1,$end - $start - 1);
print("$start\n", "$end\n");
my $png = $name . ".png";
my $pvr = $name . ".pvr.ccz";
print($name);
while (<>) {
	s/$png/$pvr/g;
	print;
}
