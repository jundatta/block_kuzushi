precision highp float;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

mat2 le(mat2 a, mat2 b, float t) {
    return mat2(
        mix(a[0][0], b[0][0], t),
        mix(a[0][1], b[0][1], t),
        mix(a[1][0], b[1][0], t),
        mix(a[1][1], b[1][1], t)
    );
}

float normE(vec2 p, float e) {
    return pow(pow(abs(p.x),e) + pow(abs(p.y),e), 1./e);
}

vec2 mul(mat2 m, vec2 v) {
    return v * m;
}

void colors(float t, out vec3 A, out vec3 B, out vec3 C) {
    float q = sqrt(2.0) * 5.;
    vec2 p = vec2(cos(t),sin(t)) * 0.6 + vec2(cos(t*q),sin(t*q)) * 0.4;
    float r = -t;
    vec2 ro = mul(mat2(cos(r),sin(r),-sin(r),cos(r)), p);
    float h = atan(ro.y, ro.x);
    float aH = h, bH = h + 1.2, cH = h + 3.1415926535 + 0.6;
    A = cos(aH + vec3(0,1,-1)*2./3.*3.1415926535) * 0.5 + 0.5;
    B = cos(bH + vec3(0,1,-1)*2./3.*3.1415926535) * 0.5 + 0.5;
    C = cos(cH + vec3(0,1,-1)*2./3.*3.1415926535) * 0.5 + 0.5;
    C *= 0.7;
}

float dur(float t, vec2 s, vec2 e) {
    float shortTime = 0.1;
    float baseTime = 0.2;
    vec2 tm = vec2(baseTime,shortTime);
    float ss = dot(tm,s);
    float ee = dot(tm,e);
    float eps = 0.05;
    return smoothstep(0.,1.,min(smoothstep(ss-eps,ss+eps,t), smoothstep(ee+eps,ee-eps,t)));
}

