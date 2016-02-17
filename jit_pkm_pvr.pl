#!/bin/perl
my $PRE_VERSION=$ARGV[0];
my $CUR_DIR=$ENV{'PWD'};
print("CUR_DIR",$CUR_DIR,"\n");
my $outPlatform_dir="${CUR_DIR}/package_resources";
print("outPlatform_dir",${outPlatform_dir},"\n");
my $res_dir="${CUR_DIR}/compared_resources/*";
print("res_dir",${res_dir},"\n");

if ( not -d $outPlatform_dir )
{
	system("mkdir -p $outPlatform_dir;");
}
system("cp -R $res_dir $outPlatform_dir");

opendir($ALL_FILE, $outPlatform_dir);
my @versions = readdir($ALL_FILE);
closedir($ALL_FILE);
#1、copy url
sub cp_res_package;
sub pkm_resources;
sub pvr_resources;
system("mkdir -p ${outPlatform_dir}/iosUiResources");
system("mkdir -p ${outPlatform_dir}/iosUiResources/Animations");
system("mkdir -p ${outPlatform_dir}/iosUiResources/pkmResources");
foreach $filename (@versions){
	if ($filename =~ /\d+_\d+$/)
	{
		cp_res_package($filename);
	}
}
system("cp -R ${CUR_DIR}/package_resources/iosUiResources ${CUR_DIR}/package_resources/androidUiResources");
#2、package res
pkm_resources();
pvr_resources();
#3、split
sub jit_res_zip;
my @all_version=();
my $endVersion;
foreach $version (@versions){
	if ($version =~ /\d+_\d+$/)
	{
		jit_res_zip($version);
	}
}
system("rm -rf ${outPlatform_dir}/iosUiResources");
system("rm -rf ${outPlatform_dir}/androidUiResources");
sub cp_res_package
{
	my ($cur_version)=@_;
	if ( -d "${outPlatform_dir}/${cur_version}/Resources/ui/Animations" )
	{
		system("cp -R ${outPlatform_dir}/${cur_version}/Resources/ui/Animations/* ${CUR_DIR}/package_resources/iosUiResources/Animations");
		system("cp -R ${outPlatform_dir}/${cur_version}/Resources/ui/Animations/* ${CUR_DIR}/package_resources/androidUiResources/Animations");
	}
	if ( -d "${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources" )
	{
		system("cp -R ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources/* ${CUR_DIR}/package_resources/iosUiResources/pkmResources");
		system("cp -R ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources/* ${CUR_DIR}/package_resources/androidUiResources/pkmResources");
	}
}

sub pkm_resources
{
	if ( -d "${CUR_DIR}/package_resources/androidUiResources/Animations" )
	{
		system("find ${CUR_DIR}/package_resources/androidUiResources/Animations -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pkm --sheet %.pkm %.png");
		system("find ${CUR_DIR}/package_resources/androidUiResources/Animations -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pkm --sheet %_alpha.pkm --opt ALPHA %.png");
		system("find ${CUR_DIR}/package_resources/androidUiResources/Animations/ -name \"*.png\" -delete");
		system("find ${CUR_DIR}/package_resources/androidUiResources/Animations -name \"*.plist\" | xargs bash Png2PkmInPlist.sh");
		system("find ${CUR_DIR}/package_resources/androidUiResources/Animations -name \"*.xml\" | xargs bash Png2PkmInPlist.sh");
	}
	if ( -d "${CUR_DIR}/package_resources/androidUiResources/pkmResources" )
	{
		system("find ${CUR_DIR}/package_resources/androidUiResources/pkmResources -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pkm --sheet %.pkm %.png");
		system("find ${CUR_DIR}/package_resources/androidUiResources/pkmResources -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pkm --sheet %_alpha.pkm --opt ALPHA %.png");
		system("find ${CUR_DIR}/package_resources/androidUiResources/pkmResources -name \"*.plist\" | xargs bash Png2PkmInPlist.sh");
		system("find ${CUR_DIR}/package_resources/androidUiResources/pkmResources/ -name \"*.png\" -delete");
	}
}

