#ifndef TRIPLE_STANDARD_CORE_CGINC_INCLUDED
#define TRIPLE_STANDARD_CORE_CGINC_INCLUDED

sampler2D _SelectionMap;
float4 _SelectionArea;

fixed4 _Color;
sampler2D _MainTex;
half _BumpScale;
sampler2D _BumpMap;
fixed4 _EmissionColor;
sampler2D _EmissionTex;
half _OcclusionStrength;
sampler2D _OcclusionMap;
half _Glossiness;
half _Metallic;
sampler2D _MetallicGlossMap;

fixed4 _Color2;
sampler2D _MainTex2;
//half _BumpScale2;
//sampler2D _BumpMap2;
fixed4 _EmissionColor2;
sampler2D _EmissionTex2;
half _OcclusionStrength2;
//sampler2D _OcclusionMap2;
half _Glossiness2;
half _Metallic2;
//sampler2D _MetallicGlossMap2;

fixed4 _Color3;
sampler2D _MainTex3;
//half _BumpScale3;
//sampler2D _BumpMap3;
fixed4 _EmissionColor3;
sampler2D _EmissionTex3;
half _OcclusionStrength3;
//sampler2D _OcclusionMap3;
half _Glossiness3;
half _Metallic3;
//sampler2D _MetallicGlossMap3;

struct Input {
    float2 uv_MainTex;
    float3 worldPos;
};

struct MaterialSetting {
    fixed4 Color;
    sampler2D MainTex;
    half BumpScale;
    sampler2D BumpMap;
    fixed4 EmissionColor;
    sampler2D EmissionTex;
    half OcclusionStrength;
    sampler2D OcclusionMap;
    half Glossiness;
    half Metallic;
    sampler2D MetallicGlossMap;
};

float2 calculate_selection_map_uv(float3 world_pos, float4 selection_area) {
    float2 uv;
    uv.x = (world_pos.x - selection_area.x) / (selection_area.z - selection_area.x);
    uv.y = (world_pos.z - selection_area.y) / (selection_area.w - selection_area.y);
    return uv;
}

void surf_core(Input IN, MaterialSetting ms, fixed ratio, inout SurfaceOutputStandard o) {
    // Albedo comes from a texture tinted by color
    fixed4 c = tex2D(ms.MainTex, IN.uv_MainTex) * ms.Color;
    o.Albedo += c.rgb * ratio;
    // Bump Map
    fixed4 n = tex2D(ms.BumpMap, IN.uv_MainTex);
    o.Normal += UnpackScaleNormal(n, ms.BumpScale) * ratio;
    // Emission
    fixed4 e = tex2D(ms.EmissionTex, IN.uv_MainTex);
    o.Emission += ms.EmissionColor * e * ratio;
    // Occlusion (合ってるかわからない)
    fixed4 oc = tex2D(ms.OcclusionMap, IN.uv_MainTex);
    o.Occlusion += oc * ms.OcclusionStrength * ratio;
    // Metallic and smoothness come from slider variables
    fixed4 m = tex2D(ms.MetallicGlossMap, IN.uv_MainTex);
    o.Metallic += m * ms.Metallic * ratio;
    o.Smoothness += ms.Glossiness * ratio;
    o.Alpha += c.a * ratio;
}

void surf(Input IN, inout SurfaceOutputStandard o) {
    float2 selection_map_uv = calculate_selection_map_uv(IN.worldPos, _SelectionArea);
    fixed3 sm = tex2D(_SelectionMap, selection_map_uv);

    o.Albedo = 0;
    o.Normal = 0;
    o.Emission = 0;
    o.Occlusion = 0;
    o.Metallic = 0;
    o.Smoothness = 0;
    o.Alpha = 0;

    MaterialSetting ms;
    ms.Color = _Color;
    ms.MainTex = _MainTex;
    ms.BumpScale = _BumpScale;
    ms.BumpMap = _BumpMap;
    ms.EmissionColor = _EmissionColor;
    ms.EmissionTex = _EmissionTex;
    ms.OcclusionStrength = _OcclusionStrength;
    ms.OcclusionMap = _OcclusionMap;
    ms.Glossiness = _Glossiness;
    ms.Metallic = _Metallic;
    ms.MetallicGlossMap = _MetallicGlossMap;
    surf_core(IN, ms, sm.r, o);

    ms.Color = _Color2;
    ms.MainTex = _MainTex2;
    ms.BumpScale = _BumpScale;
    ms.BumpMap = _BumpMap;
    ms.EmissionColor = _EmissionColor2;
    ms.EmissionTex = _EmissionTex2;
    ms.OcclusionStrength = _OcclusionStrength2;
    ms.OcclusionMap = _OcclusionMap;
    ms.Glossiness = _Glossiness2;
    ms.Metallic = _Metallic2;
    ms.MetallicGlossMap = _MetallicGlossMap;
    surf_core(IN, ms, sm.g, o);

    ms.Color = _Color3;
    ms.MainTex = _MainTex3;
    ms.BumpScale = _BumpScale;
    ms.BumpMap = _BumpMap;
    ms.EmissionColor = _EmissionColor3;
    ms.EmissionTex = _EmissionTex3;
    ms.OcclusionStrength = _OcclusionStrength3;
    ms.OcclusionMap = _OcclusionMap;
    ms.Glossiness = _Glossiness3;
    ms.Metallic = _Metallic3;
    ms.MetallicGlossMap = _MetallicGlossMap;
    surf_core(IN, ms, sm.b, o);
}

#endif // TRIPLE_STANDARD_CORE_CGINC_INCLUDED
