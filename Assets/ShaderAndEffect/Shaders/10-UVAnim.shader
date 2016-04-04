Shader "Custom/10-UVAnim" {
	Properties {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_MainTex("Base (RGB)",2D) = "white"{}
		_ScrollXSpeed ("X Scroll Speed",Range(0,10)) = 2
		_ScrollYSpeed ("Y Scroll Speed",Range(0,10)) = 2 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf  Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutput o) {
			// create a separate variable to store our uvs
			//before we pass them to the tex2D() function
			fixed2 scrolledUV = IN.uv_MainTex;

			//create variables that store the individual x and y 
			//components for the uvs scaled by time
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;	

			//apply the final uv offset
			scrolledUV += fixed2(xScrollValue, yScrollValue);

			fixed4 c = tex2D (_MainTex, scrolledUV) * _MainTint;
			o.Albedo = c.rgb;		
			o.Alpha = c.a;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
