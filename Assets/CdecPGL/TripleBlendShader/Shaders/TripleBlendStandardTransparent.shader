Shader "TripleBlend/Standard-Transparent" {
    Properties {
        [NoScaleOffset] _SelectionMap("Selection Map", 2D) = "red" {}
        _SelectionArea("Selection Area (MinX, MinZ, MaxX, MaxZ)", Vector) = (0, 0, 100, 100)
        
        _Cutoff("Alpha Cutoff (Valid In Cutout Mode)", Range(0,1)) = 0.5

        _Color("[1] Color", Color) = (1,1,1,1)
        _MainTex("[1] Albedo (RGB)", 2D) = "white" {}
        _Glossiness("[1] Smoothness", Range(0,1)) = 0.5
        [Gamma] _Metallic("[1] Metallic Scale", Range(0,1)) = 0.0
        [NoScaleOffset]_MetallicGlossMap("[1] Metallic", 2D) = "white" {}
        _BumpScale("[1] Normal Scale", Float) = 1.0
        [NoScaleOffset][Normal] _BumpMap("[1] Normal Map", 2D) = "bump" {}
        [HDR] _EmissionColor("[1] Emittion Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset] _EmissionTex("[1] Emission", 2D) = "white" {}
        _OcclusionStrength("[1] Occlusion Strength", Range(0.0, 1.0)) = 1.0
        [NoScaleOffset] _OcclusionMap("[1] Occlusion", 2D) = "white" {}

        _Color2("[2] Color", Color) = (1,1,1,1)
        [NoScaleOffset] _MainTex2("[2] Albedo (RGB)", 2D) = "white" {}
        _Glossiness2("[2] Smoothness", Range(0,1)) = 0.5
        [Gamma] _Metallic2("[2] Metallic Scale", Range(0,1)) = 0.0
        //[NoScaleOffset] _MetallicGlossMap2("[2] Metallic", 2D) = "white" {} DX11におけるテクスチャ数の上限16を超えるため共通化。凹凸は変えないことを想定。
        //_BumpScale2("[2] Normal Scale", Float) = 1.0
        //[NoScaleOffset][Normal] _BumpMap2("[2] Normal Map", 2D) = "bump" {}
        [HDR] _EmissionColor2("[2] Emittion Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset] _EmissionTex2("[2] Emission", 2D) = "white" {}
        _OcclusionStrength2("[2] Occlusion Strength", Range(0.0, 1.0)) = 1.0
        //[NoScaleOffset] _OcclusionMap2("[2] Occlusion", 2D) = "white" {}

        _Color3("[3] Color", Color) = (1,1,1,1)
        [NoScaleOffset] _MainTex3("[3] Albedo (RGB)", 2D) = "white" {}
        _Glossiness3("[3] Smoothness", Range(0,1)) = 0.5
        [Gamma] _Metallic3("[3] Metallic Scale", Range(0,1)) = 0.0
        //[NoScaleOffset]　_MetallicGlossMap3("[3] Metallic", 2D) = "white" {}
        //_BumpScale3("[3] Normal Scale", Float) = 1.0
        //[NoScaleOffset][Normal] _BumpMap3("[3] Normal Map", 2D) = "bump" {}
        [HDR] _EmissionColor3("[3] Emittion Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset] _EmissionTex3("[3] Emission", 2D) = "white" {}
        _OcclusionStrength3("[3] Occlusion Strength", Range(0.0, 1.0)) = 1.0
        //[NoScaleOffset] _OcclusionMap3("[3] Occlusion", 2D) = "white" {}
    }

    CGINCLUDE
    #include "TripleBlendStandardCore.cginc"
    ENDCG

    SubShader {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 200
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        ENDCG
    }

    Fallback "Standard"
}
