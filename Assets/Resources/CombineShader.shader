Shader "Unlit/CombineShader"
{
   Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Transparent+400" "Queue"="Transparent"}


        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0

            #include "UnityCG.cginc"

            Texture2D _GBuffer0;
            Texture2D _GBuffer1;
            Texture2D _GBuffer2;
            Texture2D _GBuffer3;

            Texture2D _Depth;
            SamplerState sampler_pointer_clamp;

            int _Mode;
            fixed4 _CameraVector;
            float _AngleCameraLight;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2ff
            {
                float4 vertex : SV_POSITION;
                 float2 uv : TEXCOORD0;
            };

            struct GBufferOutput
            {
                half4 GBuffer4 : SV_Target4;
            };

            v2ff vert (appdata v)
            {
                v2ff o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 getRefractedFluidColor() {
                return float4 (0.1f,0.3f,0,1);
            }
            float fresnelFunction(float3 normal, float3 viewDir){
                //float3 viewDir = ObjSpaceViewDir ( v.vertex );
                float fresnelValue = 1 - saturate(dot(normal, viewDir));
                return fresnelValue;
            }

            float4 colorout (float3 normal, float3 depth) {
                // the refracted fluid color
                float4 a = getRefractedFluidColor();
                // the reflected scene color - making something up...for testing...
                float4 b = float4 (0.2f,0.2f,0.6f,1);
                // constants for the specular highlight -> Phong
                float ks = 0.2f;
                float alpha = 0.7f;
                // surface normal
                float n = normal;
                // half-angle between canmera and the Light
                float h = _AngleCameraLight/2;
                // camera vector
                float3 v = _CameraVector.xyz; // seems to be depth? the camera vector?
                v = depth.xyz; //so...this should be correct one?

                float3 color1 = a * (1-fresnelFunction(n,v));
                float3 color2 = b.xyz * fresnelFunction(n,v);
                float3 color3 = ks * (pow(dot(n,h), alpha));

                float3 c = color1 + color2 + color3;
                if (_Mode == 5) {
                    // reflection
                    c = color1;
                } else if (_Mode == 6) {
                    // refraction
                   c = color2;
                } else if (_Mode == 7) {
                    // Phong specular highlight
                    c = color3;
                }
                return float4(c,1);
            }

			half4 frag (v2ff i): SV_Target
			{            
                half4 g0 = _GBuffer0.Sample(sampler_pointer_clamp, i.uv);
                half4 g1 = _GBuffer1.Sample(sampler_pointer_clamp, i.uv);
                half4 g2 = _GBuffer2.Sample(sampler_pointer_clamp, i.uv);
                half4 g3 = _GBuffer3.Sample(sampler_pointer_clamp, i.uv);
                // expensive, maybe should have a overall flag on debug mode or not
                if (_Mode == 0) {
                    // all
                    return colorout(g1.xyz, g0.xyz);
                } else if (_Mode == 1) {
                    // depth
                    return g0;
                } else if (_Mode == 2) {
                    // normal
                    return g1;
                } else if (_Mode == 3) {
                    // thickness
                    return g2;
                } else if (_Mode == 4) {
                    // tangent
                    return g3;
                } else if (_Mode == 5) {
                    // reflection
                    return colorout(g1.xyz, g0.xyz);
                } else if (_Mode == 6) {
                    // refraction
                    return colorout(g1.xyz, g0.xyz);
                } else if (_Mode == 7) {
                    // Phong specular highlight
                    return colorout(g1.xyz, g0.xyz);
                }

                return g0 + g1;

                
              
			}

            ENDCG
        }
    }
}
