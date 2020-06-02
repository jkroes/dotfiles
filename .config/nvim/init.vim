"let $NVIM_COC_LOG_LEVEL = 'debug'

" Initialize vim-plug --------------------------------------------------------

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" List of plugins ------------------------------------------------------------

call plug#begin()
    " Motions
    " Plug 'tpope/vim-surround'
    " Git support
    "Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Needed to download vim-plug docs (:h plug)
    Plug 'junegunn/vim-plug'
    " Color scheme
    Plug 'drewtempelmeyer/palenight.vim'
    " Comments
    Plug 'preservim/nerdcommenter'
    " Undo/redo visualization
    Plug 'mbbill/undotree'
    " Fuzzy finder/dispatcher
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
    " Plug 'jkroes/vim-clap', { 'do': ':Clap install-binary!' }
        "Plug 'ryanoasis/vim-devicons'
    " Shortened keymaps
    Plug 'jkroes/tinykeymap'
    " Notes
    Plug 'vimwiki/vimwiki'
    " Terminal buffer and REPLs
    Plug 'jkroes/neoterm'
    Plug 'jkroes/vim-floaterm'
    " General R support
    Plug 'jalvesaq/Nvim-R'
    " Completion
    Plug 'ncm2/ncm2'
        " RStudio-like completion
        Plug 'gaalcaras/ncm-R'
            Plug 'roxma/nvim-yarp'
            " Also depends on nvim-R
        " Python
        " Plug 'ncm2/ncm2-jedi'
        " Syntax files
        " Plug 'ncm2/ncm2-syntax'
        " Plug 'Shougo/neco-syntax'
        " Filepaths
        " Plug 'ncm2/ncm2-path'
        " GitHub repos
        " Plug 'ncm2/ncm2-github'
        " Words from other buffers
        " Plug 'ncm2/ncm2-bufword'
    " General autocompletion (specifically chosen for Python)
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " Python completion
        " " Viml completion
        Plug 'neoclide/coc-neco'
            " coc-neco dependencies
            Plug 'Shougo/neco-vim'
call plug#end()

" Install missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    " PlugInstall --sync | q
    PlugInstall --sync " Temporary until testing is finished
endif

" TODO: Research coc.nvim, nvim-R, python-mode, and coc-r-lsp. E.g., use the
" latter to enable signatures, which are missing from nvim-R but keep
" completion disabled. Also see vim-pythonsense, vim-python-pop3-indent, and
" vim-indent-object.

" Options --------------------------------------------------------------------

" Enable syntax highlighting, load filetype-specific plugins, and enable
" filetype-based indentation
filetype plugin indent on
syntax enable

" Copy indentation from previous line (unless overriden by indentexpr for the
" active filetype)
set autoindent
set nosmartindent
set nocindent

" Enable hard wrapping (line breaking) of text and comments at textwidth
set fo+=tc
" Disable automatic comment delimiter insertion when starting a new line below a
" comment. This is because <tab> doesn't account for leading columns taken up by
" comment delimiters/spacing. It is better to write a comment with whatever
" indentation or tabbing is desired, then comment the lines out using
" nerdcommenter.

" TODO: Check each filetype to see how fo is set and whether those settings are
" required by filetype plugins. Some plugins change the fo option locally.
set fo-=ro

" Tab characters are variable width. Pressing tab normally inserts a tab
" character, which is displayed as the distance between the cursor and the
" next column that is a multiple of the tabstop. Thus, changing tabstop
" changes the number of columns used to display existing tab characters.

" When expandtab is not set (noexpandtab) but shiftwidth and softtabstop are
" set, indentation and <TAB> insert a mixture of spaces and tab characters,
" based on the the values of these options relative to tabstop.  Deletion
" similarly deletes whatever is inserted as if the tab-space mixture were a
" single tab character. Setting these equal to tabstop is equivalent to
" unsetting them.

" When expandtab is set, only spaces are inserted for indentation and <TAB>
" presses. To replace existing tabs with spaces, use :retab

" Note that <tab> moves to the nearest tabstop (or softtabstop) multiple,
" while >> and similar indentation commands move a fixed distance.
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
set nosmarttab

