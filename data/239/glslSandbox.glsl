/*
 * Original shader from: https://www.shadertoy.com/view/tsKyzw
 */


#ifdef GL_ES
precision mediump float;
#endif

// glslsandbox uniforms
uniform float time;
uniform vec2 resolution;

// shadertoy emulation
#define iTime time
#define iResolution resolution
const vec4 iMouse = vec4(0.);

// --------[ Original ShaderToy begins here ]---------- //
// "Underground Trains" by dr2 - 2020
// License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

// Beneath the city streets... (viewpoint varies, mouseable, mouse in lower-left 
// corner for mono image)

#define AA  1   // optional antialiasing

float PrBoxDf (vec3 p, vec3 b);
float PrBox2Df (vec2 p, vec2 b);
float PrRoundBoxDf (vec3 p, vec3 b, float r);
float PrRoundBox2Df (vec2 p, vec2 b, float r);
float PrSphDf (vec3 p, float r);
float PrCylDf (vec3 p, float r, float h);
float PrCapsDf (vec3 p, float r, float h);
float Minv2 (vec2 p);
float Maxv2 (vec2 p);
float Maxv3 (vec3 p);
float SmoothBump (float lo, float hi, float w, float x);
mat3 StdVuMat (float el, float az);
vec2 Rot2D (vec2 q, float a);
vec2 Rot2Cs (vec2 q, vec2 cs);
float Hashfv2 (vec2 p);
float Fbm2 (vec2 p);
vec3 VaryNf (vec3 p, vec3 n, float f);

vec4 cSize = vec4(0.), dSize = vec4(0.);
vec3 ltDir = vec3(0.), qHit = vec3(0.), statSz = vec3(0.);
float tCur = 0., dstFar = 0., trnSpc = 0., cxId = 0., gGap = 0., trnPos = 0., trnUp = 0., trnDir = 0., tunSpc = 0., stpWd = 0., wThk = 0., whlRad = 0.;
int idObj = 0;
bool opDoor = false, colImg = false;
const int idCar = 1, idWin = 2, idWhl = 3, idTrk = 4, idTun = 5, idPlat = 6, idBase = 7,
   idWal = 8, idCeil = 9, idStp = 10, idHrail = 11, idSup = 12, idLamp = 13;
const float pi = 3.1415927, sqrt2 = 1.41421;

#define VAR_ZERO 0

#define DMIN(id) if (d < dMin) { dMin = d;  idObj = id; }
#define DMINQ(id) if (d < dMin) { dMin = d;  idObj = id;  qHit = q; }

