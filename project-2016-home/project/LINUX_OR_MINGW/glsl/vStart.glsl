#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec3 pos;
out vec3 normal;
out vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
    // The vector to the light from the vertex    
    //vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vPosition).xyz;
    
    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 normal = (ModelView * vec4(vNormal, 0.0)).xyz;


    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}
