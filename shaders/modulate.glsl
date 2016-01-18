extern vec3 _chroma;

// This just returns a color that's modulated by the brightest
// color channel at the given pixel in the texture.
vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = texture2D(texture, texture_coords);
    return vec4(_chroma * (max(pixel.r, max(pixel.g, pixel.b))), pixel.a);
}