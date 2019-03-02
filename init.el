;; load basic setting
(org-babel-load-file "init_cmd.org")
;; in x-window, load more setting
(if (equal (window-system) 'x)
    (org-babel-load-file "init_gui.org")
    )
