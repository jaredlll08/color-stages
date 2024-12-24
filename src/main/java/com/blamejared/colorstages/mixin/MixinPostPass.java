package com.blamejared.colorstages.mixin;

import com.blamejared.colorstages.ColorStages;
import net.minecraft.client.renderer.EffectInstance;
import net.minecraft.client.renderer.PostPass;
import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(PostPass.class)
public class MixinPostPass {

    @Shadow
    @Final
    private EffectInstance effect;

    @Inject(method = "process", at = @At(value = "INVOKE", target = "Lnet/minecraft/client/renderer/EffectInstance;apply()V", shift = At.Shift.BEFORE))
    public void injectIntoApplyMethod(CallbackInfo info) {
        if (this.effect.getName().equals("colorstages:color")) {
            this.effect.safeGetUniform("hideRed").set(ColorStages.hideRED ? 1 : 0);
            this.effect.safeGetUniform("hideOrange").set(ColorStages.hideORANGE ? 1 : 0);
            this.effect.safeGetUniform("hideBrown").set(ColorStages.hideBROWN ? 1 : 0);
            this.effect.safeGetUniform("hideYellow").set(ColorStages.hideYELLOW ? 1 : 0);
            this.effect.safeGetUniform("hideGreen").set(ColorStages.hideGREEN ? 1 : 0);
            this.effect.safeGetUniform("hideLime").set(ColorStages.hideLIME ? 1 : 0);
            this.effect.safeGetUniform("hideCyan").set(ColorStages.hideCYAN ? 1 : 0);
            this.effect.safeGetUniform("hideLightBlue").set(ColorStages.hideLIGHT_BLUE ? 1 : 0);
            this.effect.safeGetUniform("hideBlue").set(ColorStages.hideBLUE ? 1 : 0);
            this.effect.safeGetUniform("hideMagenta").set(ColorStages.hideMAGENTA ? 1 : 0);
            this.effect.safeGetUniform("hidePurple").set(ColorStages.hidePURPLE ? 1 : 0);
            this.effect.safeGetUniform("hidePink").set(ColorStages.hidePINK ? 1 : 0);
        }
    }
}