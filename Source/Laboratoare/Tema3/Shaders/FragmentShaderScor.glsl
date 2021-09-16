uniform sampler2D texture_1;


in vec2 texcoord;
in vec3 in_color;

layout(location = 0) out vec4 out_color;

void main()
{
	// TODO : calculate the out_color using the texture2D() function
	out_color = vec4(1);
	vec2 coord = texcoord;

	out_color =  texture2D(texture_1, coord);
}