#include<stdio.h>
#include<cuda_runtime.h>


// #define SIZE 1024*1024*1024

#define cudaCheckError(ans){gpuAssert((ans),__FILE__,__LINE__);}
inline void gpuAssert(cudaError_t code, const char *file, int line,bool abort=true){
    if(code!=cudaSuccess){
        fprintf(stderr,"Gpuassert : %s %s %d\n",cudaGetErrorString(code),file,line);
        if(abort) exit(code);
    }
    
}


#define gpuKernelCheck(){gpuKernelAssert(__FILE__,__LINE__);}
inline void gpuKernelAssert(const char* file, int line, bool abort=true){
    cudaError_t err=cudaGetLastError();
    if(err!=cudaSuccess){
        fprintf(stderr,"kernel launch failed: %s %s %d\n",cudaGetErrorString(err),file,line);
        if(abort) exit(err);
    }
}

__global__ void add(int* a, int* b, int* c,int N){
    int index =threadIdx.x+blockIdx.x*blockDim.x;
    c[index]=a[index]+b[index];

}


void random_ints(int* x, int size){
    for(int i=0;i<size;i++){
        x[i]=rand()%100;
    }
}

int main(){
    int *a,*b,*c;
    int* d_a,*d_b,*d_c;
    long long  SIZE =1024LL*1024*32;
    long size =SIZE*sizeof(int);
    // cudaError_t err;


   cudaCheckError(cudaMalloc((void**)&d_a,size));
// if(err!=cudaSuccess){
//     fprintf(stderr,"failed to allocate device memory -%s\n",cudaGetErrorString(err));
// }

    cudaCheckError(cudaMalloc((void**)&d_b,size));
//     if(err!=cudaSuccess){
//     fprintf(stderr,"failed to allocate device memory -%s\n",cudaGetErrorString(err));
// }
    cudaCheckError(cudaMalloc((void**)&d_c,size));
//     if(err!=cudaSuccess){
//     fprintf(stderr,"failed to allocate device memory -%s\n",cudaGetErrorString(err));
// }

    a=(int*) malloc(size);random_ints(a,SIZE);
    b=(int*) malloc (size);random_ints(b,SIZE);
    c=(int*) malloc (size);



    cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);



    add<<<1024*432,1024>>>(d_a,d_b,d_c,SIZE);
    gpuKernelCheck();
    cudaDeviceSynchronize();


    cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
    printf("\n execution finished \n");


    for(int i=0;i<SIZE;i++){

        printf("\n element id =%d -------->%d + %d = %d",i,a[i],b[i],c[i]);
        printf("\n");
    }



    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


    free(a);
    free(b);
    free(c);

return 0;



}