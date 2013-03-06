#!/bin/sh

#written 10-24-11
if [ $# -ne 5 ]                                                                                     # usage and exit if 5 args are not supplied
then
    echo
    echo "USAGE: >avg_distances.sh <distance_matrix_file> <file_path> <groups_file> <output_file> <output_dir>"
    echo   
    echo "     <distance_matrix_file>  : (string)  name of the input distance matrix file"
    echo "     <file_path>             : (string)  path of the distance matrix file"
    echo "     <groups_list>           : (string)  name of the groups list"
    echo "     <output_file>           : (string)  name for the outptu file (will be appended as *.AVG_DIST)"
    echo "     <output_dir>            : (string)  path for the output"
    echo
    echo " use example:"
    echo " for i in `cat ./DISTs/list`; do avg_distances.sh ./DISTs/$i groups ./AVG_DISTs/$i.test; done & "
    echo
    exit 1
fi

time_stamp=`date +%m-%d-%y_%H:%M:%S:%N`;  # create the time stamp month-day-year_hour:min:sec:nanosec
process_stamp=$$; # added 4-5-12 to take care of possible non-unique outputs that over-write each other

# write R script
echo "# script generated by plot_pco_shell.sh to run avg_distances.10-25-11.r" >> avg_distances_script.$time_stamp.$process_stamp.r
echo "# time stamp: $time_stamp" >> avg_distances_script.$time_stamp.$process_stamp.r
echo "source(\"~/bin/avg_distances.10-25-11.r\")" >> avg_distances_script.$time_stamp.$process_stamp.r
echo "avg_distances(distance_matrix_file = \"$1\", file_path = \"$2\", groups_list = \"$3\", output_file = \"$4\", output_dir = \"$5\")" >> avg_distances_script.$time_stamp.$process_stamp.r

# run R script
R --vanilla --slave < avg_distances_script.$time_stamp.$process_stamp.r

# remove R script
if [ -e avg_distances_script.$time_stamp.$process_stamp.r ]
then
    rm avg_distances_script.$time_stamp.$process_stamp.r
    #echo "DONE with "avg_distances_script.$time_stamp.r
fi