sub pvr_resources
{
	if ( -d "${CUR_DIR}/package_resources/iosUiResources/Animations" )
	{
		system("find ${CUR_DIR}/package_resources/iosUiResources/Animations -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pvr3ccz --sheet %.pvr.ccz --pvr-quality best --opt RGBA8888 %.png");
		system("find ${CUR_DIR}/package_resources/iosUiResources/Animations -name \"*.png\" -delete");
		system("find ${CUR_DIR}/package_resources/iosUiResources/Animations -name \"*.plist\" | xargs bash Png2PvrInPlist.sh");
		system("find ${CUR_DIR}/package_resources/iosUiResources/Animations -name \"*.xml\" | xargs bash Png2PvrInPlist.sh");
	}
	if ( -d "${CUR_DIR}/package_resources/iosUiResources/pkmResources" )
	{
		system("find ${CUR_DIR}/package_resources/iosUiResources/pkmResources -name \"*.png\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pvr3ccz --sheet %.pvr.ccz --pvr-quality best --opt PVRTC4 --force-squared %.png");
		system("find ${CUR_DIR}/package_resources/iosUiResources/pkmResources -name \"icon_animation_alpha_1\" -o -name \"icon_city_alpha_1\" -o -name \"icon_city_alpha_2\" -o -name \"icon_resources_alpha_1\" -o -name \"icon_commander_avatar_alpha_7\" -o -name \"icon_commander_avatar_alpha_8\" -o -name \"icon_commander_avatar_alpha_12\" -o -name \"icon_player_avator_alpha_1\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pvr3ccz --sheet %.pvr.ccz --pvr-quality best --opt RGBA4444 %.png");
		system("find ${CUR_DIR}/package_resources/iosUiResources/pkmResources -name \"ui_btn_alpha_1\" -o -name \"ui_guide_alpha_1\" -o -name \"ui_common_alpha_2\" -o -name \"ui_common_alpha_3\" -o -name \"ui_morefunc_alpha_3\" | sed -n 's/\.png//p' | xargs -I % -n 1 TexturePacker --smart-update --size-constraints POT --format cocos2d --maxrects-heuristics best --disable-rotation --scale 1 --max-size 2048 --border-padding 0 --shape-padding 0 --trim-mode None --reduce-border-artifacts --extrude 0 --pack-mode Best --texture-format pvr3ccz --sheet %.pvr.ccz --pvr-quality best --opt RGBA8888 %.png");
		system("find ${CUR_DIR}/package_resources/iosUiResources/pkmResources -name \"*.plist\" | xargs bash Png2PvrInPlist.sh");
		system("find ${CUR_DIR}/package_resources/iosUiResources/pkmResources -name \"*.png\" -delete");
	}
}

