#!/usr/bin/perl
if ($#ARGV != 0)
{
	die "invalid file param:\n repreat input valid filename\n";
}

my $file=$ARGV[0];
my $CUR_DIR=`pwd`;
chomp($CUR_DIR);
my $RES_DIR=$CUR_DIR."/original_resources"."/".$file;
my $DEST_DIR=$RES_DIR."/Resources";
my $RawData_DIR="../../../../trunk/RawData";
print $RES_DIR, "\n";
print $DEST_DIR, "\n";
system("mkdir -p $DEST_DIR");
system("cp $RawData_DIR/*.xml $DEST_DIR;");
system("cp $RawData_DIR/*.png $DEST_DIR;");
system("cp -r $RawData_DIR/music $DEST_DIR;");
system("cp -r $RawData_DIR/lan $DEST_DIR;");
system("cp -r $RawData_DIR/luaScript $DEST_DIR;");

my $ui_DEST=$DEST_DIR."/ui";
system("mkdir $ui_DEST");
system("cp -r $RawData_DIR/ui/Animations $ui_DEST;");
system("cp -r $RawData_DIR/ui/map $ui_DEST;");
system("cp -r $RawData_DIR/ui/Published-Android $ui_DEST;");
system("cp -r $RawData_DIR/ui/Resources/pkmResources $ui_DEST/Published-Android/;");
system("cp -r $RawData_DIR/ui/Resources/pngResources $ui_DEST/Published-Android/;");

system("find $DEST_DIR -name \"*.proto\" -delete");
system("find $DEST_DIR -name \"*.sh\" -delete");
system("find $DEST_DIR -name Makefile -delete");