float GObjDf (vec3 p)
{
  vec3 q;
  float dMin, d, db, dr, dx, dy, dd, stSize;
  dMin = dstFar;
  p.x -= gGap * (cxId + 0.5) + trnDir * (0.5 * gGap - tunSpc);
  q = p;
  q.xy -= vec2 (- trnDir * 4., - trnUp - whlRad + 0.1);
  stSize = 0.3;
  q.z *= trnDir;
  q.z -= stSize * floor (4. / stSize);
  dx = abs (q.x) - stpWd;
  dr = length (vec2 (dx, mod (q.z, stSize) - 0.5 * stSize)) - 0.03;
  dr = max (dr, abs (q.z - 2.4) - 2.4);
  q.yz = Rot2Cs (q.yz, vec2 (1. / sqrt2));
  d = max (length (vec2 (dx, q.y - 0.78)) - 0.03, abs (q.z - 4.12) - 3.4);
  DMIN (idHrail);
  d = max (dr, abs (q.y - 0.53) - 0.26);
  d = min (d, PrSphDf (vec3 (dx, q.y - 0.78, q.z - 7.55), 0.05));
  DMIN (idHrail);
  d = abs (p.y - trnUp) - 2.7;
  q.z = (abs (mod (q.z * sqrt2, 2. * stSize) - stSize) + stSize) / sqrt2;
  d = 0.8 * max (max (max (q.y - q.z, 0.1 - q.y), dx - 0.05), d);
  DMIN (idStp);
  p.z = mod (p.z - trnDir * trnPos + 0.5 * trnSpc, trnSpc) - 0.5 * trnSpc; 
  q = p;
  db = abs (max (PrRoundBoxDf (q, vec3 (0., cSize.yz), cSize.x), - trnUp - q.y));
  d = db - cSize.w;
  dy = 0.5 - abs (q.y - cSize.y);
  d = max (d, min (min (0.4 - abs (mod (q.z, 1.) - 0.5), cSize.z - abs (q.z)), dy));
  d = max (d, - max (max (PrRoundBox2Df (q.xy, vec2 (0., cSize.x - 0.2), cSize.x - 0.3), - dy),
     0.05 - abs (q.x)));
  dd = max (PrRoundBox2Df (vec2 (trnDir * q.x + cSize.x, q.z), dSize.xy, dSize.z),
     - dSize.w - q.y);
  if (opDoor) d = max (d, - dd);
  DMINQ (idCar);
  d = db - 0.5 * cSize.w;
  if (opDoor) d = max (d, - dd);
  DMINQ (idWin);
  d = PrCylDf (vec3 (q.x, q.y + trnUp - (2. * cSize.y - 0.1), abs (q.z) - 4. * dSize.z).xzy, 0.05,
     2. * cSize.y - 0.1);
  DMIN (idHrail);
  q.xz = abs (q.xz) - vec2 (0.65, 0.75) * cSize.xz;
  q.z = abs (q.z) - 0.6;
  q.y -= - trnUp;
  d = max (PrCylDf (q.yzx, whlRad, 0.08), q.y);
  DMINQ (idWhl);
  return dMin;
}

void SetTrnConf ()
{
  float t;
  t = mod (8. * tCur / trnSpc + 0.5 * step (1.5, cxId), 1.);
  trnPos = trnSpc * smoothstep (0.08, 0.92, t);
  trnDir = 1. - 2. * mod (cxId, 2.);
  opDoor = (0.5 - abs (t - 0.5) < 0.05);
}

float GObjRay (vec3 ro, vec3 rd)
{
  vec3 p;
  float s;
  float dHit, d, cxIdP, eps;
  eps = 0.0001;
  dHit = eps;
  if (rd.x == 0.) rd.x = 0.0001;
  cxIdP = -99.;
  for (int j = VAR_ZERO; j < 160; j ++) {
    p = ro + dHit * rd;
    cxId = floor (p.x / gGap);
    if (cxId != cxIdP) {
      cxIdP = cxId;
      SetTrnConf ();
    }
    s = ((cxId + step (0., rd.x)) * gGap - p.x) / rd.x;
    d = (cxId >= 0. && cxId <= 3.) ? GObjDf (p) : dstFar;
    d = min (d, abs (s) + eps);
    dHit += d;
    if (d < eps || dHit > dstFar) break;
  }
  if (d >= eps) dHit = dstFar;
  return dHit;
}

vec3 GObjNf (vec3 p)
{
  vec4 v;
  vec2 e;
  e = vec2 (0.001, -0.001);
  for (int j = VAR_ZERO; j < 4; j ++) {
    v[j] = GObjDf (p + ((j < 2) ? ((j == 0) ? e.xxx : e.xyy) : ((j == 2) ? e.yxy : e.yyx)));
  }
  v.x = - v.x;
  return normalize (2. * v.yzw - dot (v, vec4 (1.)));
}

