// adapted from http://www.youtube.com/watch?v=qNM0k522R7o

uniform vec2 _size;
uniform int samples = 4; // pixels per axis; higher = bigger glow, worse performance
uniform float quality = 2.5; // lower = smaller glow, better quality

vec4 effect(vec4 colour, sampler2D tex, vec2 tc, vec2 sc)
{
  vec4 source = texture2D(tex, tc);
  vec4 sum = vec4(0);
  int diff = (samples - 1) / 2;
  vec2 sizeFactor = vec2(1) / _size * quality;
  
  for (int x = -diff; x <= diff; x++)
  {
    for (int y = -diff; y <= diff; y++)
    {
      vec2 offset = vec2(x, y) * sizeFactor;
      sum += Texel(tex, tc + offset);
    }
  }
  
  vec4 result = ((sum / (samples * samples)) + source) * colour;
  
  return vec4(result.r, result.g, result.b, source.a);
}