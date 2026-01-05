vec4 effect(vec4 color, Image texture, vec2 uv, vec2 sc)
    {
        vec4 pixel = Texel(texture, uv);

        float fadeX = smoothstep(0.0, 0.2, uv.x) * smoothstep(1.0, 0.8, uv.x);
        float fadeY = smoothstep(0.0, 0.2, uv.y) * smoothstep(1.0, 0.8, uv.y);

        pixel.a *= fadeX * fadeY;
        return pixel * color;
    }