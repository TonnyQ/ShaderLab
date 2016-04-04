Shader "Custom/15-ColorLevel" {
	Properties {
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_inBlack("Input Black",Range(0,255)) = 0
		_inGamma("Input Gamma",Range(0,2)) = 1.6
		_inWhite("Input White",Range(0,255)) = 255

		_outWhite("Output White",Range(0,255)) = 255
		_outBlack("Output Black",Range(0,255)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;
		

		struct Input {
			float2 uv_MainTex;
		};

		//do levels calculations here for each pixel channel.
		//So we need to process the R, G, and B channels with
		//The same math calculations
		float GetPixelLevel(float pixelColor)
		{
			float pixelResult;
			pixelResult = (pixelColor * 255.0);
			pixelResult = max(0, pixelResult - _inBlack);
			pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGamma));
			pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack) / 255.0;
			return pixelResult;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float4 c;
			c = tex2D(_MainTex, IN.uv_MainTex);
		
			//create a var to stroe a pixel channel form out MainTex texture
			float outRPixel = GetPixelLevel(c.r);
			//remap 0 to 1 range to 0 to 255
			//outRPixel = (c.r * 255.0);
			//Subtract the black value given to us by the inBlack property
			//outRPixel = max(0, outRPixel - _inBlack);
			//Increase white value of each pixel with inWhite
			//outRPixel = saturate(pow(outRPixel / (_inWhite - _inBlack), _inGamma));
			//change final black point and white point and re-map form 0 to 255 to 0 to 1
			//outRPixel = (outRPixel * (_outWhite - _outBlack) + _outBlack) / 255.0;
			float outGPixel = GetPixelLevel(c.g);
			float outBPixel = GetPixelLevel(c.b);
			o.Albedo = float3(outRPixel,outGPixel, outBPixel);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
