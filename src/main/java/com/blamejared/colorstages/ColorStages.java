package com.blamejared.colorstages;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.mojang.logging.LogUtils;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.fml.loading.FMLPaths;
import org.slf4j.Logger;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

@Mod(ColorStages.MODID)
public class ColorStages {

    public static final String MODID = "color_stages";
    public static final Logger LOG = LogUtils.getLogger();
    public static final Gson GSON = new GsonBuilder().create();
    public static final Path KNOWN_COLORS = FMLPaths.GAMEDIR.get().resolve("color_stages.json");

    public static boolean hideRED = true;
    public static boolean hideORANGE = true;
    public static boolean hideBROWN = true;
    public static boolean hideYELLOW = true;
    public static boolean hideGREEN = true;
    public static boolean hideLIME = true;
    public static boolean hideCYAN = true;
    public static boolean hideLIGHT_BLUE = true;
    public static boolean hideBLUE = true;
    public static boolean hideMAGENTA = true;
    public static boolean hidePURPLE = true;
    public static boolean hidePINK = true;

    public ColorStages() {
        final IEventBus modEventBus = FMLJavaModLoadingContext.get().getModEventBus();
        modEventBus.addListener(ColorStages::onFMLClientSetup);
    }

    private static void onFMLClientSetup(FMLClientSetupEvent event) {
        if (Files.exists(KNOWN_COLORS)) {
            try (BufferedReader reader = Files.newBufferedReader(KNOWN_COLORS)) {
                JsonArray jsonElements = GSON.fromJson(reader, JsonArray.class);
                for (JsonElement jsonElement : jsonElements) {
                    if (jsonElement.isJsonPrimitive()) {
                        String colorName = jsonElement.getAsString();
                        switch (colorName) {
                            case "red":
                                hideRED = false;
                                break;
                            case "orange":
                                hideORANGE = false;
                                break;
                            case "brown":
                                hideBROWN = false;
                                break;
                            case "yellow":
                                hideYELLOW = false;
                                break;
                            case "green":
                                hideGREEN = false;
                                break;
                            case "lime":
                                hideLIME = false;
                                break;
                            case "cyan":
                                hideCYAN = false;
                                break;
                            case "light_blue":
                                hideLIGHT_BLUE = false;
                                break;
                            case "blue":
                                hideBLUE = false;
                                break;
                            case "magenta":
                                hideMAGENTA = false;
                                break;
                            case "purple":
                                hidePURPLE = false;
                                break;
                            case "pink":
                                hidePINK = false;
                                break;
                        }
                    }
                }
            } catch (Exception e) {
                LOG.error("Error while reading color-stages.json file! File will be reset", e);
                updateKnownColors();
            }
        } else {
            updateKnownColors();
        }
    }

    public static void updateKnownColors() {
        try {
            Files.deleteIfExists(KNOWN_COLORS);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        try (BufferedWriter writer = Files.newBufferedWriter(KNOWN_COLORS, StandardOpenOption.CREATE)) {
            JsonArray array = new JsonArray();

            if (!hideRED) {
                array.add("red");
            }
            if (!hideORANGE) {
                array.add("orange");
            }
            if (!hideBROWN) {
                array.add("brown");
            }
            if (!hideYELLOW) {
                array.add("yellow");
            }
            if (!hideGREEN) {
                array.add("green");
            }
            if (!hideLIME) {
                array.add("lime");
            }
            if (!hideCYAN) {
                array.add("cyan");
            }
            if (!hideLIGHT_BLUE) {
                array.add("light_blue");
            }
            if (!hideBLUE) {
                array.add("blue");
            }
            if (!hideMAGENTA) {
                array.add("magenta");
            }
            if (!hidePURPLE) {
                array.add("purple");
            }
            if (!hidePINK) {
                array.add("pink");
            }

            GSON.toJson(array, writer);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }


}
