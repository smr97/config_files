"" ensimag vim config file version 1.0.2
"" this file is intended for vim 8. at ensimag everyting is pre-configured.
"" before using it on your machine however you will need to:
"" - install plug with :
""      curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"" (see https://github.com/junegunn/vim-plug)
"" - install the languageserver server for each language you indend to use :
""    * pyls for python (see https://github.com/palantir/python-language-server)
""    * rls for rust (see https://github.com/rust-lang-nursery/rls)
""    * clangd for c
"" - you need to install jedi for python auto-completion
"" - install some font with powerline symbols for eye candy and icons
"" (see https://github.com/powerline/fonts)
"" - change plugin directory to ~/.vim/plugged
"" (uncomment line 23 and comment line 22)

"" after that copy this file as your ~/.vimrc and execute :PlugInstall
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

set nocompatible
filetype off

" call plug#begin('/etc/vim/plugged') " at ensimag
call plug#begin('~/.vim/plugged') " on your own machine

Plug 'tpope/vim-sensible' " sane defaults

" not essential
Plug 'tpope/vim-fugitive' " git
Plug 'scrooloose/nerdtree' " browse files tree
Plug 'junegunn/fzf' " fuzzy files finding

" eye candy
Plug 'vim-airline/vim-airline' " status bar (needs special fonts)
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox' " very nice and soft color theme
Plug 'ryanoasis/vim-devicons' " various symbols (linux, rust, python, ...)

" essential plugins
" see for example https://github.com/autozimu/LanguageClient-neovim/issues/35#issuecomment-288731665
Plug 'maralla/completor.vim' " auto-complete
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ } " as of july 2018 this branch is needed for vim8

" rust
Plug 'rust-lang/rust.vim' " syntax highlighting
Plug 'mattn/webapi-vim' " used for rust playpen
Plug 'racer-rust/vim-racer'
set hidden
let g:racer_cmd = "/home/user/.cargo/bin/racer"


" snippets allow to easily 'fill' common patterns
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

filetype plugin indent on

" configure maralla/completor to use tab
" other configurations are possible (see website)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

" Custom command to not show hidden files in FZF
" command! SMRFZF call fzf#run(fzf#wrap({'source': 'fd --type f'}))

" fzf bindings
nnoremap <C-p> :FZF <cr>


nnoremap gr gT
" ultisnips default bindings compete with completor's tab
" so we need to remap them
let g:UltiSnipsExpandTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" airline :
" for terminology you will need either to export TERM='xterm-256color'
" or run it with '-2' option
let g:airline_powerline_fonts = 1
set laststatus=2
au VimEnter * exec 'AirlineTheme hybrid'
set guifont=CodeNewRoman\ Nerd\ Font\ Mono\ Bold:h11


set encoding=utf-8

syntax on

colo gruvbox
set background=dark
set number

" NERDTree settings
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
nnoremap <leader>n :NERDTree <cr>

" replace tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" some more rust
let g:LanguageClient_loadSettings = 1 " this enables you to have per-projects languageserver settings in .vim/settings.json
let g:rustfmt_autosave = 1
let g:rust_conceal = 1
set hidden
au BufEnter,BufNewFile,BufRead *.rs syntax match rustEquality "==\ze[^>]" conceal cchar=≟
au BufEnter,BufNewFile,BufRead *.rs syntax match rustInequality "!=\ze[^>]" conceal cchar=≠

nnoremap <leader>d :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>dt :call LanguageClient#textDocument_definition({
    \ 'gotoCmd': 'tabedit',
    \ })<CR>
nnoremap <leader>r :call LanguageClient#textDocument_rename()<CR>
"nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>t :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>fr :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>s :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

" let's autoindent c files
au BufWrite *.c call LanguageClient#textDocument_formatting()

" run language server for python, rust and c
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'go': ['go-langserver'],
    \ 'c' : ['clangd'] }
