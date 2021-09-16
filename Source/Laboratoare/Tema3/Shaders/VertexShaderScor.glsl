#version 330

layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;
layout(location = 3) in vec3 v_color;

uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;

uniform vec3 object_color;

// Output value to fragment shader
out vec2 texcoord;
out vec3 in_color;

void main()
{
	texcoord = v_texture_coord;
	in_color = object_color;
    
    gl_Position = Model * vec4(v_position, 1.0);

}