" Switch/hide buffers without prompting for save
set hidden

" Absolute line numbers in gutter
set number

" Keep folds open by default (toggle with zi)
set nofoldenable

" Unhighlight search results on escape or enter
" Navigate highlighted results with C-g/C-t
" See `augroup vimrc-incsearch-highlight`
set incsearch

" Match all cases with lowercase in search queries, unless uppercase is
" included in the query
set ignorecase
set smartcase

" Change what Vim considers to be a word and thus results of commands like *
" TODO: Make this filetype-speficic (e.g., include <> for html?)
set iskeyword+=-

" Where to place the new window upon split
set splitbelow
set splitright

" Set which horizontal movements can cross lines
set whichwrap+=b,<,>,h,l,[,]

" Show tabfeed chars as >-------
set list
set listchars=tab:>-

" Break lines at textwidth
set textwidth=80

" Disable file backups. Rely on Git for backups.
set nobackup
set nowritebackup

" Increase height of cmdline to accommodate long messages
set cmdheight=2

" Can slow down completion. Recommended value by coc.nvim README
set updatetime=300

" Avoid messages related to completion popup
" NOTE: Disable this when debugging completion
set shortmess +=c

" Enable 256-bit color in supporting terminals (not GUIs)
" iTerm2 supports 256-bit color and sets $COLORTERM
" :h term.txt
if $COLORTERM == 'truecolor'
            \ && has('termguicolors')
        set termguicolors
endif
" Not all colorschemes support dark, but current one does
set background=dark
colorscheme palenight

" Highlight current line
" Will slow down screen redrawing, so disable if typing or moving becomes too
" slow.
" set cursorline

" Environment variables ------------------------------------------------------

" Add user-installed Python binaries (like Jedi and nvr) to $PATH within vim
" Note that this only affects $PATH within vim
" let $PATH = expand('~/.local/bin').':' . $PATH

" nvr ---------------------------------------------------------------------

" NOTE: Use :w | bd to exit git commit buffers or add this to init.vim to
" enable :wq. If this isn't enabled, toggling the terminal after running
" git commit within it will show that the command is still waiting for the
" buffer to be deleted.
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

" NOTE: This must be in the vimrc, not the shell config, to avoid spawning a
" nested nvim process.
let $GIT_EDITOR = 'nvr --remote-wait'

" Mappings ----------------------------------------------------------------
let g:mapleader = "\<Space>"
let g:maplocalleader = ";"
inoremap kj <ESC>
nnoremap <Leader>; :<c-u>set hls!<CR>

" Abbreviations --------------------------------------------------------------
" Expand :h<SPC> to :tab help
"cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

" Autocommands ---------------------------------------------------------------

" Remove trailing whitespace on write
autocmd BufWritePre * %s/\s\+$//e

" Only highlight during incremental search
" See `set incsearch`
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Plugin configuration -------------------------------------------------------

" Usage:
" In normal mode:
" <Leader>cc       Comment line or selection
" <leader>cu       Uncomment line or selection

" <Leader>c<space> Toggle comment (based on topmost line)
" <leader>ci       Invert the commented state of each selected line

" <leader>cl       Comment line or selection and align delimiters left
" <Leader>cn       Comment line or selection with forced nesting

" <leader>cA       Append comment delimiter to EOL and enter insert mode
" <leader>c$       Comment from cursor to EOL

" In insert mode:
" C-c              Insert a comment delimiter (with space) and move cursor

