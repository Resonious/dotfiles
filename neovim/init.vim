call plug#begin(stdpath('data') . '/plugged')
Plug 'Resonious/vim-phoenix'
Plug 'Resonious/nvim-schemer'
Plug 'preservim/nerdtree'
Plug 'PProvost/vim-ps1'
Plug 'rust-lang/rust.vim'
Plug 'digitaltoad/vim-pug'
Plug 'machakann/vim-highlightedyank'
Plug 'ekalinin/Dockerfile.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf.vim'
Plug 'posva/vim-vue'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'tikhomirov/vim-glsl'
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-rails'
Plug 'chr4/nginx.vim'
Plug 'mattn/emmet-vim'
Plug 'jaredgorski/fogbell.vim'
Plug 'eikesr/vim-flatdata'
Plug 'tpope/vim-surround'
Plug 'github/copilot.vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ziglang/zig.vim'
"Plug '~/Sources/whitebox_v0.91.0/editor_plugins/whitebox-vim'
"Plug 'vim-airline/vim-airline'
"Plug 'neomake/neomake', {'branch': 'main'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set termguicolors
syntax on
filetype plugin indent on

" Tabs are 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2

" Except in Rust and C files where they are 4 spaces!
autocmd FileType rs setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType pug setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4

" gdscript uses 4-space tabs
autocmd FileType gd setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

autocmd VimEnter * Schemer

lua require('colorizer').setup()
lua require('lualine').setup()

set background=dark
" let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1

let g:user_emmet_leader_key='<C-Z>'

" this just sucks
let g:zig_fmt_autosave = 0

" tnoremap <Esc> <C-\><C-n> " Esc to exit terminal mode
" nnoremap <A-r> i<Up><CR><C-\><C-n> " Alt+r to rerun last terminal command

" Tab for autocomplete
" :inoremap <Tab> <C-N>

:noremap <C-S> :w<cr>
:noremap <C-C> "+y
:noremap <C-V> "+p

" Idiotproofing
:command W w
:command Q q
:command Qa qa
:command Wqa wqa
" Typing NERDTree is kind of annoying
:command NT NERDTree
" Because folks don't seem to care about trailing whitespace
:command Trailing %s/\s\+$//g

:command Rubocop !rubocop -A %
:command CopyFile !echo % | wl-copy

:noremap <C-T> :NERDTree<cr>:tabnew<cr>:term<cr>:tabprevious<cr>

" Latex stuff
let g:tex_flavor = 'latex'

" FZF!
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
set rtp+=~/.fzf
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -g !*.svg -g !/vendor -g !/node_modules -g !*.lock -g !/db -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
noremap <silent> <C-P> :FZF<CR>
noremap <silent> <C-L> :Rg<CR>

" Use ripgrep for vim
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading\ -g\ !*.svg\ -g\ !/spec/cassettes\ -g\ !/vendor
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Multiple cursors settings
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-j>'
let g:multi_cursor_select_all_word_key = '<A-j>'
let g:multi_cursor_start_key           = 'g<C-j>'
let g:multi_cursor_select_all_key      = 'g<A-j>'
let g:multi_cursor_next_key            = '<C-j>'
let g:multi_cursor_prev_key            = '<C-k>'
let g:multi_cursor_skip_key            = '<C-h>'
let g:multi_cursor_quit_key            = '<Esc>'

" ~~No~~ YES search result highlighting
set hlsearch

" Highlight byebugs so I don't leave them around
autocmd BufNewFile,BufRead *.rb syntax match myByebug /\<byebug\>/
autocmd BufNewFile,BufRead *.rb highlight myByebug ctermbg=red ctermfg=yellow guifg=#FF0000 guibg=#FFFF00
autocmd BufNewFile,BufRead *.rb syntax match myPry /\<binding\.pry\>/
autocmd BufNewFile,BufRead *.rb highlight myPry ctermbg=red ctermfg=yellow guifg=#FF0000 guibg=#FFFF00

" Easy terminal mode escape
tnoremap <C-p> <C-\><C-n>

:noremap <C-T> :NERDTree<cr>:tabnew<cr>:term<cr>:vsp<cr>:term<cr>:tabprevious<cr>

" Way to close all unused buffers
function! CloseUnusedBuffers()
  let used_buffers = []
  for i in range(tabpagenr('$'))
    call extend(used_buffers, tabpagebuflist(i+1))
  endfor
  call extend(used_buffers, win_findbuf(win_getid()))
  for i in range(1, bufnr('$'))
    if index(used_buffers, i) == -1
      silent execute 'bwipeout! ' . i
    endif
  endfor
endfunction
:command CloseUnusedBuffers call CloseUnusedBuffers()

""""""""""""""""""""""""" Coc
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-space> coc#refresh()

" Line numbers + re-use the number gutter for error signs.
set number
set signcolumn=number

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
""""""""""""""""""""""""" End Coc

" Update Lua package.path to include the Neovim config directory
lua package.path = vim.fn.stdpath('config') .. "/?.lua;" .. package.path

" Set up autocmd to track the last accessed terminal buffer
autocmd BufEnter * lua require('terminal_helper').track_last_terminal_bufnr()

command! Rspec lua require('terminal_helper').run_command_in_last_terminal('bin/rspec ' .. vim.fn.expand('%') .. ':' .. vim.api.nvim_win_get_cursor(0)[1])
command! RSpec Rspec


" Font for neovide...
let g:neovide_cursor_vfx_mode = "wireframe"
set guifont=Berkeley\ Mono,Fira\ Code,Noto\ Sans\ Mono\ CJK\ JP:h10

" Terminal colors for neovide
let g:terminal_color_1 = "#ed1515"
let g:terminal_color_2 = "#11d116"
let g:terminal_color_3 = "#f67400"
let g:terminal_color_4 = "#1d99f3"
let g:terminal_color_5 = "#9b59b6"
let g:terminal_color_6 = "#1abc9c"
let g:terminal_color_7 = "#fcfcfc"
