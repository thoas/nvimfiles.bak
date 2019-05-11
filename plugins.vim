if has("autocmd")
    au Filetype html,markdown,textile,htmlphp,xml,xsl,rhtml,htmldjango,php source $HOME/.config/nvim/scripts/closetag.vim
endif

let python_highlight_space_errors = 0

let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.egg-info$', '\.egg-link' , '\.retry']
let NERDTreeChDirMode = 2
let NERDTreeSortOrder = ['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks = 1

autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd FocusGained * call s:UpdateNERDTree()
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

let g:NERDTreeWinPos = "left"
let NERDTreeWinSize=35

noremap <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>
nnoremap <silent> <F9> :NERDTreeToggle<CR> :NERDTreeMirror<CR>

nmap <leader>x <Plug>ToggleAutoCloseMappings

noremap <leader>t :TagbarToggle<CR>
noremap <D-S-T> :TagbarToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>

" Fugitive {
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>
nnoremap <silent> <leader>gp :Gpush<cr>
nnoremap <silent> <leader>ga :Gadd<cr>
nnoremap <silent> <leader>gco :Gcheckout<cr>
nnoremap <silent> <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END
" }

" autocmd! BufWritePost * Neomake
" let g:neomake_error_sign   = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
" let g:neomake_warning_sign = {'text': '⚠', 'texthl': 'NeomakeWarningSign'}
" let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
" let g:neomake_info_sign    = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
" let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
" let g:neomake_go_gometalinter_maker = {
"   \ 'args': [
"   \   '--tests',
"   \   '--enable-gc',
"   \   '--concurrency=3',
"   \   '--fast',
"   \   '-D', 'aligncheck',
"   \   '-D', 'dupl',
"   \   '-D', 'gocyclo',
"   \   '-D', 'gotype',
"   \   '-E', 'errcheck',
"   \   '-E', 'misspell',
"   \   '-E', 'unused',
"   \   '%:p:h',
"   \ ],
"   \ 'append_file': 0,
"   \ 'errorformat':
"   \   '%E%f:%l:%c:%trror: %m,' .
"   \   '%W%f:%l:%c:%tarning: %m,' .
"   \   '%E%f:%l::%trror: %m,' .
"   \   '%W%f:%l::%tarning: %m'
"   \ }
" let g:neomake_python_flake8_args = neomake#makers#ft#python#flake8()['args'] + ['--ignore=E501']

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

let g:deoplete#enable_at_startup = 1
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ['buffer', 'member', 'tag', 'file', 'neosnippet']
let g:deoplete#sources#go#sort_class = ['func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#jedi#python_path = '/Users/thoas/.pyenv/versions/neovim3/bin/python'


" Use partial fuzzy matches like YouCompleteMe
call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
call deoplete#custom#set('_', 'converters', ['converter_remove_paren'])
call deoplete#custom#set('_', 'disabled_syntaxes', ['Comment', 'String'])

let g:go_info_mode = 'gocode'
let g:go_def_mode='gopls'
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 0
let g:go_snippet_engine = "neosnippet"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1

let g:go_metalinter_command = ""
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_enabled = [
    \ 'deadcode',
    \ 'errcheck',
    \ 'gas',
    \ 'goconst',
    \ 'gocyclo',
    \ 'golint',
    \ 'gosimple',
    \ 'ineffassign',
    \ 'vet',
    \ 'vetshadow'
\]

let g:go_addtags_transform = "snakecase"

" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
let g:ale_python_flake8_args="--ignore=E501"
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_linters = {'python': ['flake8'], 'javascript': ['eslint'], 'go': ['go build']}
let g:ale_go_langserver_executable = 'gopls'


nmap <silent> <F6> <Plug>(ale_previous_wrap)
nmap <silent> <F7> <Plug>(ale_next_wrap)

noremap <leader>t :TagbarToggle<CR>
noremap <D-S-T> :TagbarToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>

imap <C-n>     <Plug>(neosnippet_expand_or_jump)
smap <C-n>     <Plug>(neosnippet_expand_or_jump)
xmap <C-n>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets'

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
au FileType go nmap <leader>gt :GoDeclsDir<cr>
au FileType go nmap <leader>gdv <Plug>(go-def-vertical)
au FileType go nmap <leader>gdh <Plug>(go-def-horizontal)
au FileType go nmap <leader>gD <Plug>(go-doc)
au FileType go nmap <leader>gDv <Plug>(go-doc-vertical)

let g:vim_json_syntax_conceal = 0
let g:jsx_ext_required = 0

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'],
      \             [ 'fugitive', 'filename', 'modified' ],
      \             [ 'go'] ],
      \   'right': [ [ 'lineinfo' ], 
      \              [ 'percent' ], 
      \              [ 'readonly', 'linter_warnings', 'linter_errors', 'linter_ok' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'go'] ],
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ 'component_function': {
      \   'lineinfo': 'LightLineInfo',
      \   'percent': 'LightLinePercent',
      \   'modified': 'LightLineModified',
      \   'filename': 'LightLineFilename',
      \   'go': 'LightLineGo',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'fugitive': 'LightLineFugitive',
      \ },
      \ }

function! LightLineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction
function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction
function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineInfo()
  return winwidth(0) > 60 ? printf("%3d:%-2d", line('.'), col('.')) : ''
endfunction

function! LightLinePercent()
  return &ft =~? 'vimfiler' ? '' : (100 * line('.') / line('$')) . '%'
endfunction

function! LightLineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightLineGo()
  " return ''
  return exists('*go#jobcontrol#Statusline') ? go#jobcontrol#Statusline() : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  if mode() == 't'
    return ''
  endif

  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]')
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
let g:ctrlp_buftag_types = {'go' : '--language-force=go --golang-types=ftv'}

func! MyCtrlPTag()
  let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
        \ 'AcceptSelection("t")': ['<c-t>'],
        \ }
  CtrlPBufTag
endfunc
command! MyCtrlPTag call MyCtrlPTag()

let g:table_mode_corner='|'
