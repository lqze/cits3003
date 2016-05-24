#version 130
in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

in  vec4  BoneWeights;
in  ivec4 BoneIDs;

// output values that will be interpolated per-fragment
out vec3 fN;
out vec3 fE;
out vec3 fL1, fL2;
out vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition1, LightPosition2;
uniform mat4 boneTransforms[64]; 

void main()
{   
    // Part 2: Insert bone weights into vector shader
    mat4 boneTransform = BoneWeights[0] * boneTransforms[BoneIDs[0]] +
        BoneWeights[1] * boneTransforms[BoneIDs[1]] +
        BoneWeights[2] * boneTransforms[BoneIDs[2]] +
        BoneWeights[3] * boneTransforms[BoneIDs[3]];

    vec3 normal = mat3(boneTransform) * vNormal;
    vec4 position = boneTransform * vPosition;
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
	fN = (ModelView * vec4(normal, 0.0)).xyz;
         
    // The vector to the first light from the vertex    
    fL1 = LightPosition1.xyz - pos;
    fL2 = LightPosition2.xyz;
    
    // The vector to the eye/camera from the vertex
	fE = pos;
   
    gl_Position = Projection * ModelView * position;
    
    texCoord = vTexCoord;
}
