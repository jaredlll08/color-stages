package com.blamejared.colorstages.client;

import com.blamejared.colorstages.CSUtil;
import com.mojang.blaze3d.platform.GlStateManager;
import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.PostChain;
import net.minecraft.resources.ResourceLocation;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

import java.io.IOException;
import java.util.function.LongFunction;

import static com.mojang.blaze3d.platform.GlConst.GL_DRAW_FRAMEBUFFER;

public class ColorStagesClientHandler {

    public static boolean initializedPostChain = false;

    public static long reloadCounter = 0;

    public static boolean initializedTitleFade = false;

    private static final LongFunction<PostChain> POST_CHAIN = CSUtil.cacheLast(o -> {
        try {
            Minecraft mc = Minecraft.getInstance();
            PostChain postChain = new PostChain(mc.textureManager, mc.getResourceManager(), mc.getMainRenderTarget(), new ResourceLocation("colorstages:shaders/post/color.json"));
            postChain.resize(mc.getWindow().getWidth(), mc.getWindow().getHeight());
            initializedPostChain = true;
            return postChain;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    });

    public static PostChain getChain() {
        return POST_CHAIN.apply(reloadCounter);
    }

    public static void reload() {

        if (initializedPostChain) {
            getChain().close();
        }
        initializedPostChain = false;
        reloadCounter++;
    }

    public static void onRender(float partialTicks, long nanoTime, boolean renderWorldIn, CallbackInfo ci) {
        PostChain postChain = getChain();
        if (postChain != null) {
            Minecraft mc = Minecraft.getInstance();
            postChain.process(mc.getFrameTime());
            GlStateManager._glBindFramebuffer(GL_DRAW_FRAMEBUFFER, mc.getMainRenderTarget().frameBufferId);
        }
    }
}
