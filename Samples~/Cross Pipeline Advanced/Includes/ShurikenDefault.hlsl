#ifndef SHADERGRAPH_PARTICLESINSTANCING_INCLUDED
#define SHADERGRAPH_PARTICLESINSTANCING_INCLUDED

#if defined(UNITY_PROCEDURAL_INSTANCING_ENABLED) && !defined(SHADER_TARGET_SURFACE_ANALYSIS)
#define UNITY_PARTICLE_INSTANCING_ENABLED
#endif

#ifndef UNITY_PARTICLE_INSTANCE_DATA
#define UNITY_PARTICLE_INSTANCE_DATA DefaultParticleInstanceData

struct DefaultParticleInstanceData
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

StructuredBuffer<UNITY_PARTICLE_INSTANCE_DATA> unity_ParticleInstanceData;
float4 unity_ParticleUVShiftData;
half unity_ParticleUseMeshColors;

void ParticleInstancingSetup()
{
    
}

void ParticleTransform_float(out float4x4 transform)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    transform = float4x4(data.transform, 0, 0, 0, 1);
#else
    transform = float4x4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
#endif
}

void ParticleAnimFrame_float(uint instanceID, out float frame)
{
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[instanceID];

#ifdef UNITY_PARTICLE_INSTANCE_DATA_NO_ANIM_FRAME
    frame = 0.0;
#else
    frame = data.animFrame;
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

#endif //SHADERGRAPH_PARTICLESINSTANCING_INCLUDED
