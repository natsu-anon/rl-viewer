#version 330 core
in vec2 fragTexCoord;
out vec4 finalColor;

uniform sampler2D noiseTexture;
uniform float rlTime;

#define PI 3.1415926535897932384626433832795f

const int numCols = 8;
const int numRows = 32;
const float mortarThreshold = 0.1f; // 0 - 1
const float offset = 0.5f;
const vec3 brickRed = { 0.6f, 0.22f, 0.2f };
const vec3 mortarGray = { 0.4f, 0.41f, 0.44f };
const float scrollSpeed = 1.0f;

void main()
{
	float index = floor(numRows * fragTexCoord.y) / numRows;
	float sinY = sin(PI * numRows * fragTexCoord.y);
	/* NOTE: I subtract 0.5f from the texture sample because I want bricks to scroll in both directions.
	 * If I did NOT subtract 0.5f all of the texture values would be in [0, 1], meaning the bricks would only run in one direction.
	 * Just crank up scrollSpeed if it's a little too slow ezpz */
	float scrolled = fragTexCoord.x + index * scrollSpeed * rlTime * (texture(noiseTexture, vec2(index, 0.0f)).r - 0.5f);
	// float sinX = sin(PI * numCols * fragTexCoord.x + offset * PI * step(0.0f, sinY));
	float sinX = sin(PI * numCols * scrolled + offset * PI * step(0.0f, sinY));

	// vec2 brickCoords = PI * vec2(numCols, numRows) * fragTexCoord;
	vec2 brickCoords = abs(vec2(sinX, sinY));
	brickCoords = sin(brickCoords);
	brickCoords = abs(brickCoords);
	float brick = min(brickCoords.x, brickCoords.y);
	brick = step(mortarThreshold, brick);
    finalColor = vec4(mix(mortarGray, brickRed, brick), 1.0f);
    // finalColor = vec4(indices, 0.0f, 0.0f, 1.0f);
}
