let g:wiki_root = expand('~/notes/')

augroup vimwiki_templates
  autocmd!
  autocmd BufNewFile ~/notes/*.wiki call s:ApplyTemplate()
augroup END

function! s:ApplyTemplate()
  let l:dir = expand('%:p:h')
  let l:tpl = ''
  let l:matched = ''

  " Walk up from the file's folder toward the wiki root
  while l:dir !=# g:wiki_root && len(l:dir) > len(g:wiki_root)
    let l:candidate = g:wiki_root . '/templates/' . fnamemodify(l:dir, ':t') . '.tpl'
    if filereadable(l:candidate)
      let l:tpl = l:candidate
      let l:matched = l:dir
      break
    endif
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile

  if empty(l:tpl)
    return
  endif

  execute '0r ' . fnameescape(l:tpl)
  let l:title  = expand('%:t:r')
  let l:folder = fnamemodify(l:matched, ':t')
  let l:parent = fnamemodify(l:matched, ':h:t')
  silent! %s/%TITLE%/\=l:title/g
  silent! %s/%DATE%/\=strftime('%Y-%m-%d')/g
  silent! %s/%FOLDER%/\=l:folder/g
  silent! %s/%PARENT%/\=l:parent/g
  $delete _
  normal! gg
endfunction

