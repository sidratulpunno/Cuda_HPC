#include<stdio.h>
#include<cuda_runtime.h>


#define SIZE 1024*32*1024


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
    int size =SIZE*sizeof(int);


    cudaMalloc((void**)&d_a,size);
    cudaMalloc((void**)&d_b,size);
    cudaMalloc((void**)&d_c,size);

    a=(int*) malloc(size);random_ints(a,SIZE);
    b=(int*) malloc (size);random_ints(b,SIZE);
    c=(int*) malloc (size);



    cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);



    add<<<1024*432,1024>>>(d_a,d_b,d_c,SIZE);
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