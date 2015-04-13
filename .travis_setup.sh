# A script for setting up environment for travis-ci testing. 
# Sets up Lua and Luarocks. 
# LUA must be "Lua 5.1", "Lua 5.2", "Lua 5.3" or "LuaJIT 2.0". 

set -e

echo 'rocks_servers = {
  "http://rocks.moonscript.org/",
}' >> ~/config.lua


if [ "$LUA" == "LuaJIT" ]; then
  git clone --depth=1 --branch=v2.1 git://repo.or.cz/luajit-2.0.git
  cd luajit-2.0
  git checkout v2.1
  make && sudo make install INSTALL_TSYMNAME=lua;
  sudo ln -sf /usr/local/bin/luajit-2.1.0-alpha /usr/local/bin/lua
else
  if [ "$LUA" == "Lua 5.1" ]; then
    wget -O - http://www.lua.org/ftp/lua-5.1.5.tar.gz | tar xz
    cd lua-5.1.5;
  elif [ "$LUA" == "Lua 5.2" ]; then
    wget -O - http://www.lua.org/ftp/lua-5.2.3.tar.gz | tar xz
    cd lua-5.2.3;
  elif [ "$LUA" == "Lua 5.3" ]; then
    wget -O - http://www.lua.org/ftp/lua-5.3.0.tar.gz | tar xz
    cd lua-5.3.0;
  fi
  sudo make linux install;
fi

cd ..
wget -O - http://luarocks.org/releases/luarocks-2.2.0.tar.gz | tar xz
cd luarocks-2.2.0

if [ "$LUA" == "LuaJIT" ]; then
  ./configure --with-lua-include=/usr/local/include/luajit-2.1;
else
  ./configure;
fi

make && sudo make install
cd ..
