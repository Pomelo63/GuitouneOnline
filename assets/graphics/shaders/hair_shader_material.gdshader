shader_type canvas_item;

uniform vec4 hair_color : source_color = vec4(1.0, 0.85, 0.4, 1.0); // couleur de base (blond)
uniform float is_blond : hint_range(0.0, 1.0) = 1.0; // Utilisation d'un float pour simuler un booléen

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Si c'est blond, on ne modifie pas la couleur, juste l'originale
    if (is_blond > 0.5) {
        COLOR = tex_color; // On garde la couleur originale sans shader
    } else {
        // Sinon, on applique la luminance comme d'habitude
        float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114)); // Calcul de la luminance
        vec3 shaded_color = hair_color.rgb * gray; // Applique la couleur avec la luminance
        COLOR = vec4(shaded_color, tex_color.a); // On applique la couleur modifiée avec la transparence de l'image d'origine
    }
}