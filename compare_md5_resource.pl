#!/usr/bin/perl
if ($#ARGV != 0)
{
	die "invalid file param:\n repreat input valid filename\n";
}
my $file=$ARGV[0];
my $CUR_DIR=`pwd`;
my $RES_DIR="./original_resources/";
chomp($CUR_DIR);

my @all_version=();

sub compareVersionStrings;
opendir($VERSION_DIR, "./original_resources/");
my @versions = readdir($VERSION_DIR);
closedir($VERSION_DIR);
print("gen md5");
sub check_version_md5;
foreach $version (@versions)
{
	if ($version =~ /\d+$/)
	{
		push(@all_version, $version);
		print($version," push item\n");
	}
}

@all_version = sort compareVersionStrings @all_version ;
sub compareVersionStrings {
	my ( @a, @b );
	return ( $a <=> $b );
}

my $dest_version = $all_version[$#all_version];
my $dest_version_end = $RES_DIR.$dest_version;
print "==generate md5 file of the lastest resources===================================\n";
check_version_md5($dest_version_end);
for($i = 0; $i < $#all_version; $i++)
{
	my $cur_version = $all_version[$i];
	my $cur_version_end=$RES_DIR.$cur_version;
	my $compare_res_dir=${cur_version}."_".${dest_version};
	check_version_md5($cur_version_end);
	print("perl \./compare.pl $cur_version_end $dest_version_end compared_resources $compare_res_dir");
	system("perl \./compare.pl $cur_version_end $dest_version_end compared_resources $compare_res_dir \n");
}

sub check_version_md5
{
	my ($version_dir) = @_;
	my $md5_file = "$version_dir/md5.result";
	if ( not (-e $md5_file))
	{
		my $machine = $^O;
		if ($machine eq "darwin")
		{
			system("\./gen_md5.sh $version_dir");
		}else{
			system("\./gen_md5_win.sh $version_dir");
		}
	}
}
