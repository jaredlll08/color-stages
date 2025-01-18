#version 150
#define PI 3.1415926538

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
out vec4 fragColor;


// Number of defined colors (updates loops and array sizes)
const int CLR_NUM = 14;
const float ERR_MARGIN = 0.0001;
// Ouput debug classification colors to screen
const bool DEBUG_CURS = false;
const bool DEBUG_SPEC = true;

// Color classification definition
struct ColorClass {
    vec3 debugRGB; // DO NOT USE IN RELEASE
    vec3 hsvMin;
    vec3 hsvMax;
    float lerpDist;
};

// Output classification of the current pixel fragment
struct FragClass {
    int color;
    float lerp;
};

// === UTILITY FUNCTIONS ===

float smoothStepHSV(const vec3 hsvIn, const vec3 hsvMin, const vec3 hsvMax, const float maxDist) {
    // Get nearest point within classification bounds
    vec3 nearest = vec3(
    0.0, // Hue wrapping dealt with separately
    clamp(hsvIn.y, hsvMin.y, hsvMax.y),
    clamp(hsvIn.z, hsvMin.z, hsvMax.z)
    );

    if(hsvMin.x > hsvMax.x) {
        // Which wrapped edge is closer
        if(abs(hsvIn.x - hsvMax.x) > abs(hsvMin.x - hsvIn.x)) {
            // UPPER
            nearest.x = clamp(hsvIn.x, hsvMin.x, 1.0);
        } else {
            // LOWER
            nearest.x = clamp(hsvIn.x, 0.0, hsvMax.x);
        }
    } else {
        // No wrapping
        nearest.x = clamp(hsvIn.x, hsvMin.x, hsvMax.x);
    }

    // Caclculate vec3 distance to that point (manhatten)
    //vec3 offset = nearest - hsvIn;
    //abs(offset.x) + abs(offset.y) + abs(offset.z);
    float dist = distance(nearest, hsvIn);
    if(maxDist > 0.0) {
        // Flip and scale linearly based on maximum allowed distance
        return clamp(dist / maxDist, 0.0, 1.0);
    } else {
        // Hard snap off once -ERR_MARGIN < -dist
        // Cannot be exactly 0.0 due to impossibly small gaps caused by floating point error
        return 1.0 - step(-ERR_MARGIN, -dist);
    }
}

float smoothStepHSV(vec3 hsvIn, const ColorClass clr) {
    return smoothStepHSV(hsvIn, clr.hsvMin, clr.hsvMax, clr.lerpDist);
}

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// === COLOR CLASSIFICATIONS ===

