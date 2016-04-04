Shader "ShaderCookbook/HalfLambert" {
	Properties{
		//VarName ("InspectorName",Type) = {default}
		//Type:Range(min,max),Color,2D,Rect,Cube,Float,Vector(float4)
		_EmissionColor("Emission Color",Color) = (1,1,1,1)
		_AmbientColor("Ambient Color",Color) = (1,1,1,1)
		_MySliderValue("PowerValue",Range(0,10)) = 2.6
	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		//#pragma surface指令告诉着色器将使用哪个光照模型来计算，unity4默认使用Lighting.cginc
		//文件中的Lambert光照模型，在这里我们指定使用自定义的光照模型
		#pragma surface surf HalfLambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		//与属性中的变量关联，必须声明一个变量名相同类型恰当的变量
		float4 _EmissionColor;
		float4 _AmbientColor;
		float _MySliderValue;

		void surf(Input IN, inout SurfaceOutput o) {
			float4 c;
			//pow（arg1,arg2）:cg函数，求参数1为底，参数2代表指数的幂函数
			c = pow((_EmissionColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		//函数名的格式:Lighting<自定义光照模型名>
		//1.half4 LightingName(SurfaceOutput s,half3 lightDir,half atten); 用于不需要视角方向的前向着色
		//2.half4 LightingName(SurfaceOutput s,half3 lightDir,half3 viewDir,half atten);用于需要视角方向的前向着色
		//3.half4 LightingName_PrePass(SuffaceOutput s,half4 light);用于需要使用延迟着色的项目
		inline float4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			//HalfLambert光照模型用于在低光照区域照亮物体的技术，基本提高了材质和物体表面周围的漫反射光照
			//可以用来防止某个物体的背光面丢失形状并且显得太过平面化，没有基于任何物理原理，仅仅是视觉效果增强。
			float difLight = dot(s.Normal, lightDir);
			float hLambert = difLight * 0.5 + 0.5;
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
