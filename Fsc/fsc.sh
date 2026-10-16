# to run the four models 
# model1 -> topology (LinDEV,(Lin3,Lin4)) no introgression
# model2 -> topology (Lin3,(LinDEV,Lin4)) no introgression
# model3 -> topology (LinDEV,(Lin3,Lin4)) with introgression from DEV -> Lin4
# model4 -> topology (Lin3,(LinDEV,Lin4)) with introgression from Lin3 -> Lin4

# to generate the a multiSFS file of 3D populations 
#fsc27 -i model1.par -x -s0 -d -n1 --multiSFS --seed 1234 -q

#1. run fsc 100 times: Runfsc100times.sh
  #!/bin/bash
  # command: ./1.Runfsc100Times.sh fscpwd(/media/labgenoma5/DATAPART2/bandriola/Softwares/fsc28_linux64/fsc28) model_name

  fsc2=$1

  for i in {1..100}
  do
     PREFIX=$2
     mkdir run$i
     cp ${PREFIX}.par ${PREFIX}.est ${PREFIX}_DSFS.obs run$i"/"
     cd run$i
     ${fsc2} -i ${PREFIX}.par -e ${PREFIX}.est -s0 -x -d  -b 50 -M -L 100 -0 --multiSFS -c 10 -n1 --seed 1234 -q 
     cd ..
  done

#2. find the best run: fsc-findbestrun.sh
#!/bin/bash

# Bash script by Joana Meier to select the best fastsimcoal run of multiple runs under the same demographic model
# The script expects output files of different runs to be found in folders starting with run

m=-1000000000000000
p=$1
c=0
best="ConstanteSize"
diff=0
diffBest=0

for i in run{1..80};
do
 a=$(ls | grep ${p}".tpl" | sed s'/.tpl//')

 # if the file is in the run directory
 if [ -e $i/$a.bestlhoods ]
 then
   l=$(cat $i/$a.bestlhoods | awk '{print $(NF-1)}' | tail -1 | cut -f 1 -d ".")
   diff=$(cat $i/$a.bestlhoods | awk '{print $NF-$(NF-1)}' | tail -1 | cut -f 1 -d ".")
   ((c++))
 else
   # if the file is in a subdirectory
   if [ -e $i/$a/$a.bestlhoods ]
   then
     l=$(cat $i/$a/$a.bestlhoods | awk '{print $(NF-1)}' | tail -1 | cut -f 1 -d ".")
     diff=$(cat $i/$a/$a.bestlhoods | awk '{print $NF-$(NF-1)}' | tail -1 | cut -f 1 -d ".")
     ((c++))
   else
     echo "no .bestlhoods file found in "$i
   fi

 fi


 if [ $l -gt $m ]
 then
   m=$l; x=$i; best=$i;
   diffBest=$diff
 fi
done

if [ -z ${x+1} ]
then echo "Error: No run with lik>-1000000000000000"
else mkdir bestrun
cp $x/* ./bestrun/
cp $x/$a/* ./bestrun/
fi

echo -e "\n"$c" bestlhoods files found, "$best" with "$diffBest" Lhood diff fits best."
