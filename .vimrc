
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
		finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set history=50    " keep 50 lines of command line history
set ruler    " show the cursor position all the time
set showcmd    " display incomplete commands
set incsearch    " do incremental searching

fu! SpellPTBROnOff()
		if !exists('g:spellptbr')
				let g:spellptbr=1 | setlocal spell spelllang=pt
				echo "correção ortográfica para pt_br"
		else
				unlet g:spellptbr | setlocal nospell
				echo "desativando correção ortográfica para pt_br"
		endif
endfu
map <F8> :call SpellPTBROnOff()<cr>

setlocal spell spelllang=
fu! SpellOnOff()
		if !exists('g:spell')
				let g:spell=1 | setlocal spell spelllang=en_us
				echo "spell checking for en_us"
		else
				unlet g:spell | setlocal nospell
				echo "disabling spell checking for en_us"
		endif
endfu
map <F7> :call SpellOnOff()<cr>

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
		syntax on
		set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

		" Enable file type detection.
		" Use the default filetype settings, so that mail gets 'tw' set to 72,
		" 'cindent' is on in C files, etc.
		" Also load indent files, to automatically do language-dependent indenting.
		filetype plugin indent on

		" Put these in an autocmd group, so that we can delete them easily.
		augroup vimrcEx
				au!

				" For all text files set 'textwidth' to 78 characters.
				autocmd FileType text setlocal textwidth=78

				" When editing a file, always jump to the last known cursor position.
				" Don't do it when the position is invalid or when inside an event handler
				" (happens when dropping a file on gvim).
				autocmd BufReadPost *
										\ if line("'\"") > 0 && line("'\"") <= line("$") |
										\   exe "normal g`\"" |
										\ endif

		augroup END

else

		set autoindent    " always set autoindenting on

endif " has("autocmd")

" zero configs :-)
set nowrap
set number
set showmatch
set title
set tabstop=2
set shiftwidth=4
set softtabstop=4
set expandtab
syntax on
syntax enable
set background=dark

" comeca vim com mouse desabilitado
" set mouse=

" Navegar Entre as Tabs
:nmap <C-t>  :tabnew .    <CR>
":nmap <esc><C-x>  :tabclose    <CR>
":nmap <C-a><RIGHT>  :tabnext    <CR>
":nmap <C-a><LEFT>  :tabprevious  <CR>
"
"Gambiarras com tags!
: nmap <C-b> :pop <cr>

" Quando abrir um qualquercoisa.sh automativcamente adiciona um #!/bin/bash na
" primeira linha do arquivo
autocmd BufNewFile *.sh execute "normal I#/bin/bash\<C-M>\<C-M>"

" Ajusta autocomplete com menu que visualiza opcoes
set wildmenu
set wildmode=full
set wildmode=longest,list:full

" Habilita e desabilita o mouse
fu! MouseOnOff()
		if !exists('g:setmouse')
				let g:setmouse=1 | set mouse=a
				echo "mouse ON"
		else
				unlet g:setmouse | set mouse=
				echo "mouse OFF"
		endif
endfu
"set mouse=a
"let g:setmouse=1
map <F2> :call MouseOnOff()<cr>

" Desabilitar o arquivo de swp
" By: Ursula
set nobackup
set nowb
set noswapfile

"" Algumas porcarias quando usar gvim
if has("gui_running")
		"colorscheme solarized
		colorscheme lettuce
		"set toolbar=
		set go=
    set guifont=Monospace\ 8
		highlight Visual guibg=grey30
		highlight StatusLine guifg=Black guibg=grey20

		" realcar a linha atual
		set cul
		hi cursorline guibg=grey10
else
		"colorscheme solarized
		colorscheme lettuce

		highlight StatusLine guifg=White guibg=Blue
endif


" show the name of the function whre the cursor is
":cfname
fu! SplitCurrentScreen()
    :Highlight 1 <cr>
    :Hsave
    :vsplit
    :Hrestore
    :exec "normal \<c-w>\<c-w>"
    :exec "normal \<c-]>"
    " :let g:word = expand("<cword>")
    ":tag . g:word
endfu
map <c-\> :call SplitCurrentScreen() <CR>



fu! Goto_tag_on_another_tab()
		:exec "normal \<c-w>\<c-]>"
		:exec "normal \<c-w>\<s-t>"
endfu

" Taglist
:map <C-k> :TlistToggle <CR>

" open tags on another tab
map <c-w>}  :call Goto_tag_on_another_tab() <cr>

set showfulltag

"status line:
highlight Pmenu guifg=white guibg=DodgerBlue4 gui=bold
highlight Pmenu ctermfg=white ctermbg=blue cterm=none
highlight PmenuSel ctermfg=blue ctermbg=white term=bold
highlight StatusLine term=bold
let g:ctags_title=1	      " To show tag name in title bar.
let g:ctags_statusline=1	" To show tag name in status line.
let generate_tags=1
"set statusline=%F:%l\ %m
"set statusline=%<%F\ %m\ %r\ -\ \[%l,%c\]\ -\ %p
"set laststatus=2

"melhores buscas
set ignorecase
set smartcase

" Busca no manual php on-line (K) by edjr :-)
"autocmd FileType php set keywordprg=/dados/programas/scripts/search_php_manual.sh

" Plugin para python.
"au FileType python source /usr/share/vim/vimfiles/ftplugin/python/python.vim

hi TabLine ctermbg=white ctermfg=black
hi TabLineSel ctermbg=black  ctermfg=white

if $TERM =~ '^xterm'
		set t_Co=256
elseif $TERM =~ '^screen-bce'
		set t_Co=256
elseif $TERM =~ '^rxvt'
		set t_Co=256
elseif $TERM =~ '^linux'
		set t_Co=8
else
		set t_Co=16
endif

if has("cscope")
		set csprg=/usr/bin/cscope
		set csto=0
		set cst
		set nocsverb
endif

:map <C-a>m			:make<cr>
:map <C-a>i			:make && make install<cr>

"TESTING THE AUTOCOMPLETE PLUGIN
let did_ftplugin_after = 1
