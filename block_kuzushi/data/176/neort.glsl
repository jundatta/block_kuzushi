precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec2 mouse;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

mat2 genRot(float val){
  return mat2(cos(val),-sin(val),sin(val),cos(val));
}

vec3 PPParticle(vec2 uv,float t){
  //uv =(uv - 0.5) * genRot(t) + 0.5;
  uv -=0.5;
  uv -= vec2(cos(t),sin(t)) * 0.02;
  t *= 0.5;
  t += 5.0;
  uv = vec2(length(uv),atan(uv.y/uv.x));
  uv.x -= t * 0.75;
  float tDec = fract(t);
  float tRe = floor(t);
  vec2 cell = floor(uv * 8.0);
  vec2 st = fract(uv * 8.0);
  vec2 ca = vec2(random(vec2(tRe,1./tRe) + cell),random(vec2(1./tRe,tRe) + cell)) * 0.4 + 0.3;
  //ca = vec2(ca.x * cos(ca.y),ca.x * sin(ca.y));
  vec2 cb = vec2(random(vec2(tRe + 1.0,1./(tRe + 1.0)) + cell),random(vec2(1./(tRe + 1.0),(tRe + 1.0)) + cell)) * 0.4 + 0.3;
  //cb = vec2(cb.x * cos(cb.y),cb.x * sin(cb.y));
  vec2 currentPos =  mix(ca, cb, tDec);
  //st = vec2(st.x * cos(st.y), st.x * sin(st.y));
  vec3 res1 = abs(max(abs(st.x - currentPos.x),abs(st.y - currentPos.y)) - fract(t * 2.0 + random(cell)) * 0.3) < 0.015 ? vec3(1.0) : vec3(0.0);
  vec3 res2 = max(abs(st.x - currentPos.x),abs(st.y - currentPos.y)) < (fract(t * 2.0 + random(cell)) * 0.4) ? vec3(1.0) : vec3(0.0);
  return random(cell) < 0.5 ? res1 : res1;
}
vec3 BGRing(vec2 uv, float t){
  float r = length(uv - 0.5);
  float fl = floor(r * 18.0);
  return vec3(fract(fl * 0.1 - t * 4.0) < 0.1 ? 1.0 : 0.0);
}

vec3 grid(vec2 uv,float t){
  vec3 col = vec3(0.);
  vec2 st = fract(uv * 7.0);
  float cellY = floor(uv.y * 7.0);
  col = abs(floor(uv.x * 7.0) - 0.0) < 0.01 && abs(length(max(abs(st.x - 0.5),abs(st.y - 0.5))) - fract(t * 1.5 + cellY * 0.1)) < 0.05? vec3(42./255.,157./255.,143./255.) : col;
  col = abs(floor(uv.x * 7.0) - 6.0) < 0.01&& abs(length(max(abs(st.x - 0.5),abs(st.y - 0.5))) - fract(t * 1.5 + cellY * 0.1)) < 0.05 ? vec3(244./255.,162./255.,97./255.)  : col;
  col = 0.01 < abs(floor(uv.x * 7.0)) && abs(floor(uv.x * 7.0)) < 6.0 && abs(length(max(abs(st.x - 0.5),abs(st.y - 0.5))) - fract(t * 0.375 + random(floor(uv * 7.0))) * 4.0)  < 0.05 ? vec3(1.0) : col;
  col = (fract(uv.x * 7.0) < 0.0125 || fract(uv.x * 7.0) > 0.9875 || fract(uv.y * 7.0) < 0.0125 || fract(uv.y * 7.0) > 0.9875) ? vec3(1.0) : col;
  col = ((max(fract(uv.x * 7.0),fract(uv.y * 7.0))) < 0.1) ? vec3(1.0) : col;
  col = (abs(max(fract(uv.x * 7.0),fract(uv.y * 7.0)) - 0.145) < 0.0075) ? vec3(1.0) : col;
  col =  -0.01 < (floor(uv.x * 7.0)) && (floor(uv.x * 7.0)) < 6.1 ? col : vec3(0.0);

  return col;
}

vec2 tebure(float t){
  float x = 0.0;
  float y = 0.0;
  float A = 1.0;
  float T = 1.0;
  for(int i = 0; i < 5; i++)
  {
    x += cos(t / T * 6.2830) * A;
    y += sin(t / T * 6.2830) * A;
    A *= 0.5;
    T *= 2.0;
  }
  return vec2(x,y);
}

