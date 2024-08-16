source $VIMRUNTIME/vimrc_example.vim

call plug#begin()
Plug 'preservim/nerdtree'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
" Automatically clear search highlights after you move your cursor.
Plug 'haya14busa/is.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Optional:
Plug 'honza/vim-snippets'
Plug 'godlygeek/tabular' | Plug 'tpope/vim-markdown'
" Dim paragraphs above and below the active paragraph.
Plug 'junegunn/limelight.vim'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif
" Briefly highlight which text was yanked.
Plug 'machakann/vim-highlightedyank'
" Automatically show Vim's complete menu while typing.
Plug 'vim-scripts/AutoComplPop'
" Toggle comments in various ways.
Plug 'tpope/vim-commentary'
call plug#end()

" Enable 24-bit true colors if your terminal supports it.
if (has("termguicolors"))
  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif


" Set the color scheme.
colorscheme blue
set background=dark

" Spelling mistakes will be colored up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

" Heavily inspired by: https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar

au GUIEnter * simalt ~x
set hls
set is
set cb=unnamed
set gfn=Fixedsys:h14
set ts=4
set sw=4
set complete+=kspell
set completeopt=menuone,longest
set clipboard=unnamedplus,unnamed
set encoding=utf-8
set formatoptions=tcqrn1
" Enable syntax highlighting.
syntax on
"set cursorline
set hidden
set autoindent
set autoread
" set colorcolumn=80
set ignorecase
set wildmenu
set wildmode=full
set incsearch
set hlsearch
set si
set showcmd
set spelllang=en_us
set splitbelow
set splitright
set showmatch
set shortmess+=c
set nospell " To turn on spell checking set spell!
" Toggle spell check.
nnoremap <F5> :setlocal spell!<CR>
inoremap <F5> <C-o>:setlocal spell!<CR>
set ruler
" Let's save undo info!
if !isdirectory($HOME."/vimfiles")
    call mkdir($HOME."/vimfiles", "", 0770)
