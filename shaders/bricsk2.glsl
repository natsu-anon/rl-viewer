#version 330
in vec2 fragTexCoord;
out vec4 finalColor;

#define PI 3.1415926535897932384626433832795

uniform float scale;

void main()
{
	vec2 bricks = scale * PI * fragTexCoord;
	bricks = sin(bricks);
	bricks = 0.5f * bricks + 0.5f;
	finalColor = vec4(bricks, 0.0f, 1.0f);
}
