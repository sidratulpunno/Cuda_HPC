#include<stdio.h>
#include<cuda_runtime.h>


#define SIZE 2048


__global__ void vectorAdd(int* A, int* B, int* C,int n){
    int i =threadIdx.x+blockIdx.x*blockDim.x;
    C[i]=A[i]+B[i];

}


int main(){
    int *A,*B,*C;
    int* d_A,*d_B,*d_C;
    int size =SIZE*sizeof(int);



    A=(int*) malloc(size);
    B=(int*) malloc (size);
    C=(int*) malloc (size);


    cudaMalloc((void**)&d_A,size);
    cudaMalloc((void**)&d_B,size);
    cudaMalloc((void**)&d_C,size);


    for(int i=0;i<SIZE;i++){
        A[i]=i;
        B[i]=SIZE-i;

    }

    cudaMemcpy(d_A,A,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_B,B,size,cudaMemcpyHostToDevice);



    vectorAdd<<<2,1024>>>(d_A,d_B,d_C,SIZE);


    cudaMemcpy(C,d_C,size,cudaMemcpyDeviceToHost);
    printf("\n execution finished \n");


    for(int i=0;i<SIZE;i++){

        printf("%d + %d = %d",A[i],B[i],C[i]);
        printf("\n");
    }



    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);


    free(A);
    free(B);
    free(C);

return 0;



}