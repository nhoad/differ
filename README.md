# differ

Yet another gitgutter style plugin for Vim, but with Neovim support.

This plugin shows a git/hg diff in Vim's sign column. There are a bunch of
plugins that support this, but according to my research mine is the first one
to utilise Neovim's job control for running it asynchronously.

This is great, because it means if you have a huge repo and you're using a slow
vcs (e.g. hg), saving isn't going to block Vim for 1000ms+. As you might have
guessed, I'm speaking from experience.

It also still has support for Vim, it'll just have Vim's problems (no job
control support).

It currently supports git and mercurial. Adding support for any other VCS is
trivial, as long as it can produce a unified diff.

# Using it

Put this in your .vimrc:

    autocmd! BufWritePost * call Differ()
    autocmd! BufReadPost * call Differ()

And put `annotate-differ` in your $PATH somewhere, e.g. `~/bin/`. If anyone
knows a better way for the vim script to call `annotate-differ`, let me know,
because I have no idea.

Or just call Differ() manually, e.g. `:call Differ()`.