float sdf_line(vec2 uv, vec2 s, vec2 g){
  float t = -dot((g-s),(s-uv))/dot((g-s),(g-s));
  t = clamp(t, 0.0, 1.0);
  vec2 b = s + t * (g - s);
  return length(b - uv);
}

float sdf_circle(vec2 uv,vec2 center, float rad){
  return length(uv - center) - rad;
}

float sdf_cross(vec2 uv,vec2 center, float width,float height,float t){
  vec2 pos = vec2(uv.x - center.x - uv.y + center.y,uv.x - center.x + uv.y - center.y);
pos = vec2(pos.x * cos(t * 6.283) - pos.y * sin(t * 6.283),pos.x * sin(t * 6.283) + pos.y * cos(t * 6.283));
  float a = abs(pos.x) - width;
  float b = abs(pos.y) - height;
  float c = abs(pos.x) - height;
  float d = abs(pos.y) - width;
  return min(max(a,b),max(c,d));
}

vec2 gridPos(vec2 pos){
  return vec2(((pos.x) + 0.5)/7.,((pos.y) + 0.5)/7.);
}

vec2 day(float t,float init){
    float x = random(vec2(t, init));
    float y = t;
    return vec2(x * 7.0,y);
}

vec3 line(vec2 uv,float init,float t){
    uv += init * 0.2;
  vec3 col = vec3(1.0);
  float d = 10000.0;
  vec2 yyyd = day(floor(t) - 2.0,init);
  vec2 yyd = day(floor(t) - 1.0,init);
  vec2 yd = day(floor(t) + 0.0,init);
  vec2 td = day(floor(t) + 1.0,init);
  vec2 nd = day(floor(t) + 2.0,init);
  float delta = smoothstep(-0.2,1.2,fract(t));
  delta = clamp(delta,0.0,1.0);
  vec2 yyydPos = gridPos(floor(yyyd));
  vec2 yydPos = gridPos(floor(yyd));
  vec2 ydPos = gridPos(floor(yd));
  vec2 tdPos = gridPos(floor(td));
  vec2 ndPos = gridPos(floor(nd));
  vec2 rotPos = vec2(tdPos.x,ndPos.y);
  float p1l = abs(rotPos.y - tdPos.y);
  float p2l = abs(rotPos.x - ndPos.x);
  float thr = (p1l/(p1l + p2l));
  if(delta < thr){
        d = sdf_line(uv,tdPos,(1. - delta /thr) * tdPos + delta /thr * rotPos);
  }else{
      d = sdf_line(uv,tdPos,rotPos);
      float d2 = sdf_line(uv,rotPos,(1. - (delta - thr) / (1. - thr)) * rotPos + (delta - thr) /(1. - thr) * ndPos);
      d = min(d,d2);
  }
  vec2 bRotPos = vec2(ydPos.x,tdPos.y);
  vec2 bbRotPos = vec2(yydPos.x,ydPos.y);
  vec2 bbbRotPos = vec2(yyydPos.x,yydPos.y);
  d = min(d,sdf_line(uv,ydPos,bRotPos));
  d = min(d,sdf_line(uv,bRotPos,tdPos));
  d = min(d,sdf_line(uv,yydPos,bbRotPos));
  d = min(d,sdf_line(uv,bbRotPos,ydPos));
  d = min(d,sdf_line(uv,yyydPos,bbbRotPos));
  d = min(d,sdf_line(uv,bbbRotPos,yydPos));

  d = min(d,sdf_cross(uv,yyydPos,0.035,0.0075,1.));
  d = min(d,sdf_cross(uv,yydPos,0.035,0.0075,1.));
  d = min(d,sdf_cross(uv,ydPos,0.035,0.0075,1.));
  d = min(d,mix(sdf_circle(uv,tdPos,0.0125), sdf_cross(uv,tdPos,0.035,0.0075, min(1.0,delta * 4.0)), min(1.0,delta * 4.0)));
  d = min(d,sdf_circle(uv,ndPos,0.0125 * min(1.0,delta * 2.0)));

  col = (abs(d-0.006) - 0.00075) < 0.|| d < 0.002 ? vec3(1.0) : vec3(0.0);
  return col;
  //return vec3(clamp(1.0 - max(0.,d-0.004) * max(0.,d-0.004) * 24000.0,0.0,1.0));
}


