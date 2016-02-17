#!/bin/perl
my $PRE_VERSION=$ARGV[0];
my $CUR_DIR=$ENV{'PWD'};
my $MAX_VERSION=$ARGV[1];
my $PLATFORM=$ARGV[2];
my $FILE_NAME=$ARGV[3];
print("CUR_DIR",$CUR_DIR,"\n");
my $outPlatform_dir="${CUR_DIR}/update_resources/${FILE_NAME}";
print("outPlatform_dir",${outPlatform_dir},"\n");
my $res_dir="${CUR_DIR}/package_resources/*";
print("res_dir",${res_dir},"\n");


print("gbn MAX_VERSION===",$MAX_VERSION);
open(VERSION, ">version");
print VERSION ($MAX_VERSION);
system("mv version $outPlatform_dir;");

$outPlatform_dir="${outPlatform_dir}/${MAX_VERSION}";
print("gbn outPlatform_dir===$outPlatform_dir");
if ( not -d $outPlatform_dir )
{
	system("mkdir -p $outPlatform_dir;");
}
system("cp -R $res_dir $outPlatform_dir");

opendir($ALL_FILE, $outPlatform_dir);
my @versions = readdir($ALL_FILE);
closedir($ALL_FILE);
sub jit_res_zip;
my @all_version=();
my $endVersion;
foreach $version (@versions){
	if ($version =~ /\d+_\d+$/)
	{
		@personal=split(/_/,$version);
		my $a=@personal[0];
		my $b=@personal[1];
		$endVersion=$PRE_VERSION.$a."_".$PRE_VERSION.$b;
		print("gaobingnan",$endVersion,"\n");
		my $res=$outPlatform_dir."/".$version;
		my $dest=$outPlatform_dir."/".$endVersion;
		system("mv $res $dest");
		jit_res_zip($endVersion);
	}
}

sub jit_res_zip
{
	my ($cur_version)=@_;
	print("unit==",$cur_version,"\n");

	my $out_zip="${cur_version}.zip";
	system("cd ${outPlatform_dir}/${cur_version}/${PLATFORM}; zip ${out_zip} * -r; mv *.zip ${outPlatform_dir}; cd -;\n");
	system("pwd \n");
	system("rm -rf ${outPlatform_dir}/${cur_version};");
}
