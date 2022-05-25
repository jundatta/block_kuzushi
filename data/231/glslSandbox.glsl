#ifdef GL_ES
precision highp float;
#endif


uniform float 		time;
uniform vec2 		mouse;
uniform vec2 		resolution;
uniform sampler2D 	renderbuffer;
varying vec2 		surfacePosition;

#define ba 		1.53884176859
#define iphi 	 	.6180339887498948
#define phi 		1.6180339887498948
#define aspect		(resolution/min(resolution.x, resolution.y))
#define scale		(.25-2./resolution.y)

// dashxdr 2020 07 11
// Penrose tiling, experiment with inflation/deflation
// https://www.maa.org/sites/default/files/pdf/pubs/focus/Gardner_PenroseTilings1-1977.pdf
float cr(vec2 p, vec2 a, vec2 b) 
{
	a 	= normalize(a-b);// dot(a-b, vec2(1.,1.)) == 0. ? vec2(0., 0.) : normalize(a-b);
	b 	= p - b;
	
	return (a.y * b.x - a.x * b.y);
}


float interiorDist(vec2 p, vec2 a, vec2 b, vec2 c) 
{	
	if(cr(c,a,b) > 0.) 
	{
		vec2 t	= a;
		a	= c;
		c	= t;
	}
	
	return max(cr(p,a,b), max(cr(p,b,c), cr(p,c,a)));
}


bool inside(vec2 p, vec2 a, vec2 b, vec2 c) 
{	
	return interiorDist(p, a, b, c) <= 0.;
}


mat2 rmat(float t)
{
	float c = cos(t);
	float s = sin(t);
	return mat2(c, s, -s, c);
}


float map(vec2 p)
{
	vec2 m	= (1.-mouse-.5)*aspect*ba;
	float r = length((p-m))-.125;
	//return r;
	float s = abs(sin(p.x*phi+time*.25)-p.y*phi) * pow(phi, -3.);
	return min(abs(r),max(s, s-r));			
}


