extern float time;

    vec4 effect(vec4 color, Image texture, vec2 uv, vec2 sc)
    {
        vec4 pixel = Texel(texture, uv);
        float pulse = (sin(time * 4.0) + 1.0) * 0.5; // 0 → 1

        pixel.rgb *= 0.5 + pulse * 0.5; // jemné blikání
        return pixel * color;
    }