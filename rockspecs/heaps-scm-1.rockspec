package = "heaps"
version = "scm-1"
source =
{
  url = "git://github.com/geoffleyland/lua-heaps.git",
  branch = "master",
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
  },
}
