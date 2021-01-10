pkgs:
{
  enable = true;
  plugins = with pkgs.vimPlugins; [
    editorconfig-vim
    fzf-vim
    fzfWrapper
    gruvbox
    vim-commentary
    vim-fish
    vim-gitgutter
    vim-lsp
    vim-nix
    vim-repeat
    vim-surround
    vim-visual-multi
  ];
  extraConfig = ''
    let mapleader=" "
    set clipboard=unnamed
    set grepprg=rg\ --vimgrep
    set ignorecase
    set mouse=a
    set smartcase
    set smartindent
    set splitbelow
    set splitright
    set ts=2 sw=2 expandtab
    set undofile
    call mkdir($HOME."/.vim/undo", "p", 0700)
    set undodir=~/.vim/undo

    color gruvbox
    set termguicolors
    set background=dark
    set t_ut=

    nnoremap gh ^
    nnoremap gl $
    nnoremap <leader>p :GitFiles<cr>
    nnoremap <leader>b :Buffers<cr>
    nnoremap <leader>f :FZF<cr>

    au CursorHold,CursorHoldI * checktime


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " LSP
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
    function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gi <plug>(lsp-implementation)
      nmap <buffer> gD <plug>(lsp-type-definition)
      nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
      nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
      nmap <buffer> K <plug>(lsp-hover)

      nmap <buffer> <leader>rn <plug>(lsp-rename)
      nmap <buffer> <leader>ca <plug>(lsp-code-action)
      nmap <buffer> <leader>dd <plug>(lsp-document-diagnostics)
      nmap <buffer> <leader>df <plug>(lsp-document-format)

      let g:lsp_format_sync_timeout = 1000
      autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

      " refer to doc to add more commands
    endfunction

    augroup lsp_install
      au!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END

    if executable('gopls')
      au User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info->['gopls']},
          \ 'allowlist': ['go'],
          \ })
    else
      echo("gopls not found!??")
    endif
  '';
}
