local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local app_bundle_mapping = {
  ["com.spotify.client"] = ":spotify:",
}

local media = sbar.add("item", {
  position = "right",
  icon = {
    font = settings.icons,
    color = colors.magenta,
  },
  label = {
    max_chars = 50,
    padding_left = 8,
  },
  popup = {
    horizontal = true,
    align = "center",
    y_offset = 2,
  },
  padding_right = 8,
})

sbar.add("item", {
  position = "popup." .. media.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.back },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "media-control previous-track",
})
sbar.add("item", {
  position = "popup." .. media.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "media-control toggle-play-pause",
})
sbar.add("item", {
  position = "popup." .. media.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "media-control next-track",
})

media:subscribe("media_stream_changed", function(env)
  local lookup = app_bundle_mapping[env.app_id]
  if not (lookup == nil) then
    media:set({ icon = { string = lookup }, label = env.artist .. " - " .. env.title })
  end
end)

media:subscribe("mouse.clicked", function(_)
  media:set({ popup = { drawing = "toggle" } })
end)
