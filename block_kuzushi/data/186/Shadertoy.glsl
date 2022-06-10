uniform vec2 iResolution;

uniform sampler2D iChannel0;

// Copyright Inigo Quilez, 2013 - https://iquilezles.org/
// I am the sole copyright owner of this Work.
// You cannot host, display, distribute or share this Work in any form,
// including physical and digital. You cannot use this Work in any
// commercial or non-commercial product, website or project. You cannot
// sell this Work and you cannot mint an NFTs of it.
// I share this Work for educational purposes, and you can link to it,
// through an URL, proper attribution and unmodified screenshot, as part
// of your educational material. If these conditions are too restrictive
// please contact me and we'll definitely work it out.


// on the derivatives based noise: http://iquilezles.org/www/articles/morenoise/morenoise.htm
// on the soft shadow technique: http://iquilezles.org/www/articles/rmshadows/rmshadows.htm
// on the fog calculations: http://iquilezles.org/www/articles/fog/fog.htm
// on the lighting: http://iquilezles.org/www/articles/outdoorslighting/outdoorslighting.htm
// on the raymarching: http://iquilezles.org/www/articles/terrainmarching/terrainmarching.htm


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec4 data = texture( iChannel0, uv );

	// （iChannel0で2つシェーダーを使う例としてカタチだけ残したかったので＼(^_^)／）
    vec3 col = data.xyz;    
    fragColor = vec4( col, 1.0 );
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	gl_FragColor = fragColor;
}
