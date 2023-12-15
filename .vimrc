let vimplug_exists=expand('~/.vim/autoload/plug.vim')
let curl_exists=expand('curl')

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "install curl or first install vim-plug"
    execute "q!"
  endif
  echo "installing vim-plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

"-------------------------------------------------------------

call plug#begin(expand('~/.vim/plugged'))

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'     " git
Plug 'tpope/vim-rhubarb'      " required by fugitive to :Gbrowse
Plug 'dense-analysis/ale'     " lint engine
Plug 'tomasr/molokai'         " theme
Plug 'junegunn/limelight.vim' " abstract
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'          " status bar
Plug 'vim-airline/vim-airline-themes'   " themes for it

"session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" c
Plug 'vim-scripts/c.vim', {'for': ['c', 'cpp']}
Plug 'ludwig/split-manpage.vim'

" go
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

" lua
Plug 'xolox/vim-lua-ftplugin'
Plug 'xolox/vim-lua-inspect'

" html, css, javascript
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'

Plug 'hail2u/vim-css3-syntax'
Plug 'ap/vim-css-color'         " hex colors

Plug 'pangloss/vim-javascript'

" vim-lsp
Plug 'prabirshrestha/vim-lsp'

call plug#end()

"-------------------------------------------------------------

" lag prevention
set timeout timeoutlen=3000 ttimeoutlen=50  " set lower timeout
set noswapfile                              " disable swp files
  
" encoding
set encoding=utf-8 
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast


" leader to ,
let mapleader=','

" hidden buffers
set hidden

" searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmenu
" clear search
nnoremap <silent> <leader><space> :noh<cr> 


" tabs
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" numbering
syntax on
set ruler
set number
set relativenumber

" color
let scheme_exists=expand('~/.vim/colors/molokai.vim')
if !filereadable(scheme_exists)
    silent exec "!mkdir -p ~/.vim/colors"
    silent exec "!mv ~/.vim/plugged/molokai/colors/molokai.vim ~/.vim/colors"
endif

let g:rehash256 = 0 " more colors
colorscheme molokai



" mouse support
set mouse=a
set gcr=a:blinkon0 " - blinking cursor
set scrolloff=5    " start scroll when 5 lines left 

" status bar
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)
set laststatus=2
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

"-------------------------------------------------------------

" session
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" vim-airline
let g:airline_theme = 'minimalist'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

let g:airline_powerline_fonts = 0
let g:airline_symbols = {}
let g:airline_symbols.colnr = ' col: '
let g:airline_symbols.linenr = ' ln: '
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.whitespace = ''


" ale
let g:ale_linters = {}
let g:ale_hover_cursor = -1
let g:ale_set_highlights = 1
let g:ale_set_signs = 1
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_virtualtext_cursor = 0 " disable annoying warnings

" c 
:call extend(g:ale_linters, { 
   \"c": ['ccls', 'clangd'], }) 

autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab 
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab

" go
:call extend(g:ale_linters, {
    \"go": ['golint', 'go vet'], })

"let g:go_fmt_autosave = 1
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"


let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4


" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
nnoremap <silent> <leader>e :FZF -m <CR>

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif
noremap <leader>a :Ag<CR>

" vim-lsp
set completeopt=menu,preview
let g:lsp_diagnostics_enabled = 0

if executable('ccls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'allowlist': ['c', 'cpp'],
        \ })
endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(
        \       lsp#utils#find_nearest_parent_file_directory(
        \               lsp#utils#get_buffer_path(),
        \               ['index.html']
        \       ))},
        \ 'allowlist': ['typescript', 'javascript','javascriptreact','typescript.jsx', 'javascript.jsx'],
        \ })
    autocmd FileType typescript,javascript,javascriptreact,typescript.jsx,javascript.jsx setlocal omnifunc=lsp#complete
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
