#ifndef SHADERGRAPH_CUSTOM_PARTICLESINSTANCING_INCLUDED
#define SHADERGRAPH_CUSTOM_PARTICLESINSTANCING_INCLUDED

#ifndef UNITY_PARTICLE_INSTANCE_DATA
#define UNITY_PARTICLE_INSTANCE_DATA CustomParticleInstanceData
//#define UNITY_PARTICLE_INSTANCE_DATA_NO_ANIM_FRAME
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
    float agePercent;
    float speed;
};
#endif

#include "ShurikenDefault.hlsl"

void GetParticleSpeed_float(float In, out float Out)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    Out = data.speed;
#else
    Out = In;
#endif
}

void GetParticleSpeed_half(half In, out half Out)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    Out = data.speed;
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

#endif //SHADERGRAPH_CUSTOM_PARTICLESINSTANCING_INCLUDED
