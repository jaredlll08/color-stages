#version 150

uniform sampler2D DiffuseSampler;

uniform vec4 ColorModulate;

uniform int hideRed;
uniform int hideOrange;
uniform int hideBrown;
uniform int hideYellow;
uniform int hideGreen;
uniform int hideLime;
uniform int hideCyan;
uniform int hideLightBlue;
uniform int hideBlue;
uniform int hideMagenta;
uniform int hidePurple;
uniform int hidePink;
uniform vec2 OutSize;

in vec2 texCoord;

const bool DEBUG = false;

out vec4 fragColor;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

const vec3 RGB_RED =        vec3(1., 0., 0.);//            #ff0000
const vec3 RGB_DARK_RED =   vec3(0.7, 0, 0);//             #8B0000
const vec3 RGB_ORANGE =     vec3(1., 0.647, 0.);//      "#fb6b1d"
const vec3 RGB_ORANGE_2 =   vec3(1., 0.549, 0.);
const vec3 RGB_BROWN_2 =    vec3(0.349, 0.22, 0.122);//     "#59381f"
const vec3 RGB_BROWN =      vec3(0.588, 0.294, 0.);//       "#964B00"
const vec3 RGB_YELLOW =     vec3(1., 1., 0.);//      "#ffff00"
const vec3 RGB_YELLOW_2 =   vec3(0.741, 0.718, 0.42);
const vec3 RGB_GREEN =      vec3(0., 0.502, 0.);//      "#165F16"
const vec3 RGB_GREEN_2 =    vec3(0.502, 0.502, 0.);
const vec3 RGB_LIME =       vec3(0.008, 0.992, 0.008);//       "#02FD02"
const vec3 RGB_CYAN =       vec3(0.188, 0.882, 0.725);//       "#30e1b9"
const vec3 RGB_LIGHT_BLUE = vec3(0.561, 0.827, 1.);// "#8fd3ff"
const vec3 RGB_BLUE =       vec3(0., 0.502, 1.);//       "#0080ff"
const vec3 RGB_MAGENTA =    vec3(1., 0., 1.);//    "#FF00FF"
const vec3 RGB_PURPLE =     vec3(0.502, 0., 0.502);//     "#800080"
const vec3 RGB_PINK =       vec3(1., 0.753, 0.796);//       "#FFC0CB"
const vec3 RGB_BLACK =      vec3(0.);
const vec3 RGB_WHITE =      vec3(1.);
const vec3 GRAY =      vec3(0.5);

bool isRedLike(vec3 hsb) {
    return hsb.r >= 315 || hsb.r < 15;
}

vec3 getRed(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (s < 0.6) {
        return RGB_PINK;
    }
    return RGB_RED;
}

bool isOrangeLike(vec3 hsb) {
    //TODO brown
    return hsb.r >= 15 && hsb.r < 40;
}

vec3 getOrange(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (b < 0.5) {
        return RGB_BROWN;
    }
    return RGB_ORANGE;
}

bool isYellowLike(vec3 hsb) {
    //TODO light gray
    return hsb.r >= 40 && hsb.r < 75;
}

vec3 getYellow(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (s < 0.1) {
      //  return GRAY;
    }
    return RGB_YELLOW;
}

bool isGreenLike(vec3 hsb) {
    //TODO does lime dye
    return hsb.r >= 75 && hsb.r < 165;
}

vec3 getGreen(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (b > 0.45) {
        if (s > 0.37) {
            return RGB_LIME;
        } else {
            return RGB_CYAN;
        }
    }
    return RGB_GREEN;
}

bool isCyanLike(vec3 hsb) {
    //TODO does light blue wool
    // TODO does white wool
    return hsb.r >= 165 && hsb.r < 195;
}

vec3 getCyan(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (s < 0.1) {
       // TODO 11/25/24 confirm this is right
       // return RGB_WHITE;
    }
    if (s < 0.15) {
       // TODO 11/25/24 confirm this is right
       // return GRAY;
    }
    if (s < 0.3) {
        return RGB_LIGHT_BLUE;
    }
    return RGB_CYAN;
}

bool isLightBlueLike(vec3 hsb) {
    //TODO does blue dye
    //TODO does gray and black dye
    return hsb.r >= 195 && hsb.r < 225;
}

