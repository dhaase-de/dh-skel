;;
;; general settings
;;

; no startup screen
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

; always kill entire line
(setq kill-whole-line t)

; do not save backup files in the same dir as the original file


;;
;; key bindings (make emacs a bit more sane)
;;

; emacs
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)

; file/buffer
(global-set-key (kbd "C-n") (lambda () (interactive) (switch-to-buffer (generate-new-buffer "unnamed"))))
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-w") 'kill-this-buffer)
(global-set-key (kbd "<C-prior>") 'previous-buffer)
(global-set-key (kbd "<C-next>") 'next-buffer)

; line
(global-set-key (kbd "C-d") 'kill-whole-line)
(global-set-key (kbd "C-r") (lambda () (interactive) (kill-whole-line) (yank) (yank) (previous-line)))

;;
;; external packages
;;

; yasnippet
;(require 'yasnippet)
;(yas-global-mode 1)

;;
;; themes
;;

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

; select theme
(custom-set-variables
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("0eebf69ceadbbcdd747713f2f3f839fe0d4a45bd0d4d9f46145e40878fc9b098" default))))

