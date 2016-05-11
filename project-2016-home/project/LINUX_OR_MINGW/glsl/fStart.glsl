#version 150

// per-fragment interpolated values from the vertex shader
in  vec3 fL1, fL2;
in  vec3 fN;
in  vec3 fE;
in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

out vec4 fColor;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;
uniform sampler2D texture;

void main()
{
	// Part f implement blinn-phong lighting reflection model with attenuation
	float a = 1;
    float b = 1;
    float c = 0.3;
    
	float distanceToLight = length(fL1);
	float attenuation = 1 / (a +  b*distanceToLight + c*pow(distanceToLight,2));

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L1 = normalize( fL1 );     // Direction to the light source
    vec3 L2 = normalize( fL2 );      
    vec3 E = normalize( fE );     	// Direction to the eye/camera
    vec3 H1 = normalize( L1 + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );
	vec3 N = normalize( fN );     	// Normal vector
  
    // Compute terms in the illumination equation
    vec3 ambient1 = AmbientProduct;
    vec3 ambient2 = AmbientProduct;

    float Kd1 = max( dot(L1, N), 0.0 );
    vec3  diffuse1 = Kd1 * DiffuseProduct;
    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Kd2 * DiffuseProduct;

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess );
    vec3  specular1 = Ks1 * SpecularProduct;
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3  specular2 = Ks2 * SpecularProduct;
    
  
    if (dot(L1, N) < 0.0 ) {
	    specular1 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L2, N) < 0.0 ) {
	    specular2 = vec3(0.0, 0.0, 0.0);
    } 
    

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    // Part f implement blinn-phong lighting reflection model with attenuation
    //vec4 color = vec4(globalAmbient  + (attenuation*diffuse1) + (attenuation*specular1) + ambient1*attenuation, 1.0); 
	//fColor = color * texture2D(texture, texCoord * 2.0);
		
    //vec4 color = vec4(globalAmbient + attenuation*(diffuse1 + ambient1), 1.0); 
    //fColor = color * texture2D( texture, texCoord * 2.0 ) + vec4(attenuation * specular1, 1.0); 
    
    vec4 color = vec4(globalAmbient  + attenuation*diffuse1 + attenuation*ambient1, 1.0); 
	fColor = color * texture2D(texture, texCoord * 2.0)+ vec4(attenuation * specular1, 1.0); ;
    
    
} 
