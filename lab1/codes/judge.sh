for i in {1..3}; do
    cp ../testdata/instruction_$i.txt instruction.txt
    cp ../testdata/output_$i.txt output_ref.txt
    ./run.sh &> /dev/null
    diff output_ref.txt output.txt
    echo "Complete test case $i"
done