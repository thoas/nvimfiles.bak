call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'fatih/vim-go', { 'tag': 'v1.14' }
Plug 'pangloss/vim-javascript'
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-unimpaired'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'othree/html5.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-haml'
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'sbdchd/neoformat'
Plug 'elzr/vim-json'
Plug 'ambv/black',
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar', { 'tag': 'v2.6.1' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle', 'tag': '5.0.0' }
Plug 'mxw/vim-jsx'
Plug 'zchee/deoplete-jedi'
Plug 'tweekmonster/nvim-checkhealth'
Plug 'carlitux/deoplete-ternjs'
Plug 'ekalinin/Dockerfile.vim'
Plug 'chase/vim-ansible-yaml'
Plug 'ctrlpvim/ctrlp.vim'
function! DoRemote(arg)
      UpdateRemotePlugins
  endfunction
  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-go', { 'do': 'make'}
call plug#end()


source $HOME/.config/nvim/settings.vim
source $HOME/.config/nvim/autocmd.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/map.vim