float pattern(vec2 uv, float t) {
    // cube -> arrow
    // cube -> mimi
    // cube -> tria -> hexa -> fan -> tria
    // cube -> qrot/circ -> circ2

    // qrot -> circ2
    // arrow -> qrot
    // tria -> qrot

    //    arrow: 0-2
    // -> qrot:  2-2e
    // -> circ:  2e-4e
    // -> circ2: 4e-6e
    // -> qrot:  6e-6ee
    // -> tria:  6ee-7ee
    // -> hexa:  7ee-9ee
    // -> fan:   9ee-11ee
    // -> tria:  11ee-11eee
    // -> cube:  11eee-11eeee
    // -> mimi:  11eeee-13eeee
    // -> cube:  13eeee-14eeee [end]
    // -> arrow: 14eeee-16eeee

    float shortTime = 0.1;
    float baseTime = 0.2;
    float wholeTime = 14. * baseTime + 4. * shortTime;
    float pet = mod(t, wholeTime);

    float arrow = max(dur(pet,vec2(0,0),vec2(2,0)), dur(pet,vec2(14,4),vec2(16,4)));
    float mimi = dur(pet,vec2(11,4),vec2(13,4));
    float tria = dur(pet,vec2(6,2),vec2(11,3));
    float hexa = dur(pet,vec2(7,2),vec2(11,2)); // tria = 1
    float fan = dur(pet,vec2(9,2),vec2(11,2)); // hexa = 1
    float qrot = dur(pet,vec2(2,0),vec2(6,2));
    float circ = dur(pet,vec2(2,1),vec2(6,1)); // qrot = 1
    float circ2 = dur(pet,vec2(4,1),vec2(6,1)); // circ = 1


    float s3 = sqrt(3.0);
    mat2 cro = mat2(1.,0.,0.,1.);
    mat2 tri = mat2(s3/2.,-0.5,0.,1.);
    mat2 arr = mat2(1.,0.,0.,0.6);
    mat2 m = cro;
    m = le(m,tri,tria);
    m = le(m,arr,arrow);
    vec2 origUV = uv;
    uv = mul(m, uv);
    uv.y -= abs(fract(uv.x*2.)-0.5)*0.3 * arrow;
    vec2 p = fract(uv) - 0.5;
    vec2 crossDir = fract(uv/2.) - 0.5;
    float crossi = crossDir.x * crossDir.y;
    float flipWhole = 1.0;
    if(crossi < 0.0) {
        p = p.yx * vec2(-1,1);
        p.x *= -1.;
    }

    float baseRect = -1.0;
    if(mimi > 0.0) {
        if(p.y < 0.) p *= -1.;
        if(p.x-mimi*0.5 < 0.0) {
            if(abs(p.y-0.3) < mix(0.25,0.1,mimi)) baseRect = 1.0;
            if(abs(p.y) < 0.1) baseRect = 1.0;
        }
        baseRect *= -1.0;
    } else if(circ > 0.0) {
        vec2 coord = vec2(uv.x+uv.y,uv.x-uv.y);
        coord.y -= 0.5;
        coord = floor(coord+0.5);
        vec2 cirC;
        baseRect = -1.0;
        float frontCurve = 1.0;
        coord.y += 0.5;
        cirC = vec2(coord.x+coord.y, coord.x-coord.y)/2.;
        float irad = mix(0.85,0.68,circ2);
        float rad = circ * 0.25 + 0.25;
        int intCount = 0, ontCount = 0;
        float enm;
        float ee = mix(1.0,2.0,circ);
        enm = normE(abs(uv-cirC),ee);
        if(enm < rad*irad) intCount++;
        if(enm < rad) ontCount++;
        vec2 d = abs(uv-cirC);
        float flowi = sign(d.x + d.y - 0.09 * circ2);
        frontCurve = min(frontCurve, sign(abs(distance(uv,cirC) - rad*0.975) - 0.025));
        cirC += sign(uv-cirC) * 0.5;
        d = abs(uv-cirC) * mix(0.3,0.39,circ2);
        flowi *= 
            sign(d.x + d.y - 0.29) *
            sign(normE(d,4.0) - 0.201);
        if(d.y*2.-d.x < 0.165 && d.x*2.-d.y < 0.165) flowi = 1.0;
        enm = normE(abs(uv-cirC),ee);
        if(enm < rad*irad) intCount++;
        if(enm < rad) ontCount++;
        frontCurve = min(frontCurve, sign(abs(distance(uv,cirC) - rad*0.975) - 0.025));
        if(intCount == 1) baseRect = 1.0;
        if(intCount == 0 && ontCount == 2) baseRect = 1.0;
        baseRect = -min(min(baseRect, frontCurve), flowi);
    } else if(qrot > 0.0) {
        vec2 coord = vec2(uv.x+uv.y,uv.x-uv.y);
        coord.y -= 0.5;
        coord = floor(coord+0.5);
        coord.y += 0.5;
        vec2 cirC = vec2(coord.x+coord.y, coord.x-coord.y)/2.;
        vec2 d = uv - cirC;
        float a = (1.-qrot) * 3.1415926535 / 4.0;
        d = mul(mat2(cos(a),sin(a),-sin(a),cos(a)), d);
        baseRect = sign(normE(d,1.0) - mix(0.25*sqrt(2.0),0.2,qrot));
        float u = fract(uv.x+uv.y);
        baseRect *= sign(u-tria*0.5);
    } else if(hexa > 0.0) {
        vec3 coord = vec3(uv.x,uv.y,uv.x+uv.y);
        vec3 we = fract(coord) - 0.5;
        baseRect = sign(we.x) * sign(we.y) * sign(we.z);
        vec2 hexCoord = mul(mat2(2,1,-1,1) / 3.0, uv.xy);
        vec3 hCoord = vec3(hexCoord, hexCoord.x+hexCoord.y);
        vec3 hCenter = floor(hCoord.xyz*2.+0.5)/2.;
        hCenter.z = hCenter.x + hCenter.y;
        vec2 hFrac = fract(hCoord.xy * 2.) - 0.5;
        float hz = hFrac.x + hFrac.y;
        if(hFrac.x * hFrac.y > 0.0 && abs(hz) < 0.5) {
            vec2 pc;
            if(hz < 0.) {
                pc = floor(hCoord.xy * 2.)/2. + 1./3./2.;
            } else {
                pc = ceil(hCoord.xy * 2.)/2. - 1./3./2.;
            }
            vec2 di = hCoord.xy - pc;
            vec2 hCand;
            if(di.x < di.y) {
                hCand = floor(hCoord.xy * 2.)/2.;
                hCand.y += 0.5;
            } else {
                hCand = floor(hCoord.xy * 2.)/2.;
                hCand.x += 0.5;
            }
            if(distance(vec3(hCand,hCand.x+hCand.y),hCoord) < distance(hCenter,hCoord)) {
                hCenter = vec3(hCand, hCand.x+hCand.y);
            }
        }
        vec2 center2 = mul(mat2(1,-1,1,2), hCenter.xy);
        vec3 center = vec3(center2, center2.x+center2.y);

        mat2 triInv = mat2(1.,0.5,0.,s3/2.) / (s3/2.);
        vec2 centerUV = mul(triInv, center.xy);
        vec2 difUV = origUV - centerUV;
        float a = (floor(atan(difUV.y,difUV.x)/3.1415926535/2. * 6.0) + 0.5) * 3.1415926535 * 2. / 6.;
        vec2 measUV = mul(mat2(cos(a),sin(a),-sin(a),cos(a)), difUV);
        if(baseRect < 0.) {
            baseRect *= sign(measUV.x - mix(0.,0.46,hexa));
        } else {
            baseRect *= -sign(measUV.x - mix(0.5,0.46,hexa));
        }
        baseRect *= sign(measUV.x - mix(0.,0.38,smoothstep(0.4,1.0,hexa)));

        float de;
        difUV.y += mix(1.5,0.,fan);
        de = distance(difUV, vec2(sqrt(3.0)/2.0*sign(difUV.x),0)) * 1.4;
        if(de < 1.3) baseRect = sign(fract(de*2.) - 0.5);
        de = distance(difUV, vec2(0,-0.5)) * 1.4;
        if(de < 1.3) baseRect = sign(fract(de*2.) - 0.5);
        de = distance(difUV, vec2(sqrt(3.0)/2.0*sign(difUV.x),-1.)) * 1.4;
        if(de < 1.3) baseRect = sign(fract(de*2.) - 0.5);
    } else {
        float u = fract(uv.x+uv.y);
        baseRect = sign(p.x) * sign(p.y) * sign(u-tria*0.5);
    }
    return baseRect * sign(0.5 - abs(fract(uv.x*2.)-0.5) - arrow*0.45);
}
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}
vec4 randSeq(float t, vec2 seed) {
    float s = floor(t);
    float r = fract(t);
    float w = rand(seed+s)*0.4+0.3;
    float p = s;
    if(w < r) {
        s++;
        float w2 = rand(seed+s)*0.4+0.3;
        r *= 1. - w;
        p += w;
        w = (1. - w) + w2;
    } else {
        float w2 = rand(seed+(s-1.))*0.4+0.3;
        r *= w;
        r += 1. - w2;
        p -= 1. - w2;
        w = w + (1. - w2);
    }
    return vec4(p, w, r, s);
}
vec3 cloud(vec2 uv, vec3 col, float dw) {
    vec2 ouv = uv;
    uv.y -= time * 0.2;
    float baseSeed = 0., widthScale = 1.;
    float eps = 0.01 * mix(1., 10., smoothstep(0., 1., dw));
    if(uv.x < -8.5) baseSeed = 1., uv.x += 14.;
    else if(uv.x > 8.5) baseSeed = 2., uv.x -= 14.;
    else uv *= 0.7;
    vec4 rs = randSeq(uv.y, vec2(baseSeed,0.));
    vec2 cc = vec2(sin(rs.w*1.5)*2.*widthScale+(rand(vec2(rs.w,2))-0.5)*0.5, rs.x+rs.y*0.5);
    float rsw1 = rs.z/rs.y < 0.5 ? rs.w-1. : rs.w+1.;
    float tru1 = rs.z/rs.y < 0.5 ? rs.w : rs.w+1.;
    float ccY = rs.z/rs.y < 0.5 ? rs.x : rs.x+rs.y;
    float cc1 = sin(rsw1*1.5)*2.*widthScale+(rand(vec2(rsw1,2))-0.5)*0.5;
    float pad = 0.2;
    float vr = rs.y * 0.5 - pad;
    float hr = (rand(vec2(rs.w,1))*2.4 + 0.5)*widthScale;
    float hr1 = (rand(vec2(rsw1,1))*2.4 + 0.5)*widthScale;
    float addR = rand(vec2(rs.w,-1));
    float addHr = (sin(time * addR) * 0.5 + 0.5) * 0.4 * widthScale;
    vec2 cu = cc - uv;
    cu.x = max(0., abs(cu.x) - hr - addHr);
    float d = length(cu) - vr;
    if(length(cc.x-cc1) < hr+hr1-pad*5.) {
        float lb = max(cc.x-hr, cc1-hr1);
        float ub = min(cc.x+hr,cc1+hr1);
        float ce = (lb + ub) * 0.5;
        float addR = rand(vec2(tru1,-1));
        float subHr = sin(time * addR) * 0.5 + 0.5;
        lb = mix(lb, ce-pad*2., rand(vec2(tru1,3)) * subHr);
        ub = mix(ub, ce+pad*2., rand(vec2(tru1,4)) * subHr);
        // ub - lb > pad * 3
        float curveD = max(distance(uv.y,ccY)-pad*5., max(lb-uv.x, uv.x-ub));
        curveD = max(curveD, -distance(uv, vec2(lb,ccY)) + pad);
        curveD = max(curveD, -distance(uv, vec2(ub,ccY)) + pad);
        d = min(d, curveD);
    }
    d -= 0.02;
    vec2 crossUV = vec2(ouv.x+ouv.y*2.,ouv.x-ouv.y*2.)*0.56;
    float crossPattern = 1.0;
    crossPattern *= smoothstep(eps,-eps,abs(fract(crossUV.x)-0.5)-0.25)*2.-1.;
    crossPattern *= smoothstep(eps,-eps,abs(fract(crossUV.y)-0.5)-0.25)*2.-1.;
    float lightenPattern = 0.0;
    lightenPattern = max(lightenPattern, smoothstep(eps,-eps,abs(fract(crossUV.x)-0.5)-0.25));
    lightenPattern = max(lightenPattern, smoothstep(eps,-eps,abs(fract(crossUV.y)-0.5)-0.25));
    float density = mix(0.3,0.5-0.1*lightenPattern,crossPattern*0.5+0.5);
    float overlay = mix(0.6,0.7+0.3*lightenPattern,crossPattern*0.5+0.5);
    vec3 overlayCol = mix(col, vec3(1.), density);
    overlayCol = mix(overlayCol*overlay*2., 1.-2.*(1.-overlay)*(1.-overlayCol), step(overlayCol,vec3(0.5))); // this is NOT a overlay function actually but it looks better
    vec3 cloudColor = mix(vec3(1.5), overlayCol, smoothstep(eps,-eps,d+0.05));
    col = mix(col, cloudColor, smoothstep(eps,-eps,d));
    return col;
}

