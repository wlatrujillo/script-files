return {
    {
        "tpope/vim-surround"
    },
    {
        "tpope/vim-commentary"
    },
    {
      "tpope/vim-fugitive",
      keys = {
        { "<leader>ga", ":Git fetch --all -p<cr>", desc = "Git fetch" },
        { "<leader>gl", ":Git pull<cr>", desc = "Git pull" },
        { "<leader>gdh", ":diffget //2<cr>", desc = "Git diff grab from left" },
        { "<leader>gdl", ":diffget //3<cr>", desc = "Git diff grab from right" },
      },
      cmd = { "G", "Git" },
    },
    {
        "mg979/vim-visual-multi",
        branch = "master"
    },
    {
        "vim-airline/vim-airline"
    },
    {
        "easymotion/vim-easymotion",
        keys = {
            { "<leader><leader>s","<Plug>(easymotion-s2)", desc = "Easymotion activate with 2 characters" }
        }
    },
    {
         "lewis6991/gitsigns.nvim",
         event = "VeryLazy",
         opts = {
             signcolumn = false,
             numhl = true,
             trouble = false,
             on_attach = function(bufnr)
                  local gitsigns = require "gitsigns"
                  vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hj", gitsigns.next_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hk", gitsigns.prev_hunk, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line{full=true} end, {buffer = bufnr})
                  vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, {buffer = bufnr})
             end,
             max_file_length = 10000,
         }
    }
}
