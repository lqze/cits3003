#version 130
// per-fragment interpolated values from the vertex shader
in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
in  vec3 fL1, fL2;
in  vec3 fN;
in  vec3 fE;

out vec4 fColor;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;
uniform float texScale;
uniform float brightness1, brightness2;
uniform sampler2D texture;

void main()
{
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 E = normalize( -fE ); 	    // Direction to the eye/camera
    vec3 N = normalize( fN );       // Normal vector
    vec3 L1 = normalize( fL1 );     // Directions to the light sources
    vec3 L2 = normalize( fL2 );        
    vec3 H1 = normalize( L1 + E );  // Halfway vectors
    vec3 H2 = normalize( L2 + E );
  
    // Compute terms in the illumination equation
	
    vec3 ambient1 = brightness1 * AmbientProduct;
    vec3 ambient2 = brightness2 * AmbientProduct;

    float Kd1 = max( dot(L1, N), 0.0 );
    vec3  diffuse1 = brightness1 * Kd1 * DiffuseProduct;
    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = brightness2 * Kd2 * DiffuseProduct;

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess );
    vec3  specular1 = brightness1 * Ks1 * SpecularProduct;
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3  specular2 = brightness2 * Ks2 * SpecularProduct;
    
    if (dot(L1, N) < 0.0 ) {
	    specular1 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L2, N) < 0.0 ) {
	    specular2 = vec3(0.0, 0.0, 0.0);
    } 
    
    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
	
    // Part F: implement Blinn-Phong lighting reflection model with attenuation
    float a = 1.0, b = 0.2, c = 0.6;

    float distanceToLight = length(fL1);
    float attenuation = 1 / (a + b*distanceToLight + c*pow(distanceToLight,2));

    vec4 color = vec4(globalAmbient + (attenuation*ambient1) + (attenuation*diffuse1) + ambient2 + diffuse2, 1.0);
    fColor = color * texture2D(texture, texCoord * texScale) + vec4((attenuation*specular1) + specular2, 1.0);
} 
