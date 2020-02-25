#! /bin/bash
set -e

# import common functions
src_dir="$(dirname "$0")"
source ${src_dir}/_common.sh
fn="${1}"  # Filename
label="${6}"
bn=$(basename ${1})  # Basename

# This is an XRFI script that only needs autocorrelations. You don't even need to have all the data if you don't want it ;D

# Parameters are set in the configuration file, here we define their positions,
# which must be consistent with the config.
# 1 - filename
### XRFI_AUTO parameters - see hera_qm.utils for details
# 2 - kt_size
# 3 - kf_size
# 4 - sig_init
# 5 - sig_adj
# 6 - label
# 7 - filter_centers
# 8 -filter_half_widths
# 9 -skip_wgts
# 10 -sig_inits
# 11 - sig_adjs
# 12 - polarizations
# 13 - bad_ants_dir

kt_size=${2}
kf_size=${3}
sig_init=${4}
sig_adj=${5}
label=${6}
filter_centers=${7}
filter_half_widths=${8}
skip_wgts=${9}
sig_inits=${10}
sig_adjs=${11}
polarizations=${12}
bad_ants_dir=${13}

#echo kt_size ${kt_size}
#echo kf_size ${kf_size}
#echo sig_init ${sig_init}
#echo sig_adj ${sig_adj}
#echo label ${label}
#echo filter_centers ${filter_centers}
#echo filter_half_widths ${filter_half_widths}
#echo skip_wgts ${skip_wgts}
#echo sig_inits ${sig_inits}
#echo sig_adjs ${sig_adjs}
#echo polarizations ${polarizations}
#echo bad_ants_dir ${bad_ants_dir}

jd=$(get_jd ${fn})
jd_int=`echo $jd | awk '{$1=int($1)}1'`
bad_ants_fn=`echo "${bad_ants_dir}/${jd_int}.txt"`
prep_exants ${bad_ants_fn}
exants=$(prep_exants ${bad_ants_fn})
#replace spaces with commas in exants
exants=`echo ${exants// /,}`
#echo ${exants}
echo auto_xrfi_run.py --data_file ${fn} --kt_size ${kt_size} --kf_size ${kf_size} --sig_init ${sig_init} --sig_adj ${sig_adj} --filter_centers ${filter_centers} --filter_half_widths ${filter_half_widths} --skip_wgts ${skip_wgts} --sig_inits ${sig_inits} --sig_adjs ${sig_adjs} --polarizations ${polarizations} --label ${label} --ex_ants ${exants} --clobber
auto_xrfi_run.py --data_file ${fn} --kt_size ${kt_size} --kf_size ${kf_size} --sig_init ${sig_init} --sig_adj ${sig_adj} --filter_centers ${filter_centers} --filter_half_widths ${filter_half_widths} --skip_wgts ${skip_wgts} --sig_inits ${sig_inits} --sig_adjs ${sig_adjs} --polarizations ${polarizations} --label ${label} --ex_ants ${exants} --clobber