float ObjDf (vec3 p)
{
  vec3 q;
  float dMin, d, dt, dx, dz;
  dMin = dstFar;
  p.x -= 2. * gGap;
  q = p;
  dx = abs (q.x) - statSz.x;
  dz = abs (q.z) - 9.5;
  q.x = abs (abs (q.x) - gGap) - tunSpc;
  dt = max (PrRoundBox2Df (q.xy, vec2 (0., cSize.y), cSize.x + 0.4), - cSize.y - 1.2 - q.y);
  d = max (abs (dt) - 0.1, statSz.z - 0.5 - abs (q.z));
  DMIN (idTun);
  q.y -= - trnUp - whlRad - 0.1;
  d = PrRoundBox2Df (vec2 (abs (q.x) - 0.65 * cSize.x, q.y), vec2 (0.06, 0.1) - 0.03, 0.03);
  DMIN (idTrk);
  q = p;
  d = max (max (abs (PrBox2Df (q.xz, statSz.xz + wThk)) - wThk, - dt),
     - PrRoundBoxDf (vec3 (dx - 0.5 * wThk, q.y - 5.16, dz), vec3 (wThk, 1.56, 0.8), 0.05));
  DMIN (idWal);
  q.y -= statSz.y + 2.6;
  d = max (abs (length (vec2 (mod (q.x + 0.25 * gGap, 0.5 * gGap) - 0.25 * gGap, q.y)) -
     0.4 * gGap) - 0.1, - q.y);
  DMIN (idCeil);
  q = p;
  q.y -= - trnUp - whlRad + 0.1;
  d = max (PrBox2Df (q.yz, vec2 (0.4, 1.7 * cSize.z)), 2.8 - abs (abs (q.x) - gGap));
  DMIN (idPlat);
  d = abs (q.y + 0.35 + wThk) - wThk;
  DMIN (idBase);
  q = p;
  q.y -= 3.58;
  q.z = dz;
  d = PrBoxDf (q, vec3 (statSz.x, 0.1, 0.85));
  DMIN (idStp);
  q = p;
  q.y -= 4.1;
  d = PrCylDf (vec3 (q.y - 0.4, abs (dz) - 0.82, q.x), 0.03, statSz.x);
  d = min (d, max (PrCylDf (vec3 (mod (q.x + 0.15, 0.3) - 0.15, q.y + 0.01, abs (dz) - 0.82).xzy,
     0.03, 0.41), dx));
  q.x = abs (q.x + 5.7 * sign (q.z)) - gGap;
  q.z = dz + 0.8;
  d = max (d, - PrBox2Df (q.xz, vec2 (stpWd, 0.5)));
  DMIN (idHrail);
  q = p;
  d = max (PrCylDf (vec3 (mod (q.x + 0.5 * gGap, gGap) - 0.5 * gGap, q.y - 0.8,
     abs (dz) - 0.3).xzy, 0.07, 2.7), dx);
  DMIN (idSup);
  d = PrCapsDf (vec3 (dx, q.y - statSz.y - 2.5, mod (q.z + 2., 4.) - 2.), 0.25, 0.5);
  DMIN (idLamp);
  return dMin;
}

float ObjRay (vec3 ro, vec3 rd)
{
  float dHit, d;
  dHit = 0.;
  for (int j = VAR_ZERO; j < 160; j ++) {
    d = ObjDf (ro + dHit * rd);
    if (d < 0.0005 || dHit > dstFar) break;
    dHit += d;
  }
  return dHit;
}

vec3 ObjNf (vec3 p)
{
  vec4 v;
  vec2 e;
  e = vec2 (0.001, -0.001);
  for (int j = VAR_ZERO; j < 4; j ++) {
    v[j] = ObjDf (p + ((j < 2) ? ((j == 0) ? e.xxx : e.xyy) : ((j == 2) ? e.yxy : e.yyx)));
  }
  v.x = - v.x;
  return normalize (2. * v.yzw - dot (v, vec4 (1.)));
}

vec3 ShStagGrid (vec2 p, vec2 g)
{
  vec2 q, sq, ss;
  q = p * g;
  if (2. * floor (0.5 * floor (q.y)) != floor (q.y)) q.x += 0.5;
  sq = smoothstep (0.02 * g, 0.03 * g, abs (fract (q + 0.5) - 0.5));
  q = fract (q) - 0.5;
  ss = 0.2 * smoothstep (0.35, 0.5, abs (q.xy)) * sign (q.xy);
  if (abs (q.x) < abs (q.y)) ss.x = 0.;
  else ss.y = 0.;
  return vec3 (ss.x, sq.x * sq.y, ss.y);
}

