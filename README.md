# lua-heaps

[![Build Status](https://travis-ci.org/geoffleyland/lua-heaps.svg?branch=master)](https://travis-ci.org/geoffleyland/lua-heaps)

This started as a benchmark for binary and skew heaps in Lua.  It compares them
to sorting a table, which doesn't fare well.

Now it's a reasonably good implementation of both kinds of heaps,
probably a little better for binary heaps than skew heaps because I use binary heaps.

The binary heap implementation tries to keep garbage creation to a minimum,
which seems to help speed things up.

Usage is:

    local heap = require"binary_heap" -- or "skew_heap"
    local H = heap:new()

    H:insert(2, "world")
    H:insert(1, "hello")

    local k1, w1 = H:pop()
    local k2, w2 = H:pop()

    print(k1, k2)  -- prints "hello world"

Keys and values are kept separate because it can, in some cases (like my common one)
reduce garbage creation.

You can provide a comparison function to `heap:new`, which will be passed the keys
(but not values) of the two items to compare.


The heaps tested against Lua 5.1-5.3 and LuaJIT.
