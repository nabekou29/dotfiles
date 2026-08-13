local wezterm = require("wezterm")

local monaspace_harfbuzz_features = {
  "ss01=1", -- != == ===
  "ss02=1", -- <= >=
  "ss03=1", -- -> ~>
  "ss04=1", -- </ />
  "ss05=1", -- |>
  "ss06=1", -- ### +++ &&&
  "ss07=1", -- :: =: :=
  "ss08=1", -- ..= .-
  "ss09=1", -- <=> >> =<<
  -- "ss10=1", -- #[] #() (動いてる気がしない) ||
  "cv01=4", -- 0
  "cv02=0", -- 1
  "cv10=1", -- l i
  "cv11=1", -- j f r t
  "cv30=0", -- *
  "cv31=1", -- *
  "cv32=1", -- <= >=
  "cv60=0", -- <=
  "cv61=0", -- []
  "cv62=0", -- @_ (よくわからん)
}

local function font(font_name)
  font_name = font_name or "Fira Code"
  local font = wezterm.font(font_name)
  local font_size = 14.0
  local line_height = 1.1
  local harfbuzz_features = {}

  if font_name:match("Monaspace") or font_name:match("Moralerspace") then
    harfbuzz_features = monaspace_harfbuzz_features
  end

  return {
    font = font,
    font_size = font_size,
    line_height = line_height,
    harfbuzz_features = harfbuzz_features,
  }
end

return {
  font = font,
}
