execute pathogen#infect()
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

" gdscript uses 4-space tabs
autocmd FileType gd setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

autocmd VimEnter * Schemer

autocmd! BufWritePost * Neomake

set background=dark
" let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1

tnoremap <Esc> <C-\><C-n> " Esc to exit terminal mode
nnoremap <A-r> i<Up><CR><C-\><C-n> " Alt+r to rerun last terminal command

" Tab for autocomplete
" :inoremap <Tab> <C-N>

:noremap <C-S> :w<cr>

" Idiotproofing
:command W w
:command Q q
:command Qa qa
:command Wqa wqa
" Typing NERDTree is kind of annoying
:command NT NERDTree
" Because folks don't seem to care about trailing whitespace
:command Trailing %s/\s\+$//g

" Latex stuff
let g:tex_flavor = 'latex'

" FZF!
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
noremap <silent> <C-P> :FZF<CR>

" Use ripgrep for vim
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
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

" No search result highlighting
set nohlsearch

" Highlight byebugs so I don't leave them around
autocmd BufNewFile,BufRead *.rb syntax match myByebug /\<byebug\>/
autocmd BufNewFile,BufRead *.rb highlight myByebug ctermbg=red ctermfg=yellow guifg=#FF0000 guibg=#FFFF00
autocmd BufNewFile,BufRead *.rb syntax match myPry /\<binding\.pry\>/
autocmd BufNewFile,BufRead *.rb highlight myPry ctermbg=red ctermfg=yellow guifg=#FF0000 guibg=#FFFF00

" Neoterm stuff:
nnoremap <C-l> :TREPLSendLine<cr>
vnoremap <C-l> :TREPLSendSelection<cr>

let g:neomake_cpp_enabled_makers = ['gcc']
let g:neomake_cpp_clang_maker = {
   \ 'exe': 'g++++',
   \ 'args': ['-Wall', '-Wextra', '-Weverything', '-pedantic', '-Wno-sign-conversion'],
   \ }
