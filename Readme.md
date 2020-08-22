# olp.el -- Restore last cursor positions

olp.el (open last position :P) is a simple no dependency package
used to open last positions of buffers when it was saved.

## Installation

The installation is simple. Just put the `olp.el` in your `load-path`.
And add this to your `.emacs`.

```elisp
(require 'olp)
;; ###########
(olp-setup)
```

That's it. The file positions will be stored in a file stored in `olp-save-file`
which defaults to `$HOME/.emacs.d/.olp-state.el`. If for some reason you want to change
it you can `setq` before calling `olp-setup` (precisely `;; ###########` in the above snippet).

Cheers
