for i in *_average_depth_per_scaffold.txt; 
  do awk -F' ' '{if ($2+0 > 20 && $2+0 < 60) print $0}' "$i" > "${i%.txt}_more20less60covregions.txt"
done
