Shader "Tutorial/Surface"
{
	Properties	//należy zdefiniować zmienne o analogicznym typie i nazwie
	{
		_Color("Color", Color) = (0,0,0,1)
		_Value("Value", float) = 1
		_MyTexture("My texture", 2D) = "white" {}	//white, black, gray
	_NormalMap("Normal map", 2D) = "bump" {}	// automatycznie normal mapa, #808080 
	}

		SubShader
	{
		//Common state
		Lighting On //Off

					//Tags
		Tags{ "Tag1" = "Value1" "Tag2" = "Value2" }
		/*
		Queue: Background
		Geometry (domyślna) również "Geometry+1"
		AlphaTest
		Transparent (back-to-front order; szkło, cząsteczki)
		Overlay

		RenderType:		//"typy", wykorzystywane np. przy Shader Replacement
		Opaque
		Transparent
		TransparentCutout
		Background
		Overlay
		...
		*/
		CGPROGRAM
#pragma surface surf Lambert vertex:vert //Lambert - Diffuse (albedo), BlinnPhong (specular), Standard (pbr)
#include "UnityCG.cginc"	//!!!

		struct Input
	{
		//wbudowane zmienne
		float2 uv_MyTexture; //aby otrzymać uv: uv_NazwaTekstury
		float2 uv_NormalMap;

		float3 viewDir;
		float4 colorName : COLOR;
		float4 screenPos;
		float3 worldPos;
		float3 worldRefl;
		float3 worldNormal;
		//wlase zmienne
		float someMyVariable;
	};

	float4 _Color;
	float _Value;
	sampler2D _MyTexture;
	sampler2D _NormalMap;

	void vert(inout appdata_full v, out Input o) {	//appdata_base, appdata_tan	- wymagany powyższy #include

		UNITY_INITIALIZE_OUTPUT(Input, o);	//inicjalizuje wbudowany otput
		o.someMyVariable = 1;
	}

	void surf(Input IN, inout SurfaceOutput o) {	//SurfaceOutputStandard SurfaceOutputStandardSpecular https://docs.unity3d.com/Manual/SL-SurfaceShaders.html
		o.Albedo = tex2D(_MyTexture, IN.uv_MyTexture).rgb;
	}

	ENDCG
	}

		//po wszystkich SubShaderach
		Fallback "Diffuse"

}