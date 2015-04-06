(add-hook 'after-init-hook '(lambda ()
  (load "~/.emacs-loadpackages"))) ;; anything within the lambda will run after everything has initialized.

(setq backup-directory-alist
`(("." . "~/.emacs_backups")))

;; Set emacs default indention to 4
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))
 
;; Show column numbers
(setq column-number-mode t)

;; Set font size
(set-face-attribute 'default nil :height 110)

;; Tell emacs where is your personal elisp lib dir
;; this is default dir for extra packages
(add-to-list 'load-path "~/.emacs.d/")

;; load the stylus package.
(load "stylus-mode") ;; best not to include the ending “.el” or “.elc”

;; load the evil mode package.
(add-to-list 'load-path "~/.emacs.d/evil")
(require `evil)
(evil-mode 1)

;; Add node REPL
(require 'js-comint)
;; Use node as our repl
(setq inferior-js-program-command "node")
(setq inferior-js-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
        ;; Deal with some prompt nonsense
        (add-to-list 'comint-preoutput-filter-functions
                     (lambda (output)
                       (replace-regexp-in-string ".*1G\.\.\..*5G" "..."
                     (replace-regexp-in-string ".*1G.*3G" "&gt;" output))))))

;; Code folding
(add-hook 'js-mode-hook
          (lambda ()
            ;; Scan the file for nested code blocks
            (imenu-add-menubar-index)
            ;; Activate the folding mode
            (hs-minor-mode t)))

;; Tramp
(require 'tramp)
(tramp-set-completion-function "ssh"
                               '((tramp-parse-sconfig "/etc/ssh_config")
                                 (tramp-parse-sconfig "~/.ssh/config")))