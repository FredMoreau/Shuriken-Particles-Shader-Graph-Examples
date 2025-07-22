# Shuriken Particles - Shader Graph Examples
Shuriken Particles examples using Shader Graph

This package contains examples of Shuriken Particles using Shader Graph and GPU Instancing.

![alt text](Documentation~/images/urp-only-examples.png)

From left to right:

#### URP Only - Simple
This shader graph demonstrates basic setup, leveraging URP's default Particle Instancing.
It supports flipbook UVs provided by the Texture Sheet Animation module and particle's color.
![alt text](Documentation~/images/urp-only-simple.png)

#### URP Only - Flipbook Blending
This shader graph demonstrates the implementation of a custom particle data struct with Custom Vertex Stream, to support flipbook blending provided by the Texture Sheet Animation module as explained in the documentation.

#### URP Only - Age & Speed
This shader graph demonstrates the implementation of a custom particle data struct with Custom Vertex Stream, to fetch particles' age and speed attributes.

#### URP Only - Stable Random & Custom
This shader graph demonstrates the implementation of a custom particle data struct with Custom Vertex Stream, to fetch particles' stable random and custom attributes.
