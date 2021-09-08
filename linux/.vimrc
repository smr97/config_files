"(see https://github.com/powerline/fonts)
"- change plugin directory to ~/.vim/plugged
"(uncomment line 23 and comment line 22)

"after that copy this file as your ~/.vimrc and execute :PlugInstall
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
map <Space> <leader>

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

"Language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" essential plugins
" see for example https://github.com/autozimu/LanguageClient-neovim/issues/35#issuecomment-288731665
"Plug 'maralla/completor.vim' " auto-complete
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ } " as of july 2018 this branch is needed for vim8

" rust
Plug 'rust-lang/rust.vim' " syntax highlighting
"Plug 'mattn/webapi-vim' " used for rust playpen
"Plug 'racer-rust/vim-racer'
set hidden
"let g:racer_cmd = "/home/user/.cargo/bin/racer"


" snippets allow to easily 'fill' common patterns
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

filetype plugin indent on

" configure maralla/completor to use tab
" other configurations are possible (see website)
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = 'E:'
let airline#extensions#coc#warning_symbol = 'W:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
"let g:airline#extensions#tagbar#enabled = 1
set laststatus=2
au VimEnter * exec 'AirlineTheme hybrid'
set guifont=CodeNewRoman\ Nerd\ Font\ Mono\ Bold:h11


set encoding=utf-8

syntax on

colorscheme gruvbox
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
"let g:LanguageClient_loadSettings = 1 " this enables you to have per-projects languageserver settings in .vim/settings.json
let g:rustfmt_autosave = 1
let g:rust_conceal = 1
set hidden
au BufEnter,BufNewFile,BufRead *.rs syntax match rustEquality "==\ze[^>]" conceal cchar=≟
au BufEnter,BufNewFile,BufRead *.rs syntax match rustInequality "!=\ze[^>]" conceal cchar=≠

" Some CoC settings
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
set updatetime=300
"
" Don't pass messages to |ins-completion-menu|.
 set shortmess+=c
"
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
" Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not
"mapped by
"other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : \<C-h>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Scroll popup hopfully
nnoremap <leader><u> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
nnoremap <leader><U> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"

" GoTo code navigation.
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>fr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.  " Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)

" Map function and class text objects " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=?  Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>s :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <leader>ws :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>k :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p :<C-u>CocListResume<CR>
" Remap buffer navigation
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>
call coc#config('languageserver', {
        \ 'ccls': {
        \   "command": "ccls",
        \   "trace.server": "verbose",
        \   "filetypes": ["c", "cpp", "objc", "objcpp"]
        \ }
        \})
"nnoremap <leader>d :call LanguageClient#textDocument_definition()<CR>
"nnoremap <leader>dt :call LanguageClient#textDocument_definition({
"    \ 'gotoCmd': 'tabedit',
"    \ })<CR>
"nnoremap <leader>r :call LanguageClient#textDocument_rename()<CR>
""nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
"nnoremap <leader>t :call LanguageClient#textDocument_typeDefinition()<CR>
"nnoremap <leader>fr :call LanguageClient#textDocument_references()<CR>
"nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
"nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
"nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
"nnoremap <leader>s :call LanguageClient_textDocument_documentSymbol()<CR>
"nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

" let's autoindent c files
"au BufWrite *.c call LanguageClient#textDocument_formatting()

" run language server for python, rust and c
"let g:LanguageClient_autoStart = 1
"let g:LanguageClient_serverCommands = {
"    \ 'python': ['pyls'],
"    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
"    \ 'javascript': ['javascript-typescript-stdio'],
"    \ 'go': ['go-langserver'],
"    \ 'c' : ['clangd'] }
