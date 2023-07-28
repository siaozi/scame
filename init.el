(setq package-list nil)
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
  Your version of Emacs does not support SSL connections,
  which is unsafe because it allows man-in-the-middle attacks.
  There are two things you can do about this warning:
  1. Install an Emacs version that does support SSL and be safe.
  2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(set-default-coding-systems 'utf-8)
(set-language-environment 'UTF-8)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-hl-line-mode t)
(setq-default cursor-type 'bar)

(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

(setq inhibit-splash-screen t)

(use-package monokai-theme
  :ensure t
  :config  (load-theme 'monokai t)
  )

(toggle-frame-fullscreen)

(setq display-time-day-and-date t
      display-time-default-load-average nil
      display-time-24hr-format t
      display-time-day-and-date nil)
(setq display-time-format "%Y-%m-%d %a %H:%M")
(display-time)

(use-package nyan-mode
  :config
  (setq nyan-animate-nyancat t
        nyan-wavy-trail t
        )
  (nyan-mode)
  :ensure t
  )

(use-package helm
  :ensure t
  :config (helm-mode)
  :bind (("C-x b" . helm-buffers-list)
         ("C-x r b" . helm-bookmarks)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         :map helm-command-map
         ("<tab>" . helm-execute-persistent-action))
  )

(use-package helm-swoop
  :ensure t
  :bind ("M-i" . helm-swoop)
  )

(use-package ace-window
  :ensure t
  :bind ("M-p" . ace-window)
  )

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package org
  :ensure t
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (add-to-list 'org-babel-load-languages '(dot . t))
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  :requires (org-tempo)
  )

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  )

(use-package company
  :ensure t
  :config 
  (global-company-mode t)
  (setq company-minimum-prefix-length 1)
  )

(use-package which-key
  :ensure t
  :config (which-key-mode t)
  )

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  )

(use-package hungry-delete
  :ensure t
  :config (global-hungry-delete-mode t)
  )

(use-package popwin
  :ensure t
  :config (popwin-mode t)
  )

(use-package iedit
  :ensure t
  :bind ("M-s e". iedit-mode))

(use-package expand-region
  :ensure t
  :bind("M-=" . er/expand-region)
  )

(use-package google-translate
  :ensure t
  :bind ("C-c t" . google-translate-smooth-translate)
  :init
  (setq google-translate-translation-directions-alist
        '(("en" . "zh-TW") ("zh-TW" . "en")))
  )
(if window-system (setq google-translate-listen-program "mpv"))

(use-package emms
  :requires emms-setup
  :init
  (emms-minimalistic)
  (emms-all)
  (emms-default-players)
  (setq emms-player-mpv-parameters '("--quiet" "--really-quiet" "--no-video"))
  (setq emms-player-list '(emms-player-mpv))
  )

(setq make-backup-files nil)
(setq ring-bell-function 'ignore)

(require 'dired-x)
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

(recentf-mode t)
(setq recentf-max-menu-items 40)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

(delete-selection-mode t)

(defun occur-on-point()
  "select the word on point as occur default"
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-on-point)

(defun indent-buffer()
  "indent the current buffer"
  (interactive)
  (indent-region (point-min) (point-max))
  )
(defun indent-region-or-buffer()
  "indent the selected region or the current buffer"
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end)) 
          (message "indent region"))
      (progn
        (indent-buffer)
        (message "indent buffer")))))
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)

(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))

(if window-system
    (progn 
      (defvar emacs-english-font "Inconsolata"
        "The font name of English.")
      (defvar emacs-cjk-font "Hiragino Sans GB W3"
        "The font name for CJK.")
      (defvar emacs-font-size 20
        "Default font size")
      (defun font-exist-p (fontname)
        "Test if this font is exist or not."
        (if (or (not fontname) (string= fontname ""))
            nil
          (if (not (x-list-fonts fontname)) nil t)))
      (defun set-font (english chinese size)
        "Setup emacs English and Chinese font on x window-system."
        (if (font-exist-p english)
            (set-frame-font (format "%s:pixelsize=%d" english size) t))
        (if (font-exist-p chinese)
            (dolist (charset '(kana han symbol cjk-misc bopomofo))
              (set-fontset-font (frame-parameter nil 'font) charset
                                (font-spec :family chinese :size size)))))
      (defun emacs-step-font-size (step)
        "Increase/Decrease emacs's font size."
        (setq emacs-font-size (+ emacs-font-size step))
        (message "frame font size adjust to %d pixel" emacs-font-size)
        (set-font emacs-english-font emacs-cjk-font emacs-font-size)
        )
      (defun increase-emacs-font-size ()
        "Decrease emacs's font-size acording emacs-font-size."
        (interactive) (emacs-step-font-size 2))
      (defun decrease-emacs-font-size ()
        "Increase emacs's font-size acording emacs-font-size."
        (interactive) (emacs-step-font-size -2))
      (global-set-key (kbd "C-=") 'increase-emacs-font-size)
      (global-set-key (kbd "C--") 'decrease-emacs-font-size)
      (increase-emacs-font-size)
      ))
