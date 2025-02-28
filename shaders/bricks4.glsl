#version 330
in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

#define PI 3.1415926535897932384626433832795

const int scale = 3;
const int numCols = 8;
const int numRows = 32;
const float offset = 0.25f;
const float mortarThreshold = 0.1f; // (0, 1)
const vec3 brickRed = { 0.6f, 0.22f, 0.2f };
const vec3 mortarGray = { 0.4f, 0.41f, 0.44f };

void main()
{
	float sinY = sin(PI * numRows * fragTexCoord.y);
	float sinX = sin(PI * numCols * fragTexCoord.x + offset * PI * step(0.0f, sinY));
	// float temp = PI * numCols * fragTexCoord.x;
	// float sinX = mix(sin(temp), cos(temp), step(0.0f, sinY));
    // finalColor = vec4(sinX, sinY, 0.0f, 1.0f);
	// vec2 brickCoords = PI * vec2(numCols, numRows) * fragTexCoord;
	vec2 brickCoords = abs(vec2(sinX, sinY));
	float brick = min(brickCoords.x, brickCoords.y);
	brick = step(mortarThreshold, brick);
    finalColor = vec4(mix(mortarGray, brickRed, brick), 1.0f);
}
