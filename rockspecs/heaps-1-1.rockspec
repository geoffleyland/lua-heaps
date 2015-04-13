package = "heaps"
version = "1-1"
source =
{
  url = "git://github.com/geoffleyland/lua-heaps.git",
  branch = "master",
  tag = "v1",
}
description =
{
  summary = "Binary and skew heaps",
  homepage = "http://github.com/geoffleyland/lua-heaps",
  license = "MIT/X11",
  maintainer = "Geoff Leyland <geoff.leyland@incremental.co.nz>"
}
dependencies =
{
  "lua >= 5.1"
}
build =
{
  type = "builtin",
  modules =
  {
    binary_heap = "lua/binary_heap.lua",
    skew_heap = "lua/skew_heap.lua",
  }
}