vec4 ShStagGrid3d (vec3 p, vec3 vn, vec2 g)
{
  vec3 rg;
  rg = ShStagGrid ((abs (vn.x) > 0.99) ? p.zy : ((abs (vn.y) > 0.99) ? p.zx : p.xy), g);
  if (abs (vn.x) > 0.99) {
    rg.xz *= sign (vn.x);
    if (rg.x == 0.) vn.xy = Rot2D (vn.xy, rg.z);
    else vn.xz = Rot2D (vn.xz, rg.x);
  } else if (abs (vn.y) > 0.99) {
    rg.xz *= sign (vn.y);
    if (rg.x == 0.) vn.yx = Rot2D (vn.yx, rg.z);
    else vn.yz = Rot2D (vn.yz, rg.x);
  } else if (abs (vn.z) > 0.99) {
    rg.xz *= sign (vn.z);
    if (rg.x == 0.) vn.zy = Rot2D (vn.zy, rg.z);
    else vn.zx = Rot2D (vn.zx, rg.x);
  }
  return vec4 (vn, rg.y);
}

float Truch (vec2 p)
{
  vec2 ip;
  ip = floor (p);
  p -= ip + 0.5;
  if (Hashfv2 (ip) < 0.5) p = vec2 (- p.y, p.x);
  return min (length (0.5 + p), length (0.5 - p));
}

