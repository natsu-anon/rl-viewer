#version 330
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;
out vec4 finalColor;

uniform vec3 camDir;
uniform vec3 lightDir;

void main()
{
	// finalColor = vec4(fragNormal, 1.0f);
	float nDotL = dot(lightDir, fragNormal);
	vec3 halfVector = normalize(lightDir + camDir);
	float nDotH = dot(fragNormal, halfVector);
	finalColor = vec4(nDotH, nDotH, nDotH, 1.0f);
}
