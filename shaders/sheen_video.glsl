#version 330 core
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;
out vec4 finalColor;

uniform vec3 camDir;
uniform vec3 lightDir;

void main()
{
	// Blinn-Phong for specular highlights
	float nDotL = dot(lightDir, fragNormal);
	vec3 halfVector = normalize(lightDir + camDir);
	float blinnPhong = dot(fragNormal, halfVector);
	float specular = pow(blinnPhong, 32.0f);
	specular = smoothstep(0.1, 0.11, specular);
	// fresnel
	float fresnel = 1.0f - dot(fragNormal, camDir);
	finalColor = vec4(specular, 0.0f, fresnel, 1.0f);
}