vec3 ShowScene (vec3 ro, vec3 rd)
{
  vec4 col4, rg4;
  vec3 col, vn, ltDirL, stg;
  vec2 vf, u;
  float dstObj, dstObjG, nDotL, dSum, sSum, s, dx;
  bool isMet;
  gGap = 8.;
  trnSpc = 210.;
  cSize = vec4 (1., 0.7, 6., 0.06);
  dSize = vec4 (0.1, 0.8, 0.2, 1.3 * cSize.y);
  tunSpc = 1.7 * cSize.x;
  whlRad = 0.5;
  trnUp = 0.98;
  statSz = vec3 (18., 7., 3. * cSize.z);
  stpWd = 0.9;
  wThk = 0.5;
  dstObjG = GObjRay (ro, rd);
  dstObj = ObjRay (ro, rd);
  if (min (dstObj, dstObjG)  < dstFar) {
    if (dstObjG < dstObj) {
      dstObj = dstObjG;
      ro += dstObj * rd;
      vn = GObjNf (ro);
    } else {
      ro += dstObj * rd;
      vn = ObjNf (ro);
    }
    dx = abs (ro.x - 2. * gGap);
    vf = vec2 (0.);
    stg = vec3 (0.);
    if (idObj == idCar) {
      col4 = vec4 (1., 0.3, 0.3, 0.1) * (0.4 + 0.6 * smoothstep (0.005, 0.01,
         min (abs (max (PrRoundBox2Df (vec2 (abs (qHit.x) - cSize.x, qHit.z), dSize.xy, dSize.z),
         - dSize.w - qHit.y)), max (abs (qHit.z), abs (qHit.y - 0.42 * cSize.y) - 1.72 * cSize.y))));
      s = max (PrRoundBoxDf (qHit, vec3 (0., cSize.yz), cSize.x), - trnUp - qHit.y);
      col4 *= 1. - 0.7 * step (abs (s), 0.6 * cSize.w);
      if (s < 0.) {
        col4 *= 0.5 + 0.3 * smoothstep (0.05, 0.07, abs (mod (4. * qHit.x / cSize.x, 1.) - 0.5));
      } else {
        u = vec2 (abs (qHit.z) - 0.6 * cSize.z, qHit.y + 0.5 * cSize.y);
        col4 = mix (col4, vec4 (0.7, 0.1, 0.1, 0.1), step (abs (length (u) - 0.2), 0.04));
        u = abs (u) - vec2 (0.3, 0.05);
        col4 = mix (col4, vec4 (0.1, 0.1, 0.7, 0.1), step (max (u.x, u.y), 0.));
        if (abs (qHit.z) < cSize.z + 0.5) col4 *= 0.7 + 0.3 * smoothstep (0.01, 0.02,
           length (vec2 (qHit.x, mod (qHit.z + 0.5, 1.) - 0.5)) - 0.2 * cSize.x);
        else if (length (qHit.xy - vec2 (0., - 0.5 * cSize.y)) < 0.3 * cSize.y) col4 =
           (trnDir * sign (qHit.z) > 0.) ? vec4 (1., 1., 0.3, -1.) : vec4 (1., 0., 0., -1.);
      }
    } else if (idObj == idWin) {
      col4 = vec4 (0.1, 0.1, 0.2, 0.1);
    } else if (idObj == idWhl) {
      col4 = vec4 (0.4, 0.4, 0.45, 0.2);
    } else if (idObj == idTrk) {
      col4 = vec4 (0.8, 0.8, 0.85, 0.2) * ( 1. - 0.9 * smoothstep (0., 5.,
         max (abs (ro.z) - statSz.z, 0.)));
      cxId = floor (ro.x / gGap);
      SetTrnConf ();
      u = vec2 (ro.x - gGap * (cxId + 0.5) - trnDir * (0.5 * gGap - tunSpc),
         mod (ro.z - trnDir * trnPos + 0.5 * trnSpc, trnSpc) - 0.5 * trnSpc); 
      col4 *= 0.7 + 0.3 * smoothstep (0., 0.3, PrRoundBox2Df (u, cSize.xz, cSize.x));
    } else if (idObj == idTun) {
      col4 = vec4 (0.4, 0.3, 0., 0.) * (0.8 + 0.2 * step (0.2, mod (8. * ro.y, 1.)));
      col4 *= 1. - 0.9 * smoothstep (0., 5., abs (ro.z) - statSz.z);
    } else if (idObj == idPlat) {
      col4 = vec4 (0.5, 0.4, 0.2, 0.1);
      if (ro.y > -1.) {
        if (abs (dx - gGap) > 2.98) {
          u = abs (vec2 (abs (ro.x - 2. * gGap + 5.7 * sign (ro.z)) - gGap,
             abs (ro.z) - 6.5)) - vec2 (stpWd, 2.5);
          col4 *= 0.85 + 0.15 * smoothstep (-0.1, 0.3, max (u.x, u.y));
          stg = ro;
        } else {
          col4 = mix (vec4 (0.8, 0.1, 0.1, 0.1), vec4 (0.1, 0.2, 0.1, 0.1), step (0.,
             sign (sin (4. * pi * ro.z))));
        }
      } else col4 *= 0.9 + 0.1 * cos (16. * pi * ro.z);
      vf = vec2 (64., 0.5);
    } else if (idObj == idStp) {
      col4 = vec4 (0.4, 0.45, 0.4, 0.);
      vf = vec2 (64., 1.);
    } else if (idObj == idHrail) {
      col4 = vec4 (0.5, 0.5, 0.55, 0.2);
    } else if (idObj == idSup) {
      col4 = vec4 (0.5, 0.5, 0.55, 0.2) * (0.85 + 0.15 * sin (16. * pi * ro.y));
    } else if (idObj == idBase) {
      col4 = vec4 (0.2, 0.2, 0.2, 0.) * (0.5 + 0.5 * Fbm2 (32. * ro.xz));
      if (abs (abs (dx - gGap) - 1.7) < 0.65 * cSize.x)
         col4 *= (0.5 + 0.5 * step (0.8, mod (2. * ro.z, 1.)));
      vf = vec2 (32., 2.);
    } else if (idObj == idWal) {
      if (dx < statSz.x + 0.1 * wThk) {
        col4 = vec4 (0.45, 0.5, 0.6, 0.1);
        stg = ro + vec3 (0., 0.23, 0.);
        u = vec2 (mod (ro.z + 4., 8.) - 4., ro.y - 1.);
        col4 = mix (col4, vec4 (0.7, 0.1, 0.1, 0.1), step (abs (length (u) - 0.6), 0.12));
        u = abs (u) - vec2 (0.9, 0.15);
        col4 = mix (col4, vec4 (0.1, 0.1, 0.7, 0.1), step (max (u.x, u.y), 0.));
        s = PrRoundBox2Df (vec2 (ro.y - statSz.y - 2.5,
           mod (ro.z + 2., 4.) - 2.), vec2 (0., 0.5), 0.25);
        col4.rgb += vec3 (0.9, 0.9, 0.8) / (3. + 50. * s * s);
      } else col4 = vec4 (0.1, 0.15, 0.2, 0.);
      vf = vec2 (64., 0.5);
    } else if (idObj == idCeil) {
      col4 = vec4 (0.65, 0.75, 0.7, 0.1);
      col4.rgb *= 0.85 + 0.15 * smoothstep (0.08, 0.1, abs (Truch (2. * ro.xz) - 0.5));
      col4 = mix (vec4 (1., 1., 0.9, -1.), col4, 
         smoothstep (0.06, 0.08, abs (mod (ro.x + 0.25 * gGap, 0.5 * gGap) - 0.25 * gGap)));
    } else if (idObj == idLamp) {
      col4 = vec4 (vec3 (0.9, 0.9, 0.8) * (0.95 + 0.05 * cos (32. * pi * ro.y)), -1.);
    }
    if (stg != vec3 (0.)) {
      rg4 = ShStagGrid3d (stg, vn, vec2 (4./3., 2.));
      vn = rg4.xyz;
      col4.rgb *= 0.9 + 0.1 * rg4.w;
    }
    if (vf.x > 0.) vn = VaryNf (vf.x * ro, vn, vf.y);
    if (col4.a >= 0.) {
      isMet = (idObj == idCar || idObj == idTrk || idObj == idWhl);
      dSum = 0.;
      sSum = 0.;
      for (int k = VAR_ZERO; k < 5; k ++) {
        if (k < 4) {
          ltDirL = normalize (vec3 (vec2 (min (statSz.x, statSz.z) - 1.), statSz.y + 2.).xzy);
          ltDirL.xz = Rot2D (ltDirL.xz, 0.5 * pi * float (k));
        } else ltDirL = ltDir;
        nDotL = max (dot (vn, ltDirL), 0.);
        if (isMet) nDotL *= nDotL;
        dSum += ((k < 4) ? 1. : 0.5) * nDotL;
        sSum += ((k < 4) ? 1. : 0.5) * pow (max (dot (normalize (ltDirL - rd), vn), 0.), 32.);
      }
      col = col4.rgb * (0.1 + 0.4 * dSum) + 0.5 * col4.a * sSum;
    } else col = col4.rgb * (0.6 - 0.4 * dot (rd, vn));
    if (idObj == idWin) col += vec3 (0., 0., 0.03);
  } else {
    col = vec3 (0.1);
  }
  if (! colImg) col = vec3 (0.9, 0.7, 0.5) * Maxv3 (col);
  return clamp (col, 0., 1.);
}

