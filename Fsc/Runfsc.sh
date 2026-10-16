echo "starting..."
cd LGMBottleneck/
./Runfsc100times.sh /media/labgenoma5/DATAPART6/bandriola/Softwares/fsc28_linux64/fsc28 Lin7 > saida.log 2> error.log
cd ../LGMexpansion/
./Runfsc100times.sh /media/labgenoma5/DATAPART6/bandriola/Softwares/fsc28_linux64/fsc28 Lin7 > saida.log 2> error.log
cd ../ParamTfixed/
./Runfsc100times.sh /media/labgenoma5/DATAPART6/bandriola/Softwares/fsc28_linux64/fsc28 Lin7 > saida.log 2> error.log
cd ../ParamTnotfixed/
./Runfsc100times.sh /media/labgenoma5/DATAPART6/bandriola/Softwares/fsc28_linux64/fsc28 Lin7 > saida.log 2> error.log
echo "done"
