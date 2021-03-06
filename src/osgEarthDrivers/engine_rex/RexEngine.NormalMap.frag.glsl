#version $GLSL_VERSION_STR

#pragma vp_entryPoint oe_normalMapFragment
#pragma vp_location   fragment_coloring
#pragma vp_order      0.2

#pragma import_defines(OE_TERRAIN_RENDER_NORMAL_MAP, OE_DEBUG_NORMALS)

// import terrain SDK
vec4 oe_terrain_getNormalAndCurvature(in vec2);

uniform sampler2D oe_tile_normalTex;

in vec3 vp_Normal;
in vec3 oe_UpVectorView;
in vec2 oe_normalMapCoords;
in vec3 oe_normalMapBinormal;

void oe_normalMapFragment(inout vec4 color)
{
#ifndef OE_TERRAIN_RENDER_NORMAL_MAP
    return;
#endif

    vec4 encodedNormal = oe_terrain_getNormalAndCurvature(oe_normalMapCoords);
    vec3 normal = normalize(encodedNormal.xyz*2.0-1.0);

    vec3 tangent = normalize(cross(oe_normalMapBinormal, oe_UpVectorView));
    vp_Normal = normalize( mat3(tangent, oe_normalMapBinormal, oe_UpVectorView) * normal );

    // visualize curvature quantized:
    //color.rgba = vec4(0.0,0,1);
    //float curvature = 2.0*encodedNormal.w - 1.0;
    //if (curvature > 0.0) color.r = curvature;
    //if (curvature < 0.0) color.b = -curvature;
    //color.a = 1.0;
    
#ifdef OE_DEBUG_NORMALS
    // visualize normals:
    color.rgb = encodedNormal.xyz;
#endif
}
