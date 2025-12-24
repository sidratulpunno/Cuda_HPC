#include <cuda_runtime.h>
#include <stdio.h>


int main(){
    int device;
    cudaGetDevice(&device);
    cudaDeviceProp prop;


    cudaGetDeviceProperties(&prop,device);
    printf("Max threads per sm  0: %d \n",prop.maxThreadsPerMultiProcessor);
    printf("Max warps per sm  0: %d \n\n\n",(prop.maxThreadsPerMultiProcessor)/32);



    int maxThreadsPerMP=0;

    cudaDeviceGetAttribute(&maxThreadsPerMP,cudaDevAttrMaxThreadsPerMultiProcessor,device);
    printf("Max threads per sm  1: %d \n",maxThreadsPerMP);
    printf("Max warps per sm    1: %d  \n",(maxThreadsPerMP)/32);

    return 0;

}