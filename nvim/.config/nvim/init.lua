-- ============================================================================
--                          NEOVIM CONFIGURATION
--                        Minimal, sensible defaults
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Options
-- ----------------------------------------------------------------------------
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"  -- Use system clipboard
opt.undofile = true            -- Persistent undo

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Disable netrw (if using a file explorer plugin later)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- ----------------------------------------------------------------------------
-- Keymaps
-- ----------------------------------------------------------------------------
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better escape
keymap("i", "jk", "<Esc>", opts)

-- Clear search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Stay in visual mode when indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Quick save
keymap("n", "<leader>w", ":w<CR>", opts)

-- Quick quit
keymap("n", "<leader>q", ":q<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- ----------------------------------------------------------------------------
-- Autocommands
-- ----------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
    group = "TrimWhitespace",
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Return to last edit position
autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
