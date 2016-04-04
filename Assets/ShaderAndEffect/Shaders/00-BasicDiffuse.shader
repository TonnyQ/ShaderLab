Shader "ShaderCookbook/BasicDiffuse" {
	Properties {
		//VarName ("InspectorName",Type) = {default}
		//Type:Range(min,max),Color,2D,Rect,Cube,Float,Vector(float4)
		_EmissionColor("Emission Color",Color) = (1,1,1,1)
		_AmbientColor("Ambient Color",Color) = (1,1,1,1)
		_MySliderValue("PowerValue",Range(0,10)) = 2.6
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		//与属性中的变量关联，必须声明一个变量名相同类型恰当的变量
		float4 _EmissionColor;
		float4 _AmbientColor;
		float _MySliderValue;

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			//pow（arg1,arg2）:cg函数，求参数1为底，参数2代表指数的幂函数
			c = pow((_EmissionColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
