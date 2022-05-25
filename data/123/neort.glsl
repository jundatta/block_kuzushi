// MIT Lisence
//
// Copyright (c) 2019 @gyabo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the software, and to permit persons to whom the software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
precision highp float;

//testneji gyabo
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float map(vec3 p) {
	float t = 10.0 + dot(p, vec3(0, 1, 0));
	float ti = time * 0.1;
	float tir = floor(ti);
	float tif = fract(ti);
	vec3 tp = p;
	for(int i = 0 ; i < 3; i++) {
		p = tp;
		p.x += 1.0;
		t = min(t, length(mod(p.xz, 2.0) - 1.0) - 0.12);
		p.x += sin(p.y * 40.0 - time * 15.0) * 0.1;
		p.z += cos(p.y * 40.0 - time * 15.0) * 0.1;
		t = min(t, length(mod(p.xz, 2.0) - 1.0) - 0.1);
		tp = tp.zxy;
	}
	
	return t;
}

vec2 rot(vec2 p, float a) {
	float c = cos(a);
	float s = sin(a);
	
	return vec2(
		p.x * c - p.y * s,
		p.x * s + p.y * c);
		
}


vec3 getnor(vec3 p) {
	vec2 dd = vec2(0.01, 0.0);
	vec3 kn = vec3(0.0);
	kn.x = map(p) - map(p + dd.xyy);
	kn.y = map(p) - map(p + dd.yxy);
	kn.z = map(p) - map(p + dd.yyx);
	return normalize(kn);
	
}

void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	uv.x *= resolution.x / resolution.y;
	float ti = time * 0.1;
	vec3 pos = vec3(ti, ti, ti) * 5.0;
	vec3 dir = normalize(vec3(uv, 1.0));
	
	float tir = floor(ti);
	float tif = fract(ti);
	float tism = smoothstep(0.01, 0.5, tif);

	dir.xy = rot(dir.xy, tism + tir);
	dir.xz = rot(dir.xz, tism + tir);

	
	float t = 0.0;
	for(int i = 0 ; i < 256; i++) {
		float tm = map(pos + dir * t);
		if(tm < 0.01) break;
		t += tm * 0.2;
	}
	vec3 ip = pos + dir * t;
	vec3 L = normalize(vec3(1,2,3));
	vec3 V = normalize(ip);
	vec3 N = getnor(ip);
	vec3 H = normalize(V + N);
	float D = max(0.1, dot(L, N));
	float S = pow(max(0.1, dot(L, H)), 16.0);
	gl_FragColor = vec4(D * S * vec3(1,2,10) + vec3(3,2,1) * vec3(pow(t, 2.0)) * 0.002 + map(ip + 0.01), 1.0);
}
