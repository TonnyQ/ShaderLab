Shader "Custom/Study_SubShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
        //子着色器使用标签来告诉渲染引擎期望何时何如何渲染对象
        //子着色器可以定义多个标签，标签是用来决定渲染的次序和子着色器中的其他变量的
        //渲染都是从最远的对象开始到最近的对象

        //使用Queue标签来决定对象被渲染的次序，着色器规定它所归属的对象的渲染队列，任何透明渲染器可以通过这个办法保证在所有
        //不透明对象的渲染完毕后再进行渲染，有四种预定义的渲染队列，在预定于队列之间还可以定义更多的队列：
        //Background(1000)-这个渲染队列在所有队列之前被渲染，被用于渲染天空盒之类的对象
        //Geometry(2000)-这个队列被用于大多数对象。不透明的几何体使用这个队列
        //Transparent(3000)-这个渲染队列在几何体队列之后被渲染，采用由后到前的次序，任何采用alpha混合的对象应该在这里渲染（如玻璃，粒子）
        //Overlay(4000)-被用于实现叠加效果。任何需要最后渲染的对象应该放置在此处。（如镜头光晕）
        //Tags{ "Queue"="Transparent + 1"} 自定义中间渲染队列

        //IgnoreProjector:如果设置该标签为"True",那么使用这个着色器的对象就不会被投影机制所影响。这对半透明的物体来说有好处，
        //因为暂时没有对它们产生投影比较合适的办法，所以直接忽视
		Tags { "RenderType"="Opaque" "Queue"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
