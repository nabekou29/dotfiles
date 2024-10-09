return {
  -- 遅いのでなるべく使わないほうが良さそう
  {
    "vhyrro/luarocks.nvim",
    enabled = false,
    priority = 2000,
    opts = {
      rocks = { "magick" },
    },
  },
}
