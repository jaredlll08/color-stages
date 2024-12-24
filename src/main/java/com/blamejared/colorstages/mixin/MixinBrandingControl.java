package com.blamejared.colorstages.mixin;

import com.blamejared.colorstages.client.ColorStagesClientHandler;
import net.minecraftforge.internal.BrandingControl;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.util.function.BiConsumer;

@Mixin(value = BrandingControl.class, remap = false)
public abstract class MixinBrandingControl {
    @Inject(method = "forEachAboveCopyrightLine", at = @At(value = "HEAD"), remap = false)
    private static void doThing(BiConsumer<Integer, String> lineConsumer, CallbackInfo ci) {
        ColorStagesClientHandler.initializedTitleFade = true;
    }
}
