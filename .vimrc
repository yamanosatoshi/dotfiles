scriptencoding utf-8
set encoding=utf-8

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

" runtimepath追加"{{{
set runtimepath^=$HOME/.vim
set runtimepath+=$HOME/.vim/after
"set runtimepath+=$HOME/.vim/bundle/vital.vim
"}}}



" dein{{{
  "dein.vim dark power
  if ! exists('g:vscode')
    let s:dein_dir = expand('~/.cache/dein')
  else
    let s:dein_dir = expand('~/.cache/vsdein')
  endif

  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  if &compatible
      set nocompatible               " Be iMproved
  endif
  " dein.vim をインストールしていない場合は自動インストール
  if !isdirectory(s:dein_repo_dir)
    set notimeout
    echo "install dein.vim..."
    "execute '!git clone git://github.com/Shougo/dein.vim' s:dein_repo_dir
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir

  "---------------------------
  " Start dein.vim Settings.
  "---------------------------


  " neocon
  function! s:has_lua()
      return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
  endfunction

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

      if ! exists('g:vscode')
        let g:rc_dir    = expand('~/.cache/dein')
        " TOMLファイルにpluginを記述
        call dein#load_toml(expand('~/.vim/dein.plugins.toml'),       {'lazy': 0} ) " main
        call dein#load_toml(expand('~/.vim/dein.plugins.colors.toml'),{'lazy': 0} ) " colorscheme
        call dein#load_toml(expand('~/.vim/dein.plugins-lazy.toml'),  {'lazy': 1} ) " others for lazy
      else
        let g:rc_dir    = expand('~/.cache/vsdein')
        call dein#load_toml(expand('~/.vim/dein.plugins.vscode.toml'),       {'lazy': 0} ) " main
      endif

      " You can specify revision/branch/tag.
      call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

      call dein#end()
      call dein#save_state()
  endif



  " 未インストールを確認
  if dein#check_install()
    call dein#install()
  endif
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
  set guioptions+=a
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

set redrawtime=4000

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
elseif ! exists('g:vscode')
  set ambiwidth=double
endif

set undodir=$HOME/.vim/undo
set undofile

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
    filetype plugin indent on
    syntax enable
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif

" カーソル行をハイライト
if ! exists('g:vscode')
  set cursorline
  augroup cch
      autocmd! cch
      autocmd WinLeave * set nocursorline
      autocmd WinEnter,BufRead * set cursorline
  augroup END
endif


" カーソルライン
"hi CursorLine   guibg=#eeeeee

" listchars
"hi SpecialKey   guifg=#cccccc   gui=italic

"}}}

" WSLクリップボード共有{{{
if system('uname -a | grep Microsoft') != ''
    augroup myYank
        autocmd!
        autocmd TextYankPost * :call system('clip.exe', @")
    augroup END
endif"}}}

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
if has('gui')
  let g:save_window_file = expand('~/_vimwinpos')
  augroup SaveWindow
    autocmd!
    autocmd VimLeavePre * call s:save_window()
    function! s:save_window()
      let options = [
        \ 'set columns=' . &columns,
        \ 'set lines=' . &lines,
        \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
        \ ]
      call writefile(options, g:save_window_file)
    endfunction
  augroup END

  if filereadable(g:save_window_file)
    execute 'source' g:save_window_file
  endif
endif
"}}}

" migemo search "{{{
"set grepprg=internal
"if has('migemo')
"  " a 'migemo' option changes the behavior of "g?".
"  " NOTE: 'migemo' option is local to buffer.
"  set nomigemo migemodict=$HOME/.vim/dict/utf-8/migemo-dict
"  nnoremap / g/
"endif
"}}}

" statusline settings"{{{
set laststatus=2
if has('gui') && IsWindows()
    set showtabline=2
endif

function! SetStatusLine()
  if mode() =~ 'n'
    let c = 1
    let mode_name = 'Normal'
  elseif mode() =~ 'i'
    let c = 2
    let mode_name = 'Insert'
  elseif mode() =~ 'R'
    let c = 3
    let mode_name = 'Replace'
  else
    let c = 4
    let mode_name = 'Visual'
  endif
  return '%' . c . '*[' . mode_name . ']%* %<%F %m%r%h%w [ASCII=%03.3b] [HEX=%02.2B] [X=%v:%c] [Y=%l/%L] [%2p%%:%3P] %=%V[%{(&fenc!=""?&fenc:&enc)}:%{&ff}] [%Y]'
endfunction
 
set statusline=%!SetStatusLine()

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
if ! exists('g:vscode')
  vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>
else
  vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc
endif
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


"emmet-vim"{{{
let g:user_emmet_leader_key = '<C-E>'
"}}}

"NERDTree"{{{
"nnoremap <C-n> :NERDTree<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
"nnoremap <C-f> :NERDTreeFind<CR>

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable  = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

"}}}

" {{{ ref.vim
if has('win16') || has('win32')
    let $PATH = $PATH . ';C:\Program Files (x86)\Lynx for Win32'
endif
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

" ddc.vim"{{{
" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['around'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ })

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
      \ 'clangd': {'mark': 'C'},
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', {
      \ 'around': {'maxSize': 100},
      \ })

" Use ddc.
call ddc#enable()
"}}}


" Get folding working with vscode neovim plugin
"if(exists("g:vscode"))
"    nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
"    nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
"    nnoremap zc :call VSCodeNotify('editor.fold')<CR>
"    nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
"    nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
"    nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
"    nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>
"
"    #function! MoveCursor(direction) abort
"    #    if(reg_recording() == '' && reg_executing() == '')
"    #        return 'g'.a:direction
"    #    else
"    #        return a:direction
"    #    endif
"    #endfunction
"
"    #nmap <expr> j MoveCursor('j')
"    #nmap <expr> k MoveCursor('k')
"endif

" Color scheme{{{

if ! exists('g:vscode')
    hi User1 gui=bold ctermbg=blue ctermfg=white guibg=black guifg=white
    hi User2 gui=bold ctermbg=green ctermfg=black guibg=blue guifg=white
    hi User3 gui=bold ctermbg=red ctermfg=white guibg=coral guifg=white
    hi User4 gui=bold ctermbg=yellow ctermfg=black guibg=green guifg=black

    augroup TransparentBG
        autocmd!
        autocmd Colorscheme * highlight Normal ctermbg=none
        autocmd Colorscheme * highlight NonText ctermbg=none
        autocmd Colorscheme * highlight LineNr ctermbg=none
        autocmd Colorscheme * highlight Folded ctermbg=none
        autocmd Colorscheme * highlight EndOfBuffer ctermbg=none
    augroup END

    if has('gui') && IsWindows()
        colorscheme hybrid
        set bg=dark
    else
        colorscheme hybrid
        set bg=dark
    endif
else
    highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
endif


"}}}

