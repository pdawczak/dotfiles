set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'endwise.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-cucumber'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Yggdroot/indentLine'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-commentary'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-rbenv'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
" Plugin 'SirVer/ultisnips'
Plugin 'ervandew/supertab'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'christoomey/vim-tmux-runner'
Plugin 'airblade/vim-gitgutter'
Plugin 'skwp/greplace.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'
Plugin 'morhetz/gruvbox'
Plugin 'crusoexia/vim-monokai'

call vundle#end()
filetype plugin indent on

syntax on

runtime macros/matchit.vim

" appearance
set t_Co=256
set background=dark
colorscheme monokai
set guifont=Fira\ Code:h12
set relativenumber
set number
autocmd InsertEnter * :set number norelativenumber
autocmd InsertLeave * :set relativenumber

set showcmd
set encoding=utf-8
set cursorline                    " highlight current line of cursor
set scrolloff=5                   " minimum lines above/below cursor
set nowrap                        " don't wrap to long lines
set showmatch                     " show bracket matches
set list listchars=tab:»·,trail:· " show extra space characters
set clipboard=unnamed             " use the system clipboard
set backspace=indent,eol,start    " preper bahavoir for <backspace>

let g:airline_powerline_fonts=1
set laststatus=2

" indentation
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

" autocmd FileType javascript setlocal ts=4 sts=4 sw=4
" autocmd FileType typescript setlocal ts=4 sts=4 sw=4
" autocmd FileType html setlocal ts=4 sts=4 sw=4
" autocmd BufNewFile,BufRead .bowerrc setfiletype json
" autocmd BufNewFile,BufRead *.es6 setfiletype javascript
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" search highlighting
set hlsearch                  " highlight all matches
set incsearch                 " highlight found matches during typing
set ignorecase                " ignore case in all searches...
set smartcase                 " ... unless uppercase letters used