" NOTE: If relying on <tab> or >> to indent lines when adding to a commented
" block of code, it is best to write the code, then comment it out. <tab> does
" not take into account leading comment delimiters. I attempted a fix in the
" init archive wiki, but it is unfinished.
if has_key(g:plugs, 'nerdcommenter')
    " Disabling this requires <leader>cn to nest comments explicitly rather
    " than by default. If NERDDefaultAlign and NERDDefaultNesting are both
    " disabled, then there is no way to align and nest comments. Enabling
    " auto-nested comments allows for smooth uncommenting of blocks containing
    " both comments and code.
    let NERDDefaultNesting = 1
    " NOTE: 'none' leads to issues with some autoformatters changing the
    " indentation of commented code to force delimiter alignment (e.g., black
    " for Python). Avoid 'none' for autoformatted filetypes.
    " 'none': Insert '# ' at start of each line's non-space text
    " 'left': Insert '# ' and align based on least indented line
    " 'start': Insert '# ' at start of each line
    let NERDDefaultAlign = 'left'
    " Disable to comment selection, not entire line. Allows different results
    " for char, block, and line-based visual modes
    let NERDCommentWholeLinesInVMode = 0
    " In visual-block mode, don't comment lines that are indented beyond
    " selection. Can be used to comment out a function def but not its body.
    let NERDBlockComIgnoreEmpty = 1
    " Add a space after comment delimiters when commenting
    let NERDSpaceDelims = 1
    " Removes space after comment delimiters when uncommenting
    let NERDRemoveExtraSpaces = 1
    " Not necessary if you have an autocmd to remove all lines' trailing ws
    let NERDTrimTrailingWhitespace = 0
    " Toggle comment (<leader>c<space>) based on top line of selection rather
    " than whether any selected line is uncommented
    let NERDToggleCheckAllLines = 0

    " Normal mode mappings are listed in the vim init archive wiki
    imap <C-c> <plug>NERDCommenterInsert
endif

" Anything inserted between entering and exiting insert mode counts as a
" single change by default. Insertion can be broken into smaller units by remapping
" insert-mode keys to, e.g., the same keys prefixed by c-g u. E.g., remapping
" <c-r> results in per-line changes.
" Base undo relies on u and c-r to navigate the current undo branch. It
" ignores other branches. Each node in the tree has a temporal order that can
" be navigated by g+/g- (equivalent to 'move to next/pervious state'). If
" g+/g- lands you on another branch, then u/c-r will now operate from that
" branch to the start of the undo history. This is best visualized with undo-tree.
" In fact, undotree can be navigated from the file it is visualizing simply
" through these shortcuts. The only new functionality it introduces is the
" ability to move between saved states--an extension of g-/g+. I don't
" necessarily save at logical points, and the diff is almost always overkill,
" so I am using treeundo for its visual, disabling diff, and ignoring the new
" keybindings. I can hold down u and c-r for rapid movememnt, then use g-/g+
" if I need branch switching (i.e., if I realize a previous undo was a
" mistake).
" The documentation doesn't show it, but a call to UndotreeShow if it's active
" focuses the window. Then <tab> can be hit to return to the target window.
if has_key(g:plugs, 'undotree')
    let g:undotree_WindowLayout = 4
    let g:undotree_DiffAutoOpen = 0
    "let g:undotree_SetFocusWhenToggle = 1 " Focus buffer so keybindings work
    let g:undotree_RelativeTimestamp = 1 " Useful for :earlier and :later
    let g:undotree_ShortIndicators = 1 " Abbreviated relative time units
    " Useful in combination with signcolumn, though not documented.
    " let g:undotree_HighlightChangedText = 1 " Only active if diff window is open
    let g:undotree_SplitWidth = 30

    " Stolen from |clear-undo|
    " Couldn't get <plug>ClearHistory working, so I replaced it...
    function! ClearHistory()
        let old_undolevels = &undolevels
        set undolevels=-1
        exe "normal a \<BS>\<Esc>"
        let &undolevels = old_undolevels
        unlet old_undolevels
        " TODO: If a window in current tab has filetype undotree, run UntoreeShow after UndotreeHide
        UndotreeHide " Need to close buffer for it to show cleared history
    endfunction
    command! -nargs=0 ClearHistory call ClearHistory()

    nmap <leader>uc :<c-u>ClearHistory<CR>
    nmap <leader>us :<c-u>UndotreeShow<CR>
    nmap <leader>uh :<c-u>UndotreeHide<CR>
endif

