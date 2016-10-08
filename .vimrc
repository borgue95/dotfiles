" Syntax highlighting
syntax on
set number
set t_Co=256

" Comment
highlight Comment ctermfg=8

" Constant
highlight String ctermfg=33
highlight Character ctermfg=DarkBlue
highlight Number ctermfg=DarkGreen

" Identifier
" Statement
highlight Conditional ctermfg=172 cterm=bold
highlight Repeat ctermfg=172 cterm=bold
highlight Label ctermfg=172 cterm=bold
highlight Operator ctermfg=9

" PreProc
highlight PreProc ctermfg=Red cterm=bold

" Type
highlight Type ctermfg=28 cterm=bold

" Special
highlight SpecialChar ctermfg=DarkBlue cterm=bold

" Match Parent
highlight MatchParen ctermbg=15 ctermfg=99
" Underlined
" Ignore
" Error
" Todo
highlight Todo ctermbg=123 ctermfg=Black

" ColorColumn
highlight ColorColumn ctermbg=153
"""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""

" Set autowrap
set tw=80

" Set line breaker indicator
set colorcolumn=81
highlight ColorColumn guibg=#2d2d2d ctermbg=53

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Highlight all search pattern matches
set hlsearch

" Ignore case when searching
set ignorecase

" Copy and paste between terminals
set clipboard=unnamedplus
