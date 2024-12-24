package com.blamejared.colorstages;

import java.util.Objects;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.LongFunction;
import java.util.function.Supplier;

public class CSUtil {

    public static <T> T make(Supplier<T> supplier) {

        return supplier.get();
    }

    public static <T> T make(T instance, Consumer<T> consumer) {

        consumer.accept(instance);
        return instance;
    }

    public static <T> T uncheck(final Object o) {

        return (T) o;
    }

    public static <P, R> Function<P, R> notNull(Function<P, R> func) {

        return p -> Objects.requireNonNull(func.apply(p));
    }


    public static <R> LongFunction<R> cacheLast(final LongFunction<R> func) {
        return new LongFunction<>() {
            private long key;
            private R value;

            @Override
            public R apply(long p) {

                this.value = p == this.key ? this.value : func.apply(p);
                this.key = p;
                return this.value;
            }
        };
    }

    public static <P, R> Function<P, R> cacheLatest(final Function<P, R> func) {

        return new Function<>() {
            private P key;
            private R value;

            @Override
            public R apply(P p) {

                this.value = p.equals(this.key) ? this.value : func.apply(p);
                this.key = p;
                return this.value;
            }
        };
    }

}
