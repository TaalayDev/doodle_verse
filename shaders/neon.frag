#version 300 es

precision mediump float;

uniform vec2 uResolution;
uniform vec3 uColor;

out vec4 fragColor;

void main() {
    vec2 st = gl_FragCoord.xy / uResolution.xy;
    vec2 pos = vec2(0.5) - st;

    float r = length(pos) * 2.0;
    float glow = 0.05 / r;

    vec3 color = uColor * glow;
    fragColor = vec4(color, 1.0);
}