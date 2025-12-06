// Script del stage para aplicar el shader "glitch" únicamente a DAD.

var glitchShader;

function onCreatePost()
{
    // Crear shader a partir del archivo glitch.frag
    glitchShader = new CustomShader("glitch");

    // Si tu shader tiene uniforms personalizados, puedes ponerlos aquí:
    // glitchShader.intensity = 0.5;

    // Aplicarlo directamente al personaje Dad
    if (dad != null)
        dad.shader = glitchShader;
}

function onSongStart()
{
    // Por si el engine regenera personajes después del create
    if (dad != null && dad.shader != glitchShader)
        dad.shader = glitchShader;
}
