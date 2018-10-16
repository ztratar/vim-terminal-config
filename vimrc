" ~/.vimrc    ::   Zach Tratar <ztratar@gmail.com>

set rtp=~/.vim,$VIMRUNTIME
set autoindent
set bs=2
set clipboard=unnamed
set encoding=utf-8
set hlsearch
set ignorecase smartcase
set incsearch
set nocompatible
set noerrorbells
set vb t_vb=
set ruler
set scrolloff=2
set shell=/bin/sh
set number
set showcmd
set showmatch
set switchbuf=useopen
if version >= 700
  set switchbuf+=usetab
  set nofsync
endif
set smartindent
set shiftwidth=2
set et
set smarttab
set ttyfast
set wildmenu
set wmh=0   " these disable the one line that vim shows by
set wmw=0   " default for minimised
set wrap
set fillchars=stl:_,stlnc:-,vert:\|,fold:\ ,diff:-
set swapsync=
set history=1000
set mouse=a
set hidden
set title
set tabpagemax=15
let mapleader = ","
set wildignore+=*.o,*.obj,.git,.svn,.hg,*.gif,*.png,*.jpg,*.zip,*.tgz,*.tar.gz,*.tar.bz2,*.bmp,*.swf,*.eps,*.tiff,*.pdf,*.ps,*.ai,*.avi,*.ico,*.psd,*.docx,*.doc,*/node_modules/*
set nofoldenable
set t_BE=
set expandtab
set tags=tags;/
set comments=s1:/*,mb:*,ex:*/

" Vundle
" Make sure you do this first:
"   git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" Then on a new system do
"   :PluginInstall within a new vim instance

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'pangloss/vim-javascript'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-sensible'
Plugin 'vim-ruby/vim-ruby'
Plugin 'fatih/vim-go'
Plugin 'easymotion/vim-easymotion'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'mileszs/ack.vim'
Plugin 'ConradIrwin/vim-bracketed-paste'
Bundle 'altercation/vim-colors-solarized'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'zeis/vim-kolor'
Plugin 'rhysd/vim-clang-format'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'prettier/vim-prettier', { 'do': 'yarn install' }
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mhinz/vim-grepper'
Plugin 'majutsushi/tagbar'

call vundle#end()
filetype plugin indent on
syntax on

" ale error parsing with both ruby and rubocop
let g:ale_pattern_options = {'\.\(cc\|h\)$': {'ale_enabled': 0}}
let g:ale_sign_column_always = 1
let g:ale_statusline_format = ['✗ %d', '⚠ %d', '']
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_set_highlights = 1
let g:ale_ruby_rubocop_executable = 'bundle'

" YCM
autocmd CompleteDone * pclose
let g:ycm_server_use_vim_stdout = 0
let g:ycm_server_keep_logfiles = 1
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" Solarized
syntax enable
set background=dark
let g:airline_solarized_bg='dark'
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_termcolors=16
let g:solarized_underline=1
colorscheme solarized

" clang-format
autocmd FileType c ClangFormatAutoEnable

" grepper
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)

" Often mis typed commands
command! Q  q
command! W  w
command! Wq wq
command! WQ wq
map Q :q<CR>

