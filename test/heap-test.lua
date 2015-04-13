-- Copyright (c) 2007-2011 Incremental IP Limited.

--[[
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--]]


local binary_heap = require("lua/binary_heap")
local skew_heap = require("lua/skew_heap")
local math_random = math.random
local table_sort, table_remove = table.sort, table.remove

-- tests -----------------------------------------------------------------------

local function test_heap_write(h)
  io.write("Pretty-printing heap:\n")
  for i = 1, 20 do
    h:insert(math_random(100))
  end
  h:write()
  io.write("\n")
end


local function test_heap_integrity(h, runs, insert_count, pop_count, range)
  runs = runs or 200
  insert_count = insert_count or 100
  pop_count = pop_count or 50
  range = range or 10000
  local cmp = h.comparison
  local size = 0
  local low

  io.write("Testing heap integrity...\n")
  for i = 1,runs do
    for j = 1,math_random(insert_count) do
      h:insert(math_random(range), nil)
      size = size + 1
      if not h:check() then
        io.write("\n")
        h:write()
        error("Heap check failed after insertion")
      end
      if size % 10 == 0 then io.write("Step: ", i, "/", runs, ": Heap size: ", size,".     \r") end
    end
    low = 0
    for j = 1,math.min(size, math_random(pop_count)) do
      local r = h:pop()
      size = size - 1
      if cmp(r, low) then 
        io.write("\n")
        h:write()
        error(string.format("Popped %d after %d", r, low))
      end
      low = r
      if not h:check() then
        io.write("\n")
        h:write()
        error("Heap check failed after pop")
      end
      if size % 10 == 0 then io.write("Step: ", i, "/", runs, ": Heap size: ", size,".     \r") end
    end
  end
  io.write("\n")
  low = 0
  while not h:empty() do
    local r = h:pop()
    size = size - 1
    if cmp(r, low) then 
      io.write("\n")
      h:write()
      error(string.format("Popped %d after %d", r, low))
    end
    low = r
    if not h:check() then
      io.write("\n")
      h:write()
      error("Heap check failed while clearing")
    end
    if size % 10 == 0 then io.write("Clearing: Heap size: ", size,".     \r") end
  end
  io.write("\nDone.\n")
end


local function test_heap_speed(h, name, runs, insert_count, pop_count, range)
  runs = runs or 100
  insert_count = insert_count or 10000
  pop_count = pop_count or 7500
  pop_count = math.min(pop_count, insert_count)
  range = range or 10000

  io.write(("Testing %s speed...\n"):format(name))
  local start = os.clock()
  for i = 1,runs do
    io.write("Step: ", i, "/", runs, ".\r")
    for j = 1,insert_count do
      h:insert(math_random(range), nil)
    end
    for j = 1,pop_count do
      h:pop()
    end
  end
  io.write("\nClearing heap.\n")
  while not h:empty() do
    h:pop()
  end
  
  local elapsed = os.clock() - start
  io.write("Done.  Elapsed time ", elapsed, " seconds (", elapsed / (insert_count * runs), " s/insert+pop).\n")
end


local function test_sort_queue_speed(runs, insert_count, pop_count, range)
  runs = runs or 100
  insert_count = insert_count or 10000
  pop_count = pop_count or 7500
  pop_count = math.min(pop_count, insert_count)
  range = range or 10000

  local function cmp(a, b) return a.key < b.key end

  h = {}

  io.write("Testing sorted queue speed...\n")
  local start = os.clock()
  for i = 1,runs do
    io.write("Step: ", i, "/", runs, ".\r")
    for j = 1,insert_count do
      h[#h+1] = { key=math_random(range), value=nil }
    end
    table_sort(h, cmp)
    for j = 1,pop_count do
      table_remove(h)
    end
  end
  io.write("\nClearing heap.\n")
  while h[1] do
    table_remove(h)
  end
  
  local elapsed = os.clock() - start
  io.write("Done.  Elapsed time ", elapsed, " seconds (", elapsed / (insert_count * runs), " s/insert+pop).\n")
end


-- main -----------------------------------------------------------------------

math.randomseed(1)
test_heap_write(binary_heap:new(function(k1, k2) return k1 > k2 end))
math.randomseed(1)
test_heap_write(skew_heap:new(function(k1, k2) return k1 > k2 end))
math.randomseed(1)
test_heap_integrity(binary_heap:new())
math.randomseed(1)
test_heap_integrity(skew_heap:new())
math.randomseed(1)
test_heap_speed(binary_heap:new(), "binary heap")
math.randomseed(1)
test_heap_speed(skew_heap:new(), "skew heap")

if arg[1] == "--with-sort" then
  math.randomseed(1)
  test_sort_queue_speed()
end


-- EOF -------------------------------------------------------------------------
