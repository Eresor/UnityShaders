Shader "Custom/StandardMasked" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_ColorMask0("Mask color 1", Color) = (1,1,1,1)
		_ColorMask1("Mask color 2", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_MetallicTex("Metallic", 2D) = "black" {}
		_Normal("Normal", 2D) = "bump" {}
		_OcclusionTex("Occlusion", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0,1)) = 1.0
			_EmissionTex("Emission", 2D) = "black" {}
		_Emission("Emission", Range(0,1)) = 0.0

	_Mask("Mask", 2D) = "white" {}
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard fullforwardshadows
#include "UnityPBSLighting.cginc"
		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

		sampler2D _MainTex;
	sampler2D _MetallicTex;
	sampler2D _Normal;
	sampler2D _OcclusionTex;
	sampler2D _Mask;
	sampler2D _EmissionTex;

	struct Input {
		float2 uv_MainTex;
		float2 uv_MetallicTex;
		float2 uv_Normal;
		float2 uv_OcclusionTex;
		float2 uv_Mask;
		float2 uv_EmissionTex;

	};

	half _Smoothness;
	half _Emission;
	fixed4 _Color;
	fixed4 _ColorMask0;
	fixed4 _ColorMask1;

	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
	// #pragma instancing_options assumeuniformscaling
	UNITY_INSTANCING_CBUFFER_START(Props)
		// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END



		void surf(Input IN, inout SurfaceOutputStandard o) {
		// Albedo comes from a texture tinted by color
		float4 mask = tex2D(_Mask, IN.uv_Mask);

		fixed4 maskColor = _Color;
		maskColor = lerp(maskColor, _ColorMask0, mask.r);
		maskColor = lerp(maskColor, _ColorMask1, mask.g);
		

		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * maskColor;
		o.Albedo = c.rgb;

		 o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));;

		// Metallic and smoothness come from slider variables
		fixed4 m = tex2D(_MetallicTex, IN.uv_MetallicTex);
		o.Metallic = m;

		fixed4 ao = tex2D(_OcclusionTex, IN.uv_OcclusionTex);
		o.Occlusion = ao;


		o.Smoothness = _Smoothness * m.a;
		o.Alpha = c.a;

		o.Emission = _Emission * tex2D(_EmissionTex, IN.uv_EmissionTex);;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
