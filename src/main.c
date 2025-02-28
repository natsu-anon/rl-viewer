#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <math.h>
#include "raylib.h"
#include "rlgl.h"
#define GLSL_VERSION 330



void normalize(Vector3 *v)
{
	float k = sqrtf(v->x * v->x + v->y * v->y + v->z * v->z);
	v->x *= k;
	v->y *= k;
	v->z *= k;
}

void print_usage(void)
{
	printf("Usage:\n\n"
		   "  rl-viewer -m <model-path> [options]\n\n"
		   "Arguments:\n"
		   "  <model-path>    = Path to the model to view.\n"
		   "Options:\n"
		   "  -v <vertex-path>   = Path to the vertex shader to use.\n"
		   "                       If omitted, defaults to shaders/vert_default.glsl.\n"
		   "  -f <fragment-path> = Path to the fragment shader to use.\n"
		   "                       If omitted, defaults to shaders/frag_default.glsl.\n");
}

int main(int argc, char** argv)
{
	int c;
	char* model_path = NULL;
	char* vert_path = "shaders/vert_default.glsl";
	char* frag_path = "shaders/frag_default.glsl";
	while ((c = getopt(argc, argv, "tm:v:f:")) != -1)
	{
		switch (c) {
		case 't':
			break;
		case 'm':
			model_path = optarg;
			break;
		case 'v':
			vert_path = optarg;
			break;
		case 'f':
			frag_path = optarg;
			break;
		case ':':
			fprintf(stderr, "Unrecognized option: %s", argv[optind - 1]);
			return 1;
		case '?':
			fprintf(stderr, "Unrecognized option: %s", argv[optind - 1]);
			return 1;
		}
	}
	uint8_t args_ok = 1;
	if (!model_path)
	{
		fprintf(stderr, "ERROR: model-viewer expects one -m <model> argument!\n");
		args_ok = 0;
	}
	/* if (!vert_path) */
	/* { */
	/* 	fprintf(stderr, "ERROR: model-viewer expects one -v <vertex_shader> argument!\n"); */
	/* 	args_ok = 0; */
	/* } */
	/* if (!frag_path) */
	/* { */
	/* 	fprintf(stderr, "ERROR: model-viewer expects one -f <fragment_shader> argument!\n"); */
	/* 	args_ok = 0; */
	/* } */
	if (!args_ok) {
		print_usage();
		return 1;
	}
    InitWindow(1920, 1080, "raylib model viewer");
	// camera
	Camera camera = { 0 };
	camera.position = (Vector3){ 6.0f, 2.0f, 6.0f };    // Camera position
	camera.target = (Vector3){ 0.0f, 0.0f, 0.0f };      // Camera looking at point
	camera.up = (Vector3){ 0.0f, 1.0f, 0.0f };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0f;                                // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;             // Camera projection type
	// load model
	Model model = LoadModel(model_path);
	if (!IsModelValid(model))
	{
		fprintf(stderr, "Failed to load model from '%s'.\nDoes raylib support it?\n", model_path);
		goto cleanup_model;
	}
	Vector3 model_pos = { 0.0f, 0.0f, 0.0f };
	// create shader
	Shader shader = LoadShader(vert_path, frag_path);
	if (!IsShaderValid(shader)) {
		fprintf(stderr, "Failed to load shader!\nPlease check your vertex & fragment shaders located at '%s' & '%s'.\n", vert_path, frag_path);
		goto cleanup_shader;
	}
	for (int i = 0; i < model.materialCount; ++i) {
		model.materials[i].shader = shader;
	}
	// for scrolling brick example
	int tex_loc = GetShaderLocation(shader, "noiseTexture");
	int time_loc = GetShaderLocation(shader, "rlTime");
	int cam_loc = GetShaderLocation(shader, "camDir");
	int light_loc = GetShaderLocation(shader, "lightDir");
	// "light" setup
	Vector3 light = { 0.3f, 1.0f, -0.3f };
	normalize(&light);
	SetShaderValue(shader, light_loc, &light, SHADER_UNIFORM_VEC3);
	/* light = */
	// load noise texture
	Texture2D noise_texture = LoadTexture("assets/noise.bmp");
	if (!IsTextureValid(noise_texture)) {
		perror("Failed to load texture: 'assets/noise.bmp'!\n");
		goto cleanup_texture;
	}
	SetTargetFPS(60);
	HideCursor();
	DisableCursor();
    while (!WindowShouldClose())
    {
		float rl_time = GetTime(); // for brick scrolling
		Vector3 camera_dir = camera.target;
		SetShaderValue(shader, time_loc, &rl_time, SHADER_UNIFORM_FLOAT);
		SetShaderValue(shader, cam_loc, &camera_dir, SHADER_UNIFORM_VEC3);
		UpdateCamera(&camera, CAMERA_FREE);
        BeginDrawing();
			ClearBackground((Color){40, 40, 60, 255});
			BeginMode3D(camera);
			    // for brick scrolling
				int tex_slot = 0;
				rlActiveTextureSlot(tex_slot);
				rlEnableTexture(noise_texture.id);
				SetShaderValueTexture(shader, tex_loc, noise_texture);
			    // vaniglia
				DrawModel(model, model_pos, 1.0f, WHITE);
				DrawGrid(10, 1.0f);
			EndMode3D();
            DrawText("Press 'Escape' to close.", 20, 20, 24, LIGHTGRAY);
        EndDrawing();
    }
	EnableCursor();
	ShowCursor();
	UnloadShader(shader);
	UnloadTexture(noise_texture);
	UnloadModel(model);
    CloseWindow();
    return 0;
cleanup_texture:
	UnloadTexture(noise_texture);
cleanup_shader:
	UnloadShader(shader);
cleanup_model:
	UnloadModel(model);
	CloseWindow();
	return 1;
}
