vim.cmd [[packadd packer.nvim]]

require'packer'.startup(function()
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

    use {'tkmpypy/chowcho.nvim'}
    -- use {'s1n7ax/nvim-window-picker', tag = 'v1.*'}
    use {"lukas-reineke/indent-blankline.nvim"}
    use {'numToStr/Comment.nvim'}
    use {'kevinhwang91/nvim-hlslens'}
    use {"folke/which-key.nvim"}
    use {"p00f/nvim-ts-rainbow"}
    -- スクロールバー表示
    use {"petertriho/nvim-scrollbar"}

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
    use {"Pocco81/auto-save.nvim"}
    -- エラー表示をわかりやすく
    use {"folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons"}
    -- バッファを閉じた時にウィンドウを閉じないようにしてくれる
    use {'famiu/bufdelete.nvim'}
    -- 範囲選択
    use {'terryma/vim-expand-region'}
    -- f/d で移動できる箇所をマークしてくれる
    use {'unblevable/quick-scope'}
    -- 移動
    use {
        'phaazon/hop.nvim',
        branch = 'v2' -- optional but strongly recommended
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
        end,
        config = function()
            require('telescope').setup {}
            require('telescope').load_extension("frecency")
        end,
        requires = {
            {
                "nvim-telescope/telescope-frecency.nvim",
                requires = {"kkharji/sqlite.lua"}
            }
        }
    }

    -- ステータスバー
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use {'mvllow/modes.nvim', tag = 'v0.2.0'}

    -- バッファーバー
    use {
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons'
    }

    -- LSP
    use {
        "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = {"nvim-lua/plenary.nvim"}
    }
    use {
        "glepnir/lspsaga.nvim",
        -- branch = "main",
        commit = "be029ea63f45fb74680158abe994a344481c7d25",
        requires = {
            {"nvim-tree/nvim-web-devicons"}, -- Please make sure you install markdown and markdown_inline parser
            {"nvim-treesitter/nvim-treesitter"}
        }
    }

    -- syntax highlight
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
    use {"norcalli/nvim-colorizer.lua"}

    -- Snippet
    use {'L3MON4D3/LuaSnip'}

    -- 補完
    use {
        "hrsh7th/nvim-cmp",
        module = {"cmp"},
        -- 何が必要がわかってない（有効にしてないのがいっぱいある）
        requires = {
            {'hrsh7th/cmp-buffer', event = {'InsertEnter'}}, {
                'hrsh7th/cmp-nvim-lsp' -- event = {'InsertEnter'}
            }, {'quangnguyen30192/cmp-nvim-ultisnips', event = {'InsertEnter'}},
            {'hrsh7th/cmp-nvim-lua', event = {'InsertEnter'}},
            {'octaltree/cmp-look', event = {'InsertEnter'}},
            {'hrsh7th/cmp-path', event = {'InsertEnter'}},
            {'hrsh7th/cmp-calc', event = {'InsertEnter'}},
            {'f3fora/cmp-spell', event = {'InsertEnter'}},
            {'hrsh7th/cmp-emoji', event = {'InsertEnter'}},
            {'saadparwaiz1/cmp_luasnip', event = {'InsertEnter'}}
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                sources = {
                    {name = "nvim_lsp"}, {name = "buffer"}, {name = "path"}, {
                        name = 'spell',
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end
                        }
                    }
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm {select = true}
                }),
                experimental = {ghost_text = true}
            })
        end
    }

    -- git
    use {'kdheepak/lazygit.nvim'}
    use {
        'lewis6991/gitsigns.nvim' -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }
    use {'akinsho/git-conflict.nvim', tag = "*"}
    use {'dinhhuy258/git.nvim'}
end)