" Usage:
" Within a provider (any of these Clap commands):
"     C-c exits these commands
"     C-l opens the providers list
"     Open files via <CR> (edit), C-x, C-t, or C-v
"     C-u clears input (insert mode)
"     Shift-Tab opens action menu if it exists
" Within Clap maps:
"     Use <space> instead of <leader> to search <leader> mappings
if has_key(g:plugs, 'vim-clap')
    noremap <Leader><leader> :<c-u>Clap buffers<CR>
    " Fuzzy /
    noremap <Leader>fl :<c-u>Clap blines<CR>
    " Fuzzy / in multiple buffers
    noremap <Leader>fL :<c-u>Clap lines<CR>
    noremap <Leader>fc :<c-u>Clap command<CR>
    noremap <Leader>f: :<c-u>Clap hist:<CR>
    noremap <Leader>f/ :<c-u>Clap hist/<CR>
    noremap <Leader>fk :<c-u>Clap maps<CR>
    " Most recently used files
    noremap <Leader>fm :<c-u>Clap history<CR>
    " Edit .fdignore to filter results (e.g., exclude .git)
    noremap <Leader>ff :<c-u>Clap files ++finder=fd --type f --hidden --no-ignore-vcs .<CR>
    noremap <Leader>fg :<c-u>Clap grep2<CR>
    noremap <Leader>fh :<c-u>Clap help_tags<CR>
    " https://medium.com/breathe-publication/understanding-vims-jump-list-7e1bfc72cdf0
    noremap <Leader>fj :<c-u>Clap jumps<CR>
    noremap <Leader>fR :<c-u>Clap registers<CR>
    noremap <Leader>fy :<c-u>Clap yanks<CR>

    " Filter out help files from results of :Clap history
    autocmd VimEnter * call filter(v:oldfiles, 'v:val !~ ".*/doc/.*\.txt"')

    " Run file/grep/git* providers at project root instead of pwd
    let g:clap_disable_run_rooter = 0
    " Enable normal mode in provider buffer/window
    let g:clap_insert_mode_only = 0
endif

if has_key(g:plugs, 'vim-floaterm')
    noremap <leader>r :<c-u>FloatermNew ranger<cr>
    " TODO: Find a way to make these buffer-local to ranger.
    " TODO: Why did ranger bindings to nvr ultimately fail?
    " TODO: Integrate with neoterm or provide equivalent functionality

    " Bindings for ranger process
    au filetype floaterm call SetFloatermMappings()
    function! SetFloatermMappings()
        tnoremap <c-x> <cmd>let g:floaterm_open_command = 'split'  \| call feedkeys("l")<CR>
        tnoremap <c-v> <cmd>let g:floaterm_open_command = 'vsplit'  \| call feedkeys("l")<CR>
        tnoremap <c-t> <cmd>let g:floaterm_open_command = 'tabe'  \| call feedkeys("l")<CR>
    endfunction

    " Set this before invoking floaterm to prevent accidentally altering this
    " variable's value outside of floaterm ranger. Note that any changes to
    " floaterm_open_command must be done prior to the following line for the
    " change to be reflected in floaterm ranger. See
    " /config/nvim/plugged/vim-floaterm/autoload/floaterm/wrapper/ranger.vim
    autocmd VimEnter * let g:floaterm_open_command_copy = g:floaterm_open_command

    let g:floaterm_width = 0.9
endif

" Usage:
" Invoke the windows map (<leader>w)
" For help, press ?
" For slow repeat commands (>, <, +, -), use a numeric prefix
"     Use a large prefix to mostly hide windows temporarily
if has_key(g:plugs, 'tinykeymap')
    if has_key(g:plugs, 'vimwiki')
        let g:vimwiki_map_prefix = '<leader>v'
    endif
    let g:tinykeymap#conflict=4
    let g:tinykeymap#timeout = 0
    let g:tinykeymap#map#windows#map = "<leader>w"
endif
" TODO: Edit source to filter any keys not within the keymap. Or remap all
" unlisted keys to whatever no action would be, temporarily.