vec3 hsv(in float h, in float s, in float v)
{
    	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


float line(vec2 p, vec2 a, vec2 b, float w)
{
	if(a==b)return(0.);
	float d = distance(a, b);
	vec2  n = normalize(b - a);
   	 vec2  l = vec2(0.);
	l.x = max(abs(dot(p - a, n.yx * vec2(-1.0, 1.0))), 0.0);
	l.y = max(abs(dot(p - a, n) - d * 0.5) - d * 0.5, 0.0);
	return step(.125, clamp(smoothstep(w, 0., l.x+l.y), 0., 1.));
}


vec3 penrose(vec2 pos)
{	
	vec2 t				= vec2(0., 0.);
	
	float octant			= floor((atan(-(pos.x+.5)*scale, -(pos.y+.5)*scale) * (1./(8.*atan(1.))) + .5) * 8.);
	bool lower 			= false;
	bool top 			= gl_FragCoord.y/resolution.x > .5;
	
	 vec3(0., 0., 0.);
	
	float theta 			= ceil(fract(atan(-pos.x, -pos.y) * (1./(8.*atan(1.))) + .5 - .5/10.) * 10.);
	float rho 			= (8. * atan(1.))/10.;
	
	vec2 p1 			= vec2(-1., 2.*ba) * rmat(rho*theta) * scale;
	vec2 p2 			= vec2(0.,   0.) * rmat(rho*theta) * scale;
	vec2 p3 			= vec2(1., 2.*ba) * rmat(rho*theta) * scale;
	vec2 p12 			= mix(p2, p1, iphi);
	vec2 p23 			= mix(p3, p2, iphi);
	vec2 p31 			= mix(p1, p3, iphi);
	
	if(mod(theta, 2.) == 1.)
	{
		t  = p1;
		p1 = p3;
		p2 = p2;
		p3 = t;
	}
	
		
	vec3 color 			= vec3(0.);// hsv(.15-theta * .1, 1., 1.);
	int type 			= 0; // 0=thin, 1=fat
	
	const float iter 		= 18.;
	float fault			= 0.;
	
	float d 			= 1.;
	vec3 m 				= vec3(0., 0., 0.);
	vec3 f				= vec3(0., 0., 0.);
	
	vec2 mm 			= vec2(0., 0.);
	vec2 fm 			= vec2(0., 0.);
	
	vec2 c				= vec2(0., 0.);
	
	vec2 vertex			= (mouse-.5)*aspect*ba;
	vec2 prior			= vec2(0., 0.);
	
	float edges			= 0.;
	float points			= 1.;
	float paths 			= 0.;
	float vectors			= 0.;
	bool outside 			= false;
	vec2 v2				= vec2(0., 0.);
	bool test 		= pos.x < ((mouse-.5) * aspect * ba).x;
		
	for(float i=0.; i < iter; ++i) 
	{
	 	outside 		= false;
		m.x 			= length(p1-p2);
		m.y 			= length(p1-p3);
		m.z 			= length(p2-p3);
		
		f.x 			= map(p1);
		f.y 			= map(p2);
		f.z 			= map(p3);
		
		
		fm.x			= min(min(f.x, f.y),f.z);
		fm.y			= max(max(f.x, f.y),f.z);
		
		mm.x			= min(min(m.x, m.y),m.z);
		mm.y			= max(max(m.x, m.y),m.z);
		
		
		if(i==0.)
		{
			d 		= min(d, abs(interiorDist(pos, p1, p2, p3)));		
			c		= ( p1 +  p2 +  p3) * (1./3.);		
		
			edges		= max(edges, smoothstep(0.,  (d+1./resolution.y), 2./resolution.y));
		}
		
		
		bool contains_point 	= inside(vertex, p1, p2, p3);
		bool contour_within 	= mm.y > fm.y;
					
		//if(!contains_point) fault++;		//single point vertex
		if(!(contour_within) && !contains_point) fault++;	//stringent contour
		
		
		if(fault > 0.) break;
		
		
		//fault++;
		if(test)
		{
			p12 			= mix(p2, p1, iphi);
			p23 			= mix(p3, p2, iphi);
			p31 			= mix(p1, p3, iphi);
		}
		
		if(type==0) 
		{
			if(!test)
			{
				p12 			= mix(p2, p1, iphi);
				p23 			= mix(p3, p2, iphi);		
			}
			
			if(inside(pos, p12, p2, p23)) 
			{
				p1	= p2;
				p2	= p23;
				p3	= p12;							
				type 	= 1;	
			} 
			else if(inside(pos, p1, p12, p3)) 
			{
				p2	= p3;
				p3	= p1;
				p1	= p12;
				type	= 0;			
			} 
			else if(inside(pos, p12, p23, p3)) 
			{
				p1	= p12;
				p2	= p3;
				p3	= p23;				
				type 	= 0;				
			}
			else
			{
				outside = true;
			}
		} 
		else 
		{
			if(!test)
			{
				p31 			= mix(p1, p3, iphi);
			}
			if(inside(pos, p1, p2, p31)) 
			{
				t 	= p2;
				p2 	= p1;
				p3 	= p31;
				p1	= t;
				
				type 	= 0;				
			} 
			else if(inside(pos, p2, p3, p31))
			{
				p1 	= p3;
				p3 	= p2;
				p2 	= p31;				
				
				type 	= 1;		
			}
			else
			{
				outside = true;
			}
		}
		
	
		if(!outside)
		{
			d 			= min(d, abs(interiorDist(pos, p1, p2, p3)));		
			c			= ( p1 +  p2 +  p3) * (1./3.);		
			
			vec2 c1			= (p12 + p23 + p31) * (1./3.);
			
			points			= min(points, smoothstep(length(c  - pos), 0., 2./resolution.x));			
			paths			= max(paths,abs(paths - line(pos+.5/resolution, prior, type == 0 ? p1 : p3, 8./resolution.y)));
			edges			= max(edges, smoothstep(0.,  (d + .5/resolution.y), 1./resolution.y));		
			vectors			= max(vectors, line(pos, vertex, prior, 5./resolution.y));
			
			color			+= 1.;//type == 0 ? vec3(1., 1.9, .125) : vec3(0., 2., 1.);
			
			prior			= type == 0 ? p1 : p3;
		}
		 		
	}

	color 	*= 3./iter;
	points 	= 1.-clamp(points, 0., 1.);

	return vec3(color.xxx) * .5 + edges * .125 + paths * .025;
} 

	    
void main( void )
{
	
	vec4 current			= vec4(penrose((gl_FragCoord.xy/resolution.xy-.5)*aspect*ba), 1.);

	
	gl_FragColor			= current;
	
	gl_FragColor.w 			= 1.;
}//mods by sphinx - mad props to dashxdr

