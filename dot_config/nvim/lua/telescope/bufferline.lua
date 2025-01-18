local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local groups = require("bufferline.groups")

local M = {}

M.buffer_line_group_picker = function(opts)
  opts = opts or {}

  local all_groups = groups.get_all()
  local active_group_names = groups.complete("", "", 0)

  pickers
    .new(opts, {
      prompt_title = "Buffer Line Group",
      finder = finders.new_table({
        results = active_group_names,
        entry_maker = function(entry)
          return {
            value = entry,
            display = all_groups[entry].display_name,
            ordinal = all_groups[entry].display_name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          groups.action(selection.value, "toggle")
        end)
        return true
      end,
    })
    :find()
end

return M
