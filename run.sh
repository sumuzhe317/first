#!/bin/bash
#SBATCH -J SLIC
#SBATCH -p work
#SBATCH -N 1
#SBATCH --exclusive

CXX="g++"
CXXFLAGS="-std=c++11 -fopenmp"
LD="g++"
LIBS=""

echo "========="
echo "CXX=$CXX"
echo "CXXFLAGS=$CXXFLAGS"
echo "LD=$LD"
echo "LIBS=$LIBS"

$CXX $CXXFLAGS -c -o SLIC.o SLIC.cpp
$LD $LIBS -o SLIC SLIC.o

for CASE in case1 case2 case3; do

    echo "++++++++"
    echo "CASE=$CASE"

    rm -rf $CASE

    if [[ ! -f $CASE.tar.gz ]]; then
        tar xf /public1/soft/IPCC/2021/first/$CASE.tar # case2 is too large
    else
        tar xzf $CASE.tar.gz
    fi

    cd $CASE
    M_SPCOUNT=$(cat readme.txt)
    M_SPCOUNT=${M_SPCOUNT#*=}

    echo "M_SPCOUNT=$M_SPCOUNT"

    for NUM_THREADS in 64; do
        echo "-------"
        echo "OMP_NUM_THREADS=$NUM_THREADS"
        OMP_NUM_THREADS=$NUM_THREADS ../SLIC $M_SPCOUNT
    done

    cd ..
done
