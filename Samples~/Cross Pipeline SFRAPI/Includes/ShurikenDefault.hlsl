#include "ShaderApiReflectionSupport.hlsl"

#ifndef SHADERGRAPH_PARTICLESINSTANCING_INCLUDED
#define SHADERGRAPH_PARTICLESINSTANCING_INCLUDED

#if defined(UNITY_PROCEDURAL_INSTANCING_ENABLED) && !defined(SHADER_TARGET_SURFACE_ANALYSIS)
#define UNITY_PARTICLE_INSTANCING_ENABLED
#endif

#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)

#ifndef UNITY_PARTICLE_INSTANCE_DATA
#define UNITY_PARTICLE_INSTANCE_DATA DefaultParticleInstanceData

struct DefaultParticleInstanceData
{
    float3x4 transform;
    uint color;
#ifndef UNITY_PARTICLE_INSTANCE_DATA_NO_ANIM_FRAME
    float animFrame;
#endif
#ifdef _FLIPBOOKBLENDING_ON
    float animBlend;
#endif
};
#endif

StructuredBuffer<UNITY_PARTICLE_INSTANCE_DATA> unity_ParticleInstanceData;
float4 unity_ParticleUVShiftData;
half unity_ParticleUseMeshColors;

#endif // UNITY_PARTICLE_INSTANCING_ENABLED

void ParticleInstancingSetup()
{
    
}

///<funchints>
///     <sg:ProviderKey>TransformParticleMesh</sg:ProviderKey>
///</funchints>
///<paramhints name = "position">
///     <Position />
///     <Default>ObjectSpace</Default>
///</paramhints>
///<paramhints name = "normal">
///     <Normal />
///     <Default>ObjectSpace</Default>
///</paramhints>
///<paramhints name = "tangent">
///     <Tangent />
///     <Default>ObjectSpace</Default>
///</paramhints>
UNITY_EXPORT_REFLECTION
void TransformParticleMesh(inout float3 position, inout float3 normal, inout float3 tangent)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    float4x4 tx = float4x4(data.transform, 0, 0, 0, 1);
    position = mul(tx, float4(position, 1));
    float3x3 notranslation_tx = (float3x3)tx;
    normal = mul(notranslation_tx, normal);
    tangent = mul(notranslation_tx, tangent);
#endif
}

///<funchints>
///     <sg:ProviderKey>ParticleColor</sg:ProviderKey>
///</funchints>
///<paramhints name = "vc">
///     <VertexColor />
///     <Local />
///</paramhints>
UNITY_EXPORT_REFLECTION
void ParticleColor(in float4 vc, out float4 color)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    color = lerp(float4(1.0, 1.0, 1.0, 1.0), vc, unity_ParticleUseMeshColors);
    color *= float4(UnpackFromR8G8B8A8(data.color));
#else
    color = vc;
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

///<funchints>
///     <sg:ProviderKey>ParticleTexCoords</sg:ProviderKey>
///</funchints>
///<paramhints name = "uv">
///     <UV />
///     <Default>UV0</Default>
///</paramhints>
UNITY_EXPORT_REFLECTION
void GetParticleTexcoords(inout float2 uv)
{
    float3 dummyTexcoord2AndBlend = 0.0;
    GetParticleTexcoords(uv, dummyTexcoord2AndBlend, uv.xyxy, 0.0);
}

///<funchints>
///     <sg:ProviderKey>ParticleTexCoordsFlipbookBlending</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleTexcoords(float4 inputTexcoord, float inputBlend, out float2 outputTexcoord, out float2 texcoord2, out float blend)
{
    float3 dummyTexcoord2AndBlend = 0.0;
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    GetParticleTexcoords(outputTexcoord, dummyTexcoord2AndBlend, inputTexcoord, inputBlend);
#else
    outputTexcoord = inputTexcoord.xy;
    dummyTexcoord2AndBlend = float3(inputTexcoord.zw, inputBlend);
#endif
    texcoord2 = dummyTexcoord2AndBlend.xy;
    blend = dummyTexcoord2AndBlend.z;
}

///<funchints>
///     <sg:ProviderKey>ParticleAnimFrame</sg:ProviderKey>
///</funchints>
UNITY_EXPORT_REFLECTION
void GetParticleAnimFrame(inout float animFrame)
{
#if defined(UNITY_PARTICLE_INSTANCING_ENABLED)
    UNITY_PARTICLE_INSTANCE_DATA data = unity_ParticleInstanceData[unity_InstanceID];
    animFrame = data.animFrame;
#endif
}

#endif //SHADERGRAPH_PARTICLESINSTANCING_INCLUDED
