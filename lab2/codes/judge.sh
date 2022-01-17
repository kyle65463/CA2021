for i in {1..4}; do
    cp ../testdata/instruction_$i.txt instruction.txt
    cp ../testdata/cache_$i.txt cache_ref.txt
    cp ../testdata/output_$i.txt output_ref.txt
    ./run.sh &> /dev/null
    diff -u <(tail -n 20 output_ref.txt) <(tail -n 20 output.txt)
    echo "Complete test case $i"
done