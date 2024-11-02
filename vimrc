" Go to last position when reopening a file:
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

syntax on

set ignorecase
set smartcase           " With ignorecase on, typing a mixed-case search will do case-sensitive.
set nowrapscan          " Don't automatically wrap to the start of the file when hitting the end in search
set shiftwidth=2        " I mostly use vi for editing scripts, not C++, so indent by 2
set tabstop=8
set autoindent
set textwidth=0
set expandtab           " Insert spaces when tab key is pressed
set showmatch           " Highlight matching brace, paren, etc.
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set number              " Show line numbers.
set wrap

set backup
set backupdir=~/.vim/backup
set backupskip=~/.vim/backup/*
set directory=~/.vim/workdir
set writebackup
" New for vim 7.4
set undodir=~/.vim/undodir
set hlsearch

set enc=utf-8
set fileencoding=utf-8

" ]s           Move to next misspelled word after the cursor.
" [s           Move to prev misspelled word before the cursor.
" z=           For the word under/after the cursor, suggest correctly spelled words.
" zg           Add word under the cursor as a good word
"set spell

" Functions to add current timestamp after the current line.
function! AddShortTime()
  put = ''
  put = strftime('%m.%d %H:%M')
  put = '==========='
  put = ''
  put = ''
  startinsert
endfunction

function! AddLongTime()
  " Tuesday, June 28, 2022 10:28 AM
  let d = strftime('%A, %B %d, %H:%M')
  let u = '=================================================='
  put = ''
  put = d
  put = u[0:len(d)-1]
  put = ''
  put = ''
  startinsert
endfunction

nnoremap <F5> :<C-U>call AddShortTime()<CR>
nnoremap <F6> :<C-U>call AddLongTime()<CR>

" If we're editing a journal file (e.g. 202210.txt), turn on AutoSave.
let fn = expand("%:t")
if fn =~ '[0-9][0-9][0-9][0-9][0-9][0-9]\.txt'
  let g:auto_save = 1
endif
