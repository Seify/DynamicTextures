    /*
 
 File: matrix.c
 
 Abstract: simple 4x4 matrix computations
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
*/

#include <string.h>
#include <math.h>
#include "matrix.h"

/*
 NOTE: These functions are created for your convenience but the matrix algorithms 
 are not optimized. You are encouraged to do additional research on your own to 
 implement a more robust numerical algorithm.
*/

void mat4f_LoadIdentity(float* m)
{
	m[0] = 1.0f;
	m[1] = 0.0f;
	m[2] = 0.0f;
	m[3] = 0.0f;
	
	m[4] = 0.0f;
	m[5] = 1.0f;
	m[6] = 0.0f;
	m[7] = 0.0f;
	
	m[8] = 0.0f;
	m[9] = 0.0f;
	m[10] = 1.0f;
	m[11] = 0.0f;	

	m[12] = 0.0f;
	m[13] = 0.0f;
	m[14] = 0.0f;
	m[15] = 1.0f;
}

// s is a 3D vector
void mat4f_LoadScale(float* s, float* m)
{
	m[0] = s[0];
	m[1] = 0.0f;
	m[2] = 0.0f;
	m[3] = 0.0f;
	
	m[4] = 0.0f;
	m[5] = s[1];
	m[6] = 0.0f;
	m[7] = 0.0f;
	
	m[8] = 0.0f;
	m[9] = 0.0f;
	m[10] = s[2];
	m[11] = 0.0f;	
	
	m[12] = 0.0f;
	m[13] = 0.0f;
	m[14] = 0.0f;
	m[15] = 1.0f;
}

void mat4f_LoadXRotation(float radians, float* m)
{
	float cosrad = cosf(radians);
	float sinrad = sinf(radians);
	
	m[0] = 1.0f;
	m[1] = 0.0f;
	m[2] = 0.0f;
	m[3] = 0.0f;
	
	m[4] = 0.0f;
	m[5] = cosrad;
	m[6] = sinrad;
	m[7] = 0.0f;
	
	m[8] = 0.0f;
	m[9] = -sinrad;
	m[10] = cosrad;
	m[11] = 0.0f;	
	
	m[12] = 0.0f;
	m[13] = 0.0f;
	m[14] = 0.0f;
	m[15] = 1.0f;
}

void mat4f_LoadYRotation(float radians, float* mout)
{
	float cosrad = cosf(radians);
	float sinrad = sinf(radians);
	
	mout[0] = cosrad;
	mout[1] = 0.0f;
	mout[2] = -sinrad;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = 1.0f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = sinrad;
	mout[9] = 0.0f;
	mout[10] = cosrad;
	mout[11] = 0.0f;	
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}

void mat4f_LoadZRotation(float radians, float* mout)
{
	float cosrad = cosf(radians);
	float sinrad = sinf(radians);
	
	mout[0] = cosrad;
	mout[1] = sinrad;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = -sinrad;
	mout[5] = cosrad;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = 1.0f;
	mout[11] = 0.0f;	
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}


//матрица поворота по трем осям. Отсюда: http://www.3dcodingtutorial.com/Basic-OpenGL-functions/Translate-and-Rotate-functions.html
void mat4f_LoadXYZRotation(float radiansX, float radiansY, float radiansZ, float* m)
{	
#define alpha radiansX
#define beta radiansY
#define gamma radiansZ    
    
	m[0] = cosf(alpha)*cosf(beta);
	m[1] = sinf(alpha)*cos(beta);
	m[2] = -sinf(beta);
	m[3] = 0.0f;
	
	m[4] = cosf(alpha)*sinf(beta)*sinf(gamma)-sinf(alpha)*cosf(gamma);
	m[5] = sinf(alpha)*sinf(beta)*sinf(gamma)+cosf(alpha)*cosf(gamma);
	m[6] = cosf(beta)*sinf(gamma);
	m[7] = 0.0f;
	
	m[8] = cosf(alpha)*sinf(beta)*cosf(gamma)+sinf(alpha)*sinf(gamma);
	m[9] = sinf(alpha)*sinf(beta)*cosf(gamma)-cosf(alpha)*sinf(gamma);
	m[10] = cosf(beta)*cosf(gamma);
	m[11] = 0.0f;	
	
	m[12] = 0.0f;
	m[13] = 0.0f;
	m[14] = 0.0f;
	m[15] = 1.0f;
}



