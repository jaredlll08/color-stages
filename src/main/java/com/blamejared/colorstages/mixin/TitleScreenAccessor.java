package com.blamejared.colorstages.mixin;

import net.minecraft.client.gui.screens.TitleScreen;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.gen.Accessor;

@Mixin(TitleScreen.class)
public interface TitleScreenAccessor {
    @Accessor("fadeInStart")
    long color_stages$fadeInStart();

    @Accessor
    boolean isFading();
}
