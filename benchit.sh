#!/bin/bash
if [ "$1" = "--help" ] || [ $# -lt 1 ]; then
    echo "This app runs the fio benchmarks using the files generated by createfiojobfiles.sh"
    echo "The expected input is a number that corresponds to the number of loadgeneration systems"
    echo "The loadgeneration systems are expected to be named loadgen1, loadgen2, etc"
    echo "Each loadgen system should have fio installed and running in server mode"
    echo "e.g. fio --server &"
    echo "LOCAL RUN - if the only parameter passed is 'local', the script will "
    echo "run fio using the local host and the created jobfiles"
    exit
fi
for i in 4kr 4kw 8kr 8kw 64kr 64kw 1mr 1mw; do
command=""
if [ "$1" = "local" ]; then 
    command=" $i.fio"
else
    if [ $# -eq 1 ]; then
            gseq=$(seq 1 $1)
    elif [ $# -eq 2 ]; then
	gseq=$(seq 1 $2 $1)
    fi
    for g in $gseq; do
    	echo $g
	commandset=("--client=loadgen"$g)
	command+="$commandset $i.fio "
    done
fi
	echo "running $i "
	fio $command >$i.out
	fio2gnuplot -b -g -o $i
	fio2gnuplot -i -g -o $i
        mkdir archive
	mv $i*.log archive
done

