#version 330 core
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;
out vec4 finalColor;

uniform vec3 camDir;
uniform vec3 lightDir;

const vec3 color = { 1.0f, 0.55f, 0.6f };
const vec3 specularColor = { 0.4f, 0.4f, 0.95f };

void main()
{
	// Blinn-Phong for specular highlights
	float nDotL = dot(lightDir, fragNormal);
	nDotL = step(0.0f, nDotL);
	float lighting = clamp(nDotL, 0.7f, 0.9f);
	lighting += 0.1f * dot(lightDir, fragNormal);
	vec3 halfVector = normalize(lightDir + camDir);
	float blinnPhong = dot(fragNormal, halfVector);
	float specular = pow(blinnPhong, 16.0f);
	specular = smoothstep(0.5, 0.51, specular);
	// fresnel
	float fresnel = 1.0f - clamp(dot(fragNormal, camDir), 0.0f, 1.0f);
	// finalColor = vec4(specular, 0.0f, fresnel, 1.0f);
	finalColor = vec4(lighting * color + specularColor * nDotL * (specular + fresnel), 1.0f);
}
