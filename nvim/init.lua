-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
        'nvim-treesitter/nvim-treesitter',
	  lazy = false,
	  branch = 'main',
	  build = ':TSUpdate'
    },
    {
	    'neovim/nvim-lspconfig',
    },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "nvim-mini/mini.icons" },
      opts = {}
    },

    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },

    {
      "lewis6991/gitsigns.nvim",
    },
    {
      "kylechui/nvim-surround",
    },
    {
      "uloco/bluloco.nvim",
    },
    {
      "rktjmp/lush.nvim",
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "bluloco" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("bluloco").setup({
  style = "auto",               -- "auto" | "dark" | "light"
  transparent = true,
  italics = false,
  terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
  guicursor = true,
  rainbow_headings = false,     -- if you want different colored headings for each heading level
})
vim.cmd('colorscheme bluloco')

require'nvim-treesitter'.install { 'ruby', 'rust', 'javascript', 'typescript', 'zig', 'swift', 'bash', 'lua', 'c', 'c++', 'vim', 'markdown' }

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
vim.opt.termguicolors = true
vim.o.guifont = "Berkeley Mono:h12"
vim.g.transparent_enabled = true

vim.cmd('set autoindent')
vim.cmd('set smartindent')
vim.cmd('set expandtab')
vim.cmd('set shiftwidth=2')
vim.cmd('set softtabstop=2')

vim.g.neovide_opacity = 0.95
vim.g.transparency = 0.88
vim.g.neovide_background_color = "#FFFFFF"

-- My cool commands
vim.api.nvim_create_user_command('File', function()
  local filename = vim.fn.expand('%:p')  -- Get absolute path of current file
  local lineno = vim.fn.line('.')  -- Get current line number
  local file_with_lineno = filename .. ':' .. lineno  -- Append line number
  vim.fn.setreg('+', file_with_lineno)  -- Yank to the + register
  print('Yanked file path with line number: ' .. file_with_lineno)
end, {})

vim.api.nvim_create_user_command('Rel', function()
  local relpath = vim.fn.expand('%')  -- Get relative path of current file
  local lineno = vim.fn.line('.')  -- Get current line number
  local rel_with_lineno = relpath .. ':' .. lineno  -- Append line number
  vim.fn.setreg('+', rel_with_lineno)  -- Yank to the + register
  print('Yanked relative file path with line number: ' .. rel_with_lineno)
end, {})

vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gh', '0', { noremap = true })
vim.api.nvim_set_keymap('n', 'gl', '$', { noremap = true })
vim.api.nvim_set_keymap('n', 'ge', 'G', { noremap = true })
vim.api.nvim_set_keymap('v', 'gh', '0', { noremap = true })
vim.api.nvim_set_keymap('v', 'gl', '$h', { noremap = true })
vim.api.nvim_set_keymap('v', 'ge', 'G', { noremap = true })

-- vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })-- Save with leader + w
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true })-- Quit with leader + q

vim.keymap.set('n', '<Leader>w', function()
  vim.cmd.write()

  vim.defer_fn(function()
    vim.diagnostic.setloclist()
    vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr('#')))
  end, 100)
end)

vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', { noremap = true })-- Quit with leader + q

vim.keymap.set({ 'n', 'v' }, '<Leader>f', function() FzfLua.files() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>b', function() FzfLua.buffers() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>/', function() FzfLua.grep() end)

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev()
  vim.diagnostic.open_float()
end)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next()
  vim.diagnostic.open_float()
end)

vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.setqflist()
end)

-- surround...
require("nvim-surround").setup({
  keymaps = {
    normal = "ms",
    visual = "ms",
    delete = "md",
    change = "mr",
  }
})

-- gitsigns...
require('gitsigns').setup({
  on_attach = function(buffer)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = buffer
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    -- vim.print(client.name, client.server_capabilities)

    if not client then
      return
    end

    local bufnr = event_context.buf

    -- Mappings.
    local map = function(mode, l, r, opts)
      opts = opts or {}
      opts.silent = true
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "gr", vim.lsp.buf.references)

    map("n", "gd", function()
      vim.lsp.buf.definition {
        on_list = function(options)
          -- custom logic to avoid showing multiple definition when you use this style of code:
          -- `local M.my_fn_name = function() ... end`.
          -- See also post here: https://www.reddit.com/r/neovim/comments/19cvgtp/any_way_to_remove_redundant_definition_in_lua_file/

          -- vim.print(options.items)
          local unique_defs = {}
          local def_loc_hash = {}

          -- each item in options.items contain the location info for a definition provided by LSP server
          for _, def_location in pairs(options.items) do
            -- use filename and line number to uniquelly indentify a definition,
            -- we do not expect/want multiple definition in single line!
            local hash_key = def_location.filename .. def_location.lnum

            if not def_loc_hash[hash_key] then
              def_loc_hash[hash_key] = true
              table.insert(unique_defs, def_location)
            end
          end

          options.items = unique_defs

          -- set the location list
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.fn.setloclist(0, {}, " ", options)

          -- open the location list when we have more than 1 definitions found,
          -- otherwise, jump directly to the definition
          if #options.items > 1 then
            vim.cmd.lopen()
          else
            vim.cmd([[silent! lfirst]])
          end
        end,
      }
    end, { desc = "go to definition" })
    map("n", "<C-]>", vim.lsp.buf.definition)
    map("n", "<leader>k", function()
      vim.lsp.buf.hover {
        border = "single",
        max_height = 20,
        max_width = 130,
        close_events = { "CursorMoved", "BufLeave", "WinLeave", "LSPDetach" },
      }
    end)
    map("n", "<C-k>", vim.lsp.buf.signature_help)
    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<leader>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "list workspace folder" })

    -- Set some key bindings conditional on server capabilities
    -- Disable ruff hover feature in favor of Pyright
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    -- Uncomment code below to enable inlay hint from language server, some LSP server supports inlay hint,
    -- but disable this feature by default, so you may need to enable inlay hint in the LSP server config.
    -- vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
      local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = gid,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd("CursorMoved", {
        group = gid,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end,
  nested = true,
  desc = "Configure buffer keymap and behavior based on LSP",
})

-- Enable lsp servers when they are available

local get_default_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- required by nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end
local capabilities = get_default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 500,
  },
})

vim.lsp.config('ts_ls', {})
vim.lsp.enable('ts_ls')

-- vim.lsp.enable('clangd')

vim.lsp.config('ruby_lsp', {
  settings = {
    ['ruby-lsp'] = {},
  },
})
vim.lsp.enable('ruby_lsp')

vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})
vim.lsp.enable('rust_analyzer')
