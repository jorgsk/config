" first of all point to anaconda python installation
let g:python3_host_prog = '/Users/jorgens/miniconda3/bin/python'
"
" Set mapleader to semicolion
let mapleader =";"

call plug#begin('~/.vim/plugged')

" Tag navigation that is .git aware
Plug 'ludovicchabant/vim-gutentags'
" Don't make tags for common non-code files
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml', '.mypy_cache', '*.md', '*.MD', '*.txt']

" Use the built in lsp!
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_ignore_case = 1

" The LSP doesn't give good highlighting so use semshi for now 
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Smooth scrolling?
Plug 'joeytwiddle/sexy_scroller.vim'

" Better syntax highlighting for pandoc
Plug 'vim-pandoc/vim-pandoc-syntax'

" Make sure that markdown is associated with markdown.pandoc
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

" Test vim-test :)
Plug 'vim-test/vim-test'
let test#strategy = "kitty"
nnoremap <silent> <leader>t :TestSuite<CR>

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
call vimtex#imaps#add_map({
  \ 'lhs' : '<C-i>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate"],
  \})
" snippets (e.g. for latex environments) require a snippet plugin
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine.
Plug 'honza/vim-snippets'

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-v>"

" Nice buffer bar on top with icons.
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Move to previous/next
nnoremap <silent> <C-h> :BufferPrevious<CR>
nnoremap <silent> <C-l> :BufferNext<CR>
nnoremap <silent> <C-x> :BufferClose<CR>

let bufferline = {}
let bufferline.icons = v:true

" Try this to avoid losing the cursor
Plug 'danilamihailov/beacon.nvim'

" Visual debugging in nvim? Yes please :D
" So far I can't get it to work, but it holds great promise.
"Plug 'puremourning/vimspector'
"let g:vimspector_enable_mappings = 'HUMAN'

" Really cool plugin for sending text lines to e.g. ipython
Plug 'jpalardy/vim-slime', { 'for': 'python' }
" screen is default, change to tmux
let g:slime_target = 'tmux'
"
" fix paste issues in ipython
let g:slime_python_ipython = 1
"" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
" Use '##' to define cells instead of using marks
let g:ipython_cell_delimit_cells_by = 'tags'
"
" map <Leader>r to run script
nnoremap <Leader>r :w<CR>:IPythonCellRun<CR>
nnoremap <Leader>R :w<CR>:IPythonCellRunTime<CR>
nnoremap <Leader>l :IPythonCellClear<CR>
" map <Leader>x to close all Matplotlib figure windows
nnoremap <Leader>mx :IPythonCellClose<CR>
" map <Leader>h to send the current line or current selection to IPython
nmap <Leader>h <Plug>SlimeLineSend
xmap <Leader>h <Plug>SlimeRegionSend
" map <Leader>q to clear IPython screen
nnoremap <Leader>q :SlimeSend1 quit<CR>
" map <Leader>i to run ipython
nnoremap <Leader>i :SlimeSend1 ipython<CR>
" map <Leader>I to restart ipython
nnoremap <Leader>I :IPythonCellRestart<CR>

" color scheme
Plug 'mhartington/oceanic-next'

let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
" Indent like a boss
Plug 'hynek/vim-python-pep8-indent'

" Working with brackets
Plug 'Raimondi/delimitMate'
imap <C-j> <Plug>delimitMateS-Tab
nmap <C-j> <Plug>delimitMateS-Tab


"""""""""""""""""""""""""" EnhancedCommentify """"""""""""""""""""
Plug 'hrp/EnhancedCommentify'
" Selecting mode for the the EnhancedCommentify script
let g:EnhCommentifyUserMode = 'yes'
let g:EnhCommentifyTraditionalMode = 'no'
let g:EnhCommentifyFirstLineMode = 'no'
let g:EnhCommentifyUserBindings = 'no'
let g:EnhCommentifyRespectIndent = 'Yes'

" Nice colors
Plug 'chriskempson/base16-vim'

" Let's get some quick project navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Jump if single tag is found otherwise open rg
function! FzfTagsCurrentWord()
  let l:word = expand('<cword>')
  call fzf#vim#rg(l:word)
  endif