vec3 flower(vec2 uv, vec3 col, float dw, float epsScale, vec3 frC, vec3 bcC, float count, float distrib) {
    float t = time;
    uv.y += t * 0.2;
    float wholeR = 0.5;
    uv = mul(mat2(cos(wholeR),sin(wholeR),-sin(wholeR),cos(wholeR)), uv);
    vec2 cell = floor(uv);
    vec2 luv = fract(uv) - 0.5;
    luv *= 2.;
    if(rand(cell+3.) < 0.3) {
        return col;
    }

    float eps = 0.005 * epsScale * mix(1., 10., smoothstep(0., 1., dw));
    float pad = 0.02;
    float scale = mix(2.5, mix(1.2, 2.5, pow(rand(cell-1.), 2.)), distrib*0.8+0.2);
    vec2 diffPos = (vec2(rand(cell), rand(cell.yx+vec2(0.2,0.6))) * 2. - 1.) * (0.3+0.25*(1.-distrib));
    luv += diffPos;
    luv *= scale;
    eps *= scale;
    float lm = (rand(cell+2.) * 2. - 1.) * t * 2.;
    float gA = (rand(cell+1.) * 2. - 1.) * t * 0.5;
    luv += vec2(cos(lm),sin(lm)) * 0.2;
    luv = mul(mat2(cos(gA),sin(gA),-sin(gA),cos(gA)), luv);

    float back = 0.0, front = 0.0;

    float a = floor(atan(luv.y, luv.x) / 3.1415926535 / 2. * count + 0.5) * 3.1415296535 * 2. / count;
    vec2 p = mul(mat2(cos(a),sin(a),-sin(a),cos(a)), luv);
    float th = 3.1415926535 * 2. / count / 2.;
    back = smoothstep(eps,-eps,p.x-0.5);
    front = min(smoothstep(eps,-eps,p.x-0.5), smoothstep(eps,-eps,dot(abs(p),vec2(-sin(th),cos(th))) + pad));
    float cr = 0.5 * sin(th) + pad;
    float cx = 0.5 + cr * tan(th) / cos(th);
    cr += cr * tan(th) * tan(th);
    back = max(back, smoothstep(eps,-eps,distance(p,vec2(cx,0)) - cr));
    front = max(front, smoothstep(eps,-eps,distance(p,vec2(cx,0)) - cr + pad*2.));
    float centerR = 0.12;
    front = min(front, 1. - smoothstep(eps,-eps,length(luv) - centerR));
    front = max(front, smoothstep(eps,-eps,length(luv) - centerR + pad*2.));

    vec3 flowerCol = mix(bcC, frC, front);
    col = mix(col, flowerCol, back);
    return col;
}

