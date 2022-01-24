Shader "Unlit/FloorShader"
{
    Properties
    {
         _Color("Color", Color) = (0,0,0,1) 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull OFF

        Pass
        {
            Tags { "LightMode"="ObjectA" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normals : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float dist : float;
            };

            
            fixed4 _Color;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normals = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv;

                o.dist = length(WorldSpaceViewDir(v.vertex));
                return o;
            }

            void frag (v2f i,
            out half4 GRT0:SV_Target0,
            out half4 GRT1:SV_Target1
            )
			{   
                // floor to camera
                half toColor = i.dist/30;
				GRT0 = fixed4(toColor, toColor, toColor,1);
                // normal
                GRT1 = fixed4(i.normals.x, i.normals.y, i.normals.z, 1);
			}
            ENDCG
        }
    }
}