void mainImage (out vec4 fragColor, in vec2 fragCoord)
{
  mat3 vuMat;
  vec4 mPtr;
  vec3 ro, rd, col;
  vec2 canvas, uv, uvv, mMid[2], ut[2], mSize, msw;
  float el, az, zmFac, asp, vuId, regId, sr, t;
  int vuMode;
  canvas = iResolution.xy;
  uv = 2. * fragCoord.xy / canvas - 1.;
  uv.x *= canvas.x / canvas.y;
  tCur = iTime;
  mPtr = iMouse;
  mPtr.xy = mPtr.xy / canvas - 0.5;
  colImg = true;
  asp = canvas.x / canvas.y;
  mSize = (1./6.) * vec2 (asp, 1.);
  if (mPtr.z > 0. && Minv2 (- mPtr.xy + 0.03 * vec2 (1. / asp, 1.) - 0.5) > 0.) colImg = ! colImg;
  mMid[0] = vec2 (asp, 1.) * (1. - mSize.y) * vec2 (-1., 1.);
  mMid[1] = vec2 (asp, 1.) * (1. - mSize.y) * vec2 (1., 1.);
  for (int k = 0; k < 2; k ++) ut[k] = abs (uv - mMid[k]) - mSize;
  regId = -1.;
  if (mPtr.z > 0. && colImg) {
    for (int k = 0; k < 2; k ++) {
      msw = 2. * mPtr.xy - mMid[k] / vec2 (asp, 1.);
      if (Maxv2 (abs (msw)) < mSize.y) {
        regId = 1. + float (k);
        msw /= 2. * mSize.y;
        break;
      }
    }
    if (regId == -1.) msw = mPtr.xy;
  }
  vuId = 0.;
  for (int k = 0; k < 2; k ++) {
    if (Maxv2 (ut[k]) < 0.) {
      uv = (uv - mMid[k]) / mSize.y;
      vuId = float (k + 1);
      break;
    }
  }
  if (regId > 0. && (vuId == 0. || vuId == regId)) vuId = regId - vuId;
  t = mod (0.05 * tCur, 6.);
  vuMode = int (mod (vuId + floor (t / 2.), 3.)) + 1;
  t = mod (t, 2.);
  t = SmoothBump (0.25, 0.75, 0.22, mod (t, 1.)) * sign (t - 1.);
  if (vuMode == 1) {
    az = -0.5 * pi;
    el = -0.05 * pi;
  } else if (vuMode == 2) {
    az = 0.55 * pi;
    el = -0.15 * pi;
  } else if (vuMode == 3) {
    az = 0.75 * pi;
    el = -0.15 * pi;
  }
  if ((mPtr.z <= 0. || ! colImg)  && vuId == 0.) {
    if (vuMode == 1) az += 0.25 * pi * t;
    else if (vuMode == 2 || vuMode == 3) el += 0.15 * pi * t;
  }
  if (mPtr.z > 0. && (vuId == 0. || vuId == regId)) {
    az += 2. * pi * msw.x;
    el += pi * msw.y;
  }
  el = clamp (el, -0.4 * pi, 0.4 * pi);
  vuMat = StdVuMat (el, az);
  if (vuMode == 1) {
    ro = vuMat * vec3 (0., 0., -4.);
    ro.xy += vec2 (17., 1. /*3.*/);
    ro.y = max (ro.y, 0.);
    zmFac = 2.7;
  } else if (vuMode == 2) {
    ro = vec3 (4., 8., 5.);
    zmFac = 3.;
  } else if (vuMode == 3) {
    ro = vec3 (4., 6., 15.);
    zmFac = 3.;
  }
  dstFar = 150.;
  ltDir = vuMat * normalize (vec3 (0.3, 1., -1.));
#if ! AA
  const float naa = 1.;
#else
  const float naa = 3.;
#endif  
  col = vec3 (0.);
  sr = 2. * mod (dot (mod (floor (0.5 * (uv + 1.) * canvas), 2.), vec2 (1.)), 2.) - 1.;
  for (float a = float (VAR_ZERO); a < naa; a ++) {
    uvv = (uv + step (1.5, naa) * Rot2D (vec2 (0.5 / canvas.y, 0.), sr * (0.667 * a +
       0.5) * pi)) / zmFac;
    rd = vuMat * normalize (vec3 ((2. * tan (0.5 * atan (uvv.x / asp))) * asp, uvv.y, 1.));
    col += (1. / naa) * ShowScene (ro, rd);
  }
  for (int k = 0; k < 2; k ++) {
    if (Maxv2 (ut[k]) < 0. && Minv2 (abs (ut[k])) * canvas.y < 2.1)
       col = colImg ? vec3 (0.3, 0.7, 0.3) : vec3 (0.9, 0.7, 0.5);
  }
  fragColor = vec4 (col, 1.);
}

