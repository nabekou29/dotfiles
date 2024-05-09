
_evalcache anyenv init -

export PATH=`npm prefix --location=global`/bin:$PATH
_evalcache github-copilot-cli alias -- "$0"


# install plugins

# luaenv-luarocks がインストールされていない場合はインストールする
if [ ! -d ~/.anyenv/envs/luaenv/plugins/luaenv-luarocks ]; then
  git clone https://github.com/xpol/luaenv-luarocks.git ~/.anyenv/envs/luaenv/plugins/luaenv-luarocks
fi
