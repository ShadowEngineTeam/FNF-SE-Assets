      #pragma header

      // GLES needs an extension for fwidth, so it only gets the fixed pixel distance
      #if !defined(GL_ES) && __VERSION__ >= 130
        #define HAS_DERIVATIVES
      #endif

      // This shader aims to mostly recreate how Adobe Animate/Flash handles drop shadows, but its main use here is for rim lighting.

      // this shader also includes a recreation of the Animate/Flash "Adjust Color" filter,
      // which was kindly provided and written by Rozebud https://github.com/ThatRozebudDude ( thank u rozebud :) )
      // Adapted from Andrey-Postelzhuks shader found here: https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
      // Hue rotation stuff is from here: https://www.w3.org/TR/filter-effects/#feColorMatrixElement

      // Ported from Funkin's DropShadowShader rewrite. AA_STAGES is unused now, it stays so scripts can still set it.

      // equals (frame.left, frame.top, frame.right, frame.bottom)
      uniform vec4 uFrameBounds;

      uniform float ang;
      uniform float dist;
      uniform float str;
      uniform float thr;

      // need to account for rotated frames... oops
      uniform float angOffset;

      uniform sampler2D altMask;
      uniform bool useMask;
      uniform float thr2;

      uniform vec3 dropColor;

      uniform float hue;
      uniform float saturation;
      uniform float brightness;
      uniform float contrast;

      uniform float AA_STAGES;

      const vec3 lumaValue = vec3(0.2126, 0.7152, 0.0722);
      const float e = 2.718281828459045;

      // Funkin's DropShadowShader builds these matrices on the CPU, they are made here so the uniforms stay the same
      mat3 makeHueMatrix(float h)
      {
        float c = cos(h);
        float s = sin(h);
        const float wR = 0.299;
        const float wG = 0.587;
        const float wB = 0.114;
        return mat3(
          wR + (1.0 - wR) * c - wR * s, wG - wG * c - wG * s, wB - wB * c + (1.0 - wB) * s,
          wR - wR * c + 0.143 * s, wG + (1.0 - wG) * c + 0.140 * s, wB - wB * c - 0.283 * s,
          wR - wR * c - (1.0 - wR) * s, wG - wG * c + wG * s, wB + (1.0 - wB) * c + wB * s
        );
      }

      mat3 makeSaturationMatrix(float value)
      {
        if (value > 0.0) value *= 3.0;
        float s = 1.0 + (value / 100.0);
        const float lr = 0.2126;
        const float lg = 0.7152;
        const float lb = 0.0722;
        float inv = 1.0 - s;
        return mat3(
          lr * inv + s, lg * inv, lb * inv,
          lr * inv, lg * inv + s, lb * inv,
          lr * inv, lg * inv, lb * inv + s
        );
      }

      float makeContrast(float value)
      {
        value = 1.0 + (value / 100.0);
        if (value > 1.0)
        {
          value = (((0.00852259 * pow(e, 4.76454 * (value - 1.0))) * 1.01) - 0.0086078159) * 10.0; // Just roll with it...
          value += 1.0;
        }
        return value;
      }

      vec3 applyHSBCEffect(vec3 color)
      {
        vec3 bh = (brightness / 255.0 + color) * makeHueMatrix(radians(hue));
        vec3 c = (bh - 0.25) * makeContrast(contrast) + 0.25;
        return c * makeSaturationMatrix(saturation);
      }

      float getLumaRGB(vec3 color)
      {
        return dot(color.rgb, lumaValue);
      }

      // Used as Difference Based AA.
      // Return value range (0.0, 2.0)
      float lwidth_manual(float center, vec2 uv, vec2 px)
      {
        float right = getLumaRGB(texture2D(bitmap, uv + vec2(1.0, 0.0) * px).rgb);
        float down = getLumaRGB(texture2D(bitmap, uv + vec2(0.0, 1.0) * px).rgb);
        float diagonal = getLumaRGB(texture2D(bitmap, uv + vec2(1.0, 1.0) * px).rgb);

        float dx = abs(right - center);
        float dy = abs(down - center);
        float dd = abs(diagonal - center);

        return ((dx + dy + dd * 0.7) / (1.0 + 1.0 + 0.7)) * 2.0;
      }

      float getThreshold(vec2 uv)
      {
        if (useMask && texture2D(altMask, uv).b > 0.0)
          return thr2;

        return thr;
      }

      vec4 createDropShadow(vec2 uv, vec2 ratio)
      {
        vec4 color4 = texture2D(bitmap, uv);

        #ifdef HAS_DERIVATIVES
        // Increase the pixel distance if the screen is smaller than the sprite!
        vec2 px = max(ratio, fwidth(uv));
        #else
        vec2 px = ratio;
        #endif

        float color3_light = getLumaRGB(color4.rgb);
        float delta = lwidth_manual(color3_light, uv, px);
        float threshold = getThreshold(uv);
        float intensity = smoothstep(threshold - delta, threshold + delta, color3_light);

        vec3 color3 = applyHSBCEffect(color4.a > 0.0 ? color4.rgb / color4.a : color4.rgb);

        // check the pixel in the direction and distance specified
        vec2 checked = vec2(uv.x + (dist * cos(ang + angOffset) * ratio.x), uv.y - (dist * sin(ang + angOffset) * ratio.y));

        float shadowAlpha = 0.0;
        if (checked.x > uFrameBounds.x && checked.y > uFrameBounds.y && checked.x < uFrameBounds.z && checked.y < uFrameBounds.w)
          shadowAlpha = texture2D(bitmap, checked).a;

        color3 += dropColor * ((1.0 - (shadowAlpha * str)) * intensity);

        return vec4(color3 * color4.a, color4.a);
      }

      void main()
      {
        gl_FragColor = createDropShadow(openfl_TextureCoordv, 1.0 / openfl_TextureSize.xy);
      }
