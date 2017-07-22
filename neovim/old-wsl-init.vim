execute pathogen#infect()
set termguicolors

syntax on
filetype plugin indent on

" Tabs are 2 spaces by default
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Except in Rust and C files where they are 4 spaces!
autocmd FileType rs setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Neomake on write
autocmd BufWritePost * Neomake!

" Use g++-5 or clang-check-3.9 with neomake
let g:neomake_cpp_gpp5_maker = {
        \ 'exe': 'g++-5',
        \ 'args': ['-std=c++14', '-fsyntax-only', '-Wall', '-Werror', '-pedantic'],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
            \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
            \ '%-GIn file included%.%#,' .
            \ '%-G %#from %f:%l\,,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,' .
            \ '%f:%l: %trror: %m,' .
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m',
        \ }
let g:neomake_cpp_clang39_maker = {
    \ 'exe': 'clang-check-3.9',
    \ 'args': ['%:p'],
    \ 'errorformat':
        \ '%-G%f:%s:,' .
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m,' .
        \ '%I%f:%l:%c: note: %m,' .
        \ '%f:%l:%c: %m,'.
        \ '%f:%l: %trror: %m,'.
        \ '%f:%l: %tarning: %m,'.
        \ '%I%f:%l: note: %m,'.
        \ '%f:%l: %m',
    \ }
let g:neomake_cpp_enabled_makers = ['gpp5']

colorscheme phoenix

set background=dark
let g:airline_theme='simple'
let g:airline_powerline_fonts = 1

if getcwd() =~ 'eecs370'
  autocmd VimEnter * PhoenixOrange
elseif getcwd() =~ 'eecs281'
  autocmd VimEnter * PhoenixPurple
elseif getcwd() =~ 'eecs280'
  autocmd VimEnter * PhoenixGray
endif

tnoremap <Esc> <C-\><C-n> " Esc to exit terminal mode
nnoremap <A-r> i<Up><CR><C-\><C-n> " Alt+r to rerun last terminal command

" Tab for autocomplete
" inoremap <Tab> <C-N>

" Ctrl+S for save
noremap <silent> <C-S> :w<CR>

" Idiot(me)proofing
:command W w
:command Q q
:command Qa qa
:command Wqa wqa
" Typing NERDTree is kind of annoying
:command NT NERDTree
" Because folks don't seem to care about trailing whitespace

:command Trailing %s/\s\+$//g
set rtp+=~/.fzf

" Syntastic stuff:
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatusLineFlat()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

set nohlsearch

" Use deoplete.
" let g:deoplete#enable_at_startup = 1

" clang_complete clang path
let g:clang_library_path='/usr/lib/llvm-3.9/lib/libclang-3.9.so.1'
