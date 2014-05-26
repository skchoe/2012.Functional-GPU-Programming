#include "(just-meta 0 (rename ../typed-utils/cuda-vars.rkt struct:Float3 struct:Float3)).h";

typedef struct Float3 {
float x;
float y;
float z;
} Float3;
void make_Float3 (float x30834 , float y30835 , float z30836 , Float3* Float330837 ) {
	Float330837->x = x30834;
	Float330837->y = y30835;
	Float330837->z = z30836;

};
float* Float3_x (Float3* Float331072) {
	float* x31073 = Float331072->x;
	return x31073;
}
float* Float3_y (Float3* Float331078) {
	float* y31079 = Float331078->y;
	return y31079;
}
float* Float3_z (Float3* Float331084) {
	float* z31085 = Float331084->z;
	return z31085;
}