" vimwiki: Note taking
" |vimwiki-options| recommends setting options prior to sourcing
" !!!plugin/vimwiki.vim. Does vim-plug auto-source this file? See |autoload|
" and whether it answers this.!!!
"autocmd FileType vimwiki set ft=markdown
" https://vimwiki.github.io/vimwikiwiki/
if has_key(g:plugs, 'vimwiki')
    " Individual wiki configuration
    let w2 = {}
    let w2.path = '~/vimwiki'
    let w2.syntax = 'markdown'
    let w2.ext = '.Rmd'
    " let w2.index = '_index'
    let g:vimwiki_list = [w2]

    " Use nvim-r with vimwiki
    if has_key(g:plugs, 'Nvim-R') && w2.ext == '.Rmd'
        " When R_assign isn't 0, vimwiki .Rmd files throw an error because a
        " buffer-local variable is missing that enables the R_assign behavior.
        " This prevents inserting underscores. The commented RStart below
        " comes from the nvim-r docs; however, it's a pain to have to hit a
        " key to enable insertion each time a .Rmd file is edited. I could not
        " for the life of me figure out how to make RStart an autocmd, so I
        " just disabled R_assign.
        let R_assign = 0
        " command! RStart if &ft!="r"
                    " \ | let oldft=&ft | set ft=r | exe 'set ft='.oldft
                    " \ | let b:IsInRCode = function("DefaultIsInRCode")
                    " \ | endif
                    " \ | call StartR("R")
        " autocmd FileType vimwiki map <buffer> <localleader>rf :<c-u>RStart<cr>
        " autocmd FileType vimwiki set syntax=rmd " Rmd syntax highlighting
    endif

    " Global options
    " Only set vimwiki filetype if file with the wiki extension exists within
    " the wiki path. Allows for non-wiki .Rmd files to be created.
    let g:vimwiki_global_ext = 0
    " Auto-save as you navigate between wiki files
    let g:vimwiki_autowriteall = 1
    " Table auto formatting can slow things down, but it is useful. For now, I
    " am largely ignoring tables until I learn how to speed it up.
    let g:vimwiki_table_auto_fmt=0
    " Quicker folding of sections and code blocks
    " For custom folding expression example, see
    " https://vimwiki.github.io/vimwikiwiki/Tips%20and%20Snips.html
    let g:vimwiki_folding='expr:quick'

    " With wrap enabled, lines longer than window width will be displayed on
    " the next line. Even though vimwiki displays links with display text that
    " may be shorter than the line, the display text will be split when the
    " actual text exceeds the line. So we need to disable wrapping of lines
    " that exceed textwidth
    autocmd FileType vimwiki setlocal nowrap

    "From |vimwikilinkhandler|:
    " Use Vim to open external files with the 'vfile:' scheme.
    " E.g., [abc123](vfile:~/Code/PythonProject/abc123.py)
    function! VimwikiLinkHandler(link)
        let link = a:link
        if link =~# '^vfile:'
            let link = link[1:]
        else
            return 0
        endif
        let link_infos = vimwiki#base#resolve_link(link)
        if link_infos.filename == ''
            echomsg 'Vimwiki Error: Unable to resolve link!'
            return 0
        else
            exe 'edit ' . fnameescape(link_infos.filename)
            return 1
        endif
    endfunction
endif
" TODO: Enable vimwiki mappings like <BS> for the vfile: scheme, since
" non-wiki files doesn't have the vimwiki mappings enabled
" TODO: Explore a way to fully combine nvim-R and vimwiki funcitionality
" together, and whether any functionality is lost be relying on one filetype or
" another.

" Usage:
" See the keybindings. These include commands for the terminal buffer itself, as
" well as commands for sending code to the terminal

