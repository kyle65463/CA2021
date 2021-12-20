id=b08902003
dir=${id}_lab1
excluded=('PC.v' 'Instruction_Memory.v' 'Data_Memory.v' 'Registers.v')

mkdir $dir $dir/codes
cp *.v $dir/codes
# cp ${id}_lab1_report.pdf $dir

for file in ${excluded[@]}; do
    rm $dir/codes/$file
done

zip -r $dir.zip $dir
rm -rf $dir