//матрица поворота по трем осям. Отсюда: http://www.3dcodingtutorial.com/Basic-OpenGL-functions/Translate-and-Rotate-functions.html
void mat3f_LoadXYZRotation(float radiansX, float radiansY, float radiansZ, float* m)
{	
#define alpha radiansX
#define beta radiansY
#define gamma radiansZ    
    
	m[0] = cosf(alpha)*cosf(beta);
	m[1] = sinf(alpha)*cos(beta);
	m[2] = -sinf(beta);
	
	m[3] = cosf(alpha)*sinf(beta)*sinf(gamma)-sinf(alpha)*cosf(gamma);
	m[4] = sinf(alpha)*sinf(beta)*sinf(gamma)+cosf(alpha)*cosf(gamma);
	m[5] = cosf(beta)*sinf(gamma);
	
	m[6] = cosf(alpha)*sinf(beta)*cosf(gamma)+sinf(alpha)*sinf(gamma);
	m[7] = sinf(alpha)*sinf(beta)*cosf(gamma)-cosf(alpha)*sinf(gamma);
	m[8] = cosf(beta)*cosf(gamma);
}

// v is a 3D vector
void mat4f_LoadTranslation(float* v, float* mout)
{
	mout[0] = 1.0f;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = 1.0f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = 1.0f;
	mout[11] = 0.0f;	
	
	mout[12] = v[0];
	mout[13] = v[1];
	mout[14] = v[2];
	mout[15] = 1.0f;
}

void mat4f_LoadXYZTranslation(float transX, float transY, float transZ, float* mout)
{
	mout[0] = 1.0f;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = 1.0f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = 1.0f;
	mout[11] = 0.0f;	
	
	mout[12] = transX;
	mout[13] = transY;
	mout[14] = transZ;
	mout[15] = 1.0f;
}

void mat4f_LoadXYZScale(float scaleX, float scaleY, float scaleZ, float* mout)
{
	mout[0] = scaleX;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = scaleY;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = scaleZ;
	mout[11] = 0.0f;	
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}


// моя функция для вычисления перспективной матрицы
// http://www.songho.ca/opengl/gl_projectionmatrix.html

void mat4f_LoadPerspective2(float near, float far, float top, float right, float* mout)
{
	
	mout[0] = near / right;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = near / top;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = - (far+near) / (far-near);
	mout[11] = -2 * far * near / (far - near);
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = -1.0f;
	mout[15] = 0.0f;
}

void BuildPerspProjMat(float *m, float fov, float aspect,
                       float znear, float zfar)
{
    
    #define PI_OVER_360 0.0087266
    
    float xymax = znear * tan(fov * PI_OVER_360);
    float ymin = -xymax;
    float xmin = -xymax;
    
    float width = xymax - xmin;
    float height = xymax - ymin;
    
    float depth = zfar - znear;
    float q = -(zfar + znear) / depth;
    float qn = -2 * (zfar * znear) / depth;
    
    float w = 2 * znear / width;
    w = w / aspect;
    float h = 2 * znear / height;
    
    m[0]  = w;
    m[1]  = 0;
    m[2]  = 0;
    m[3]  = 0;
    
    m[4]  = 0;
    m[5]  = h;
    m[6]  = 0;
    m[7]  = 0;
    
    m[8]  = 0;
    m[9]  = 0;
    m[10] = q;
    m[11] = -1;
    
    m[12] = 0;
    m[13] = 0;
    m[14] = qn;
    m[15] = 0;
}

void mat4f_LoadPerspective(float fov_radians, float aspect, float zNear, float zFar, float* mout)
{
	float f = 1.0f / tanf(fov_radians/2.0f);
	
	mout[0] = f / aspect;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = (zFar+zNear) / (zNear-zFar);
	mout[11] = -1.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 2 * zFar * zNear /  (zNear-zFar);
	mout[15] = 0.0f;
}

void mat4f_LoadOrtho(float left, float right, float bottom, float top, float near, float far, float* mout)
{ 
	float r_l = right - left;
	float t_b = top - bottom;
	float f_n = far - near;
	float tx = - (right + left) / (right - left);
	float ty = - (top + bottom) / (top - bottom);
	float tz = - (far + near) / (far - near);

	mout[0] = 2.0f / r_l;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = 2.0f / t_b;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = -2.0f / f_n;
	mout[11] = 0.0f;
	
	mout[12] = tx;
	mout[13] = ty;
	mout[14] = tz;
	mout[15] = 1.0f;
}

