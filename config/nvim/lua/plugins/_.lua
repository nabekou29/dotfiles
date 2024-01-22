return {{
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- インデントのハイライト
    'lukas-reineke/indent-blankline.nvim',
    event = {"VeryLazy"},
    main = "ibl",
    config = function()
        require('ibl').setup {}
    end
}, {
    -- https://github.com/kevinhwang91/nvim-hlslens
    -- 検索時に右に n/N を表示してくれる
    'kevinhwang91/nvim-hlslens',
    event = {"VeryLazy"},
    config = function()
        require('hlslens').setup {}
    end
}, -- https://github.com/petertriho/nvim-scrollbar
-- スクロールバー表示
{
    "petertriho/nvim-scrollbar",
    event = {"VeryLazy"},
    config = function()
        require("scrollbar").setup {}
    end

}, -- https://github.com/folke/todo-comments.nvim
-- TODO コメントに色を付ける
{
    "folke/todo-comments.nvim",
    event = {"FocusLost", "BufReadPre"},
    dependencies = {"nvim-lua/plenary.nvim"}
}, -- https://github.com/norcalli/nvim-colorizer.lua
-- カラーコードに色をつける
{
    "norcalli/nvim-colorizer.lua",
    event = {"FocusLost", "CursorHold"},
    config = function()
        local targetFileTypes = {'css', 'javascript', 'typescript', 'html', 'lua'}

        require'colorizer'.setup {'css', 'javascript', 'typescript', 'html', 'lua'}

        -- すでに開いているファイルに対して実行する
        local fileType = vim.bo.filetype
        for _, v in pairs(targetFileTypes) do
            if fileType == v then
                vim.cmd [[ ColorizerAttachToBuffer ]]
                break
            end
        end
    end
}, -- Lazygit
{
    'kdheepak/lazygit.nvim',
    cmd = {"LazyGit"},
    init = function()
        -- LazyGit 召喚
        vim.keymap.set('n', '<leader>G', '<Cmd>LazyGit<CR>')
    end
}, {
    'tyru/open-browser.vim',
    cmd = {"OpenBrowser"}
}}
