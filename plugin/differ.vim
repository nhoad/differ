sign define DifferAdd text=+ texthl=DiffAdd
sign define DifferMod text=! texthl=DiffChange
sign define DifferMod1 text=!1 texthl=DiffChange
sign define DifferMod2 text=!2 texthl=DiffChange
sign define DifferMod3 text=!3 texthl=DiffChange
sign define DifferMod4 text=!4 texthl=DiffChange
sign define DifferMod5 text=!5 texthl=DiffChange
sign define DifferMod6 text=!6 texthl=DiffChange
sign define DifferMod7 text=!7 texthl=DiffChange
sign define DifferMod8 text=!8 texthl=DiffChange
sign define DifferMod9 text=!9 texthl=DiffChange
sign define DifferDel text=__ texthl=DiffDelete
sign define DifferDel1 text=_1 texthl=DiffDelete
sign define DifferDel2 text=_2 texthl=DiffDelete
sign define DifferDel3 text=_3 texthl=DiffDelete
sign define DifferDel4 text=_4 texthl=DiffDelete
sign define DifferDel5 text=_5 texthl=DiffDelete
sign define DifferDel6 text=_6 texthl=DiffDelete
sign define DifferDel7 text=_7 texthl=DiffDelete
sign define DifferDel8 text=_8 texthl=DiffDelete
sign define DifferDel9 text=_9 texthl=DiffDelete

highlight default link SignifySignAdd    DiffAdd
highlight default link SignifySignChange DiffChange
highlight default link SignifySignDelete DiffDelete

let s:previous_lines = {}

function Differ()
  let buffer = expand('%')
  let previous_lines = get(s:previous_lines, buffer, [])
  for i in previous_lines
    execute 'sign unplace' i
  endfor
  let s:previous_lines[buffer] = []

  if has('nvim')
    call jobstart(['lineannotate.py', buffer], extend({'buffer': buffer}, s:callbacks))
  else
    let diff = system(['lineannotate.py', buffer])
    call s:DiffUpdate(split(diff, '\n'), buffer)
  endif
endfunction

function s:DiffUpdate(lines, buffer)
  for line in a:lines
    if strlen(line) > 0
      " call append(line('$'), line)
      let i_sym = split(line, '=')
      let i = i_sym[0]
      let sym = i_sym[1]
      call add(s:previous_lines[a:buffer], eval(i))

      execute 'sign place' i 'line='. eval(i) 'name='. sym 'file='. a:buffer
    endif
  endfor
endfunction

function s:JobHandler(job_id, data, event)
  if a:event == 'stdout'
    call s:DiffUpdate(a:data, self.buffer)
  endif
endfunction

let s:callbacks = {
\ 'on_stdout': function('s:JobHandler'),
\ 'on_stderr': function('s:JobHandler'),
\ 'on_exit': function('s:JobHandler')
\ }
