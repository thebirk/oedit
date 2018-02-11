#version 330 core

layout(location=0) in vec2 in_position;
layout(location=1) in vec2 in_uv;
layout(location=2) in vec4 in_fg_color;
layout(location=3) in vec4 in_bg_color;

out vec2 uv;
out vec4 fg_color;
out vec4 bg_color;

uniform mat4 projection;

void main() {
    uv = in_uv;
    fg_color = in_fg_color;
    bg_color = in_bg_color;
    gl_Position = projection * vec4(in_position, 0, 1);
}