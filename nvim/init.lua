-- ========== Core Options ==========
local o = vim.opt
o.termguicolors = true
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true
o.cursorline = true
o.scrolloff = 8
o.signcolumn = "yes"
o.showcmd = true
o.hidden = true
o.undofile = true
o.foldenable = true
o.foldlevelstart = 99
o.foldmethod = "manual"
o.updatetime = 250
o.timeoutlen = 400
o.splitright = true
o.splitbelow = true
o.wrap = false
o.conceallevel = 0
vim.cmd("set synmaxcol=1000")

-- ========== Keymaps ==========
vim.g.mapleader = " "
local map = vim.keymap.set
map("n", "<SPACE>", "<cmd>nohlsearch<cr>")
map({ "n", "i" }, "<C-s>", function() vim.cmd.write() end)
map("n", "<C-q>", "<cmd>q<cr>")
map("n", "<C-a>", "ggVG")
map("n", "<leader>e", "<cmd>Ex<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- ========== Bootstrap lazy.nvim ==========
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Theme
    { "folke/tokyonight.nvim",           lazy = false,       priority = 1000, opts = { style = "night" } },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP + Installer + Formatters
    "neovim/nvim-lspconfig",
    { "williamboman/mason.nvim",             opts = {} }, -- FIXED: removed build hook
    "williamboman/mason-lspconfig.nvim",
    { "stevearc/conform.nvim",               opts = {} },

    -- UI/UX
    { "nvim-lualine/lualine.nvim",           dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "lewis6991/gitsigns.nvim" },
    { "folke/which-key.nvim",                opts = {} },
    { "numToStr/Comment.nvim",               opts = {} },
    { "windwp/nvim-autopairs",               opts = {} },
    { "kylechui/nvim-surround",              version = "*",                                   opts = {} },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",                                    opts = {} },

    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim",       branch = "0.1.x",                                dependencies = { "nvim-lua/plenary.nvim" } },
})

-- ========== Colorscheme ==========
vim.cmd.colorscheme("tokyonight")

-- ========== Treesitter Setup ==========
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua", "vim", "vimdoc",
        "javascript", "typescript", "tsx", "json",
        "html", "css", "markdown", "markdown_inline"
    },
    highlight = { enable = true },
    indent = { enable = true },
})

-- ========== Mason (LSP/DAP/Tools) ==========
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",
        "lua_ls",
        "jsonls",
        "html",
        "cssls",
    }
})

-- ========== LSP Setup ==========
local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = function(_, bufnr)
    local bufmap = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end
    bufmap("n", "gd", vim.lsp.buf.definition)
    bufmap("n", "gr", vim.lsp.buf.references)
    bufmap("n", "K", vim.lsp.buf.hover)
    bufmap("n", "<leader>rn", vim.lsp.buf.rename)
    bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
    bufmap("n", "<leader>f", function() require("conform").format({ async = true }) end)
end

lspconfig.tsserver.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
        },
    },
})
lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

-- ========== Formatting ==========
require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
    },
    format_on_save = {
        timeout_ms = 1500,
        lsp_fallback = true,
    },
})

-- ========== Telescope ==========
require("telescope").setup({
    defaults = {
        mappings = {
            i = { ["<C-u>"] = false, ["<C-d>"] = false },
        },
    },
})

-- ========== Gitsigns ==========
require("gitsigns").setup()

-- ========== Lualine ==========
require("lualine").setup({
    options = { theme = "tokyonight", globalstatus = true },
})

-- ========== Filetype tweaks ==========
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.mjs", "*.cjs" },
    callback = function() vim.bo.filetype = "javascript" end,
})
