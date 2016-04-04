Shader "Custom/Bump_Rim"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_RimColor("Rim Color",Color) = (1,1,1,1)
		_RimPower("Rim Power",Range(0.1,9.0)) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGPROGRAM		
		#pragma surface surf Lambert

		struct Input {
			float2 uv_MainTex;//纹理贴图
			float2 uv_Bumpmap;//凹凸贴图
			float3 viewDir;//观察方向
		};

		//变量声明
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		void surf(Input IN, inout SurfaceOutput o)
		{
			//表面反射颜色为纹理颜色
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			//表面法线为凹凸纹理的颜色
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_Bumpmap));
			//边缘颜色
			half rimColor = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			//边缘颜色强度
			o.Emission = _RimColor.rgb * pow(rimColor, _RimPower);
		}
		ENDCG
	}
	Fallback "Diffuse"
}