const ColorClass COLOR_LIST[CLR_NUM] = ColorClass[CLR_NUM](
// Debug RGB, Min HSV, Max HSV, Lerp Distance (all values [0.000 - 1.000]).
// Old hue (value / 360) rounded to 3 decimal places.
// Overlapping classifications are priority top down
ColorClass(vec3(0.500, 0.500, 0.500), vec3(0.000, 0.000, 0.000), vec3(0.000, 0.010, 1.000), 0.020), // GRAYSCALE (default)
ColorClass(vec3(1.000, 0.000, 0.000), vec3(0.875, 0.600, 0.000), vec3(0.042, 1.000, 1.000), 0.020), // RED
ColorClass(vec3(1.000, 0.753, 0.796), vec3(0.875, 0.000, 0.000), vec3(0.042, 0.600, 1.000), 0.020), // PINK
ColorClass(vec3(1.000, 0.647, 0.000), vec3(0.042, 0.000, 0.500), vec3(0.111, 1.000, 1.000), 0.020), // ORANGE
ColorClass(vec3(0.588, 0.294, 0.000), vec3(0.042, 0.000, 0.000), vec3(0.111, 1.000, 0.500), 0.020), // BROWN
ColorClass(vec3(1.000, 1.000, 0.000), vec3(0.111, 0.000, 0.000), vec3(0.208, 1.000, 1.000), 0.020), // YELLOW
ColorClass(vec3(0.000, 0.502, 0.000), vec3(0.208, 0.000, 0.000), vec3(0.458, 1.000, 0.450), 0.020), // GREEN
ColorClass(vec3(0.008, 0.992, 0.008), vec3(0.208, 0.370, 0.000), vec3(0.458, 1.000, 1.000), 0.020), // LIME
ColorClass(vec3(0.188, 0.882, 0.725), vec3(0.208, 0.000, 0.000), vec3(0.458, 0.370, 1.000), 0.020), // CYAN 1 (green)
ColorClass(vec3(0.188, 0.882, 0.725), vec3(0.458, 0.300, 0.000), vec3(0.542, 1.000, 1.000), 0.020), // CYAN 2 (blue)
ColorClass(vec3(0.561, 0.827, 1.000), vec3(0.458, 0.000, 0.000), vec3(0.708, 0.800, 1.000), 0.020), // BLUE LIGHT
ColorClass(vec3(0.000, 0.502, 1.000), vec3(0.542, 0.800, 0.000), vec3(0.708, 1.000, 1.000), 0.020), // BLUE
ColorClass(vec3(1.000, 0.000, 1.000), vec3(0.792, 0.000, 0.440), vec3(0.875, 1.000, 1.000), 0.020), // MAGENTA
ColorClass(vec3(0.502, 0.000, 0.502), vec3(0.708, 0.000, 0.000), vec3(0.875, 1.000, 1.000), 0.020)  // PURPLE
);

// Index constants
const int GRAY = 0;
const int RED = 1;
const int PINK = 2;
const int ORANGE = 3;
const int BROWN = 4;
const int YELLOW = 5;
const int GREEN = 6;
const int LIME = 7;
const int CYAN_1 = 8;
const int CYAN_2 = 9;
const int BLUE_LIGHT = 10;
const int BLUE = 11;
const int MAGENTA = 12;
const int PURPLE = 13;

// Map color index to uniform toggle state.
// You can map one toggle to multiple colors.
bool isHidden(int color) {
    if(color < 0 || color >= CLR_NUM) return false;
    if(color == RED) return hideRed > 0;
    if(color == PINK) return hidePink > 0;
    if(color == ORANGE) return hideOrange > 0;
    if(color == BROWN) return hideBrown > 0;
    if(color == YELLOW) return hideYellow > 0;
    if(color == GREEN) return hideGreen > 0;
    if(color == LIME) return hideLime > 0;
    if(color == CYAN_1 || color == CYAN_2) return hideCyan > 0;
    if(color == BLUE_LIGHT) return hideLightBlue > 0;
    if(color == BLUE) return hideBlue > 0;
    if(color == MAGENTA) return hideMagenta > 0;
    if(color == PURPLE) return hidePurple > 0;
    return false;
}

FragClass classifyHSV(vec3 diffuseHSV) {
    int color = -1;
    float lerp = 1.0;

    float dist;
    for(int i = 0; i < CLR_NUM; i++) {
        dist = smoothStepHSV(diffuseHSV, COLOR_LIST[i]);
        if(color < 0 && dist < ERR_MARGIN) color = i;
        if(!isHidden(i)) lerp = min(lerp, dist);
    }

    return FragClass(color, lerp);
}

// === MAIN ===

void main() {

    vec4 color = texture(DiffuseSampler, texCoord) * ColorModulate;
    FragClass clrClass = classifyHSV(rgb2hsv(color.rgb));


    if(clrClass.color < 0) {
        // Unclassified. Passthrough original color
        fragColor = color;
    } else {
        vec4 clrOut = color;
        if (isHidden(clrClass.color)) {
            // Convert to grayscale
            clrOut = vec4(dot(color.rgb, vec3(0.299, 0.587, 0.114)));
            // Mix color back in based on classification distance
            clrOut = mix(color, clrOut, clrClass.lerp);
            clrOut.a = color.a;
        }
        fragColor = clrOut;
    }
}