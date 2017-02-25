while read line;
do
	echo "$line";
    #xargs 
    # echo $(for target in "$@";
    #                     do
    #                         echo $line | value "$target";
    #                     done;
    #             )
done;
