#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#written 10-18-11
if [ $# -ne 7 ]                                                                                     # usage and exit if 4 args are not supplied
then
    echo
    echo "USAGE: >plot_pco_shell.sh <file_in> <inupt_dir> <output_PCoA_dir> <print_dist> <output_DIST_dir> <dist_method> <headers>"
    echo   
    echo "     <file_in>         : (string)  name of the input file (tab delimited file)"
    echo "     <input_dir>       : (string)  directory that contains file_in"
    echo "     <output_PCoA_dir> : (string)  directory for the output *.PCoA file"
    echo "     <print_dist>      : (boolean) [ 0 | 1 ] print distance matrices"
    echo "     <output_DIST_dir> : (string)  directory for the output *.DIST files"
    echo "     <dist_method>     : (string)  distance method ( bray-curtis | maximum     | canberra  |" 
    echo "                                                     binary      | minkowski   | euclidean |" 
    echo "                                                     jacccard    | mahalanobis | sorensen  |" 
    echo "                                                     manhattan   | difference )"     
    echo "     <headers>         : (boolean) [ 0 | 1 ] print headers in the PCoA output files"         
    echo 
    echo " # Script produces *.DIST and *.PCoA outputs using the specified OTU method"    
    exit 1
fi

time_stamp=`date +%m-%d-%y_%H:%M:%S:%N`;  # create the time stamp month-day-year_hour:min:sec:nanosec

echo "# script generated by plot_pco_shell.sh to run plot_pco.r" >> plot_pco_script.$time_stamp.r
echo "# time stamp; $time_stamp" >> plot_pco_script.$time_stamp.r
echo "source(\"$DIR/plot_pco.r\")" >> plot_pco_script.$time_stamp.r
echo "MGRAST_plot_pco(file_in = \"$1\", input_dir = \"$2\", output_PCoA_dir = \"$3\", print_dist = $4, output_DIST_dir = \"$5\" , dist_method = \"$6\", headers = $7)" >> plot_pco_script.$time_stamp.r

# check R version and installed pacakges
echo "$0" >> R_check.log
my_r=`which R`
installed_packages=`echo 'installed.packages()' | R --slave`
echo "my_r: $my_r" >> R_check.log
echo "installed_r_packages: " >> R_check.log
echo "$installed_packages" >> R_check.log
echo "" >> R_check.log

R --vanilla --slave < plot_pco_script.$time_stamp.r

if [ -e plot_pco_script.$time_stamp.r ]
then
    rm -f plot_pco_script.$time_stamp.r
    #echo "Done with "plot_pco_script.$time_stamp.r
fi
