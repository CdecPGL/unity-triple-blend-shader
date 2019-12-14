Shader "TripleBlend/StandardOpaqueTest" {
    Properties {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        [Gamma] _Metallic("Metallic Scale", Range(0,1)) = 0.0
        [NoScaleOffset]_MetallicGlossMap("Metallic", 2D) = "white" {}
        _BumpScale("Normal Scale", Float) = 1.0
        [NoScaleOffset][Normal] _BumpMap("Normal Map", 2D) = "bump" {}
        [HDR] _EmissionColor("Emittion Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset] _EmissionTex("Emission", 2D) = "white" {}
        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        [NoScaleOffset] _OcclusionMap("Occlusion", 2D) = "white" {}
    }
 
    SubShader {
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

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

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Bump Map
            fixed4 n = tex2D(_BumpMap, IN.uv_MainTex);
            o.Normal = UnpackScaleNormal(n, _BumpScale);
            // Emission
            fixed4 e = tex2D(_EmissionTex, IN.uv_MainTex);
            o.Emission = _EmissionColor * e;
            // Occlusion (合ってるかわからない)
            fixed4 oc = tex2D(_OcclusionMap, IN.uv_MainTex);
            o.Occlusion = oc * _OcclusionStrength;
            // Metallic and smoothness come from slider variables
            fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
            o.Metallic = m * _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Standard"
}
