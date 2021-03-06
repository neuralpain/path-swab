# path-swab
# audit paths on Windows to remove 
# empty or non-existent folders

$_Path = $null                                        # audited paths
$x_Path = $null                                       # removed paths
$out_Dir = "$pwd\path"                                # output directory
$uid = [DateTimeOffset]::Now.ToUnixTimeSeconds()      # unix time as identifier

if (Test-Path $out_Dir -IsValid) { mkdir $out_Dir }   # create output dir

$s_Path = $Env:PATH -split ";"                        # collect all paths
$s_Path | out-file -filepath $out_Dir\$uid.old_path.txt

foreach ($_Dir in $s_Path) {
  if (Test-Path -Path $_Dir) { $_Path += "$_Dir;" }   # if path exist, add to audited paths;
  else { $x_Path += "$_Dir`n" }                       # else add to removed paths
}

$_Path | out-file -filepath $out_Dir\$uid.new_path.txt
$x_Path | out-file -filepath $out_Dir\$uid.removed_path.txt

$Env:PATH = $_Path
