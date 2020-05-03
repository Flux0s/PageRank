#!/bin/bash


run_algorithm() {
    for i in 1 2 3 4 5
    do
        ./ParallelPageRank --n=$1 --p=$2 --display_ranks=false --max_iterations=50
    done
}

echo "n=10"
for i in 1 2 5 10
do
    run_algorithm 10 $i
done

echo "n=50"
for i in 1 2 5 10 25 50
do
    run_algorithm 50 $i
done

echo "n=100"
for i in 1 2 5 10 50 100
do
    run_algorithm 100 $i
done

echo "n=1000"
for i in 1 2 5 10 100 500 1000
do
    run_algorithm 1000 $i
done

echo "n=5000"
for i in 1 2 5 10 100 500 1000
do
    run_algorithm 1000 $i
done

echo "n=10000"
for i in 1 2 5 10 100 1000 2500 5000
do
    run_algorithm "10000" $i
done