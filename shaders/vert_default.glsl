#version 330 core
in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;
out vec2 fragTexCoord;
out vec3 fragNormal;
out vec4 fragColor;

uniform mat4 modelMatrx;
uniform mat4 mvp;

void main()
{
    fragTexCoord = vertexTexCoord;
	fragColor = vertexColor;
	fragNormal = vertexNormal;
    gl_Position = mvp * vec4(vertexPosition, 1.0);
}
