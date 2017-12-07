runtime vim-plug/plug.vim

" let g:SuperTabSetDefaultCompletionType = 'context'

call plug#begin('~/.config/nvim/vendor/')
" autocomplete
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" show function signature and inline doc.
Plug 'Shougo/echodoc.vim'

" git
Plug 'tpope/vim-fugitive'

Plug 'altercation/vim-colors-solarized'
Plug 'benekastah/neomake'

Plug 'roxma/nvim-completion-manager', { 'do': ':UpdateRemotePlugins' }

" language server integration
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf.vim'
" (Optional) Multi-entry selection UI.
"Plug 'Shougo/denite.nvim'

" use tab for completion, superseeded by snippet below
" Plug 'ervandew/supertab'

Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-ragtag'
Plug 'machakann/vim-highlightedyank'

Plug 'rust-lang/rust.vim'
" Plug 'racer-rust/vim-racer', { 'for': ['rust'] }

" Show git diff status next to linenumbers
Plug 'airblade/vim-gitgutter'

" does not work yet with neovim
"Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
"Plug 'Shougo/vimproc' " only dependency of ghcmod-vim

Plug 'cespare/vim-toml'
Plug 'mzlogin/vim-markdown-toc'

Plug 'neovimhaskell/haskell-vim', { 'for': ['haskell', 'cabal'] }
Plug 'cloudhead/neovim-ghcid', { 'for': ['haskell'] }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
Plug 'feuerbach/vim-hs-module-name', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }

Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
call plug#end()

syntax on
filetype plugin indent on

" language server config
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'yaml': ['node', '~/node_modules/yaml-language-server/out/server/src/server.js', '--stdio'],
    \ 'dockerfile': ['~/node_modules/.bin/docker-langserver', '--stdio'],
    \ }
" buggy
"    \ 'ruby': ['~/bin/language_server-ruby'],
"    \ 'haml': ['~/bin/language_server-ruby'],

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

autocmd FileType dockerfile setlocal omnifunc=LanguageClient#complete

nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

" navigate through pop up menu with tab and shift-tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" disable gitgutter map keys
let g:gitgutter_map_keys = 0

" color scheme
let g:solarized_visibility='low'
set background=dark
colorscheme solarized

set autoindent
set backspace=indent,eol,start
"set complete-=i
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
"set encoding=utf-8
set relativenumber

" don't globally install keybinding for hs-module-name
let g:hs_module_no_mappings = 1
function! s:auBindingsHaskellModName()
    nmap <buffer> <silent> <Leader>hM :InsertHaskellModuleName<CR>
endfunction
command! BindingsHaskellModName call <SID>auBindingsHaskellModName()
au BufNewFile,BufRead,WinEnter *.hs,*.lhs   :BindingsHaskellModName

" Disable haskell-vim omnifunc and enable necoghc
let g:haskellmode_completion_ghc = 0
" autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:necoghc_enable_detailed_browse = 1

" binary files
augroup Binary
    au!
    au BufReadPre  *.bin *.fp5 let &bin=1
    au BufReadPost *.bin *.fp5 if &bin | %!xxd
    au BufReadPost *.bin *.fp5 set ft=xxd | endif
    au BufWritePre *.bin *.fp5 if &bin | %!xxd -r
    au BufWritePre *.bin *.fp5 endif
    au BufWritePost *.bin *.fp5 if &bin | %!xxd
    au BufWritePost *.bin *.fp5 set nomod | endif
augroup END

" fuzzy matching with :find, :help file-searching
set path+=**

" tab completion like in shell
" ignore some filetypes
if has ("wildmenu")
    set wildmenu
    set wildmode=longest,list
    set wildignore+=*.a,*.o,*~,.git,*.swp,*.tmp
endif

" have at least N lines of context before and below the cursor
set scrolloff=5

" ~ as operator: swap case for motion
set tildeop

" backspace in insert mode works before beginning of insert
set backspace=indent,eol,start

" selecting in virtual block mode treats lines with less columns badly
set virtualedit=block

" search for visual selected text using * and #
" default: visual select till last searchterm
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" fugitive customization
" delete old buffers when jumping to new one
autocmd BufReadPost fugitive://* set bufhidden=delete
" add branchname to statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" persistent undo
set undofile

" automatically wrap, when wrapping is enabled
set formatoptions+=cn1jq

" search case insensitive for lowercase regex, sensitive otherwise
set ignorecase
set smartcase

" call neomake when reading, writing, and on normal-made changes (after 750ms)
call neomake#configure#automake('rnw', 750)

" let g:deoplete#enable_at_startup=1

" auto cd to dir of file opened
set autochdir

" open quickfix window after a grep
autocmd QuickFixCmdPost *grep* cwindow

" autorun rustfmt on save
"let g:rustfmt_autosave = 1

" neomake: disable rustc and cargo makers
let g:neomake_rust_enabled_makers = []

" function! neomake#makers#ft#rust#rustc()
"     return {
"         \ 'exe': 'cargo',
"         \ 'args': ['rustc', '--', '-Zno-trans', '-Zincremental=/home/tob/.cache/rustc'],
"         \ 'append_file': 0,
"         \ 'errorformat':
"             \ '%-Gerror: aborting due to previous error,'.
"             \ '%-Gerror: aborting due to %\\d%\\+ previous errors,'.
"             \ '%-Gerror: Could not compile `%s`.,'.
"             \ '%Eerror[E%n]: %m,'.
"             \ '%Eerror: %m,'.
"             \ '%-Gwarning: the option `Z` is unstable %s,'.
"             \ '%-Gwarning: file-system error deleting outdated file %s,'.
"             \ '%Wwarning: %m,'.
"             \ '%Inote: %m,'.
"             \ '%-Z\ %#-->\ %f:%l:%c,'.
"             \ '%G\ %#\= %*[^:]: %m,'.
"             \ '%G\ %#|\ %#%\\^%\\+ %m,'.
"             \ '%I%>help:\ %#%m,'.
"             \ '%Z\ %#%m,'.
"             \ '%-G%s',
"         \ }
" endfunction

let g:necoghc_enable_detailed_browse = 1
" don't run hindent on every save
let g:hindent_on_save = 0
let g:hindent_line_length = 80
let g:hindent_indent_size = 4
au FileType haskell setlocal omnifunc=necoghc#omnifunc

augroup ft_rust
    au!
    set hidden
    let g:racer_cmd = "/home/tob/.cargo/bin/racer"
    let g:racer_experimental_completer = 1
augroup END

let g:netrw_browse_split=4 "open in prior window
let g:netrw_liststyle=3 "tree view
let g:netrw_list_hide=netrw_gitignore#Hide()

" automatically enter Limelight, when in Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

let g:limelight_conceal_ctermfg = 240

" full-text search with :F
let g:rg_command = 'rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --color always '
command! -bang -nargs=* F call fzf#vim#grep(g:rg_command.shellescape(<q-args>), 1, <bang>0)

" prefix all fzf command with Fzf
let g:fzf_command_prefix = 'Fzf'

" use ripgrep for :grep
set grepprg=rg\ --vimgrep

" map esc in terminal mode to get into normal mode
tnoremap <Esc> <C-\><C-n>
