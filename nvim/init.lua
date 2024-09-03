-- General settings
vim.opt.number = true                   -- Show line numbers
vim.opt.relativenumber = true           -- Show relative line numbers
vim.opt.wrap = false                    -- Disable line wrapping
vim.opt.mouse = 'a'                     -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'       -- Use system clipboard
vim.opt.ignorecase = true               -- Case insensitive searching
vim.opt.smartcase = true                -- Smart case searching
vim.opt.swapfile = false                -- Disable swap files
vim.opt.backup = false                  -- Disable backups
vim.opt.undofile = true                 -- Enable persistent undo
vim.o.guifont = "Berkeley Mono:h12"
vim.g.transparent_enabled = true

vim.cmd('set expandtab')
vim.cmd('set shiftwidth=2')
vim.cmd('set softtabstop=2')

vim.g.neovide_transparency = 0.8
vim.g.transparency = 0.88
vim.g.neovide_background_color = ("#000000" .. string.format("%x", math.floor(((255 * vim.g.transparency) or 0.8))))

-- Enable syntax highlighting and colorscheme
vim.cmd('syntax on')
vim.cmd('colorscheme desert')           -- You can change this to your preferred colorscheme


-- Helix-like keys...
vim.api.nvim_set_keymap('n', 'm', 'v', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '<S-v>', { noremap = true })
vim.api.nvim_set_keymap('v', 'x', 'j', { noremap = true })
vim.api.nvim_set_keymap('n', 'mm', '%', { noremap = true })
vim.api.nvim_set_keymap('v', 'mm', '%', { noremap = true })
vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })

vim.api.nvim_set_keymap('v', 'R', 'p', { noremap = true })

vim.api.nvim_set_keymap('n', 'gh', '0', { noremap = true })
vim.api.nvim_set_keymap('n', 'gl', '$', { noremap = true })
vim.api.nvim_set_keymap('n', 'ge', 'G', { noremap = true })
vim.api.nvim_set_keymap('v', 'gh', '0', { noremap = true })
vim.api.nvim_set_keymap('v', 'gl', '$h', { noremap = true })
vim.api.nvim_set_keymap('v', 'ge', 'G', { noremap = true })

-- Leader key bindings (optional, you can set this to your preference)
vim.g.mapleader = " "                                                  -- Space as leader key
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })-- Save with leader + w
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true })-- Quit with leader + q
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', { noremap = true })

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.api.nvim_set_keymap("n", "<Leader>k", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', { noremap = true })

-- Language Server Protocol (LSP) similar to Helix's built-in LSP support
--require'lspconfig'.pyright.setup{}  -- Python LSP example
--require'lspconfig'.tsserver.setup{} -- TypeScript/JavaScript LSP example
--require'lspconfig'.solargraph.setup{
--	cmd = { '/home/nigel/.local/share/mise/installs/ruby/3.3.1/bin/solargraph' },
--	init_options = {
--		formatting = false
--	}
--}
--vim.lsp.set_log_level('debug')

-- doing coc instead
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
vim.api.nvim_set_keymap("n", "[d", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.api.nvim_set_keymap("n", "]d", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", {silent = true})

-- code actions
vim.api.nvim_set_keymap("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>as", "<Plug>(coc-codeaction-source)", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>qf", "<Plug>(coc-fix-current)", {silent = true})


-- Treesitter for better syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
      },
    },
  },
}

-- Commenting like Helix
vim.api.nvim_set_keymap('n', '<C-c>', ':Commentary<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-c>', ':Commentary<CR>', { noremap = true })

-- Statusline
vim.opt.laststatus = 2
vim.opt.statusline = "%f %y %m %r %= %l,%c %p%%"

-- Minimal setup to replicate Helix's feel
vim.opt.termguicolors = true
vim.cmd('set completeopt=menu,menuone,noselect')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

-- fix panes on resize
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- surround...
require("nvim-surround").setup({
  keymaps = {
    normal = "ms",
    visual = "ms",
    delete = "md",
    change = "mr",
  }
})

-- git
require('gitsigns').setup({
  on_attach = function(buffer)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = buffer
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    map('n', '<leader>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ig', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

require('autoclose').setup()

require('schemer')
SchemerGenerate()
 -- Optional, you don't have to run setup.
--require("transparent").clear()
--require("transparent").toggle(true)