vec3 circlePos(float x, float shift, float y) {
    float t = time;
    float shiftSpeed = rand(vec2(0,y)) * 2. - 1.;
    float mov = t * shiftSpeed * 0.1;
    vec2 ix = vec2(floor(x+mov)+shift,y);
    vec2 pos = ix / vec2(1,2);
    pos.x -= mov;
    float xShiftSpeed = rand(vec2(ix+3.)) * 2. - 1.;
    float xShift = cos(t * xShiftSpeed + 1.);
    float yShiftSpeed = rand(vec2(ix+4.)) * 2. - 1.;
    float yShift = cos(t * yShiftSpeed + 2.);
    pos.x += (rand(ix+2.)*2.-1.) * 0.2 * xShift;
    pos.y += (rand(ix+1.)*2.-1.) * 0.085 * yShift + 0.055;
    return vec3(pos, rand(ix));
}

vec3 rCol(vec3 c) {
    // g: AB, 0B, 1B, A0, A1
    return vec3(rand(vec2(0,c.z)), rand(vec2(1,c.z)), rand(vec2(2,c.z)));
}

void separate(vec2 uv, float dw, in vec3 A, in vec3 B, out vec3 oA, out vec3 oB) {
    float ixy = floor(uv.y*2.);
    float eps = 0.005 * mix(1., 10., smoothstep(0., 1., dw));

    vec3 col = vec3(0.);
    vec3 c0, c1;
    float r = 0.8;

    c0 = circlePos(uv.x,0.,ixy);
    c1 = circlePos(uv.x,1.,ixy);
    float d = 2.0, ld;

    if(c0.z < c1.z) {
        ld = length(c0.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c0), smoothstep(eps,-eps,ld));
        ld = length(c1.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c1), smoothstep(eps,-eps,ld));
    } else {
        ld = length(c1.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c1), smoothstep(eps,-eps,ld));
        ld = length(c0.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c0), smoothstep(eps,-eps,ld));
    }

    c0 = circlePos(uv.x,0.,ixy-1.);
    c1 = circlePos(uv.x,1.,ixy-1.);

    if(c0.z < c1.z) {
        ld = length(c0.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c0), smoothstep(eps,-eps,ld));
        ld = length(c1.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c1), smoothstep(eps,-eps,ld));
    } else {
        ld = length(c1.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c1), smoothstep(eps,-eps,ld));
        ld = length(c0.xy-uv)-r;
        d = mix(min(d,abs(ld)), abs(ld), smoothstep(eps,-eps,ld));
        col = mix(col, rCol(c0), smoothstep(eps,-eps,ld));
    }

    vec3 C = (A + B) / 2.0;
    if(col.r > 0.5) {
        vec3 t = A;
        A = B;
        B = t;
    }
    float str = col.g * 0.8;;
    float bt = col.b < 0.5 ? 0. : 1.5;
    if(fract(col.b*4.) > 0.5) A = mix(A, vec3(bt), str);
    else B = mix(B, vec3(bt), str);

    float th = 0.005;
    eps *= 0.7;
    A = mix(A, mix(C,vec3(2),0.5), smoothstep(eps,-eps,d-th));
    B = mix(B, mix(C,vec3(2),0.5), smoothstep(eps,-eps,d-th));
    oA = A;
    oB = B;
}

