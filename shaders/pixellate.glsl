// image size
uniform vec2 size;

// sample size, use number is divisible by two
uniform float factor;

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 pixel_coords)
{
    vec2 position = floor(texture_coords * size / factor) * factor / size;
    return texture2D(texture, position);
}