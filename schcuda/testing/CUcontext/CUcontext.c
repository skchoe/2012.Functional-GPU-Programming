#include <stdio.h>
#include <malloc.h>
#define MAX 100
typedef struct CUctx_st *CUcontext;

int num_pctx = 1;

CUcontext **ctx_store;

int num_ctx = 0; // initial size of ctx's
int current_ctx_id = 0;
CUcontext ctx;

void cuAttach(CUcontext* cc)
{
    printf("Attach %d\n", cc);
    ctx_store[current_ctx_id] = cc;
    
    current_ctx_id++;
    num_ctx++;
}


int cuDetach(CUcontext ctx)
{
    printf("Detach of %d\n", ctx);
    printf("Detach of %d\n", &ctx);

    int i;
    for(i=0;i< num_ctx;i++)
    {
	if(*(ctx_store[i]) == ctx){
	    ctx_store[i] = NULL;
	    //free(&ctx);
	    num_ctx--;
	    printf ("found ctx of same value\n");
	}
    }
    if(num_ctx==0) free (ctx_store);
    return 0;
}

int cuCreate(CUcontext *ctx)
{
    printf("Create\n");
    if (num_ctx==0)
	ctx_store = (CUcontext**)malloc(MAX * sizeof(CUcontext*));

    cuAttach(ctx);
    return 0;
}


int main(int argc, char** argv)
{
    int i = cuCreate(&ctx);

    cuAttach(&ctx);
    printf("pointer of ctx = %d\n", &ctx);
    printf(" of ctx = %d\n", ctx);
    printf ("%d\n", cuDetach(ctx));
}
