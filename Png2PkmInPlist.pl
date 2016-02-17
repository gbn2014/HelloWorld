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
my $pkm = $name . ".pkm";
print($name);
while (<>) {
	s/$png/$pkm/g;
	print;
}