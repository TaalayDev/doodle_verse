#version 460 core

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;

layout(location = 0) out vec4 fragColor;

float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    vec2 st = gl_FragCoord.xy / uResolution.xy;
    vec2 pos = vec2(0.5) - st;

    float n = noise(pos * 3.0 + uTime * 0.1);
    float r = length(pos) * 2.0;
    float a = atan(pos.y, pos.x);

    float f = abs(cos(a * 12.0) * sin(a * 3.0)) * 0.8 + 0.1;
    float color = 1.0 - smoothstep(f, f + 0.02, r);

    color *= 1.0 - n * 0.5;
    fragColor = vec4(vec3(color), 1.0);
}