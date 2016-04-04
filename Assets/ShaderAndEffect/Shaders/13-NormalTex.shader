Shader "Custom/13-NormalTex" {
	Properties {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_NormalTex("Normal Map",2D) = "bump"{}
		_NormalIntensity("Normal Map Intensity",Range(0,10)) = 1
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _MainTint;
		sampler2D _NormalTex;
		float _NormalIntensity;

		//make sure you get the uvs for the texture in the Struct
		struct Input {
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			// c = tex2D (_NormalTex, IN.uv_NormalTex) * _MainTint;
			//get the normal data out of the normal map textures
			//using the UnpackNormal() function
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
