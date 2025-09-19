local colors = require("colors")
local icons = require("icons")

return {
  paddings = 3,
  group_paddings = 5,
  modes = {
    main = {
      icon = icons.apple,
      color = colors.rainbow[1],
    },
    service = {
      icon = icons.nuke,
      color = 0xffff9e64,
    },
  },
  bar = {
    height = 30,
    padding = {
      x = 10,
      y = 0,
    },
    background = colors.bar.bg,
  },
  items = {
    height = 22,
    gap = 3,
    padding = {
      right = 10,
      left = 8,
      top = 0,
      bottom = 0,
    },
    default_color = function(workspace)
      return colors.rainbow[workspace + 1]
    end,
    highlight_color = function(workspace)
      return colors.yellow
    end,
    colors = {
      background = colors.bg1,
    },
    corner_radius = 5,
  },

  icons = "sketchybar-app-font:Regular:13.0", -- alternatively available: NerdFont

  font = {
    text = "JetBrainsMono Nerd Font", -- Used for text
    numbers = "JetBrainsMono Nerd Font", -- Used for numbers
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "SemiBold",
      ["Heavy"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  },
}
