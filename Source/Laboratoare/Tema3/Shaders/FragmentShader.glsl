uniform sampler2D texture_1;
uniform sampler2D texture_2;
uniform int usesTexture2;

uniform float Timp;
uniform float Speed;
uniform int Ball;

uniform vec3 light_direction;
uniform vec3 light_position;
uniform vec3 light_position_punct1;
uniform vec3 light_position_punct2;
uniform vec3 eye_position;

uniform float material_kd;
uniform float material_ks;
uniform float cutoff;
uniform int material_shininess;

uniform int DiscardWhite;
uniform int DeformBall;
uniform int Score;
uniform int DontMultiply;
uniform int Invincible;

in vec2 texcoord;
in vec3 in_color;
in vec3 world_position;
in vec3 world_normal;

layout(location = 0) out vec4 out_color;

void main()
{
	out_color = vec4(1);
	vec2 coord = texcoord;

	vec3 N = normalize(world_normal);
	vec3 L = normalize(light_position - world_position);
	vec3 V = normalize(eye_position - world_position);
	vec3 R = reflect (-L, N);
	vec3 H = normalize( L + V );

	vec3 N2 = normalize(world_normal);
	vec3 L2 = normalize(light_position_punct1 - world_position);
	vec3 V2 = normalize(eye_position - world_position);
	vec3 R2 = reflect (-L2, N2);
	vec3 H2 = normalize( L2 + V2 );

	vec3 N3 = normalize(world_normal);
	vec3 L3 = normalize(light_position_punct2 - world_position);
	vec3 V3 = normalize(eye_position - world_position);
	vec3 R3 = reflect (-L3, N3);
	vec3 H3 = normalize( L3 + V3 );
	float ambient_light = 0.5;

	float diffuse_light = dot(L ,world_normal);
	float diffuse_light2 = dot(L2 ,world_normal);
	float diffuse_light3 = dot(L3 ,world_normal);

	float specular_light = 0;

	float cut_off = radians(cutoff);
	float spot_light = dot(-L, light_direction);
	float spot_light_limit = cos(cut_off);

	float linear_att = (spot_light - spot_light_limit) / (1.0f - spot_light_limit);
	float light_att_factor = pow(linear_att, 2);

	float punct	= distance(light_position, world_position);
	float light_att_factor_punct = 1.f / max(punct - 1, 1.f);

	if (diffuse_light > 0)
	{
		specular_light = max(0, dot(R, V));
	}

	// Pentru textura de fani ridicati de pe scaune
	if(DontMultiply == 1) {
		coord /= 10;
	}
	out_color =  texture2D(texture_1, coord);
	if(DiscardWhite == 1 && out_color.b > 0.8f){
		discard;
	}
	
	vec3 light = vec3(ambient_light) + vec3(light_att_factor * 2 * (material_kd * max(diffuse_light, 0)) + vec3(material_ks * 1 * pow(max(dot(N, H), 0), material_shininess)))
						  + (vec3(light_att_factor_punct * (material_kd * max(diffuse_light2, 0)) + material_ks * vec3(1, 0, 0) * pow(max(dot(N2, H2), 0), material_shininess))) * vec3(0, 0, 10)
						  + (vec3(light_att_factor_punct * (material_kd * max(diffuse_light3, 0)) + material_ks * vec3(0.7, 0.2, 0.5) * pow(max(dot(N3, H3), 0), material_shininess))) * vec3(5, 0, 0);

	out_color *= vec4(light, 1);


	if (spot_light > cos(cut_off))
	{
		//out_color *= vec4(.2, .65, .65, 1);
		out_color *= vec4(vec3(ambient_light + light_att_factor_punct), 1);
	} else {
		out_color *= vec4(vec3(ambient_light), 1);
	}

	

	if(usesTexture2 == 1) {
		out_color = mix(out_color, texture2D(texture_2, texcoord), 0.7f);
	}
}