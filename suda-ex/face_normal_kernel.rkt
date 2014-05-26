#lang suda
(require/typed
 [threadIdx/x (-> Integer)] [threadIdx/y (-> Integer)] [threadIdx/z (-> Integer)]
 [blockDim/x (-> Integer)] [blockDim/y (-> Integer)] [blockDim/z (-> Integer)]
 [blockIdx/x (-> Integer)] [blockIdx/y (-> Integer)]
 [gridDim/x (-> Integer)] [gridDim/y (-> Integer)]
 
 [struct Float3 ([x : Float] [y : Float] [z : Float])]
 [struct Int3 ([x : Integer] [y : Integer] [z : Integer])])

#|
face_normal_kernel(float3* points, int num_points, int3* face_pt_indices, int num_faces, 
                   float3* face_normals,
                   float3* outpoints, int* num_points_out, int3* outfaces, int* num_faces_out)
|#

(: face_normal_kernel
   ((Vectorof Float3) Integer (Vectorof Int3) Integer 
   (Vectorof Float3) -> Void))
(define (face_normal_kernel 
         lst-points num_points lst_face_pt_indices num_faces
         vec_face_normals)
  
  (let*: 
   ([block_index_1d : Integer (+ (blockIdx/x) (* (blockIdx/y) (gridDim/x)))]
    [idx : Integer (+ (threadIdx/x) (* (blockDim/x) block_index_1d))])
   (when (< idx num_faces)
     (let*: ([ptidx : Int3 (vector-ref lst_face_pt_indices idx)]
             [pt0 : Float3 (vector-ref lst-points (Int3-x ptidx))]
             [pt1 : Float3 (vector-ref lst-points (Int3-y ptidx))]
             [pt2 : Float3 (vector-ref lst-points (Int3-z ptidx))]
             
             [edge0 : Float3 
                    (make-Float3 (- (Float3-x pt1) (Float3-x pt0))
                                 (- (Float3-y pt1) (Float3-y pt0))
                                 (- (Float3-z pt1) (Float3-z pt0)))]
             [edge1 : Float3 
                    (make-Float3 (- (Float3-x pt2) (Float3-x pt0))
                                 (- (Float3-y pt2) (Float3-y pt0))
                                 (- (Float3-z pt2) (Float3-z pt0)))]
             
             [cross-x : Float (- (* (Float3-y edge0) (Float3-z edge1)) (Float3-z edge0) (Float3-y edge1))]
             [cross-y : Float (- (* (Float3-z edge0) (Float3-x edge1)) (Float3-x edge0) (Float3-z edge1))]
             [cross-z : Float (- (* (Float3-x edge0) (Float3-y edge1)) (Float3-y edge0) (Float3-x edge1))]
             
             [cross : Float3 (make-Float3 cross-x cross-y cross-z)])
             
            (vector-set! vec_face_normals idx cross)))))
             