" Send single command with :T and reference active buffer with %
" E.g., :T cat %
if has_key(g:plugs, 'neoterm')
    " Tab-specific terminals
    let g:neoterm_term_per_tab = 1
    " Start in insert/terminal mode
    let g:neoterm_autoinsert = 1
    " How to open terminal (defaults to current buffer)
    " TODO: Configure to split only if a single window exists
    " let g:neoterm_default_mod = 'belowright'
    " Scroll term to end after running command or :Topen for a hidden terminal
    let g:neoterm_autoscroll = 1
    " Toggling neoterm opens a terminal with your shell
    " But sending code (e.g., gx) automatically opens a terminal with the
    " filetype's REPL command invoked
    if get(g:, 'neoterm_direct_open_repl', 0) == 0
        let g:neoterm_auto_repl_cmd = 1
    endif
    " Language REPLs
    let g:neoterm_repl_python = 'ipython3 --no-autoindent'
    " Easy escape from the terminal
    " TODO: autocmd to unmap when calling ranger, as it forces a long pause for
    " navigating upward via 'k'
    " tnoremap kj <C-\><C-n>
    tnoremap <Esc> <C-\><C-n>

    " Bindings that operate on tab-specific teriminal
    " (or last active terminal if not tab-specific)
    nnoremap <localleader>c :<c-u>exec v:count.'Tclear!'<CR>
    nnoremap <localleader>k :<c-u>exec v:count.'Tkill'<CR>
    nnoremap <localleader>t :<c-u>exec v:count.'Ttoggle'<CR>
    nnoremap <localleader>q :<c-u>exec v:count.'Tclose!'<CR>
    nnoremap <localleader>r :<c-u>TREPLSendFile<CR>
    " ...and work with motions, selections, and counts
    " E.g., 2gxx or gxip
    nmap gx <Plug>(neoterm-repl-send)
    xmap gx <Plug>(neoterm-repl-send)
    nmap gxx <Plug>(neoterm-repl-send-line)

    " nnoremap <localleader>i :<c-u>echo b:neoterm_id<CR>
endif
" TODO: Test the changes made to the main repository based on my fork for
" handling Python code. I filed an issue that was linked to another issue, so
" use that as your guide.
" TODO: Research motions so you can more effectively evaluate code
" TODO: Write helper function to advance the cursor to the line following the
" end of motion.
" TODO: Replicate nvim-R commands/funcitonality using neoterm

if has_key(g:plugs, 'Nvim-R')
    "See |nvim-r|, |ft-r-indent|, and |R_indent_commented|
    let r_indent_ess_comments = 0 "No ess-style comment indentation (for #, ##, and ###)
    let r_indent_ess_compatible = 0 "Indent lines following line ending in '<-'
    "TODO: Space b/w # and text is proportional to function depth with
    "R_indent_commented. Investigate source code. May depend on external
    "indentation or formatting rules.
    let R_indent_commented = 1 "Reindent after toggling comment
    "let r_indent_comment_column = 40 "<LocalLeader>;
    "let R_rcomment_string = '# ' "<LocalLeader>x[x|c|u]
    let r_indent_align_args = 1 "Align function arguments
    let R_close_term = 1
    let R_objbr_place = 'console,right' "Object browser location
    let R_objbr_opendf = 1 "Show data frame elements
    let R_objbr_openlist = 1 "Show list elements
    let R_objbr_allnames = 0 "Show .GlobalEnv hidden objects
    let R_objbr_labelerr = 1 "Warn if label attribute is not class character
    let R_nvimpager = 'tab' "Open help document in new tab or use existing
    let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,tidyverse' "Omnicompletion and syntax highlighting for unloaded packages listed here
    "R_objbr/editor/help_w/h
    "R_path,R_app,R_args
    autocmd FileType r set tags+=~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags
endif

if has_key(g:plugs, 'ncm-R')
    " Equiv. to CocConfig's 'suggest.autoTrigger': always
    let g:ncm2#auto_popup = 1
    "Equiv. to CocConfig's 'suggest.minTriggerInputLength': 1
    let g:ncm2#complete_length = 1

    " Prevent automatic selection and text injection into current line, and show
    " popup even for only one match
    set completeopt=noinsert,menuone,noselect

    " Enable ncm2 for R
    autocmd BufEnter *.R,*.Rmd call ncm2#enable_for_buffer()

    autocmd FileType r,rmd call Configure_ncm2_filetypes()

    function! Configure_ncm2_filetypes()
        " Unlike coc.nvim, the popup appears by default (at least in R) when
        " you're adjacent to text even after you've moved away from text,
        " closing the popup. Because of this, the function to check for
        " backspace isn't necessary.
        inoremap <buffer><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
        " Use shift-tab to navigate up the completion menu or backspace.
        " This differs somewhat from coc.nvim, b/c the popup appears adjacent to
        " text automatically. So backspace is only possible across empty space.
        inoremap <buffer><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
        " The ncm2 README claims that:
        "     When the <Enter> key is pressed while the popup menu is visible, it
        "     only hides the menu. Use this mapping to close the menu and also start
        "     a new line.
        " I found this to be inverted: By default, the popup hid the menu and
        " inserted a new line. I wanted the behavior claimed by the README, so I
        " modified the mapping for the true condition. Then modified it for the
        " false condition to more closely resemble the coc.nvim mapping.
        "
        " If you have issues, the Wiki included a link to this issue:
        " https://github.com/ncm2/ncm2/issues/163
        " Check it out for insights if needed.
        inoremap <buffer><expr> <CR> (pumvisible() ? "\<c-y>" : "\<C-g>u\<CR>")
        "More or less equivalent to Show_coc_documentation
        nmap <buffer> K <localleader>rh
    endfunction
