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

void IncludeInstancingSetup_float(float3 In, out float3 Out)
{
    Out = In;
}

void IncludeInstancingSetup_half(half3 In, out half3 Out)
{
    Out = In;
}

#endif // SHADERGRAPH_PARTICLESINSTANCING_URP_ONLY_INCLUDED
