extern vec3 _chroma;

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 c = texture2D(texture, texture_coords);
    // This reads a color from our texture at the coordinates LOVE gave us (0-1, 0-1)
    return vec4(_chroma * (max(c.r, max(c.g, c.b))), c.a);
    // This just returns a white color that's modulated by the brightest
    // color channel at the given pixel in the texture. Nothing too complex, and not exactly the prettiest way to do B&W :P
}