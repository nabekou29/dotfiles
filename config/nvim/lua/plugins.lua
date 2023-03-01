vim.cmd [[packadd packer.nvim]]

require'packer'.startup(function()
    -- color scheme
    use "EdenEast/nightfox.nvim"
    -- use "jacoborus/tender.vim"
    -- use 'tiagovla/tokyodark.nvim'
    -- use 'folke/tokyonight.nvim'
    -- use({
    --     'projekt0n/github-nvim-theme',
    --     tag = 'v0.0.7'
    -- })

    use {'wbthomason/packer.nvim', opt = true}
    use 'mhinz/vim-startify'

    use {'tkmpypy/chowcho.nvim'}
    use {'s1n7ax/nvim-window-picker', tag = 'v1.*'}
    use "lukas-reineke/indent-blankline.nvim"
    use 'numToStr/Comment.nvim'
    use {'kevinhwang91/nvim-hlslens'}
    use {"folke/which-key.nvim"}
    use {"p00f/nvim-ts-rainbow"}
    use("petertriho/nvim-scrollbar")
    use({
        "folke/noice.nvim",
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim", -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify"
        }
    })
    use({"Pocco81/auto-save.nvim"})
    use {"folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons"}
    use 'famiu/bufdelete.nvim'
    use 'terryma/vim-expand-region'
    use 'unblevable/quick-scope'
    use {
        'phaazon/hop.nvim',
        branch = 'v2' -- optional but strongly recommended
    }

    -- ファイラー
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim"
        }
    }
    -- ファジーファインダー
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use {
        "nvim-telescope/telescope-frecency.nvim",
        requires = {"kkharji/sqlite.lua"}
    }
    use {
        "nvim-telescope/telescope-media-files.nvim",
        requires = {"nvim-lua/popup.nvim"}
    }

    -- ステータスバー
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use({'mvllow/modes.nvim', tag = 'v0.2.0'})

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
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {"nvim-lua/plenary.nvim"}
    })
    use({
        "glepnir/lspsaga.nvim",
        -- branch = "main",
        commit = "be029ea63f45fb74680158abe994a344481c7d25",
        requires = {
            {"nvim-tree/nvim-web-devicons"}, -- Please make sure you install markdown and markdown_inline parser
            {"nvim-treesitter/nvim-treesitter"}
        }
    })

    -- syntax highlight
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
    use "norcalli/nvim-colorizer.lua"

    -- Snippet
    use 'L3MON4D3/LuaSnip'

    -- 補完
    use {
        "hrsh7th/nvim-cmp",
        -- 何が必要がわかってない（有効にしてないのがいっぱいある）
        requires = {
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
            'quangnguyen30192/cmp-nvim-ultisnips', 'hrsh7th/cmp-nvim-lua',
            'octaltree/cmp-look', 'hrsh7th/cmp-path', 'hrsh7th/cmp-calc',
            'f3fora/cmp-spell', 'hrsh7th/cmp-emoji', 'saadparwaiz1/cmp_luasnip'
        }
    }

    -- git
    use 'kdheepak/lazygit.nvim'
    use {
        'lewis6991/gitsigns.nvim' -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }
    use {'akinsho/git-conflict.nvim', tag = "*"}
    use {'dinhhuy258/git.nvim'}
end)