void mat4f_MultiplyMat4f(const float* a, const float* b, float* mout)
{
	mout[0]  = a[0] * b[0]  + a[4] * b[1]  + a[8] * b[2]   + a[12] * b[3];
	mout[1]  = a[1] * b[0]  + a[5] * b[1]  + a[9] * b[2]   + a[13] * b[3];
	mout[2]  = a[2] * b[0]  + a[6] * b[1]  + a[10] * b[2]  + a[14] * b[3];
	mout[3]  = a[3] * b[0]  + a[7] * b[1]  + a[11] * b[2]  + a[15] * b[3];

	mout[4]  = a[0] * b[4]  + a[4] * b[5]  + a[8] * b[6]   + a[12] * b[7];
	mout[5]  = a[1] * b[4]  + a[5] * b[5]  + a[9] * b[6]   + a[13] * b[7];
	mout[6]  = a[2] * b[4]  + a[6] * b[5]  + a[10] * b[6]  + a[14] * b[7];
	mout[7]  = a[3] * b[4]  + a[7] * b[5]  + a[11] * b[6]  + a[15] * b[7];

	mout[8]  = a[0] * b[8]  + a[4] * b[9]  + a[8] * b[10]  + a[12] * b[11];
	mout[9]  = a[1] * b[8]  + a[5] * b[9]  + a[9] * b[10]  + a[13] * b[11];
	mout[10] = a[2] * b[8]  + a[6] * b[9]  + a[10] * b[10] + a[14] * b[11];
	mout[11] = a[3] * b[8]  + a[7] * b[9]  + a[11] * b[10] + a[15] * b[11];

	mout[12] = a[0] * b[12] + a[4] * b[13] + a[8] * b[14]  + a[12] * b[15];
	mout[13] = a[1] * b[12] + a[5] * b[13] + a[9] * b[14]  + a[13] * b[15];
	mout[14] = a[2] * b[12] + a[6] * b[13] + a[10] * b[14] + a[14] * b[15];
	mout[15] = a[3] * b[12] + a[7] * b[13] + a[11] * b[14] + a[15] * b[15];
}

void makePerspectiveMatrix(const float *scaleMatrix, const float *translationMatrix, const float *rotationMatrix, const float *projectionMatrix, float* mout){

    float tempMatrix[16], modelview[16];
    
    mat4f_MultiplyMat4f(translationMatrix, scaleMatrix, tempMatrix);
    mat4f_MultiplyMat4f(tempMatrix, rotationMatrix, modelview);
    mat4f_MultiplyMat4f(projectionMatrix, modelview, mout); 
}


// rotate X matrix:
/*        
 {
 1.0,        0.0,        0.0,        0.0,
 0.0, cos(angle), sin(angle),        0.0,
 0.0,-sin(angle), cos(angle),        0.0,
 0.0,        0.0,        0.0,        1.0,        
 };
 */        

// rotate Y matrix:       
/*
 {
 cos(angle),    0.0, -sin(angle),        0.0,
 0.0,    1.0,         0.0,        0.0,
 sin(angle),    0.0,  cos(angle),        0.0,
 0.0,    0.0,         0.0,        1.0,        
 };
 */

// rotate Z matrix:
/*
 {
 cos(angle),  -sin(angle),     0.0,        0.0,                                                
 sin(angle),   cos(angle),     0.0,        0.0,                                                
 0.0,          0.0,     1.0,        0.0,                                                
 0.0,          0.0,     0.0,        1.0,    
 };
 */

// единичная матрица
/*
 {
 1.0, 0.0, 0.0, 0.0,
 0.0, 1.0, 0.0, 0.0,
 0.0, 0.0, 1.0, 0.0,
 0.0, 0.0, 0.0, 1.0,        
 };
 */

// Projection Matrix:
/*        
 {
 2*n/(r-l),    0.0,   (r+l)/(r-l),   0.0,
 0.0,    2*n/(t-b),    (t+b)/(t-b),    0.0,
 0.0,    0.0,    -(f+n)/(f-n),   -2*f*n/(f-n),
 0.0,    0.0,    -1.0, 0.0
 };
 */
