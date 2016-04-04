Shader "Custom/12-BlendTex" {
	Properties {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_ColorA("Terrain Color A",Color) = (1,1,1,1)
		_ColorB("Terrain Color B",Color) = (1,1,1,1)
		_RTexture("Red Channel Texture",2D) = "white"{}
		_GTexture("Green Channel Texture",2D) = "white"{}
		_BTexture("Blue Channel Texture",2D) = "white"{}
		_ATexture("Alpha Channel Texture",2D) = "white"{}
		_BlendTex("Blend Texture",2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque"}
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 2.0

		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTex;
		};

		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTex;

		void surf (Input IN, inout SurfaceOutput o) {
			//get the pixel data from the blend texture
			//we need a float4 here because the texture
			//will return R,G,B,A
			float4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);
			
			//get the data from the texture we want to blend
			float4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

			//Now we need to contruct a new RGBA value and 
			//all the different blended texture back together
			//lerp(a,b,f) == (1-f)a + b*f
			float4 finalColor;
			finalColor = lerp(rTexData, gTexData, blendData.g);
			finalColor = lerp(finalColor, bTexData, blendData.b);
			finalColor = lerp(finalColor, aTexData, blendData.a);
			finalColor.a = 1.0;

			//add on our terrain tinting colors
			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);
			
			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
