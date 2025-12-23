#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h> 


__global__ void test01(){
    int warp_Id_value=0;
    warp_Id_value=threadIdx.x/32;

printf("\n The block id is %d, and thread id is %d and warp id is %d\n",blockIdx.x,threadIdx.x,warp_Id_value);
}


int main(){
    test01<<<2,128>>>();
    cudaDeviceSynchronize();
    return 0;
}