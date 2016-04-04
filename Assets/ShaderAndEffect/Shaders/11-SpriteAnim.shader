Shader "Custom/11-SpriteAnim" {
	Properties{
		_MainTex("Base (RGB)",2D) = "white"{}
		_TexWidth("Sheet Width",Float) = 0.0
		_CellAmount("Cell Amount",Float) = 0.0
		_Speed("Speed",Range(0.01,32)) = 12
	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf  Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		float _TexWidth;
		float _CellAmount;
		float _Speed;
		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) {
			// create a separate variable to store our uvs
			//before we pass them to the tex2D() function
			fixed2 spriteUV = IN.uv_MainTex;

			//Let's calculate the width of a single cell in our
			//sprite sheet and get a UV percentage that each cell takes up
			float cellPixelWidth = _TexWidth / _CellAmount;
			float cellUVPercentage = cellPixelWidth / _TexWidth;

			//Let's get a stair step value out of time so we can increment
			//the uv offset
			//fmod(x,y):cgfx function,return x mod y
			float timeVal = fmod(_Time.y * _Speed, _CellAmount);
			timeVal = ceil(timeVal);

			//Animate the uvs forward by the width precentage of each cell
			float xValue = spriteUV.x;
			xValue += cellUVPercentage * timeVal * _CellAmount;
			xValue *= cellUVPercentage;
			spriteUV = float2(xValue, spriteUV.y);

			fixed4 c = tex2D(_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

		}
		ENDCG
	}
	FallBack "Diffuse"
}