vec4 render(vec3 c, vec3 r,vec3 centerPos,float ti){
  float t = -(c.y - centerPos.y)/r.y;
  if(t < 0.0){
    return vec4(0.0);
  }
  vec2 uv = vec2(c.x + r.x * t,c.z + r.z * t);
  uv -= centerPos.xz;
  uv.x = fract(uv.x / 1.2) * 1.2;
  return ((0.0 < uv.x && uv.x < 1.0)) ? vec4(grid(uv,ti) /(1. + (uv.y - c.z) * (uv.y - c.z) * 0.02),1.0): vec4(0.0);
}


vec4 render2(vec3 c, vec3 r,vec3 centerPos,float ti){
  float t = -(c.y - centerPos.y)/r.y;
  if(t < 0.0){
    return vec4(0.0);
  }
  vec2 uv = vec2(c.x + r.x * t,c.z + r.z * t);
  uv -= centerPos.xz;
  vec3 lineCol = line(uv,0.1,ti + 0.3) * vec3(57./255.,0./255.,153./255.);
  vec3 lineCol2 = line(uv,-0.1,ti + 0.2) * vec3(158./255.,0./255.,89./255.);
  vec3 lineCol3 = line(uv,-0.2,ti + 0.1) * vec3(255./255.,0./255.,84./255.);
  vec3 lineCol4 = line(uv,0.2,ti) * vec3(255./255.,84./255.,0./255.);
  vec3 col = lineCol + lineCol2 + lineCol3 + lineCol4;
  return ((0.0 < uv.x && uv.x < 1.0) && length(col) > 0.01) ? vec4(col,1.0): vec4(0.0);
}

void main( void ) {

    float t = time / 1.5;
	vec2 uv = ( gl_FragCoord.xy / resolution ) - 0.5;
  vec3 cam = vec3(0.5,0.35,0.75 + t / 7.0);
  cam.xy += tebure(time * 0.5) * 0.01;
  cam.xy += (mouse - 0.5) * 0.3;
  vec3 ray = vec3(uv,0.25);
  ray.xy *= genRot(0.075 * sin(t));
  ray.xz *= genRot(0.075 * cos(t));
  ray.yz *= genRot(0.1);
  vec4 col = render2(cam,ray,vec3(-0.0,0.075,0.75),1.0 + (t));
  col = col.w != 0.0 ?col : render(cam,ray,vec3(0.,0.,0.75),1.0 + t);
  col = col.w != 0.0 ?col : render2(cam,ray,vec3(0.,1.0 - 0.075,0.75),1.0 + t);
  col = col.w != 0.0 ?col : render(cam,ray,vec3(0.,1.0,0.75),1.0 + t);

  col.xyz += col.w != 0.0 ? vec3(0.0) : PPParticle(gl_FragCoord.xy / resolution,t);
  //col.xyz += col.w != 0.0 ? vec3(0.0) : BGRing(gl_FragCoord.xy / resolution,t * 0.5);
  vec3 bloom1;
  float bSum = 0.0;
  float bIntensity = 1.0;
  float bUnit = 0.00125;
  for(float i = 1.0; i < 25.0; i += 1.0)
  {
    /* code */
    vec3 L = texture2D(backbuffer, gl_FragCoord.xy / resolution + vec2(bUnit * i,0.0)).xyz;
    vec3 R = texture2D(backbuffer, gl_FragCoord.xy / resolution - vec2(bUnit * i,0.0)).xyz;
    vec3 U = texture2D(backbuffer, gl_FragCoord.xy / resolution + vec2(0.0,bUnit * i)).xyz;
    vec3 D = texture2D(backbuffer, gl_FragCoord.xy / resolution - vec2(0.0,bUnit * i)).xyz;
    bSum += bIntensity;
    bloom1 += (L + U + R + D)/2.0 * bIntensity;
    bIntensity *= 0.9;
  }
  bloom1 /= bSum;
  col.xyz = col.xyz * 0.8 + bloom1 * 0.4;
  float vigRate = 1. - length(gl_FragCoord.xy / resolution - 0.5) * length(gl_FragCoord.xy / resolution - 0.5) * 0.8;
  col *= vigRate;
  float CAamount = 0.001;
  CAamount = 0.003 * random(vec2(t));
  vec3 CAR =texture2D(backbuffer, gl_FragCoord.xy / resolution + vec2(CAamount,0.0)).xyz;
  vec3 CAB =texture2D(backbuffer, gl_FragCoord.xy / resolution - vec2(0.001,0.0)).xyz;
  col.xyz = vec3(CAR.x * 0.5 + col.x * 0.5,CAB.y * 0.5 + col.y * 0.5,col.z);

  gl_FragColor = vec4(col.xyz, 1.0);
}
