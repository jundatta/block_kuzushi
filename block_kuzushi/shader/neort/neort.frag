// https://paiza.io/でhttps://neort.io/art/c7r35ks3p9fclnodut9g?index=80&origin=user_likeを展開したもの
// （PC-8001（TN8001）さんありがとう＼(^_^)／）

precision highp float;
precision highp int;

varying vec2 vTexCoord;

uniform vec3 u_color0;uniform vec3 u_color1;uniform vec3 u_color2;uniform vec3 u_color3;uniform vec3 u_color4;uniform vec3 u_color5;
uniform vec4 u_rnd0;uniform vec4 u_rnd1;uniform vec4 u_rnd2;uniform vec4 u_rnd3;uniform vec4 u_rnd4;uniform vec4 u_rnd5;uniform vec4 u_rnd6;uniform vec4 u_rnd7;uniform vec4 u_rnd8;uniform vec4 u_rnd9;uniform vec4 u_rnd10;uniform vec4 u_rnd11;uniform vec4 u_rnd12;uniform vec4 u_rnd13;uniform vec4 u_rnd14;uniform vec4 u_rnd15;uniform vec4 u_rnd16;uniform vec4 u_rnd17;uniform vec4 u_rnd18;uniform vec4 u_rnd19;uniform vec4 u_rnd20;uniform vec4 u_rnd21;uniform vec4 u_rnd22;uniform vec4 u_rnd23;uniform vec4 u_rnd24;uniform vec4 u_rnd25;uniform vec4 u_rnd26;uniform vec4 u_rnd27;uniform vec4 u_rnd28;uniform vec4 u_rnd29;uniform vec4 u_rnd30;uniform vec4 u_rnd31;uniform vec4 u_rnd32;uniform vec4 u_rnd33;uniform vec4 u_rnd34;uniform vec4 u_rnd35;uniform vec4 u_rnd36;uniform vec4 u_rnd37;uniform vec4 u_rnd38;uniform vec4 u_rnd39;uniform vec4 u_rnd40;uniform vec4 u_rnd41;uniform vec4 u_rnd42;uniform vec4 u_rnd43;uniform vec4 u_rnd44;uniform vec4 u_rnd45;uniform vec4 u_rnd46;uniform vec4 u_rnd47;uniform vec4 u_rnd48;uniform vec4 u_rnd49;

float pi = 3.14159265358979;

float gaussian(vec2 pos, vec2 offset, vec2 bin){
	vec2 a = 1.0 / sqrt(2.0 * pi) / bin;
	vec2 b = (pos - offset) / bin;
	vec2 e = a * exp(b * b / -2.0);
	return e.x * e.y;
}

float cal_color(vec2 pos, vec4 rnd_n){
  float size;
  float bin;
  vec2 offs;

  size = 0.4 + rnd_n[0];
  bin = 0.01 + rnd_n[1];
  offs.x = rnd_n[2] ;
  offs.y = rnd_n[3] ;

  return size * gaussian(pos, offs, vec2(bin));
}

void main() {
	vec2 pos = vTexCoord * 2.0 - 1.0;

	vec3 tc = mix(u_color0, u_color1, vTexCoord.x) ;
	vec3 bc = mix(u_color2, u_color3, vTexCoord.x) ;
	vec3 cc = mix(tc, bc, vTexCoord.y) ;
	vec3 cb = mix(u_color4, u_color5, vTexCoord.y) ;

	vec3 color = cc;
	float add_color;

  
    add_color = cal_color(pos, u_rnd0);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd1);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd2);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd3);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd4);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd5);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd6);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd7);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd8);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd9);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd10);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd11);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd12);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd13);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd14);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd15);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd16);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd17);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd18);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd19);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd20);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd21);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd22);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd23);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd24);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd25);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd26);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd27);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd28);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd29);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd30);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd31);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd32);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd33);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd34);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd35);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd36);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd37);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd38);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd39);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd40);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd41);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd42);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd43);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd44);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd45);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd46);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd47);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd48);
    color += 0.01 * (cb - cc) * add_color;
 
    add_color = cal_color(pos, u_rnd49);
    color += 0.01 * (cb - cc) * add_color;
     

	float tra = 2.0 * gaussian(pos, vec2(0.0), vec2(0.3));
	tra = min(tra, 1.0);

	gl_FragColor = vec4(color, tra);
}