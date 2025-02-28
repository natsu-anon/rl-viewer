#version 330
in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

#define PI 3.1415926535897932384626433832795

const int scale = 3;
const int numCols = 7;
const int numRows = 15;
const float mortarThreshold = 0.1f;

void main()
{
	// vec2 offset = PI 
	brickCoords = sin(brickCoords);
	brickCoords = abs(brickCoords);
	float brick = min(brickCoords.x, brickCoords.y);
	brick = smoothstep(mortarThreshold - 0.01f, mortarThreshold, brick);
    finalColor = vec4(brick, brick, brick, 1.0f);
}
