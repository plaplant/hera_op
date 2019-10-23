#! /bin/bash
set -e

# import common functions
src_dir="$(dirname "$0")"
source ${src_dir}/_common.sh

# Parameters are set in the configuration file, here we define their positions,
# which must be consistent with the config.
# 1 - filename
fn="${1}"
# generate diff file name from input file name.
fnd=`echo ${fn%.*}.diff.uvh5`

# get outfilename, removing extension and appending .autos.uvh5
autos_file=`echo ${fn%.*}.autos.uvh5`
autos_file_diff=`echo ${fnd%.*}.autos.uvh5`

echo extract_autos.py ${fn} ${autos_file} --clobber
extract_autos.py ${fn} ${autos_file} --clobber

echo extract_autos.py ${fnd} ${autos_file_diff} --clobber
extract_autos.py ${fnd} ${autos_file_diff} --clobber
