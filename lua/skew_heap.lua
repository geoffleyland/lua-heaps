-- Copyright (c) 2008-2011 Incremental IP Limited.

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

-- A good description of a skew heap can be found at
-- http://www.cs.usu.edu/~allan/DS/Notes/Ch23.pdf


-- heap construction ---------------------------------------------------------


local heap = {}
heap.__index = heap


local function default_comparison(k1, k2)
  return k1 < k2
end


function heap:new(comparison)
  return setmetatable({ comparison = comparison or default_comparison }, self)
end


-- info ----------------------------------------------------------------------

function heap:next_key()
  assert(self.left, "The heap is empty")
  return self.left.key
end


function heap:empty()
  return self.left == nil
end


-- merging -------------------------------------------------------------------

function heap:merge(a, b)
  local cmp = self.comparison
  local head = self

  if not b then
    head.left = a
  else
    while a do
      if cmp(a.key, b.key) then     -- a is less (or higher priority) than b
        head.left = a               -- the lesser tree goes on the left
        head = a                    -- and we work on that in the next round
        a = head.right              -- by merging its right side with b
        head.right = head.left      -- and we move the left side to the right
      else
        head.left = b
        head = b
        a, b = head.right, a
        head.right = head.left
      end
    end
    head.left = b
  end
end


-- insertion and popping ------------------------------------------------------

function heap:insert(k, v)
  assert(k, "You can't insert nil into a heap")
  self:merge({key=k, value=v}, self.left)
end


function heap:pop()
  assert(self.left, "The heap is empty")
  local result = self.left
  self:merge(result.left, result.right)
  return result.key, result.value
end


-- checking ------------------------------------------------------------------

local function _check(h, cmp)
  if h == nil then return true end
  local k, l, r = h.key, h.left, h.right
  if (l and cmp(l.key, k)) or (r and cmp(r.key, k)) then
    return false
  else
    return _check(l, cmp) and _check(r, cmp)
  end
end


function heap:check(cmp)
  return _check(self.left, cmp or self.comparison)
end


-- pretty printing -----------------------------------------------------------

function heap:write(f, tostring_func)
  f = f or io.stdout
  tostring_func = tostring_func or tostring
  local size = #self

  local function write_node(h, lines, line, start_col)
    line = line or 1
    start_col = start_col or 0
    lines[line] = lines[line] or ""

    local my_string = tostring_func(h.key)
    local my_len = my_string:len()

    local left_spaces, right_spaces = 0, 0
    if h.left ~= nil then
      left_spaces = write_node(h.left, lines, line + 1, start_col)
    end
    if h.right ~= nil then
      right_spaces = write_node(h.right, lines, line + 1, start_col+left_spaces+my_len)
    end
    lines[line] = lines[line]..string.rep(' ', start_col+left_spaces - lines[line]:len())..my_string..string.rep(' ', right_spaces)
    return left_spaces + my_len + right_spaces
  end

  local lines = {}
  write_node(self.left, lines)
  for _, l in ipairs(lines) do
    f:write(l, '\n')
  end
end


------------------------------------------------------------------------------

return heap

------------------------------------------------------------------------------

