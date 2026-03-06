#include "ShaderApiReflectionSupport.hlsl"

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
    float custom1;
    float stableRandom;
};
#endif

//#include "ShurikenDefault.hlsl"
#include "Assets/ShurikenExamples/Cross Pipeline SFRAPI/Includes/ShurikenDefault.hlsl"

///<funchints>
///     <sg:ProviderKey>GetParticleCustomOne</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleCustomOne(inout float custom1)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    custom1 = data.custom1;
#endif
}

///<funchints>
///     <sg:ProviderKey>GetParticleStableRandom</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleStableRandom(inout float stableRandom)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    stableRandom = data.stableRandom;
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
