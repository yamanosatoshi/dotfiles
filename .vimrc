" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

" environment detect"{{{
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_sudo = $SUDO_USER != '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

function! IsWindows()
  return s:is_windows
endfunction

function! IsMac()
  return !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))
endfunction
"}}}

"文字コードの自動認識 "{{{
" Win用
if has('win16') || has('win32')
  set termencoding=cp932
endif

"http://www.kawaz.jp/pukiwiki/?vim#content_1_7 
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック 
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック 
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分 
  unlet s:enc_euc
  unlet s:enc_jis
endif
"}}}

" runtimepath追加"{{{
set runtimepath^=$HOME/.vim
set runtimepath+=$HOME/.vim/after
set runtimepath+=$HOME/.vim/bundle/vital.vim
"}}}

" NeoBundle {{{

"デバッグよう
"let g:neobundle#log_filename = $HOME . "/neobundle.log"

set nocompatible
filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

filetype plugin indent on

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

"
"プラグインをNeoBundle
"
NeoBundle 'vim-jp/vital.vim'
NeoBundle 'gmarik/vundle'
NeoBundle 'scrooloose/nerdcommenter'
"NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
"NeoBundle 'kana/vim-fakeclip'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'vim-scripts/The-NERD-tree'
"NeoBundle 'yanktmp.vim'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'mbbill/undotree'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'h1mesuke/textobj-wiw'
NeoBundle 'tpope/vim-surround'
NeoBundle 'gcmt/wildfire.vim'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'haya14busa/vim-migemo'
NeoBundle 'editorconfig/editorconfig-vim'
"NeoBundle 'wakatime/vim-wakatime'

" neocon
function! s:meet_neocomplete_requirements()
	return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if s:meet_neocomplete_requirements()
	NeoBundle 'Shougo/neocomplete.vim'
	NeoBundleFetch 'Shougo/neocomplcache.vim'
else
	NeoBundleFetch 'Shougo/neocomplete.vim'
	NeoBundle 'Shougo/neocomplcache.vim'
endif


" Color Schemes "{{{

"" カラースキーム一覧表示に Unite.vim を使う
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'

"NeoBundle 'freeo/vim-kalisi'
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'croaker/mustang-vim'
"NeoBundle 'nanotech/jellybeans.vim'
"NeoBundle 'vim-scripts/Lucius'
"NeoBundle 'vim-scripts/Zenburn'
"NeoBundle 'mrkn/mrkn256.vim'
"NeoBundle 'tomasr/molokai'
"NeoBundle 'daylerees/colour-schemes'
"NeoBundle 'chriskempson/vim-tomorrow-theme'
"NeoBundle 'therubymug/vim-pyte'
NeoBundle 'Haron-Prime/Antares'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'sickill/vim-monokai'
NeoBundle 'google/vim-colorscheme-primary'
NeoBundle 'sjl/badwolf'
NeoBundle 'cocopon/iceberg.vim'
NeoBundle 'jgdavey/vim-railscasts'
NeoBundle 'pasela/edark.vim'
NeoBundle 'w0ng/vim-hybrid'



""}}}

call neobundle#end()

"}}} neoBundle

" vital.vim"{{{
let g:V = vital#of('vital').load(
\  ['Math'],
\  ['DateTime'],
\  ['System.Filepath'],
\  ['Data.List'],
\  ['Data.String'])
"}}}

" General"{{{

"保存しなくても別ファイルをオープン出来るようにする
set hidden

set expandtab
set t_Co=256
set ts=4 sw=4 sts=4
set fo+=r
set shortmess+=I
set cindent
set ignorecase
set smartcase
set wrapscan
set showmatch
set matchtime=1
set number
set ruler
set nolist
set wrap
set cmdheight=2
set title
set shortmess+=I
set nrformats=
set nobackup
syn on
set visualbell
set noerrorbells

if has('gui') && IsWindows()
  gui
  set guioptions-=T "ツールバーなし
  set guioptions-=m "メニューバーなし
  set guioptions-=R
  set guioptions-=l "左スクロールバーなし
  set guioptions-=L
  set guioptions-=b "下スクロールバーなし
endif

set showcmd
set incsearch
set nocompatible
set hlsearch

" OSのクリップボードを使用する
set clipboard+=unnamed
" ヤンクした文字は、システムのクリップボードに入れる
set clipboard=unnamed

" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

"insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" フォールドマーカー
set foldmethod=marker
set foldmarker={{{,}}}

" コマンド実行中は再描画しない
set lazyredraw

" 高速ターミナル接続を行う
set ttyfast


" input
set backspace=indent,eol,start
set formatoptions+=mM
set autoindent
set smartindent
set iminsert=0
set imsearch=-1
set cindent
set whichwrap=b,s,h,l,<,> ",[,] 行末はやめとく

" display
if has('gui') && IsWindows()
	set columns=180
	set lines=90
	set linespace=1
	winpos 100 100
	set display=lastline
endif


"fonts
"set gfn=Courier_New:h12:cSHIFTJIS
"set gfn=Migu_1M:h8:cDEFAULT
"set gfn=Ricty:h8:cDEFAULT
"set gfw=Migu_1M:h8:cDEFAULT
"set gfn=Inconsolata:h9:cDEFAULT
set gfn=MS_Gothic:h10:cDEFAULT

"半角文字の表示
"set guifont=Migu_1M:h8:cDEFAULT
"全角文字の表示
"set guifontwide=Migu_1M:h8:cDEFAULT

" Don't show :intro when startup.
"set shortmess& shortmess+=I

if has('kaoriya') && IsWindows() && has('gui_running')
  set ambiwidth=auto
else
  set ambiwidth=double
endif

set undodir=$HOME/.vim/undo

set helplang=ja,en

"}}}

" ハイライト表示"{{{
" タブ文字、行末など不可視文字を表示する
set list
" listで表示される文字のフォーマットを指定する
set listchars=tab:>_,trail:~,nbsp:_,extends:>,precedes:<

" スペースをハイライトさせる
" Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
" 設定する必要がある。
function! SOLSpaceHilight()
    syntax match SOLSpace /\s\+/ display containedin=ALL
    "highlight SOLSpace term=underline ctermbg=LightGray guibg=#efffef
endf
" 全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
    syntax match JISX0208Space /　/ display containedin=ALL
    highlight JISX0208Space term=underline ctermbg=LightCyan gui=underline guibg=#dddddd
endf
" syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
    syntax on
        augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif

" カーソル行をハイライト
set cursorline
augroup cch
	autocmd! cch
	autocmd WinLeave * set nocursorline
	autocmd WinEnter,BufRead * set cursorline
augroup END


" カーソルライン
"hi CursorLine   guibg=#eeeeee

" listchars
"hi SpecialKey   guifg=#cccccc   gui=italic

"}}}

" GUI時複数起動禁止"{{{
if v:servername == 'GVIM1' || v:servername == 'GVIM2'
    let file = expand('%:p')
	bwipeout
    call remote_send('GVIM', '<ESC>:tabnew ' .escape(file, "%") .'<CR>')
    call remote_foreground('GVIM')
    quit
endif
"}}}


"no use HankakuSpace() "{{{
"function! HankakuSpace()
"  "HankakuSpaceをカラーファイルで設定するなら次の行は削除
"  highlight HankakuSpace cterm=underline ctermfg=lightblue guibg=#334333
"  "半角スペースを明示的に表示する。
"  silent! match HankakuSpace / /
"endfunction
"
"if has('syntax')
"  augroup HankakuSpace
"    autocmd!
"    autocmd VimEnter,BufEnter * call HankakuSpace()
"  augroup END
"endif

" Hack #22: XMLの閉じタグを補完するようにする
" http://vim-users.jp/2009/06/hack22/
"augroup MyXML
"  autocmd!
"  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype php inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype phtml inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype xhtml inoremap <buffer> </ </<C-x><C-o>
"augroup END
"}}}


"ウィンドウの位置とサイズを記憶する" {{{
"if has('gui')
  "let g:save_window_file = expand('~/_vimwinpos')
  "augroup SaveWindow
    "autocmd!
    "autocmd VimLeavePre * call s:save_window()
    "function! s:save_window()
      "let options = [
        "\ 'set columns=' . &columns,
        "\ 'set lines=' . &lines,
        "\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
        "\ ]
      "call writefile(options, g:save_window_file)
    "endfunction
  "augroup END

  "if filereadable(g:save_window_file)
    "execute 'source' g:save_window_file
  "endif
"endif
"}}}

" migemo search "{{{
"set grepprg=internal
if has('migemo')
  " a 'migemo' option changes the behavior of "g?".
  " NOTE: 'migemo' option is local to buffer.
  set nomigemo migemodict=$HOME/.vim/dict/utf-8/migemo-dict
  nnoremap / g/
endif
"}}}


" statusline settings"{{{
set laststatus=2
if has('gui') && IsWindows()
	set showtabline=2
endif

set statusline=%<%f\ %m%r%h%w\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%l,%c][%p%%]\ [LEN=%L]\ %{'['.(&fenc!=''?&fenc:&enc)}:%{&ff}]\ [%Y]%=%V%8P
"}}}

set dir=~/

if has("autocmd")
	autocmd BufNewFile,Bufread *.php,*.php3,*.php4 set keywordprg="help"
endif


" VDsplit windowsの%入りパス対応版
command! -nargs=1 -complete=file VDS call <SID>EscVDsplit('<args>')
function! s:EscVDsplit(file)
	execute "vertical diffsplit " . escape(a:file, "%")
endfunction


"php checker"{{{
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l
"}}}

" FileTypeLint"{{{
"
" @author halt feits <halt.feits at gmail.com>
"
function! FTLint(option)
  if &ft == 'html'
    let result = system( 'php -l '.a:option.' ' . bufname(""))
  else
	let result = system( &ft . ' -l '.a:option.' ' . bufname(""))
  endif
  echo result
endfunction

nmap ,l :call FTLint('')<CR>
nmap ,,l :call FTLint('-d short_open_tag=0')<CR>
"}}}

" mappings "{{{

"検索結果のハイライトをオフ
nmap <ESC><ESC> :nohlsearch<CR><ESC>
"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>
"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

"<C-^>で編集ファイルを入れ替え
nmap <C-^> :b#<CR>
"<C-@>で:filesから選択
nmap <C-@> :files<CR>:b

" Current line at center of window and open the folding.
noremap n nzzzv
noremap N Nzzzv

" Very magic by default.
nnoremap / /\v
nnoremap ? ?\v
cnoremap <expr> s/ getcmdline() =~# '^\A*$' ? 's/\v' : 's/'
cnoremap <expr> g/ getcmdline() =~# '^\A*$' ? 'g/\v' : 'g/'
cnoremap <expr> v/ getcmdline() =~# '^\A*$' ? 'v/\v' : 'v/'
cnoremap s// s//
cnoremap g// g//
cnoremap v// v//

"}}}

" {{{ Automatic close char mapping

inoremap  { {<CR>}<C-O>O
"inoremap [ []<LEFT>
inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

" }}} Automatic close char mapping

" {{{ Wrap visual selections with chars

:vnoremap ( "zdi(<C-R>z)<ESC>
:vnoremap { "zdi{<C-R>z}<ESC>
":vnoremap [ "zdi[<C-R>z]<ESC>
":vnoremap ' "zdi'<C-R>z'<ESC>
":vnoremap " "zdi"<C-R>z"<ESC>

" }}} Wrap visual selections with chars

" {{{ Dictionary completion

" The completion dictionary is provided by Rasmus:
" http://lerdorf.com/funclist.txt
set dictionary-=~/.vim/dict/funclist.txt dictionary+=~/.vim/dict/funclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" }}} Dictionary completion

" {{{ Autocompletion using the TAB key

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion

"function InsertTabWrapper()
"    let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k'
"        return "\<tab>"
"    else
"        return "\<c-p>"
"    endif
"endfunction

function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}} Autocompletion using the TAB key


" Plugin Settings"{{{


"neocomplcache"{{{

if s:meet_neocomplete_requirements()
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#max_list = 20

	" Use smartcase.
	let g:neocomplete#enable_smart_case = 1
	" Use camel case completion.
	let g:neocomplete#enable_camel_case_completion = 0
	" Use underbar completion.
	let g:neocomplete#enable_underbar_completion = 0
	" Set minimum syntax keyword length.
	let g:neocomplete#min_syntax_length = 3
	" Set manual completion length.
	let g:neocomplete#auto_completion_start_length = 2

	let g:neocomplete#snippets_dir = $HOME.'/.vim/dict/funclist.txt'
else
	let g:neocomplcache_enable_at_startup = 1
	let g:neocomplcache_max_list = 20

	" Use smartcase.
	let g:neocomplcache_enable_smart_case = 1
	" Use camel case completion.
	let g:neocomplcache_enable_camel_case_completion = 0
	" Use underbar completion.
	let g:neocomplcache_enable_underbar_completion = 0
	" Set minimum syntax keyword length.
	let g:neocomplcache_min_syntax_length = 3
	" Set manual completion length.
	let g:neocomplcache_auto_completion_start_length = 2

	let g:neocomplcache_snippets_dir = $HOME.'/.vim/dict/funclist.txt'
endif

"}}}

"emmet-vim"{{{
let g:user_emmet_leader_key = '<C-E>'
"}}}


"NERDTree"{{{
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"}}}

" {{{ ref.vim
let $PATH = $PATH . ';C:\Program Files (x86)\Lynx for Win32'
nmap ,ra :<C-u>Ref alc<Space>
let g:ref_alc_start_linenumber = 39 " 表示する行数
nmap ,rp :<C-u>Ref phpmanual<Space>
let g:ref_phpmanual_path = $HOME . '/.vim/dict/php-chunked-xhtml/'
" }}} ref.vim

" unite.vim "{{{
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" 待ち時間を増やす
let g:unite_update_time = 300
"let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200

" yankヒストリ一覧
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
"}}}

" yanktmp"{{{
"map <silent> sy :call YanktmpYank()<CR>
"map <silent> sp :call YanktmpPaste_p()<CR>
"map <silent> sP :call YanktmpPaste_P()<CR>
"}}}

" undotree.vim"{{{
" undo履歴を表示する。? でヘルプを表示
" http://vimblog.com/blog/2012/09/02/undotree-dot-vim-display-your-undo-history-in-a-graph/
" https://github.com/r1chelt/dotfiles/blob/master/.vimrc
nmap <Leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
"let g:undotree_SplitLocation = 'topleft' "
let g:undotree_WindowLayout = 2
let g:undotree_SplitWidth = 35
let g:undotree_diffAutoOpen = 1
let g:undotree_diffpanelHeight = 25
let g:undotree_RelativeTimestamp = 1
let g:undotree_TreeNodeShape = '*'
let g:undotree_HighlightChangedText = 1
let g:undotree_HighlightSyntax = "UnderLined"
"}}}

" wildfire.vim"{{{
" This selects the next closest text object.
let g:wildfire_fuel_map = "<ENTER>"
" This selects the previous closest text object.
let g:wildfire_water_map = "<BS>"

let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "i>", "ip", "it", "a'", 'a"', "a)", "a]", "a}", "a>", "ap", "at"]
"}}}

"}}}


if has('gui') && IsWindows()
	colorscheme hybrid
    set bg=dark
else
	colorscheme wombat256
endif
