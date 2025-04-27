shader_type canvas_item;

uniform vec4 eyes_color : source_color = vec4(0.0, 0.51, 1.0, 1.0); // couleur des yeux
uniform float is_blue : hint_range(0.0, 1.0) = 1.0;

// Fonction pour comparer deux couleurs avec tolérance
bool is_color_close(vec3 a, vec3 b, float epsilon) {
    return distance(a, b) < epsilon;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Définition des couleurs à exclure
    vec3 black = vec3(0.0);
    vec3 white = vec3(1.0);
    vec3 blue_gray = vec3(0.7569, 0.8078, 0.9843);
    vec3 gray = vec3(0.4549, 0.4549, 0.5412);    // #75758C

    float epsilon = 0.1; // Tolérance pour comparaison

    // Vérifie si le pixel correspond à l'une des couleurs exclues
    bool is_excluded = is_color_close(tex_color.rgb, black, epsilon)
                    || is_color_close(tex_color.rgb, white, epsilon)
                    || is_color_close(tex_color.rgb, blue_gray, epsilon)
                    || is_color_close(tex_color.rgb, gray, epsilon);

    if (is_blue > 0.5 || is_excluded) {
        COLOR = tex_color; // on garde la couleur originale
    } else {
        // Recoloration basée sur la luminance
        float gray = dot(tex_color.rgb, vec3(0.5, 0.7, 0.4));
        vec3 shaded_color = eyes_color.rgb * gray;
        COLOR = vec4(shaded_color, tex_color.a);
    }
}