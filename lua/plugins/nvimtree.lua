return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true


    -- OR setup with some options
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      actions = {

          open_file = {
            quit_on_open = true
          }
      }
    })
  end,
  keys = function()
      local api = require("nvim-tree.api")
      local toggle_nvim_tree = function()
        api.tree.toggle({ find_file = true, focus = true })
      end
      return {
        { "<leader>nt", toggle_nvim_tree, silent = true, desc = "Toggle nvim tree" },
      }

  end

}
