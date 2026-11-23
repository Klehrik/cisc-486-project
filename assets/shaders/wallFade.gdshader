shader_type spatial;

uniform vec3 bottom_color : source_color = vec3(0.1804, 0.3451, 0.3882);
uniform vec3 top_color : source_color = vec3(0.043, 0.051, 0.149);

varying float height_fade;

void vertex() {
	float world_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
	height_fade = smoothstep(
		0.0,
		1.5,
		world_y
	);
}

void fragment() {
	ALBEDO = mix(bottom_color, top_color, height_fade);
}
