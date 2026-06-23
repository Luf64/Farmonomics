shader_type canvas_item;

uniform float speed = 0.5;

void vertex() {
	UV.x += speed;
	UV.y += speed;
}