vec3 bubble(vec2 uv, float dw) { // uv.x == 0 ---- uv.x == 1
    float t = time * 0.5;
    float ix = floor(uv.x*10.);
    float y = rand(vec2(ix,5)) + t * 0.1;
    vec2 seed = vec2(ix,floor(y));
    vec3 col = vec3(0.0);
    float w = 0.0015;
    float eps = 0.001 * mix(1., 10., smoothstep(0., 1., dw));
    for(int i=0;i<10;i++) {
        vec2 cp = vec2((ix+0.5)/10., fract(y));
        float r = 0.03;
        cp.y -= (1. - pow(1. - float(i) / 10., 1.3)) * 0.3;
        r *= (11.-float(i)) / 11.;
        r *= rand(seed+vec2(1,0)) * 0.5 + 0.5;
        vec2 dif = vec2(rand(seed+vec2(-0.1,i))*2.-1., rand(seed+vec2(-0.2,i))*2.-1.) * 0.7;
        float sp = (rand(seed+vec2(-0.3,i)) * 0.9 + 0.1) * 2.;
        float sq = (rand(seed+vec2(-0.7,i)) * 0.9 + 0.1) * 8.;
        dif += vec2(cos(t*sp),sin(t*sp)) * 0.4;
        dif += vec2(cos(t*sq),sin(t*sq)) * 0.1;
        cp += dif * 0.018;
        float dense = rand(seed+vec2(-0.4,i)) * 0.4 + 0.2;
        float hia = sign(rand(seed+vec2(-0.5,i))*2.-1.) * 0.5 + 3.1415926535 / 2.;
        vec2 hilcp = cp + vec2(cos(hia),sin(hia)) * 0.4 * r;
        col = max(col, smoothstep(eps,-eps,abs(distance(uv,cp) - r) - w));
        col = max(col, dense * smoothstep(eps,-eps,distance(uv,cp) - r));
    }
    return col;
}

