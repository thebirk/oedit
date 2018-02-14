#version 330 core

in vec2 uv;
in vec4 fg_color;
in vec4 bg_color;

out vec4 final_color;

uniform sampler2D atlas;

void main() {
    vec4 color = vec4(1, 1, 1, texture(atlas, uv).r);
    final_color = fg_color*color;
}