nnoremap <buffer> <ENTER> <C-]>
nnoremap <buffer> <BS> <C-T>
" Navigate between links
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

" Expand :h<SPC> to :tab help
"cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'
