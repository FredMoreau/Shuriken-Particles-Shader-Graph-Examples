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
    float agePercent;
    float speed;
};
#endif

#include "ShurikenDefault.hlsl"

///<funchints>
///     <sg:ProviderKey>GetParticleSpeed</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleSpeed(inout float speed)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    speed = data.speed;
#endif
}

///<funchints>
///     <sg:ProviderKey>GetParticleAge</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleAge(inout float age)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    age = data.agePercent;
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
