#! /bin/bash
set -e

# import common functions
src_dir="$(dirname "$0")"
source ${src_dir}/_common.sh

# Parameters are set in the configuration file, here we define their positions,
# which must be consistent with the config.
# 1 - filename
# 2 - ant_z_thresh: Threshold of modified z-score for chi^2 per antenna above which antennas are thrown away and calibration is re-run iteratively.
# 3 - solar_horizon: When the Sun is above this altitude in degrees, calibration is skipped and the integrations are flagged.
# 4 - flag_nchan_low: integer number of channels at the low frequency end of the band to always flag (default 0)
# 5 - flag_nchan_high: integer number of channels at the high frequency end of the band to always flag (default 0)
# 6 - nInt_to_load: number of integrations to load and calibrate simultaneously. Lower numbers save memory, but incur a CPU overhead.
# 7 - min_bl_cut: cut redundant groups with average baseline lengths shorter than this length in meters
# 8 - max_bl_cut: cut redundant groups with average baseline lengths longer than this length in meters
# 9 - iter0_prefix: if not "", save omnical results after the 0th interation with this prefix iff there will be a rerun
# 10 - ant_metrics_extension: file extension to replace .uvh5 with to get ant_metrics files
fn="${1}"
bad_ants_dir="${2}"
ant_z_thresh="${3}"
solar_horizon="${4}"
flag_nchan_low="${5}"
flag_nchan_high="${6}"
nInt_to_load="${7}"
min_bl_cut="${8}"
max_bl_cut="${9}"
iter0_prefix="${10}"
ant_metrics_extension="${11}"
good_statuses="${12}"

# extract JD from filename
jd=$(get_jd ${fn})

# get exants from HERA CM database
ex_ants_db=`query_ex_ants.py ${jd} ${good_statuses}`

# use awk to round off fractional bit
jd_int=`echo $jd | awk '{$1=int($1)}1'`

# Get other bad antennas from bad_ants folder
bad_ants_fn=`echo "${bad_ants_dir}/${jd_int}.txt"`
if [ -f "${bad_ants_fn}" ]; then
    ex_ants=$(prep_exants ${bad_ants_fn})
    ex_ants=`echo "${ex_ants}","${ex_ants_db}"`
else
    ex_ants="${ex_ants_db}"
fi

# get metrics_json filename, removing extension and appending ant_metrics_extension
metrics_f=`echo ${fn%.uvh5}${ant_metrics_extension}`

# run redcal
echo redcal_run.py ${fn} --ex_ants ${ex_ants} --ant_metrics_file ${metrics_f}  --ant_z_thresh ${ant_z_thresh} --solar_horizon ${solar_horizon} \
    --flag_nchan_low ${flag_nchan_low} --flag_nchan_high ${flag_nchan_high} --nInt_to_load ${nInt_to_load} --min_bl_cut ${min_bl_cut} \
    --max_bl_cut ${max_bl_cut} --iter0_prefix ${iter0_prefix} --clobber --verbose
redcal_run.py ${fn} --ex_ants ${ex_ants} --ant_metrics_file ${metrics_f}  --ant_z_thresh ${ant_z_thresh} --solar_horizon ${solar_horizon} \
    --flag_nchan_low ${flag_nchan_low} --flag_nchan_high ${flag_nchan_high} --nInt_to_load ${nInt_to_load} --min_bl_cut ${min_bl_cut} \
    --max_bl_cut ${max_bl_cut} --iter0_prefix ${iter0_prefix} --clobber --verbose