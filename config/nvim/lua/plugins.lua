vim.cmd [[packadd packer.nvim]]

require'packer'.startup(function()
    local use = use

    -- キャッシュによる高速化。vim.loader.enable が入ったらやめる
    use {'lewis6991/impatient.nvim'}

    -- color scheme
    use {"EdenEast/nightfox.nvim"}
    -- use {"jacoborus/tender.vim"}
    -- use {'tiagovla/tokyodark.nvim'}
    -- use {'folke/tokyonight.nvim'}
    -- use({
    --     'projekt0n/github-nvim-theme',
    --     tag = 'v0.0.7'
    -- })

    use {'wbthomason/packer.nvim', opt = true}
    use {'mhinz/vim-startify'}

    use {"lukas-reineke/indent-blankline.nvim"}

    -- コメントアウト
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }
    -- 検索時に右に n/N を表示してくれる
    use {
        'kevinhwang91/nvim-hlslens',
        config = function() require('hlslens').setup() end
    }

    -- キーバインドを教えてくれる
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    }
    -- スクロールバー表示
    use {
        "petertriho/nvim-scrollbar",
        event = {
            "BufWinEnter", "CmdwinLeave", "TabEnter", "TermEnter",
            "TextChanged", "VimResized", "WinEnter", "WinScrolled"
        },
        config = function() require("scrollbar").setup {} end
    }

    -- 通知やコマンドの表示をいい感じに
    use {
        "folke/noice.nvim",
        requires = { -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim", -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify"
        }
    }
    -- 自動保存
    use {
        "Pocco81/auto-save.nvim",
        event = {'InsertEnter'},
        config = function()
            require("auto-save").setup {trigger_events = {"InsertLeave"}}
        end
    }
    -- エラーの一覧を表示したり
    use {
        "folke/trouble.nvim",
        module = {"trouble"},
        event = {"FocusLost", "CursorHold"},
        setup = function()
            vim.keymap.set("n", "<leader>xx",
                           function() require("trouble").toggle() end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle'
            })
            vim.keymap.set("n", "<leader>xx", function()
                require("trouble").toggle('workspace_diagnostics')
            end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle workspace_diagnostics'
            })
            vim.keymap.set("n", "<leader>xd", function()
                require("trouble").toggle('document_diagnostics')
            end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle document_diagnostics'
            })
            vim.keymap.set("n", "<leader>xl",
                           function()
                require("trouble").toggle('loclist')
            end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle loclist'
            })
            vim.keymap.set("n", "<leader>xq", function()
                require("trouble").toggle('quickfix')
            end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle quickfix'
            })
            vim.keymap.set("n", "gR", function()
                require("trouble").toggle('lsp_references')
            end, {
                silent = true,
                noremap = true,
                desc = ':TroubleToggle lsp_references'
            })
        end,
        config = function()
            require("trouble").setup {use_diagnostic_signs = true}
        end,
        requires = "nvim-tree/nvim-web-devicons"
    }
    -- ウィンドウの選択して移動などの任意のコマンドを実行できる
    use {
        'tkmpypy/chowcho.nvim',
        module = {"chowcho"},
        setup = function()
            vim.keymap.set('n', '<C-w>w',
                           function() require('chowcho').run() end, {})
            vim.keymap.set('n', '<C-w>q', function()
                require('chowcho').run(vim.api.nvim_win_hide)
            end, {})
        end,
        config = function()
            require('chowcho').setup {
                icon_enabled = true, -- required 'nvim-web-devicons' (default: false)
                text_color = '#FFFFFF',
                bg_color = '#555555',
                active_border_color = '#0A8BFF',
                border_style = 'default', -- 'default', 'rounded',
                use_exclude_default = false,
                exclude = function(buf, win)
                    -- Exclude a window from the choice based on its buffer information.
                    -- This option is applied iff `use_exclude_default = false`.
                    -- Note that below is identical to the `use_exclude_default = true`.
                    local fname = vim.fn.expand('#' .. buf .. ':t')
                    return fname == ''
                end,
                zindex = 10000 -- sufficiently large value to show on top of the other windows
            }
        end
    }
    -- バッファを閉じた時にウィンドウを閉じないようにしてくれる
    use {
        'famiu/bufdelete.nvim',
        module = {'bufdelete'},
        setup = function()
            vim.keymap.set("n", "<leader>w", function()
                require('bufdelete').bufdelete(0, true)
            end, {desc = ':Bdelete'})
        end
    }
    -- 範囲選択
    use {
        'terryma/vim-expand-region',
        config = function()
            vim.keymap.set({'n', 'v'}, '<A-Up>', '<Plug>(expand_region_expand)',
                           {desc = 'Expand region'})
            vim.keymap.set({'n', 'v'}, '<A-k>', '<Plug>(expand_region_expand)',
                           {desc = 'Expand region'})
            vim.keymap.set({'n', 'v'}, '<A-Down>',
                           '<Plug>(expand_region_shrink)',
                           {desc = 'Shrink region'})
            vim.keymap.set({'n', 'v'}, '<A-j>', '<Plug>(expand_region_shrink)',
                           {desc = 'Shrink region'})
        end
    }
    -- 括弧・クォートで囲むやつ
    use {'machakann/vim-sandwich'}
    -- f/t で移動できる箇所をマークしてくれる
    use {'unblevable/quick-scope'}
    -- 移動
    use {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        module = {'hop', 'hop.hint'},
        setup = function()
            vim.keymap.set('', 'f', function()
                require('hop').hint_chr1({
                    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
                    current_line_only = true
                })
            end, {remap = true, silent = true})
            vim.keymap.set('', 'F', function()
                require('hop').hint_char1({
                    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
                    current_line_only = true
                })
            end, {remap = true, silent = true})
            vim.keymap.set('', 't', function()
                require('hop').hint_char1({
                    direction = require('hop.hint').HintDirection.AFTER_CvURSOR,
                    current_line_only = true,
                    hint_offset = -1
                })
            end, {remap = true, silent = true})
            vim.keymap.set('', 'T', function()
                require('hop').hint_char1({
                    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
                    current_line_only = true,
                    hint_offset = 1
                })
            end, {remap = true, silent = true})

            local hop_prefix = '<leader><leader>'
            vim.keymap.set('n', hop_prefix .. 'l', function()
                require('hop').hint_lines_skip_whitespace()
            end, {desc = '[Hop] Hint lines'})
            vim.keymap.set('n', hop_prefix .. '/',
                           function() require('hop').hint_patterns() end,
                           {desc = '[Hop] Hint patterns', silent = true})
            vim.keymap.set('n', hop_prefix .. 'f',
                           function() require('hop').hint_char2() end,
                           {desc = '[Hop] Hint char2'})
        end,
        config = function() require('hop').setup {} end
    }
    -- リンクを開くやつ
    use {'tyru/open-browser.vim'}

    -- neo-tree, telescope あたりで使う
    use {"nvim-lua/plenary.nvim"}

    -- ファイラー
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            {
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                opt = true
            }, "MunifTanjim/nui.nvim", {
                -- only needed if you want to use the commands with "_with_window_picker" suffix
                's1n7ax/nvim-window-picker',
                tag = "v1.*",
                opt = true,
                config = function()
                    require'window-picker'.setup({
                        autoselect_one = true,
                        include_current = false,
                        filter_rules = {
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = {
                                    'neo-tree', "neo-tree-popup", "notify"
                                },

                                -- if the buffer type is one of following, the window will be ignored
                                buftype = {'terminal', "quickfix"}
                            }
                        },
                        other_win_hl_color = '#e35e4f'
                    })
                end
            }
        },

        module = {"neo-tree"},
        setup = function()
            local keymap = vim.keymap.set
            keymap('n', '<leader>e', function()
                require('neo-tree').focus()
            end)
            keymap('n', '<leader><S-e>', function()
                require("neo-tree").show('buffers', true, true, true)
            end)
            keymap('n', '<C-1>', function()
                require("neo-tree").reveal_current_file("filesystem", false)
            end)
            keymap('n', '<C-2>',
                   function() require('neo-tree').focus("buffers") end)
            keymap('n', '<C-3>',
                   function() require('neo-tree').focus('git_status') end)
        end,
        config = function()
            require("neo-tree").setup({
                source_selector = {winbar = true, statusline = true}
            })
        end
    }
    -- ファジーファインダー
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        module = {"telescope", "telescope.builtin"},
        setup = function()
            -- 通常の検索
            vim.keymap.set('n', '<leader>ff', function()
                require('telescope.builtin').find_files()
            end, {desc = ':Telescope find_files'})
            -- 隠しファイル込み
            vim.keymap.set('n', '<leader>fF', function()
                require('telescope.builtin').find_files({hidden = true})
            end, {
                desc = ':Telescope find_files find_command=rg,--hidden,--files'
            })
            -- 最近開いたファイル
            vim.keymap.set("n", "<leader>fr", function()
                require('telescope').extensions.frecency.frecency()
            end, {noremap = true, silent = true, desc = ':Telescope frecency'})
            -- 全文検索
            vim.keymap.set('n', '<leader>fg', function()
                require('telescope.builtin').live_grep()
            end, {desc = ':Telescope live_grep'})
            -- バッファから検索
            vim.keymap.set('n', '<leader>fb', function()
                require('telescope.builtin').buffers()
            end, {desc = ':Telescope buffers'})
            vim.keymap.set('n', '<leader>fh', function()
                require('telescope.builtin').help_tags()
            end, {desc = ':Telescope help_tags'})
            -- Github
            vim.keymap.set('n', '<leader>gi', function()
                require('telescope').extensions.gh.issues()
            end, {desc = ':Telescope gh issues'})
        end,
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = false,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    }
                }
            }
            require('telescope').load_extension("frecency")
            require('telescope').load_extension('gh')
            require('telescope').load_extension('fzf')
        end,
        requires = {
            {
                "nvim-telescope/telescope-frecency.nvim",
                requires = {"kkharji/sqlite.lua"}
            }, {'nvim-telescope/telescope-github.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
        }
    }

    -- ステータスバー
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function() require('lualine').setup() end
    }
    use {
        'mvllow/modes.nvim',
        tag = 'v0.2.0',
        config = function()
            require('modes').setup({
                colors = {
                    copy = "#f5c359",
                    delete = "#c75c6a",
                    insert = "#78ccc5",
                    visual = "#9745be"
                },
                -- Set opacity for cursorline and number background
                line_opacity = 0.35,
                -- Enable cursor hiighlights
                set_cursor = true,
                -- Enable cursorline initially, and disable cursorline for inactive windows
                -- or ignored filetypes
                set_cursorline = true,
                -- Enable line number highlights to match cursorline
                set_number = true
            })
        end
    }

    -- バッファーバー
    use {
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {}
            vim.keymap.set('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>', {})
            vim.keymap.set('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>', {})
        end
    }

    -- LSP
    use {
        'williamboman/mason.nvim',
        config = function() require('mason').setup() end
    }
    use {"williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig"}
    use {
        "jose-elias-alvarez/null-ls.nvim",
        event = {"InsertLeave"},
        -- keys = { "gf", "gF" }, -- フォーマットのショートかっと
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code-1
            local null_ls = require("null-ls")
            vim.lsp.buf.format({timeout_ms = 5000})

            -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            -- local command_resolver = require('null-ls.helpers.command_resolver')
            -- local async_formatting = function(bufnr)
            --     bufnr = bufnr or vim.api.nvim_get_current_buf()

            --     vim.lsp.buf_request(bufnr, "textDocument/formatting", vim.lsp.util.make_formatting_params({}),
            --         function(err, res, ctx)
            --             if err then
            --                 local err_msg = type(err) == "string" and err or err.message
            --                 -- you can modify the log message / level (or ignore it completely)
            --                 vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
            --                 return
            --             end

            --             -- don't apply results if buffer is unloaded or has been modified
            --             if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
            --                 return
            --             end

            --             if res then
            --                 local client = vim.lsp.get_client_by_id(ctx.client_id)
            --                 vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
            --                 vim.api.nvim_buf_call(bufnr, function()
            --                     vim.cmd("silent noautocmd update")
            --                 end)
            --             end
            --         end)
            -- end

            null_ls.setup({
                sources = { --
                    -- 本当はLintの表示も null_ls でやりたいけど、stylelint がなぜか動かないのでやめる
                    -- diagnostics
                    -- null_ls.builtins.diagnostics.eslint.with({
                    --     diagnostics_format = '[eslint] #{m}\n(#{c})'
                    -- }), --
                    -- null_ls.builtins.diagnostics.stylelint.with({
                    --     diagnostics_format = '[stylelint] #{m}\n(#{c})'
                    -- }), --
                    -- format
                    -- null_ls.builtins.formatting.eslint.with({}), --
                    null_ls.builtins.formatting.eslint_d.with({}), --
                    null_ls.builtins.formatting.stylelint.with({}), --
                    -- null_ls.builtins.formatting.prettier.with({}), --
                    null_ls.builtins.formatting.prettierd.with({}), --
                    null_ls.builtins.formatting.lua_format --
                    --
                    --
                },
                debug = false
                -- on_attach = function(client, bufnr)
                --     if client.supports_method("textDocument/formatting") then
                --         vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
                --         vim.api.nvim_create_autocmd("BufWritePost", {
                --             group = augroup,
                --             buffer = bufnr,
                --             callback = function() async_formatting(bufnr) end
                --         })
                --     end
                -- end
            })
        end
    }
    use {
        "glepnir/lspsaga.nvim",
        branch = "main",
        event = {"BufRead"},
        -- commit = "be029ea63f45fb74680158abe994a344481c7d25",
        config = function()
            -- require("lspsaga").setup()
            require("lspsaga").setup {
                debug = false,
                use_saga_diagnostic_sign = true,
                -- diagnostic sign
                error_sign = "",
                warn_sign = "",
                hint_sign = "",
                infor_sign = "",
                diagnostic_header_icon = "   ",
                -- code action title icon
                code_action_icon = "🔧",
                code_action_prompt = {
                    enable = true,
                    sign = true,
                    sign_priority = 40,
                    virtual_text = true
                },
                finder_definition_icon = "  ",
                finder_reference_icon = "  ",
                max_preview_lines = 10,
                finder_action_keys = {
                    open = "o",
                    vsplit = "s",
                    split = "i",
                    quit = "q",
                    scroll_down = "<C-f>",
                    scroll_up = "<C-b>"
                },
                code_action_keys = {quit = "q", exec = "<CR>"},
                rename_action_keys = {quit = "<C-c>", exec = "<CR>"},
                definition_preview_icon = "  ",
                border_style = "single",
                rename_prompt_prefix = "➤",
                rename_output_qflist = {
                    enable = false,
                    auto_open_qflist = false
                },
                server_filetype_map = {},
                diagnostic_prefix_format = "%d. ",
                diagnostic_message_format = "%m %c",
                highlight_prefix = false
            }
            vim.fn.sign_define("DiagnosticSignWarn",
                               {text = "", texthl = "DiagnosticSignWarn"})
            vim.fn.sign_define("DiagnosticSignError",
                               {text = "", texthl = "DiagnosticSignError"})
            vim.fn.sign_define("DiagnosticSignInfo",
                               {text = "", texthl = "DiagnosticSignInfo"})
            vim.fn.sign_define("DiagnosticSignHint",
                               {text = "🔧", texthl = "DiagnosticSignHint"})
        end,
        requires = {
            {"nvim-tree/nvim-web-devicons"}, -- Please make sure you install markdown and markdown_inline parser
            {"nvim-treesitter/nvim-treesitter"}
        }
    }

    -- node package info
    use {
        'vuki656/package-info.nvim',
        module = 'package-info',
        setup = function()
            vim.keymap.set("n", "<leader>ns",
                           function() require('package-info').show() end,
                           {noremap = true, desc = "Show node package info"})
            vim.keymap.set("n", "<leader>nh",
                           function() require('package-info').hide() end,
                           {noremap = true, desc = "Hide node package info"})
            vim.keymap.set("n", "<leader>nt",
                           function()
                require('package-info').toggle()
            end, {noremap = true, desc = "Toggle node package info"})
            vim.keymap.set("n", "<leader>nd",
                           function()
                require('package-info').delete()
            end, {noremap = true, desc = "Delete node package"})
            vim.keymap.set("n", "<leader>ni",
                           function()
                require('package-info').install()
            end, {noremap = true, desc = "Install node package"})
            vim.keymap.set("n", "<leader>np", function()
                require('package-info').change_version()
            end, {noremap = true, desc = "Change node package version"})
        end,
        config = function()
            require('package-info').setup({
                colors = {
                    up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
                    outdated = "#d19a66" -- Text color for outdated dependency virtual text
                },
                icons = {
                    enable = true, -- Whether to display icons
                    style = {
                        up_to_date = "|  ", -- Icon for up to date dependencies
                        outdated = "|  " -- Icon for outdated dependencies
                    }
                },
                autostart = true, -- Whether to autostart when `package.json` is opened
                hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
                hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
                -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
                -- The plugin will try to auto-detect the package manager based on
                -- `yarn.lock` or `package-lock.json`. If none are found it will use the
                -- provided one, if nothing is provided it will use `yarn`
                package_manager = 'npm'
            })
        end,
        requires = {'MunifTanjim/nui.nvim'}
    }

    -- syntax highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            local ts = require("nvim-treesitter.configs")

            ts.setup {
                highlight = {enable = true, disable = {}},
                indent = {enable = true, disable = {}},
                ensure_installed = {
                    "tsx", "toml", "fish", "json", "yaml", "css", "scss",
                    "html", "lua", "svelte", "elm"
                },
                auto_install = true,
                rainbow = {enable = true, extended_mode = true},
                autotag = {enable = true}
            }

            local parser_config =
                require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.tsx.filetype_to_parsername = {
                "javascript", "typescript.tsx"
            }
        end,
        requires = {"windwp/nvim-ts-autotag", "p00f/nvim-ts-rainbow"}
    }
    -- TODOコメントに色をつける
    use {
        "folke/todo-comments.nvim",
        event = {"FocusLost", "CursorHold"},
        requires = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup() end
    }
    -- カラーコードに色をつける
    use {
        "norcalli/nvim-colorizer.lua",
        config = function() require'colorizer'.setup() end
    }

    -- Snippet
    use {'L3MON4D3/LuaSnip', module = {'luasnip'}}

    -- 補完
    use {
        "hrsh7th/nvim-cmp",
        module = {"cmp"},
        -- 何が必要がわかってない（有効にしてないのがいっぱいある）
        requires = {
            {'hrsh7th/cmp-buffer', event = {'InsertEnter'}},
            {'hrsh7th/cmp-nvim-lsp'}, -- , event = {'InsertEnter'}},
            {'quangnguyen30192/cmp-nvim-ultisnips', event = {'InsertEnter'}},
            {'hrsh7th/cmp-nvim-lua', event = {'InsertEnter'}}, -- {'octaltree/cmp-look', event = {'InsertEnter'}},
            {'hrsh7th/cmp-path', event = {'InsertEnter'}}, -- {'hrsh7th/cmp-calc', event = {'InsertEnter'}},
            -- {'f3fora/cmp-spell', event = {'InsertEnter'}},
            {'hrsh7th/cmp-emoji', event = {'InsertEnter'}},
            {'saadparwaiz1/cmp_luasnip', event = {'InsertEnter'}}, --
            -- {
            --     'zbirenbaum/copilot-cmp',
            --     event = { 'InsertEnter' },
            --     config = function()
            --         require("copilot_cmp").setup()
            --     end
            -- },
            {'onsails/lspkind.nvim'}
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require('lspkind')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                sources = {
                    {name = "nvim_lsp"}, --
                    {name = "buffer"}, --
                    {name = "path"}, --
                    -- {
                    --     name = 'spell',
                    --     option = {
                    --         keep_all_entries = false,
                    --         enable_in_context = function()
                    --             return true
                    --         end
                    --     }
                    --  },
                    {name = 'emoji'}, --
                    -- {name = 'look'}, --
                    {name = 'nvim_lua'}, --
                    {name = 'luasnip'}, --
                    {name = 'ultisnips'} --
                    -- {name = 'calc'}
                    -- { name = "copilot",  group_index = 2 }
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm {select = true}
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function(entry, vim_item)
                            return vim_item
                        end
                    })
                },
                experimental = {ghost_text = true}
            })
        end
    }

    -- git
    use {
        'kdheepak/lazygit.nvim',
        config = function()
            -- LazyGit 召喚
            vim.keymap.set('n', '<leader>G', '<Cmd>LazyGit<CR>')
        end
    }
    use {
        'lewis6991/gitsigns.nvim', -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
        event = {"FocusLost", "CursorHold"},
        config = function()
            require('gitsigns').setup({
                current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 300,
                    ignore_whitespace = false
                }
            })
        end
    }
    use {
        'akinsho/git-conflict.nvim',
        tag = "*",
        config = function() require('git-conflict').setup() end
    }
    use {'dinhhuy258/git.nvim', config = function() require('git').setup() end}

    -- copilot
    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = {"InsertEnter"},
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true, -- false,
                    debounce = 75,
                    keymap = {
                        accept = "<M-;>",
                        accept_word = "<M-l>",
                        accept_line = "<M-j>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>"
                    }
                }
            })
            -- for comp
            -- require("copilot").setup({
            --     suggestion = {enabled = false},
            --     panel = {enabled = false}
            -- })
        end
    }

    -- Test
    use {
        "nvim-neotest/neotest",
        module = {"neotest"},
        setup = function()
            -- test nearest
            vim.keymap.set('n', '<leader>tt',
                           function() require("neotest").run.run() end,
                           {desc = "Run test"})
            -- vim.keymap.set('n', '<leader>tT', function()
            --     require("neotest").run.run({strategy = "dap"})
            -- end, {desc = "Run test with DAP"})
            -- test file
            vim.keymap.set('n', '<leader>tf', function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, {desc = "Run test file"})
            -- vim.keymap.set('n', '<leader>tF', function()
            --     require("neotest").run
            --         .run(vim.fn.expand("%"), {strategy = "dap"})

            vim.keymap.set('n', '<leader>tl',
                           function()
                require("neotest").run.run_last()
            end, {desc = "Run last test"})
            -- vim.keymap.set('n', '<leader>tL', function()
            --     require("neotest").run.run_last({strategy = "dap"})
            -- end, {desc = "Run last test with DAP"})
            -- other
            vim.keymap.set('n', '<leader>ts',
                           function()
                require("neotest").summary.toggle()
            end, {desc = "Toggle test summary"})
            vim.keymap.set('n', '<leader>to', function()
                require("neotest").output_panel.toggle()
            end, {desc = "Toggle test output"})
        end,
        config = function()
            require("neotest").setup({
                --     summary = {
                --         animated = true,
                --         enabled = true,
                --         expand_errors = true,
                --         follow = true,
                --         mappings = {
                --             attach = "a",
                --             clear_marked = "M",
                --             clear_target = "T",
                --             debug = "d",
                --             debug_marked = "D",
                --             expand = { "<CR>", "<2-LeftMouse>" },
                --             expand_all = "e",
                --             jumpto = "i",
                --             mark = "m",
                --             next_failed = "J",
                --             output = "o",
                --             prev_failed = "K",
                --             run = "r",
                --             run_marked = "R",
                --             short = "O",
                --             stop = "u",
                --             target = "t"
                --         },
                --         open = "botright vsplit | vertical resize 50",
                -- },

                adapters = { -- require("neotest-python")({
                    --     dap = { justMyCode = false },
                    -- }),
                    -- require("neotest-go"),
                    require("neotest-vitest")({vitestCommand = "npx vitest"}),
                    require("neotest-vim-test")({
                        -- ignore_file_types = { "python", "vim", "lua" },
                    })
                }
            })
        end,
        requires = {
            {"nvim-lua/plenary.nvim"}, {"nvim-treesitter/nvim-treesitter"},
            {"antoinemadec/FixCursorHold.nvim"},
            {"nvim-neotest/neotest-vim-test", requires = {"vim-test/vim-test"}},
            {"nvim-neotest/neotest-go"}, {"marilari88/neotest-vitest"}
        }
    }

    -- Debug
    -- vimspector
    -- use {
    --     'puremourning/vimspector',
    --     config = function()
    --         vim.keymap.set('n', '<F9>', '<Plug>VimspectorToggleBreakpoint',
    --                        {desc = "Toggle breakpoint"})
    --         vim.keymap.set('n', '<F5>', '<Plug>VimspectorContinue',
    --                        {desc = "Continue"})
    --         vim.keymap.set('n', '<F10>', '<Plug>VimspectorStepOver',
    --                        {desc = "Step over"})
    --         vim.keymap.set('n', '<F11>', '<Plug>VimspectorStepInto',
    --                        {desc = "Step into"})
    --         vim.keymap.set('n', '<F12>', '<Plug>VimspectorStepOut',
    --                        {desc = "Step out"})
    --         vim.keymap.set('n', '<leader><F9>',
    --                        '<Plug>VimspectorToggleConditionalBreakpoint',
    --                        {desc = "Toggle conditional breakpoint"})
    --         vim.keymap.set('n', '<leader><F5>', '<Plug>VimspectorRestart',
    --                        {desc = "Restart"})
    --     end
    -- }
    -- DAP
    -- use {
    --     "rcarriga/nvim-dap-ui",
    --     -- event = { "CursorHold" },
    --     module = {"dapui", "dap"},
    --     setup = function()
    --         vim.keymap.set('n', '<leader>db',
    --                        function()
    --             require("dap").toggle_breakpoint()
    --         end, {desc = "Toggle breakpoint"})
    --         vim.keymap.set('n', '<leader>dc',
    --                        function() require("dap").continue() end,
    --                        {desc = "Continue"})
    --         vim.keymap.set('n', '<leader>di',
    --                        function() require("dap").step_into() end,
    --                        {desc = "Step into"})
    --         vim.keymap.set('n', '<leader>do',
    --                        function() require("dap").step_over() end,
    --                        {desc = "Step over"})
    --         vim.keymap.set('n', '<leader>du',
    --                        function() require("dap").step_out() end,
    --                        {desc = "Step out"})
    --         vim.keymap.set('n', '<leader>dr',
    --                        function() require("dap").repl.open() end,
    --                        {desc = "Open repl"})
    --
    --         vim.keymap.set('n', '<leader>du',
    --                        function() require("dapui").toggle() end,
    --                        {desc = "Toggle dap ui"})
    --     end,
    --     config = function()
    --         require("dap-vscode-js").setup({
    --             -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    --             -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    --             -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    --             adapters = {
    --                 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal',
    --                 'pwa-extensionHost'
    --             } -- which adapters to register in nvim-dap
    --             -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    --             -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    --             -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    --         })
    --         require("dapui").setup()
    --     end,
    --     requires = {
    --         {"mfussenegger/nvim-dap"}, {
    --             "microsoft/vscode-js-debug",
    --             -- opt = true,
    --             run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    --         }
    --     }
end)