float PrBoxDf (vec3 p, vec3 b)
{
  vec3 d;
  d = abs (p) - b;
  return min (max (d.x, max (d.y, d.z)), 0.) + length (max (d, 0.));
}

float PrBox2Df (vec2 p, vec2 b)
{
  vec2 d;
  d = abs (p) - b;
  return min (max (d.x, d.y), 0.) + length (max (d, 0.));
}

float PrRoundBoxDf (vec3 p, vec3 b, float r)
{
  return length (max (abs (p) - b, 0.)) - r;
}

float PrRoundBox2Df (vec2 p, vec2 b, float r)
{
  return length (max (abs (p) - b, 0.)) - r;
}

float PrSphDf (vec3 p, float r)
{
  return length (p) - r;
}

float PrCylDf (vec3 p, float r, float h)
{
  return max (length (p.xy) - r, abs (p.z) - h);
}

float PrCapsDf (vec3 p, float r, float h)
{
  return length (p - vec3 (0., 0., clamp (p.z, - h, h))) - r;
}

float Minv2 (vec2 p)
{
  return min (p.x, p.y);
}

float Maxv2 (vec2 p)
{
  return max (p.x, p.y);
}

float Maxv3 (vec3 p)
{
  return max (p.x, max (p.y, p.z));
}

