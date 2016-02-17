#!/usr/bin/perl
print "$#ARGV num=", $#ARGV, "\n";
if ($#ARGV != 3)
{
	die "invalid compare param:\n usage compare.pl src dest out_dir out_file\n";
}

my $src_dir = $ARGV[0];
my $dest_dir = $ARGV[1];
my $out_dir = $ARGV[2];
my $out_name = $ARGV[3];
my $config_root = "luaScript/Configure";
my $config_version = "";

$src_dir =~ s/\/$//;
$dest_dir =~ s/\/$//;
$out_dir =~ s/\/$//;

my %src_files;

#parser configure path
open(CONF_FILE, "compare_config.conf");
while(<CONF_FILE>)
{
	if (/([\w\d]+)\s*=\s*([\w\d\/]+)/)
	{
		my ($config, $value) = ($1, $2);
		if ($config eq "config_root")
		{
			$config_root = $value;
		}
		elsif ($config eq "config_version")
		{
			$config_version = $value;
		}
		else 
		{
			print "Unsupported config param\n";
		}
	}
}
close(CONF_FILE);
my $machine = $^O;
#parser src md5 result
open(SRC_MD5, "$src_dir/md5.result");
while(<SRC_MD5>)
{
	if ($machine eq "darwin")
	{
		if (/MD5 \((.*)\) = (.*)/) 
		{
			$src_files{$1} = $2;
		}
	}else{
		if (/(.*)  (.*)/) 
		{
			$src_files{$2} = $1;
		}
	}
}
close(SRC_MD5);
open(DEST_MD5, "$dest_dir/md5.result");
my $copy_dest_root = "$out_dir/$out_name";
if (not -d $copy_dest_root)
{
	system("mkdir -p $copy_dest_root");
}
print "==copy files in difference to Folder update_files ===================================\n";
while(<DEST_MD5>)
{
	if ($machine eq "darwin"){
		if (/MD5 \((.*)\) = (.*)/) 
		{
			my $file_name = $1;
			my $md5_value = $2;
			my $file_dir = `dirname $file_name`;
			if ($file_dir  =~ /$config_root\/.+/ && (not $file_name =~ /$config_root\/$config_version/))
			{
				print STDERR ("skip configure $file_name $config_root $config_version\n");
				next;
			}
			print($src_files{$file_name},$file_name,$md5_value,"compare-----",exists $src_files{$file_name},"if equal=",$md5_value eq $src_files{$file_name},"\n");
			if (not (exists $src_files{$file_name} && $md5_value eq $src_files{$file_name}))
			{
				my $copy_dest = "${copy_dest_root}/$file_name";
				my $copy_dir = `dirname $copy_dest`;
				print($copy_dir,"--------copy_dir\n");
				if (not -e $copy_dir) 
				{
					system("mkdir -p $copy_dir");
				}
				print(${dest_dir},$file_name,"------copy_file\n");
				system("cp ${dest_dir}/$file_name $copy_dir");
			}
		}
	}else{
		if (/(.*)  (.*)/)
		{
			my $file_name = $2;
			my $md5_value = $1;
			my $file_dir = `dirname $file_name`;
			if ($file_dir  =~ /$config_root\/.+/ && (not $file_name =~ /$config_root\/$config_version/))
			{
				print STDERR ("skip configure $file_name $config_root $config_version\n");
				next;
			}
			print($src_files{$file_name},$file_name,$md5_value,"compare-----",exists $src_files{$file_name},"if equal=",$md5_value eq $src_files{$file_name},"\n");
			if (not (exists $src_files{$file_name} && $md5_value eq $src_files{$file_name}))
			{
				my $copy_dest = "${copy_dest_root}/$file_name";
				my $copy_dir = `dirname $copy_dest`;
				print($copy_dir,"--------copy_dir\n");
				if (not -e $copy_dir) 
				{
					system("mkdir -p $copy_dir");
				}
				print(${dest_dir},$file_name,"------copy_file\n");
				system("cp ${dest_dir}/$file_name $copy_dir");
			}
		}	   
	}


}
close(DEST_MD5);
my $resource_dir="${out_dir}/${out_name}/Resources";
if ( not -d $resource_dir )
{
	system("mkdir -p $resource_dir/ui");
}
