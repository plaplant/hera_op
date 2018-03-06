#! /bin/bash
set -e

# import common functions
src_dir="$(dirname "$0")"
source ${src_dir}/_common.sh

# define polarizations
pol1="xx"
pol2="yy"

# make the file name
bn=$(basename ${!#})
# Get pol
pol=$(get_pol ${!#})


# We need to run xrfi on the raw visibilities for all polarizations.
# In addition, we want to run on the model visibilities, abscal gain solutions
# (including omnical and firstcal), and omnical chi-squared values. We then
# broadcast all of these together to get a consensus of what should be flagged as RFI.
#
# We therefore pass the *.abs.calfits file into $pol1 and $pol2 defined above
# to flag on the gain solutions and chi-squared values. We also pass the model
# visibilities to these pols. These two threads flag
# these data products in addition to the raw visibitilies. The other two threads only flag
# their respective raw visibilities. The by-product of these steps are *.npz files, which
# contain the flag information produced by each thread.
#
# Once the flagging is done, we need to tie everything together, and broadcast/apply to the
# data files. This is done in the `do_DELAY XRFI_APPLY.sh' script, which will take all of the
# *.npz files as arguments in addition to the flags generated by flagging the raw visibilities.

# Parameters are set in the configuration file, here we define their positions,
# which must be consistent with the config.
### Delay filter parameters - see hera_cal.utils for details
# 1 - standoff
# 2 - horizon
# 3 - tol
# 4 - window
# 5 - skip_wgt
# 6 - maxiter
### XRFI parameters - see hera_qm.utils for details
# 7 - kt_size
# 8 - kf_size
# 9 - sig_init
# 10 - sig_adj
# 11 - px_threshold
# 12 - freq_threshold
# 13 - time_threshold
### Last one is the filename
# 14 - filename

if [is_same_pol $bn $pol1] || [is_same_pol $bn $pol2]; then
    # This thread runs on raw visibility + cal + model

    # get the name of the abs.calfits and model vis files
    abs_f=`echo ${bn}.abs.calfits`
    vis_f=`echo ${bn}.vis.uvfits`

    # run the xrfi command
    echo delay_xrfi_run.py --standoff=${1} --horizon=${2} --tol=${3} --window=${4} --skip_wgt=${5} --maxiter=${6} --kt_size=${7} --kf_size=${8} --sig_init=${9} --sig_adj=${10} --px_threshold=${11} --freq_threshold=${12} --time_threshold=${13} --calfits_file=${abs_f} --model_file=${vis_f} --model_file_format=uvfits --infile_format=miriad --algorithm=xrfi --extension=.flags.npz --summary ${bn}OC
    delay_xrfi_run.py --standoff=${1} --horizon=${2} --tol=${3} --window=${4} --skip_wgt=${5} --maxiter=${6} --kt_size=${7} --kf_size=${8} --sig_init=${9} --sig_adj=${10} --px_threshold=${11} --freq_threshold=${12} --time_threshold=${13} --calfits_file=${abs_f} --model_file=${vis_f} --model_file_format=uvfits --infile_format=miriad --algorithm=xrfi --extension=.flags.npz --summary ${bn}OC
else
    # These threads run just on raw visibility
    echo delay_xrfi_run.py --standoff=${1} --horizon=${2} --tol=${3} --window=${4} --skip_wgt=${5} --maxiter=${6} --kt_size=${7} --kf_size=${8} --sig_init=${9} --sig_adj=${10} --px_threshold=${11} --freq_threshold=${12} --time_threshold=${13} --infile_format=miriad --algorithm=xrfi --extension=.flags.npz --summary ${bn}OC
    delay_xrfi_run.py --standoff=${1} --horizon=${2} --tol=${3} --window=${4} --skip_wgt=${5} --maxiter=${6} --kt_size=${7} --kf_size=${8} --sig_init=${9} --sig_adj=${10} --px_threshold=${11} --freq_threshold=${12} --time_threshold=${13} --infile_format=miriad --algorithm=xrfi --extension=.flags.npz --summary ${bn}OC
fi