vec3 customColor(vec2 uv) {
    vec2 rawUV = uv;
    
    float t = time * 0.025;
    vec3 base, front, tie;
    colors(t + uv.y * 0.5, base, front, tie);

    float dw = 0.15;

    // SSAA, only for neort
    float p = 0.0;
    for(int i=0;i<2;i++) {
   		for(int j=0;j<2;j++) {
            vec2 iuv = uv + vec2(i,j) / resolution.y / 5.;
	    	p += pattern(iuv*40., t + iuv.y * 0.2);
        }
    }
    p = p * 0.25 * 0.5 + 0.5; // mix(p * 0.5 + 0.5, 0.5, smoothstep(0.,1.,dw) * 0.9);
    
    vec3 uBase, uFront;
    separate(uv*15., dw, base, front, uBase, uFront);
    vec3 col = mix(uBase, uFront, p);
    col *= 0.9;
    col = cloud(uv*50., col, dw);
    col = flower(uv*20., col, dw, 1.35, vec3(1.5), front*0.7, 8., 0.);
    col = flower(uv*10., col, dw, 0.75, base*0.7, vec3(1.2), 15., 1.);
    col = mix(col, vec3(1.3), bubble(uv*0.7 + 0.4, 0.));
    return col;
}

void main(void) {
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / resolution.y;
    gl_FragColor = vec4(customColor(uv/5.), 1.0);
}