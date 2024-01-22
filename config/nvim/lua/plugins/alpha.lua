local Ascii = {}
Ascii.miku = {[[              ⬛⬛⬛                ⬛⬛⬛              ]],
              [[              ⬛🟪⬛                ⬛🟪⬛              ]],
              [[            ⬛⬛🟪⬛  ⬛⬛⬛⬛⬛⬛  ⬛🟪⬛⬛            ]],
              [[          ⬛🟦⬛🟪⬛⬛🟦🟦🟦🟦🟦🟦⬛⬛🟪⬛🟦⬛          ]],
              [[          ⬛🟦🟦⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦⬛          ]],
              [[        ⬛🟦🟦⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦⬛        ]],
              [[        ⬛🟦🟦⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦⬛        ]],
              [[      ⬛🟦🟦⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦⬛      ]],
              [[      ⬛🟦🟦⬛🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦⬛      ]],
              [[    ⬛🟦🟦🟦⬛🟦🟦🟦🟦🟦🏻🟦🟦🟦🟦🟦🟦🟦🟦⬛🟦🟦🟦⬛    ]],
              [[    ⬛🟦🟦🟦⬛🟦🟦🟦🟦🏻🏻🟦🟦🟦🏻🟦🟦🟦🟦⬛🟦🟦🟦⬛    ]],
              [[  ⬛🟦🟦🟦⬛  ⬛🟦🟦🏻⬛🏻🏻🟦🏻⬛🏻🟦🟦⬛  ⬛🟦🟦🟦⬛  ]],
              [[  ⬛🟦🟦🟦⬛  ⬛🟦🟦🏻⬛🏻🏻🏻🏻⬛🏻🟦🟦⬛  ⬛🟦🟦🟦⬛  ]],
              [[  ⬛🟦🟦🟦⬛  ⬛🟦🟦🏻🏻🏻🏻🏻🏻🏻🏻🟦🟦⬛  ⬛🟦🟦🟦⬛  ]],
              [[⬛🟦🟦🟦🟦⬛    ⬛🟦⬛🏻🏻🏻🏻🏻🏻⬛🟦⬛    ⬛🟦🟦🟦🟦⬛]],
              [[⬛🟦🟦🟦🟦⬛      ⬛  ⬛⬛🌫️🌫️⬛⬛  ⬛      ⬛🟦🟦🟦🟦⬛]],
              [[⬛🟦🟦🟦🟦⬛          ⬛🌫️🟦🟦🌫️⬛          ⬛🟦🟦🟦🟦⬛]],
              [[⬛🟦🟦🟦🟦⬛        ⬛⬛🌫️🟦🟦🌫️⬛⬛        ⬛🟦🟦🟦🟦⬛]],
              [[⬛🟦🟦🟦🟦🟦⬛    ⬛🏻⬛⬛🟦🟦⬛⬛🏻⬛    ⬛🟦🟦🟦🟦🟦⬛]],
              [[  ⬛🟦🟦🟦🟦⬛      ⬛⬛⬛⬛⬛⬛⬛⬛      ⬛🟦🟦🟦🟦⬛  ]],
              [[    ⬛🟦🟦🟦🟦⬛      ⬛🏻⬛⬛🏻⬛      ⬛🟦🟦🟦🟦⬛    ]],
              [[      ⬛⬛⬛⬛        ⬛⬛⬛⬛⬛⬛        ⬛⬛⬛⬛      ]],
              [[                        ⬛    ⬛                        ]]}
-- https://asciiart.club/

function merge_tables(t1, t2)
    local merged = {}
    for _, v in ipairs(t1) do
        table.insert(merged, v)
    end
    for _, v in ipairs(t2) do
        table.insert(merged, v)
    end
    return merged
end

return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        local alpha = require 'alpha'
        local dashboard = require 'alpha.themes.dashboard'

        local hl_group_name = "AlphaHeader"
        -- vim.cmd("hi " .. hl_group_name .. " guifg=#f8a5bb")
        vim.cmd("hi " .. hl_group_name .. " guifg=#FC9DFF")

        dashboard.section.header.val = Ascii.miku
        dashboard.section.header.opts.hl = hl_group_name

        alpha.setup(dashboard.config)

    end
}
