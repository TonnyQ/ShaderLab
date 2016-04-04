Shader "Custom/Study_Property" {
    //固定管线编程颜色计算模型
    //FinalColor=Ambient * RenderSettings ambientsetting + (Light Color * Diffuse + Light Color *Specular) + Emission
    //当Unity选择用于渲染的子着色器时，它为每一个被定义的通道渲染一次对象（可能会更多，这取决于光线的交互作用）。
    //当对象的每一次渲染都是很费资源之时，我们便使用尽量少的通道来定义一个着色器。
    //当然，有时在一些显示硬件上需要的效果不能通过单次通道来完成。自然就得使用多通道的子着色器了。
    //任何出现在通道定义的状态同时也能整个子着色器块中可见。这将使得所有通道共享状态。

	Properties {
		//_WaveScale("Wave Scale",Range(0.02,0.15)) = 0.07
        //_ReflSistort("Reflection Distort",Range(0,1.5)) = 0.5
        //_RefrDistort("Refraction Distort",Range(0,1.5)) = 0.4
        //_RefrColor("Refraction Color",Color) = (.34,.85,.92,1)
        //_ReflectionTex("Environment Reflection",2D) = "white"{}
        //_RefractionTex("Environment Refraction",2D) = ""{}
        //_Freshnel("Fresnel (A)",2D) = ""{}
        //_BumpMap("Bumpmap (RGB)",2D) = ""{}
        _MainTex("Base (RGB)",2D) = "white"{}
        _Color("Main Color",Color) = (1,1,1,0)
        _SpecColor("Specular Color",Color) = (1,1,1,1)
        _Emission("Emission Color",Color) = (0,0,0,0)
        _Shininess("Shininess",Range(0.01,1)) = 0.7
	}
	SubShader {

        //如果SubShader存在多个Pass,最终将选择最后一个合适的生效
        Pass{
            Color(0,0,0.6,0)//单色shader
        }

        Pass{
            //材质
            Material{
                //将漫反射和环境光颜色设为相同
                Diffuse(1,0.5,0.4,1)
                Ambient(0,0.5,0.4,1)
            }
            //开启光照
            Lighting On
        }  
        
        //从外部传入颜色值
        Pass{
            Material{
                Diffuse[_RefrColor]
                Ambient[_RefrColor]
            }           
            Lighting On
        }
        
        Pass{
            Material{
                Diffuse[_Color]
                Ambient[_Color]
                Shininess[_Shininess]
                Specular[_SpecColor]
                Emission[_Emission]
            }
            Lighting On
        }  

        //简单纹理
        Pass{
            //设置纹理为属性中选择的纹理
            SetTexture[_MainTex]{
                combine texture
            }
        }

        Pass{
            Material{
                Diffuse[_Color]
                Ambient[_Color]
                Shininess[_Shininess]
                Emission[_Emission]
            }
            Lighting On
            //开启独立镜面反射
            SeparateSpecular On
            //设置纹理并进行纹理混合
            SetTexture[_MainTex]{
                Combine texture * primary DOUBLE,texture * primary
            }
        }
    }
	FallBack "Diffuse"
}
