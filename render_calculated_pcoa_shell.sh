#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # get the path for the script
#written 10-24-11
if [ $# -ne 9 ]                                                                                     # usage and exit if 5 args are not supplied
then
    echo
    echo "USAGE: >render_calculated_pcoa_shell.sh <pcoa_in> <pcoa_path> <groups_in> <groups_path> <png_width> <png_height> <png_dpi> <relative_width_legend> <relative_width_pcoa> <png_legend_cex> <png_figure_cex>"
    echo   
    echo "     <pcoa_in>                : (string) name of the input PCoA flat file"
    #echo "     <pcoa_path>              : (string)  path of the PCoA file"
    echo "     <groups_in>              : (string) name of the groups file"
    #echo "     <groups_path>            : (string)  path of the groups file"
    echo "     <png_width>              : (int)    width in inches for the png"
    echo "     <png_height>             : (int)    height in inches for the png"
    echo "     <png_dpi>                : (int)    resolution in dpi for the png"
    echo "     <relative_width_legend>  : (float)  proportion of width used for legend" 
    echo "     <relative_width_pcoa>    : (float)  proportion of width used for pcoa"
    echo "     <png_legend_cex>         : (float)  cex value (font scaling) for the legend"
    echo "     <png_figure_cex>         : (float)  cex value (font scaling) for the pcoa"
    echo ""
    echo "     All (9) of these arguments are required"
    echo ""
    exit 1
fi

time_stamp=`date +%m-%d-%y_%H:%M:%S:%N`;  # create the time stamp month-day-year_hour:min:sec:nanosec
process_stamp=$$; # added 4-5-12 to take care of possible non-unique outputs that over-write each other

# write R script
echo "# script generated by render_calculated_pcoa_shell.sh to render_calculated_pcoa.r" >> my_script.$time_stamp.$process_stamp.r
echo "# time stamp: $time_stamp" >> my_script.$time_stamp.$process_stamp.r
echo "source(\"$DIR/render_calculated_pcoa.r\")" >> my_script.$time_stamp.$process_stamp.r
echo "render_pcoa( PCoA_in = \"$1\", amethst_groups = \"$2\", image_width_in = $3, image_height_in = $4, image_res_dpi = $5, width_legend = $6, width_figure = $7, legend_cex = $8, figure_cex = $9 )" >> my_script.$time_stamp.$process_stamp.r

# check R version and installed pacakges
echo "$0" >> R_check.log
my_r=`which R`
installed_packages=`echo 'installed.packages()' | R --slave`
echo "my_r: $my_r" >> R_check.log
echo "installed_r_packages: " >> R_check.log
echo "$installed_packages" >> R_check.log
echo "" >> R_check.log

# run R script
R --vanilla --slave < my_script.$time_stamp.$process_stamp.r

# remove R script
if [ -e my_script.$time_stamp.$process_stamp.r ]
then
    rm my_script.$time_stamp.$process_stamp.r
    #echo "DONE with "avg_distances_script.$time_stamp.r
fi









