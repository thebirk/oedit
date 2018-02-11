#version 330 core

in vec2 uv;
in vec4 fg_color;
in vec4 bg_color;

out vec4 final_color;

uniform sampler2D atlas;

void main() {
    vec4 color = texture(atlas, uv);
    if(color.r != 0) {
        final_color = vec4(fg_color.rgb * color.r, bg_color.a*color.r);
    } else {
        final_color = bg_color;
    }
}