sub jit_res_zip
{
	my ($cur_version)=@_;
	print("unit==",$cur_version,"\n");

	if ( -d "${outPlatform_dir}/${cur_version}/Resources/luaScript" )
	{
		if ( not -d "${outPlatform_dir}/${cur_version}/Resources/luaScript64" )
		{
			system("mkdir -p ${outPlatform_dir}/${cur_version}/Resources/luaScript64;");
		}
		system("cp -R ${outPlatform_dir}/${cur_version}/Resources/luaScript/* ${outPlatform_dir}/${cur_version}/Resources/luaScript64");
	}
	if (-d "${outPlatform_dir}/${cur_version}/Resources/ui/Animations")
	{
		if ( not -d "${outPlatform_dir}/${cur_version}/Resources/ui/Animations_pvr" )
		{
			system("mkdir -p ${outPlatform_dir}/${cur_version}/Resources/ui/Animations_pvr;");
		}
	}
	if (-d "${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources")
	{
		if ( not -d "${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources_pvr" )
		{
			system("mkdir -p ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources_pvr;");
		}
	}

	#1.luajit
	system("./build_lua.sh ${outPlatform_dir}/${cur_version}/Resources/luaScript");
	if (-d "${outPlatform_dir}/${cur_version}/Resources/luaScript64")
	{
		system("./build_lua.sh ${outPlatform_dir}/${cur_version}/Resources/luaScript64 arm64");
	}
	#2.pkm&pvr
	my $animation_dir="${outPlatform_dir}/${cur_version}/Resources/ui/Animations";
	if ( -d $animation_dir )
	{
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Animations -name \"*.png\" -delete");
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Animations -name \"*.plist\" -delete");
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Animations -name \"*.xml\" -delete");
		opendir($ALL_FILES, $animation_dir);
		my @dirs = readdir($ALL_FILES);
		closedir($ALL_FILES);
    # opendir(my $dh, $some_dir) || die "can't opendir $some_dir: $!";
    # @dots = grep { /^\./ && -f "$some_dir/$_" } readdir($dh);
    # closedir $dh;
		foreach $dir (@dirs){
			print("gaobingnan_dir",${dir},"\n");
			if ( ${dir} =~ /[a-zA-Z0-9]/ )
			{
				print("gaobingnan_dir_end=",${dir},"\n");
				my $androidFile="${CUR_DIR}/package_resources/androidUiResources/Animations/${dir}";
				system("cp -r $androidFile ${outPlatform_dir}/${cur_version}/Resources/ui/Animations");
				my $iosFile="${CUR_DIR}/package_resources/iosUiResources/Animations/${dir}";
				system("cp -r $iosFile ${outPlatform_dir}/${cur_version}/Resources/ui/Animations_pvr");
			}
		}
	}
	if ( -d "${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources" )
	{
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources -name \"*.plist\" -delete");
		opendir($ALL_FILES2, "${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources");
		my @files = readdir($ALL_FILES2);
		closedir($ALL_FILES2);
		my $android_dir="${CUR_DIR}/package_resources/androidUiResources/pkmResources";
		my $ios_dir="${CUR_DIR}/package_resources/iosUiResources/pkmResources";
		foreach $file (@files){
			my $fileBaseName=(split /\./,$file)[0];
			$fileBaseName="*".$fileBaseName."*";
			print("gaobingnan_png",$fileBaseName,"\n");
			if ($fileBaseName)
			{
				system("find $android_dir -name ${fileBaseName} | xargs -I % -n 1 cp % ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources");
				system("find $ios_dir -name ${fileBaseName} | xargs -I % -n 1 cp % ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources_pvr");
			}
		}
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources -name \"*.png\" -delete ");
		system("find ${outPlatform_dir}/${cur_version}/Resources/ui/Published-Android/pkmResources_pvr -name \"*.png\" -delete ");
	}
	#3、 android ios32 ios64
	system("mkdir -p ${outPlatform_dir}/${cur_version}/android");
	system("mkdir -p ${outPlatform_dir}/${cur_version}/ios32");
	system("mkdir -p ${outPlatform_dir}/${cur_version}/ios64");
	
	system("cp -R ${outPlatform_dir}/${cur_version}/Resources/* ${outPlatform_dir}/${cur_version}/android");
	system("cp -R ${outPlatform_dir}/${cur_version}/Resources/* ${outPlatform_dir}/${cur_version}/ios32");
	system("cp -R ${outPlatform_dir}/${cur_version}/Resources/* ${outPlatform_dir}/${cur_version}/ios64");

	#del android
	system("rm -rf ${outPlatform_dir}/${cur_version}/android/luaScript64");
	system("rm -rf ${outPlatform_dir}/${cur_version}/android/ui/Animations_pvr");
	system("rm -rf ${outPlatform_dir}/${cur_version}/android/ui/Published-Android/pkmResources_pvr");
	#del ios32
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios32/luaScript64");
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios32/ui/Animations");
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios32/ui/Published-Android/pkmResources");
	system("mv  ${outPlatform_dir}/${cur_version}/ios32/ui/Animations_pvr ${outPlatform_dir}/${cur_version}/ios32/ui/Animations");
	system("mv  ${outPlatform_dir}/${cur_version}/ios32/ui/Published-Android/pkmResources_pvr ${outPlatform_dir}/${cur_version}/ios32/ui/Published-Android/pkmResources");
	#del ios64
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios64/luaScript");
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios64/ui/Animations");
	system("rm -rf ${outPlatform_dir}/${cur_version}/ios64/ui/Published-Android/pkmResources");
	system("mv  ${outPlatform_dir}/${cur_version}/ios64/ui/Animations_pvr ${outPlatform_dir}/${cur_version}/ios64/ui/Animations");
	system("mv  ${outPlatform_dir}/${cur_version}/ios64/ui/Published-Android/pkmResources_pvr ${outPlatform_dir}/${cur_version}/ios64/ui/Published-Android/pkmResources");
}
