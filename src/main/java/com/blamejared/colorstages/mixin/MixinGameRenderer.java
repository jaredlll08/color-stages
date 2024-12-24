package com.blamejared.colorstages.mixin;

import com.blamejared.colorstages.client.ColorStagesClientHandler;
import net.minecraft.Util;
import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.GameRenderer;
import net.minecraft.util.Mth;
import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(GameRenderer.class)
public abstract class MixinGameRenderer {

    @Shadow
    @Final
    private Minecraft minecraft;

    @Shadow public abstract Minecraft getMinecraft();

    @Inject(method = "render", at = @At(value = "INVOKE", target = "Lcom/mojang/blaze3d/systems/RenderSystem;applyModelViewMatrix()V", shift = At.Shift.BEFORE, ordinal = 1))
    private void onRender(float partialTicks, long nanoTime, boolean renderWorldIn, CallbackInfo ci) {

        if(!ColorStagesClientHandler.initializedTitleFade){
            return;
        }
        ColorStagesClientHandler.onRender(partialTicks, nanoTime, renderWorldIn, ci);
    }

    @Inject(method = "resize", at = @At("TAIL"))
    private void onWindowResize(int width, int height, CallbackInfo ci) {
        if (ColorStagesClientHandler.initializedPostChain) {
            ColorStagesClientHandler.getChain().resize(width, height);
        }
    }

    @Inject(method = "reloadShaders", at = @At("HEAD"))
    private void onReloadShaders(CallbackInfo ci) {
        ColorStagesClientHandler.reload();
    }
}