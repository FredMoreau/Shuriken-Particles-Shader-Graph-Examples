#ifndef SHADERGRAPH_PARTICLESINSTANCING_URP_ONLY_INCLUDED
#define SHADERGRAPH_PARTICLESINSTANCING_URP_ONLY_INCLUDED

#ifndef UNITY_PARTICLE_INSTANCE_DATA
#define UNITY_PARTICLE_INSTANCE_DATA CustomParticleInstanceData
struct CustomParticleInstanceData
{
    float3x4 transform;
    uint color;
#ifndef UNITY_PARTICLE_INSTANCE_DATA_NO_ANIM_FRAME
    float animFrame;
#ifdef _FLIPBOOKBLENDING_ON
    float animBlend;
#endif
#endif
};
#endif

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ParticlesInstancing.hlsl"

void ParticleColor_float(float4 In, out float4 Out)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    Out = lerp(float4(1.0, 1.0, 1.0, 1.0), In, unity_ParticleUseMeshColors);
    Out *= float4(UnpackFromR8G8B8A8(data.color));
#else
    Out = In;
#endif
}

void ParticleColor_half(half4 In, out half4 Out)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    Out = lerp(half4(1.0, 1.0, 1.0, 1.0), In, unity_ParticleUseMeshColors);
    Out *= half4(UnpackFromR8G8B8A8(data.color));
#else
    Out = In;
#endif
}

void GetParticleTexcoords(out float2 outputTexcoord, out float3 outputTexcoord2AndBlend, in float4 inputTexcoords, in float inputBlend)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    if (unity_ParticleUVShiftData.x != 0.0)
    {
        UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];

        float numTilesX = unity_ParticleUVShiftData.y;
        float2 animScale = unity_ParticleUVShiftData.zw;
#ifdef UNITY_PARTICLE_INSTANCE_DATA_NO_ANIM_FRAME
        float sheetIndex = 0.0;
#else
        float sheetIndex = data.animFrame;
#endif

        float index0 = floor(sheetIndex);
        float vIdx0 = floor(index0 / numTilesX);
        float uIdx0 = floor(index0 - vIdx0 * numTilesX);
        float2 offset0 = float2(uIdx0 * animScale.x, (1.0 - animScale.y) - vIdx0 * animScale.y); // Copied from built-in as is and it looks like upside-down flip

        outputTexcoord = inputTexcoords.xy * animScale.xy + offset0.xy;

#ifdef _FLIPBOOKBLENDING_ON
        float index1 = floor(sheetIndex + 1.0);
        float vIdx1 = floor(index1 / numTilesX);
        float uIdx1 = floor(index1 - vIdx1 * numTilesX);
        float2 offset1 = float2(uIdx1 * animScale.x, (1.0 - animScale.y) - vIdx1 * animScale.y);

        outputTexcoord2AndBlend.xy = inputTexcoords.xy * animScale.xy + offset1.xy;
        outputTexcoord2AndBlend.z = frac(sheetIndex);
#endif
    }
    else
#endif
    {
        outputTexcoord = inputTexcoords.xy;
#ifdef _FLIPBOOKBLENDING_ON
        outputTexcoord2AndBlend.xy = inputTexcoords.zw;
        outputTexcoord2AndBlend.z = inputBlend;
#endif
    }

#ifndef _FLIPBOOKBLENDING_ON
    outputTexcoord2AndBlend.xy = inputTexcoords.xy;
    outputTexcoord2AndBlend.z = 0.5;
#endif
}

void GetParticleTexcoords_float(float4 inputTexcoord, float inputBlend, out float2 outputTexcoord, out float2 texcoord2, out float blend)
{
    float3 dummyTexcoord2AndBlend = 0.0;
    GetParticleTexcoords(outputTexcoord, dummyTexcoord2AndBlend, inputTexcoord, inputBlend);
    texcoord2 = dummyTexcoord2AndBlend.xy;
    blend = dummyTexcoord2AndBlend.z;
}

void GetParticleTexcoords_half(half4 inputTexcoord, half inputBlend, out half2 outputTexcoord, out half2 texcoord2, out half blend)
{
    half3 dummyTexcoord2AndBlend = 0.0;
    GetParticleTexcoords(outputTexcoord, dummyTexcoord2AndBlend, inputTexcoord, inputBlend);
    texcoord2 = dummyTexcoord2AndBlend.xy;
    blend = dummyTexcoord2AndBlend.z;
}

void IncludeInstancingSetup_float(float3 In, out float3 Out)
{
    Out = In;
}

void IncludeInstancingSetup_half(half3 In, out half3 Out)
{
    Out = In;
}

#endif // SHADERGRAPH_PARTICLESINSTANCING_URP_ONLY_INCLUDED