endif

" NOTE: This plugin is complex, and many features don't seem to work. But while
" suggestions are only enabled in certain buffers, it seems that other features
" may be enabled vim-wide. If any odd behavior is discovered with another
" plugin, try disabling coc.nvim and see if it has an effect.
if has_key(g:plugs, 'coc.nvim')
    " Extensions to install
    " autocmd VimEnter * CocInstall coc-python
    "" Enable highlighting references and other (?) stuff
    " autocmd VimEnter * CocInstall coc-highlight
    " Without this I can't see reference highlights...
    " hi link CocHighlightText Search
    " Highlight references on cursor hold
    " autocmd CursorHold * call CocActionAsync('highlight')
    echom 'There seems to have been a recent change in coc.nvim that prevents me from running CocInstall as an autocmd. What is more, sometimes CocInstall seems to have no effect initially. Try opening a python file, editing, and saving. Then try CocInstall. After each docker build, you need to install coc-python and coc-highlight.'

    " Disable COC completion by default. To enable completion and other
    " configuration, add the filetype to the list within Show_coc_documentation
    autocmd FileType * call DisableCocFT ()

    function! DisableCocFT()
        if index(['vim', 'python'], &filetype) < 0
            let b:coc_suggest_disable = 1
        else
            call Configure_coc_filetypes()
        endif
    endfunction

    function! Configure_coc_filetypes()
        "Persistent left-hand column for, e.g., debugging indicators
        setlocal signcolumn=yes
        " Standard statusline recreation
        setlocal statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
        " Prepend b/c left of '%<' avoids being trimmed
        setlocal statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

        " If the completion popup is visible, navigate down it. Otherwise, if the
        " preceding character is \s, <tab>; else trigger the completion popup.
        inoremap <buffer><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ Check_space_behind() ? "\<TAB>" :
              \ coc#refresh()

        " Use shift-tab to navigate up the completion menu or backspace
        inoremap <buffer><expr><S-TAB>
              \ pumvisible() ? "\<C-p>" :
              \ "\<C-h>"

        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
        " position. See |undo| and |ins-special-special|. So the alternative is
        " to insert a <cr> and break the undo chain.
        inoremap <buffer><expr> <cr>
              \ complete_info()["selected"] != "-1" ? "\<C-y>" :
              \ "\<C-g>u\<CR>"

        nmap     <buffer> <leader>dp <Plug>(coc-diagnostic-prev)
        nmap     <buffer> <leader>dn <Plug>(coc-diagnostic-next)

        nmap     <buffer> gd <Plug>(coc-definition)
        " NOTE: In the preview window for coc-references, you can determine how to go
        " (e.g., vsplit) by pressing tab on the selected reference
        nmap     <buffer> gr <Plug>(coc-references)
        nnoremap <buffer> K :call Show_coc_documentation()<CR>
    endfunction

    " Check for a space one column before cursor
    function! Check_space_behind() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    function! Show_coc_documentation()
      " Vim docs
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      " Non-Vim docs
      else
        call CocAction('doHover')
      endif
    endfunction

endif
" TODO: Investigate workspace folders, coc-search
" TODO: Investigate the example tab mapping from the docs for snippet
" expansion and placeholder jumping
" TODO: How does coc.nvim compare to the other LSP plugins listed here:
" https://www.reddit.com/r/vim/comments/7lnhrt/which_lsp_plugin_should_i_use/
" NOTE: Most functionality is broken for Python: extract, rename, refactor, etc.
" The one thing that works beautifully is completion and function signatures


" Open init.vim to start
"e $MYVIMRC
