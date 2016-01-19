// http://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters
uniform vec2 _step;

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    float alpha = 4 * texture2D(texture, texture_coords).a;
    alpha -= texture2D(texture, texture_coords + vec2(_step.x, 0.0f)).a;
    alpha -= texture2D(texture, texture_coords + vec2(-_step.x, 0.0f)).a;
    alpha -= texture2D(texture, texture_coords + vec2(0.0f, _step.y)).a;
    alpha -= texture2D(texture, texture_coords + vec2(0.0f, -_step.y)).a;  
    return vec4(0.0f, 1.0f, 0.0f, alpha);
}