extern vec2 playerPosition; 

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) 
{ 
    
    vec4 pixel = Texel(texture, texture_coords);
    float distance = length(screen_coords - playerPosition); 
    float fade = clamp(distance/250, 0.0, 1.0); 
    pixel.a *= fade;

    return pixel * color;
}