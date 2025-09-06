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

#include "ShurikenDefault.hlsl"

void IncludeInstancingSetup_float(float3 In, out float3 Out)
{
    Out = In;
}

void IncludeInstancingSetup_half(half3 In, out half3 Out)
{
    Out = In;
}

#endif //SHADERGRAPH_CUSTOM_PARTICLESINSTANCING_INCLUDED
