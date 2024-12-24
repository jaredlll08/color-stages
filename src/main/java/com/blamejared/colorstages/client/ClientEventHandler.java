package com.blamejared.colorstages.client;

import com.blamejared.colorstages.ColorStages;
import net.darkhax.gamestages.event.StagesSyncedEvent;
import net.minecraft.client.Minecraft;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

@Mod.EventBusSubscriber(modid = ColorStages.MODID, value = Dist.CLIENT)
public class ClientEventHandler {

    @SubscribeEvent
    public static void onGamestageSync(StagesSyncedEvent event) {

        Minecraft.getInstance().execute(() -> {
            ColorStages.hideRED = true;
            ColorStages.hideORANGE = true;
            ColorStages.hideBROWN = true;
            ColorStages.hideYELLOW = true;
            ColorStages.hideGREEN = true;
            ColorStages.hideLIME = true;
            ColorStages.hideCYAN = true;
            ColorStages.hideLIGHT_BLUE = true;
            ColorStages.hideBLUE = true;
            ColorStages.hideMAGENTA = true;
            ColorStages.hidePURPLE = true;
            ColorStages.hidePINK = true;
            for (String stage : event.getData().getStages()) {
                switch (stage) {
                    case "all_colors": {
                        ColorStages.hideRED = false;
                        ColorStages.hideORANGE = false;
                        ColorStages.hideBROWN = false;
                        ColorStages.hideYELLOW = false;
                        ColorStages.hideGREEN = false;
                        ColorStages.hideLIME = false;
                        ColorStages.hideCYAN = false;
                        ColorStages.hideLIGHT_BLUE = false;
                        ColorStages.hideBLUE = false;
                        ColorStages.hideMAGENTA = false;
                        ColorStages.hidePURPLE = false;
                        ColorStages.hidePINK = false;
                        break;
                    }
                    case "red":
                        ColorStages.hideRED = false;
                        break;
                    case "orange":
                        ColorStages.hideORANGE = false;
                        break;
                    case "brown":
                        ColorStages.hideBROWN = false;
                        break;
                    case "yellow":
                        ColorStages.hideYELLOW = false;
                        break;
                    case "green":
                        ColorStages.hideGREEN = false;
                        break;
                    case "lime":
                        ColorStages.hideLIME = false;
                        break;
                    case "cyan":
                        ColorStages.hideCYAN = false;
                        break;
                    case "light_blue":
                        ColorStages.hideLIGHT_BLUE = false;
                        break;
                    case "blue":
                        ColorStages.hideBLUE = false;
                        break;
                    case "magenta":
                        ColorStages.hideMAGENTA = false;
                        break;
                    case "purple":
                        ColorStages.hidePURPLE = false;
                        break;
                    case "pink":
                        ColorStages.hidePINK = false;
                        break;
                }
            }
            ColorStages.updateKnownColors();
        });

    }

}