float SmoothBump (float lo, float hi, float w, float x)
{
  return (1. - smoothstep (hi - w, hi + w, x)) * smoothstep (lo - w, lo + w, x);
}

mat3 StdVuMat (float el, float az)
{
  vec2 ori, ca, sa;
  ori = vec2 (el, az);
  ca = cos (ori);
  sa = sin (ori);
  return mat3 (ca.y, 0., - sa.y, 0., 1., 0., sa.y, 0., ca.y) *
         mat3 (1., 0., 0., 0., ca.x, - sa.x, 0., sa.x, ca.x);
}

vec2 Rot2D (vec2 q, float a)
{
  vec2 cs;
  cs = sin (a + vec2 (0.5 * pi, 0.));
  return vec2 (dot (q, vec2 (cs.x, - cs.y)), dot (q.yx, cs));
}

vec2 Rot2Cs (vec2 q, vec2 cs)
{
  return vec2 (dot (q, vec2 (cs.x, - cs.y)), dot (q.yx, cs));
}

const float cHashM = 43758.54;

float Hashfv2 (vec2 p)
{
  return fract (sin (dot (p, vec2 (37., 39.))) * cHashM);
}

vec2 Hashv2v2 (vec2 p)
{
  vec2 cHashVA2 = vec2 (37., 39.);
  return fract (sin (dot (p, cHashVA2) + vec2 (0., cHashVA2.x)) * cHashM);
}

float Noisefv2 (vec2 p)
{
  vec2 t, ip, fp;
  ip = floor (p);  
  fp = fract (p);
  fp = fp * fp * (3. - 2. * fp);
  t = mix (Hashv2v2 (ip), Hashv2v2 (ip + vec2 (0., 1.)), fp.y);
  return mix (t.x, t.y, fp.x);
}

float Fbm2 (vec2 p)
{
  float f, a;
  f = 0.;
  a = 1.;
  for (int j = 0; j < 5; j ++) {
    f += a * Noisefv2 (p);
    a *= 0.5;
    p *= 2.;
  }
  return f * (1. / 1.9375);
}

float Fbmn (vec3 p, vec3 n)
{
  vec3 s;
  float a;
  s = vec3 (0.);
  a = 1.;
  for (int j = 0; j < 5; j ++) {
    s += a * vec3 (Noisefv2 (p.yz), Noisefv2 (p.zx), Noisefv2 (p.xy));
    a *= 0.5;
    p *= 2.;
  }
  return dot (s, abs (n));
}

vec3 VaryNf (vec3 p, vec3 n, float f)
{
  vec3 g;
  vec2 e = vec2 (0.1, 0.);
  g = vec3 (Fbmn (p + e.xyy, n), Fbmn (p + e.yxy, n), Fbmn (p + e.yyx, n)) - Fbmn (p, n);
  return normalize (n + f * (g - n * dot (n, g)));
}

// --------[ Original ShaderToy ends here ]---------- //

void main(void)
{
    mainImage(gl_FragColor, gl_FragCoord.xy);
}