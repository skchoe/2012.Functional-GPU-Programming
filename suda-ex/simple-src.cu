
float n2553;
n2553 = 1.0;

float A = n2553;
void id(float x , float* float2604 ) {
float x2609;
x2609 = x;

*float2604 = x2609;
return;
}


int* vec_2721;
int n2656;
n2656 = 1;

int n2671;
n2671 = 2;

int n2686;
n2686 = 3;

int n2701;
n2701 = 4;

int n2716;
n2716 = 5;
int* vgrp_2738[] = {n2656, n2671, n2686, n2701, n2716};
vec_2721 = vgrp_2738;

int* exlst = vec_2721;
void return_2_val(int* int2785 , float* float2786 ) {
int n2817;
float n2832;
int n2817;
n2817 = 1;

float n2832;
n2832 = 1.0;

*int2785 = n2817;
*float2786 = n2832;
return;
}

void test_apply(float expr , float* float2918 ) {
float add12990;
float expr2969;
expr2969 = expr;
add1(expr2969);

*float2918 = add12990;
return;
}


int n3025;
n3025 = 123;

int ex = n3025;
void ey(int a , int* int3038 ) {
int proc_3131;
int n3077;
n3077 = 1;

int a3100;
a3100 = a;
proc_3131 = ( n3077 + a3100 );

*int3038 = proc_3131;
return;
}

int ey3199;
int n3188;
n3188 = 1;
ey(n3188);

int n3220;
n3220 = 10;

int blocksize = n3220;

int n3321;
n3321 = 100;

int blocksize2 = n3321;
void single-value1(int n , int* int3334 ) {
int proc_3427;
int n3381;
n3381 = n;

int n3396;
n3396 = 1;
proc_3427 = ( n3381 + n3396 );

*int3334 = proc_3427;
return;
}

int single-value13495;
int n3484;
n3484 = 32;
single-value1(n3484);
void single-value2(int n , int m , int* int3510 ) {
int n3529;
n3529 = n;
int m3538;
m3538 = m;

*int3510 = m3538;
return;
}

int single-value23715;
int n3687;
n3687 = 2;

int n3702;
n3702 = 3;
single-value2(n3687, n3702);
void single-value(int n , int* int3735 ) {
int n3740;
n3740 = n;

*int3735 = n3740;
return;
}

void multi-value(int n , int* int3771 , int* int3772 ) {
int n3795;
int proc_3884;
int n3795;
n3795 = n;

int proc_3884;
int n3832;
n3832 = -1;

int n3855;
n3855 = n;
proc_3884 = ( n3832 * n3855 );

*int3771 = n3795;
*int3772 = proc_3884;
return;
}

void void-ftn!(int arg , int arg2 , void* void3937 ) {

int blocksize3964;
blocksize3964 = blocksize;
arg = blocksize3964;
return;
}

void negate(int a , int* int4013 ) {
int a;
(a)? 0 : a
*int4013 = a;
return;
}

void change-sign(float n , float* float4050 ) {
float proc_4144;
int n4089;
n4089 = -1;

float n4112;
n4112 = n;
proc_4144 = ( n4089 * n4112 );

*float4050 = proc_4144;
return;
}