" Remap ` to ' to use column in mark, because this can be annoying
nnoremap ' `
nnoremap ` '

" Tabs
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
" Alternatively use
nnoremap th :tabnext<CR>
nnoremap tl :tabprev<CR>
nnoremap tn :tabnew<CR>

" Edit another file in the same directory as the current file, use: ,e
if has("unix")
  map ,e :tabe <C-R>=expand("%:h") . "/" <CR>
else
  map ,e :tabe <C-R>=expand("%:h") . "\\" <CR>
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
augroup END

" Ruby Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
let g:ruby_indent_access_modifier_style="indent"

" files in /tmp, like crontabs need this
autocmd BufReadPost /tmp/* set backupcopy=yes

" python world is 4 spaces
au BufNewFile,BufRead *.py setlocal shiftwidth=4

" try to select a better html mode based on file contents
fun! s:SelectHTML()
  let n = 0
  while n < 50 && n < line("$")
    " check for jinja
    if getline(n) =~ '{%\s*\(extends\|block\|comment\|ssi\|if\|for\|blocktrans\)\>'
      set ft=htmljinja
      return
    endif
    " check for php
    if getline(n) =~ '<?php'
      set ft=php
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()

" disable automatic folding in php
let g:DisableAutoPHPFolding = 1

" Ryan's crazy jk crazy escape
inoremap jk <esc>
" inoremap <esc> <nop>

" Enter command mode by pressing ; instead of :
noremap ; :

" Window nav
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" jk should scroll by actual lines
nnoremap <silent> j gj
nnoremap <silent> k gk

" Strip trailing whitespace
autocmd FileType c,cpp,java,php,javascript,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

set tabstop=2

highlight OverLength ctermbg=red ctermfg=white
set textwidth=80

map <Leader>g :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>
let g:easytags_async=1

" Control p
" Only search to current working dir
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard | grep -v node_modules', 'find %s -type f']
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" line up params
set cindent

" http://blog.mattcrampton.com/post/86216925656/move-vim-swp-files
" Make sure to run
" mkdir -p ~/.vim/{backup_files,swap_files,undo_files}
set backupdir=~/.vim/backup_files//
set directory=~/.vim/swap_files//
set undodir=~/.vim/undo_files//

" Ruby shortcuts
nnoremap <leader>p A<CR>require 'pry'; binding.pry<C-c>

" Fugitive - Leader mappings.
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gg :Ggrep<Space>
nnoremap <leader>gl :Glog<CR><CR><CR>:copen<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gh :Gbrowse<CR>

autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* lwindow
set makeprg=scripts/bin/typecheck
nnoremap <leader>t :silent make\|redraw!\|cw<CR>

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set numberwidth=5

" Silver Surfer Search
map <Leader>a :Ag<Space>

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v

" When you're in Tmux, easy run a command or test in the other window
map <Leader>vp :VimuxPromptCommand<CR>

" NERD Tree
map <C-n> :NERDTreeToggle<CR>

" Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#whitespace#enabled = 1
let g:airline_symbols.whitespace = '□□'
let g:airline#extensions#whitespace#mixed_indent_format = 'MI[%s]'
let g:airline#extensions#whitespace#trailing_format = 'T[%s]'
let g:airline#extensions#whitespace#trailing_regexp = '\s\s$'
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing']
let g:airline_section_b = '%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
let g:airline_section_c = '%<%<%{airline#extensions#fugitiveline#bufname()}%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_section_y = ''
let g:airline_section_z = ''
" If need to know these then simply do:
" set ff for fileformat
" set fenc for fileencoding
" set ft for filetype
let g:airline#extensions#hunks#non_zero_only = 0
let base16colorspace=256
let g:airline_mode_map = {
\ '__' : '-',
\ 'n' : 'N',
\ 'i' : 'I',
\ 'R' : 'R',
\ 'c' : 'C',
\ 'v' : 'V',
\ 'V' : 'V',
\ 's' : 'S',
\ 'S' : 'S',
\ '�' : 'S',
\ }
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type= 2
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#ycm#enabled = 1

" FZF & FZF.vim
let g:fzf_tags_command = 'ctags --extra=+f -R'
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
map <Leader>f :FZF<CR>
map <Leader>t :Tags<CR>
map <Leader>h :History<CR>

" Easymotion
map <Leader>d <Plug>(easymotion-bd-w)
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=red

" Tags to have class, module, and snippet search
map <Leader>m :TagbarToggle<CR>
let g:tagbar_type_ruby = {
  \ 'kinds' : [
    \ 'm:modules',
    \ 'c:classes',
    \ 'd:describes',
    \ 'C:contexts',
    \ 'f:methods',
    \ 'F:singleton methods'
  \ ]
\ }