vec3 getLightBlue(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (s > 0.8) {
        return RGB_BLUE;
    }
    // TODO 11/25/24 confirm this is right
    // if (s < 0.1) {
    //    return RGB_WHITE;
    // }
    if (s < 0.5) {
        if (b < 0.32) {
            return RGB_CYAN;
        }
    }

    return RGB_LIGHT_BLUE;
}


bool isBlueLike(vec3 hsb) {
    //TODO doesn't do blue dye
    //TODO does black wool?
    return hsb.r >= 225 && hsb.r < 255;
}

vec3 getBlue(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    return RGB_BLUE;
}

bool isPurpleLike(vec3 hsb) {
    return hsb.r >= 255 && hsb.r < 285;
}

vec3 getPurple(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    return RGB_PURPLE;
}

bool isMagentaLike(vec3 hsb) {
    //TODO does purple dye
    return hsb.r >= 285 && hsb.r < 315;
}

vec3 getMagenta(vec3 hsb) {
    float h = hsb.r;
    float s = hsb.g;
    float b = hsb.b;
    if (b <= 0.44) {
        return RGB_PURPLE;
    }
    return RGB_MAGENTA;
}

vec3 classifyHSB(vec3 actual) {
    vec3 hsb = rgb2hsv(actual);
    hsb.r *= 360.;
    if (hsb.g == 0) {
        return actual;
    }
    if (isRedLike(hsb)) {
        return getRed(hsb);
    }
    if (isOrangeLike(hsb)) {
        return getOrange(hsb);
    }
    if (isYellowLike(hsb)) {
        return getYellow(hsb);
    }
    if (isGreenLike(hsb)) {
        return getGreen(hsb);
    }
    if (isBlueLike(hsb)) {
        return getBlue(hsb);
    }
    if (isMagentaLike(hsb)) {
        return getMagenta(hsb);
    }
    if (isPurpleLike(hsb)) {
        return getPurple(hsb);
    }
    if (isLightBlueLike(hsb)) {
        return getLightBlue(hsb);
    }

    if (isCyanLike(hsb)) {
        return getCyan(hsb);
    }
    return actual;
}

void main() {
    vec4 color = texture(DiffuseSampler, texCoord) * ColorModulate;
    vec3 outCol = color.rgb;
    bool isGray = false;
    vec3 closestCol = classifyHSB(color.rgb);

    if (hideRed == 1 && closestCol == RGB_RED) {
        isGray = true;
    }
    if (hideOrange == 1 && closestCol == RGB_ORANGE) {
        isGray = true;
    }
    if (hideBrown == 1 && closestCol == RGB_BROWN) {
        isGray = true;
    }
    if (hideYellow == 1 && closestCol == RGB_YELLOW) {
        isGray = true;
    }
    if (hideGreen == 1 && closestCol == RGB_GREEN) {
        isGray = true;
    }
    if (hideLime == 1 && closestCol == RGB_LIME) {
        isGray = true;
    }
    if (hideCyan == 1 && closestCol == RGB_CYAN) {
        isGray = true;
    }
    if (hideLightBlue == 1 && closestCol == RGB_LIGHT_BLUE) {
        isGray = true;
    }
    if (hideBlue == 1 && closestCol == RGB_BLUE) {
        isGray = true;
    }
    if (hideMagenta == 1 && closestCol == RGB_MAGENTA) {
        isGray = true;
    }
    if (hidePurple == 1 && closestCol == RGB_PURPLE) {
        isGray = true;
    }
    if (hidePink == 1 && closestCol == RGB_PINK) {
        isGray = true;
    }

    if (isGray) {
        outCol = vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114)));
    }

    if (DEBUG) {
        vec4 middle = texture(DiffuseSampler, vec2(0.5, 0.5)) * ColorModulate;
        if (texCoord.x > 0.55 && texCoord.x < 0.6 && texCoord.y > 0.55 && texCoord.y < 0.6) {
            fragColor = vec4(classifyHSB(vec3(1) - middle.rgb), color.a);
        } else {
            fragColor = vec4(outCol, color.a);
        }
        //    fragColor = vec4(classifyHSB(color.rgb), color.a);
    } else {
        fragColor = vec4(outCol, color.a);
    }
}