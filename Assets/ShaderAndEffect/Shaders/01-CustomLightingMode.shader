Shader "ShaderCookbook/CustomLightingMode" {
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
		#pragma surface surf BasicDiffuse

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
		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			//max(a,b):cg函数，取a,b之中最大值，saturate函数可以将浮点值限制在0~1之间，唯一的区别在于saturate直接将浮点值转换成饱和度
			//dot(v1,v2):cg函数，用来比较两个向量在空间中的方向。
			//任意两个向量都可以通过点积函数获得(-1,1)的夹角范围，两个向量之间的夹角越小，点积越大，表面可接受的入射光就越多。
			//-1表示平行向量并背向离屏幕的方向，1也表示平行向量并朝屏幕外方向，0表示和屏幕方向垂直。
			float difLight = max(0, dot(s.Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