endif
if !isdirectory($HOME."/vimfiles/undo-dir")
    call mkdir($HOME."/vimfiles/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
set wrap
set laststatus=2
set errorformat=%f
"set showtabline=2 guioptions+=e

set updatetime=100

" highlighting
if !exists('##TextYankPost')
  nmap y <Plug>(highlightedyank)
  xmap y <Plug>(highlightedyank)
  omap y <Plug>(highlightedyank)
endif
let g:highlightedyank_highlight_duration = 2000

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c']

" Tabular command helps to allign using a particular symbol for entire file or selected text
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" .............................................................................
" ntpeters/vim-better-whitespace
" .............................................................................

let g:strip_whitespace_confirm = 0
let g:strip_whitelines_at_eof  = 1
let g:strip_whitespace_on_save = 1


" .............................................................................
" iamcco/markdown-preview.nvim
" .............................................................................

let g:mkdp_auto_close=0
let g:mkdp_refresh_slow=1
let g:mkdp_markdown_css=fnameescape($HOME).'/vimfiles/github-markdown.css'

" nnoremap <SPACE> <Nop>
let mapleader=" "
let maplocalleader=" "

let g:snipMate = { 'snippet_version' : 1 }

inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

nnoremap <C-s> :w<cr>
nnoremap <C-q> :bd<cr>
nnoremap <C-S-q> :q!<cr>
nnoremap <C-S-s> :w<cr> :source $MYVIMRC<cr>
nnoremap <C-a> ggVG <cr>
nnoremap <A-Left> :bprevious<CR>
nnoremap <A-Right> :bnext<CR>


" Copy the current buffer's path to your clipboard.
nmap cp :let @+ = expand("%")<CR>

" Automatically fix the last misspelled word and jump back to where you were.
" Taken from this talk: https://www.youtube.com/watch?v=lwD8G1P52Sk
nnoremap <leader>sp :normal! mz[s1z=`z<CR>

" Move 1 more lines up or down in normal and visual selection modes.
""nnoremap <C-k> :m .-2<CR>==
""nnoremap <C-j> :m .+1<CR>==
""vnoremap <C-k> :m '<-2<CR>gv=gv
""vnoremap <C-j> :m '>+1<CR>gv=gv
nnoremap <C-Up> :m .-2<CR>==
nnoremap <C-Down> :m .+1<CR>==
vnoremap <C-Up> :m '<-2<CR>gv=gv
vnoremap <C-Down> :m '>+1<CR>gv=gv

" Navigate around splits with a single key combo.
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-j> <C-w><C-j>

" Cycle through splits.
nnoremap <S-Tab> <C-w>w

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
""nnoremap <Leader>r :%s///g<Left><Left>
""nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
""nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
""xnoremap <silent> s* "sy:let @/=@s<CR>cgn

""nnoremap <leader>n :NERDTreeFocus<CR>
""nnoremap <C-n> :NERDTree<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Navigate the complete menu items like CTRL+n / CTRL+p would.
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"

" Select the complete menu item like CTRL+y would.
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"

" Cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa

" Edit Vim config file in a new tab.
map <Leader>ev :tabnew $MYVIMRC<CR>

" Prevent x and the delete key from overriding what's in the clipboard.
noremap x "_x
noremap X "_x
noremap <Del> "_x

autocmd filetype cpp nnoremap <F9> :w <bar> !g++ -std=c++17 % -o %:r -Wl,--stack,268435456<CR>
autocmd filetype cpp nnoremap <F10> :!%:r<CR>
autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter * :checktime

" Make sure all types of requirements.txt files get syntax highlighting.
autocmd BufNewFile,BufRead requirements*.txt set ft=python

" Make sure .aliases, .bash_aliases and similar files get syntax highlighting.
autocmd BufNewFile,BufRead .*aliases* set ft=sh

set nu
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

function Openall()
    edit <cfile>
    bfirst
endfunction

" both visual and select modes at once. gv means reselect the last selection
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" just visual mode. this is unsurprisingly the same as vnoremap
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv

:imap <C-Tab> <Plug>snipMateNextOrTrigger
:imap <C-S-Tab> <Plug>snipMateBack

" function! s:map_if_not_mapped(lhs, rhs, mode) abort
"     let l:unique = s:overwrite ? '' : ' <unique>'
"     if !hasmapto(a:rhs, a:mode)
" 	silent! exe a:mode . 'map' . l:unique a:lhs a:rhs
"     endif
" endfunction


" if !exists('g:snips_no_mappings') || !g:snips_no_mappings
" 	if exists('g:snips_trigger_key')
" 		echom 'g:snips_trigger_key is deprecated. See :h snipMate-mappings'
" 		exec 'imap <unique>' g:snips_trigger_key '<Plug>snipMateTrigger'
" 		exec 'smap <unique>' g:snips_trigger_key '<Plug>snipMateSNext'
" 		exec 'xmap <unique>' g:snips_trigger_key '<Plug>snipMateVisual'
" 	else
" 		" Remove SuperTab map if it exists
" 		let s:overwrite = maparg('<C-Tab>', 'i') ==? '<Plug>SuperTabForward'
" 		call s:map_if_not_mapped('<C-Tab>', '<Plug>snipMateNextOrTrigger', 'i')
" 		call s:map_if_not_mapped('<C-Tab>', '<Plug>snipMateNextOrTrigger', 's')
" 		let s:overwrite = 0
" 		call s:map_if_not_mapped('<C-Tab>', '<Plug>snipMateVisual', 'x')
" 	endif

" 	if exists('g:snips_trigger_key_backwards')
" 		echom 'g:snips_trigger_key_backwards is deprecated. See :h snipMate-mappings'
" 		exec 'imap <unique>' g:snips_trigger_key_backwards '<Plug>snipMateIBack'
" 		exec 'smap <unique>' g:snips_trigger_key_backwards '<Plug>snipMateSBack'
" 	else
" 		let s:overwrite = maparg('<C-S-Tab>', 'i') ==? '<Plug>SuperTabBackward'
" 		call s:map_if_not_mapped('<C-S-Tab>', '<Plug>snipMateBack', 'i')
" 		call s:map_if_not_mapped('<C-S-Tab>', '<Plug>snipMateBack', 's')
" 		let s:overwrite = 0
" 	endif

" 	call s:map_if_not_mapped('<C-R><Tab>', '<Plug>snipMateShow', 'i')
" endif