" custom mappings
map  <C-n> ;NERDTreeToggle<CR>
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let mapleader=" "
" fix indentation for whole file
map <Leader>i m]gg=G`]
" safely paste the code (not to let Vim mess with indentation)
map <Leader>p ;set paste<CR>o<esc>"*];set nopaste<cr>
" hide search result highlight
map <Leader>h ;nohl<cr>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,log/,.git,*/node_modules/*

" Open 'alternative file' in split window
map <Leader>v ;AV<cr>

map <Leader>ct ;call GenerateCTags()<cr>

function GenerateCTags()
  " if project is "bundle"-ready
  if !empty(glob("Gemfile")) || !empty(glob("./bundle"))
    execute "!clear;time ctags . --exclude=.git --exclude=log `bundle show --paths`"
  else
    execute "!clear;time ctags . --exclude=.git --exclude=log"
  endif
endfunction

" activate vim-javascript-syntax
" au FileType javascript call JavaScriptFold()

" hint to keep lines short
if exists('+colorcolumn')
  set colorcolumn=80
endif

" swap : with ; for 'faster' commands
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

" and just highlight the match in red...
highlight WhiteOnRed ctermbg=red ctermfg=white
function! HLNext (blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#\%('.@/.'\)'
  let ring = matchadd('WhiteOnRed', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" visual Block mode is far more useful that Visual mode (so swap thecommands)...
nnoremap v <C-V>
nnoremap <C-V> v

vnoremap v <C-V>
vnoremap <C-V> v

map <Leader>sd ;VtrDetachRunner<CR>
map <Leader>f ;VtrFocusRunner<CR>

map <Leader>t ;w<CR>;call RunCurrentTestFile()<CR>
map <Leader>s ;w<CR>;call RunNearestTest()<CR>
map <Leader>l ;w<CR>;call RunLastTest()<CR>
map <Leader>a ;w<CR>;call RunAllTests()<CR>

" Syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

" automatically rebalance windows on vim resize
autocmd VimResized * ;wincmd =

" zoom a vim pane, <C-w>= re-balance
nnoremap <Leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <Leader>= :wincmd =<cr>

" For Fugitive
map <Leader>gd <Leader>- ;Gdiff<CR>
map <Leader>gs ;Gstatus<CR><C-w>K

nnorema <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'irb'}<cr>

let g:gitgutter_sign_column_always = 1
set updatetime=500

" ======== FOR TESTS
function! RunAllTests()
  if !empty(glob("spec"))
    let s:last_test = "spec"
  else
    let s:last_test = "test"
  end
  call s:RunTests(s:last_test)
endfunction

function! RunCurrentTestFile()
  if s:InTestingFile()
    let s:last_test_file = s:CurrentFilePath()
    let s:last_test = s:last_test_file
    call s:RunTests(s:last_test_file)
  elseif exists("s:last_test_file")
    call s:RunTests(s:last_test_file)
  endif
endfunction

function! RunNearestTest()
  if s:InTestingFile()
    let s:last_test_file = s:CurrentFilePath()
    if s:InSpecFile()
      let s:last_test_file_with_line = s:last_test_file . ":" . line(".")
    else
      let s:last_test_file_with_line = s:last_test_file
    end
    let s:last_test = s:last_test_file_with_line
    call s:RunTests(s:last_test_file_with_line)
  elseif exists("s:last_test_file_with_line")
    call s:RunTests(s:last_test_file_with_line)
  endif
endfunction

set rtp+=/usr/local/opt/fzf

function! RunLastTest()
  if exists("s:last_test")
    call s:RunTests(s:last_test)
  endif
endfunction

" ======== LOCALS FOR RUNNING TESTS
function! s:RunTests(test_location)
  if s:InSpecFile(a:test_location)
    let s:test_command_base = "VtrSendCommandToRunner! ./bin/rspec {test_location}"
  elseif s:InMinitestFile(a:test_location)
    let s:test_command_base = "VtrSendCommandToRunner! ./bin/rake test {test_location}"
  elseif s:InTeaspoonSpecFile(a:test_location)
    let s:test_command_base = "VtrSendCommandToRunner! ./bin/rake teaspoon files={test_location}"
  else
    let s:test_command_base = "VtrSendCommandToRunner! ./bin/rspec {test_location}"
  endif
  let s:test_command = substitute(s:test_command_base, "{test_location}", a:test_location, "g")

  execute s:test_command
endfunction

function! s:InSpecFile(...)
  if a:0 > 0
    let location = a:1
  else
    let location = expand("%")
  endif
  return match(location, "_spec.rb") != -1 || match(location, ".feature") != -1
endfunction

function! s:InTeaspoonSpecFile(...)
  if a:0 > 0
    let location = a:1
  else
    let location = expand("%")
  endif
  return match(location, "_spec.js") != -1
endfunction

function! s:InMinitestFile(...)
  if a:0 > 0
    let location = a:1
  else
    let location = expand("%")
  endif
  return match(location, "_test.rb") != -1
endfunction

function! s:InJasmineSpecFile(...)
  if a:0 > 0
    let location = a:1
  else
    let location = expand("%")
  endif
  return match(location, "_spec.js") != -1
endfunction

function! s:InTestingFile()
  return s:InSpecFile() || s:InMinitestFile() || s:InJasmineSpecFile()
endfunction

function! s:TestCommand()
  if s:TestCommandProvided()
    let l:command = g:test_command
  else
    let l:command = s:DefaultTerminalCommand()
  endif

  return l:command
endfunction

function! s:TestCommandProvided()
  return exists("g:test_command")
endfunction

function! s:DefaultTerminalCommand()
  return "!" . s:ClearCommand() . " && echo " . s:default_command . " && " . s:default_command
endfunction

function! s:CurrentFilePath()
  return @%
endfunction

function! s:ClearCommand()
  return "clear"
endfunction

" UltiSnips
" let g:UltiSnipsSnippetsDir='~/.vim/UltiSnips'
" let g:UltiSnipsEditSplit='vertical'
" let g:UltiSnipsExpandTrigger='<tab>'
" let g:UltiSnipsJumpForwardTrigger='<tab>'
" let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

" nnoremap <leader>ue :UltiSnipsEdit<cr>

let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
