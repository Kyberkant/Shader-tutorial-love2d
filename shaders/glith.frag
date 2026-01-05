extern float strength;   // 0.0 = vypnuto
    extern float time;

    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc)
    {
        // jemné náhodné cuknutí
        float noise = sin(sc.y * 0.05 + time * 20.0) * 0.002 * strength;

        vec2 offset = vec2(noise, 0.0);

        float r = Texel(tex, uv + offset * 1.5).r;
        float g = Texel(tex, uv).g;
        float b = Texel(tex, uv - offset * 1.5).b;
        float a = Texel(tex, uv).a;

        return vec4(r, g, b, a) * color;
    }