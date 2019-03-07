;; load basic setting
(org-babel-load-file "~/.emacs.d/init_cmd.org")

;; in x-window, load more setting
(if (equal (window-system) 'x)
    (org-babel-load-file "~/.emacs.d/init_gui.org")
    )