endfunction
"search for git tracked files (use :Files for all files)
noremap <C-f> :GFiles <CR>
"search for text in git tracked files
noremap <C-s> :Rg <C-R>=expand("<cword>")<CR><CR>
noremap <C-space> :Rg  <CR>

"format the rest of the paragraph and return (using this for latex all the time)
nmap <leader>fp gq}<CR><C-o>

" switch current directory to git project root, gives search across all files
Plug 'airblade/vim-rooter'
let g:rooter_manual_only = 1

call plug#end()
" Fortran defaults
let fortran_free_source=1
let fortran_do_enddo=1
let fortran_have_tabs=1
let fortran_more_precise=1


"""""""""" LSP CONFIGURATION """""""""""""""""""
" Does this need to come after plug?
set completeopt-=preview

" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype fortran setlocal omnifunc=v:lua.vim.lsp.omnifunc

" some shortcuts
" this lets you use lsp-navigation for python and fortran and fall back to tags for c/cpp/others
autocmd FileType python,fortran nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>

set completeopt=menuone,noinsert,noselect

"Fortran setup from https://github.com/neovim/nvim-lspconfig/issues/219#
lua << EOF
local on_attach_vim = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
end
require'nvim_lsp'.fortls.setup{
    on_attach = on_attach_vim,
    cmd = {
        'fortls',
        '--symbol_skip_mem',
        '--incrmental_sync',
        '--autocomplete_no_prefix',
        '--autocomplete_name_only',
        '--debug_log',
    }
}
require'nvim_lsp'.pyls.setup{on_attach = on_attach_vim,
                             settings = {
                               pyls = {
                                  plugins = {
                                       pyls_mypy = {enabled=true;}
                                       }
                                   }
                                 }
                              }
local util = require 'nvim_lsp/util'
require'nvim_lsp'.sourcekit.setup{on_attach = on_attach_vim,
                                    cmd = {"sourcekit-lsp"},
                                    root_dir = util.root_pattern('.git')
                                    }
EOF
let g:diagnostic_enable_underline = 1
let g:diagnostic_auto_popup_while_jump = 1
let g:diagnostic_insert_delay = 1

" get diagnostic popup without using :NextDiagnostic
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
set updatetime=250  " cursorhold used updatetime, defaults to 4000 ms
" then we can disable the virtual text
let g:diagnostic_enable_virtual_text = 0
"
"""""""""" END LSP CONFIGURATION """""""""""""""""""

" Map space to space in normal mode
nnoremap <space> i<space><ESC>

""" Indentation
set shiftwidth=4 "how many columns to shift when using >> and <<
set expandtab "tab will produce spaces
set tabstop=4 "tab=4 columns (=4 spaces with expandtab on)"

" Change between most recent buffers with F12 
nnoremap <F12> :b#<CR>
inoremap <F12> <ESC>:b#<CR>

" quick adding of quotes to word
nnoremap <C-q> ciw''<Esc>P

" Autocompete file paths with control-p
imap <C-p> <C-X><C-F>

" Global substitute with 'gs'  
map gs :%s/

" Multiple replacements per line for gods sake
set gdefault

" Switch between buffers without saving
set hidden

" Use python 3.7+ and pdb++
nnoremap <leader>D obreakpoint()<ESC>:w<CR>
" Spell settings
" Use zi to pick the first suggested word and go to the next 'red' word!
nmap zi 1z=]s
" Only suggest 5 words with z= during spellcheck
set spellsuggest=5
" Set spell/nospell with F4
imap <F4> <ESC>:setlocal spell!<CR>
nmap <F4> <ESC>:setlocal spell!<CR>

" Vim statusline
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%04l,%04v][%p%%]\ [LEN=%L]\ %r
set laststatus=2

" Enough with the search highlighting
set nohlsearch
"

" Enable copy paste to windows apps
set clipboard=unnamedplus
" Enable visual selection to clipboard
set go+=a

" Use F2 and control l/h to better view CSV files
" enable/disable scrollbar and nowrap at the same time
nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"
""
" Make sure the cursor stays in the middle of the screen when scrolling up and
" down. Avoids having to go all the way to the bottom to scroll down.
set scrolloff=1000
set textwidth=100

if (has("termguicolors"))
    set termguicolors
endif


colorscheme OceanicNext
