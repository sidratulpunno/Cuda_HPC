#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>


__global__ void test01(){

printf("\n The block id is %d, and thread id is %d\n",blockIdx.x,threadIdx.x);
}


int main(){
    test01<<<128,1024>>>();
    cudaDeviceSynchronize();
    return 0;
}