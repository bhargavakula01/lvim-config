-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.treesitter.ensure_installed = {
  "rust",
  "python",
}

-- Example Treesitter configuration for Rust
lvim.builtin.treesitter.highlight.enable = true

-- Ensure vim-illuminate is configured
lvim.plugins = {
  { "RRethy/vim-illuminate" },
  { "tpope/vim-surround" },
  { "mfussenegger/nvim-dap-python" },
  { "nvim-neotest/neotest" },
  { "nvim-neotest/neotest-python" },
  { 'nvim-neotest/nvim-nio' },
  { "AckslD/swenv.nvim" },
  { "stevearc/dressing.nvim" },
}

-- Example configuration for vim-illuminate
vim.g.Illuminate_delay = 100
vim.g.Illuminate_highlightUnderCursor = 0

lvim.keys.term_mode["<Esc>"] = "<C-\\><C-n>"

vim.api.nvim_set_keymap('n', 'b', 'N', { noremap = true, silent = true })

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)



-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" } 
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }

local opts = { noremap = true, silent = true }

-- Map F4 to toggle the DAP UI
vim.api.nvim_set_keymap("n", "<F4>", "<Cmd>lua require'dapui'.toggle()<CR>", opts)

-- binding for switching
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}
