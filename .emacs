;----------------------;
;;; Package Settings ;;;
;----------------------;

;; Set package archives
(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("elpy" . "http://jorgenschaefer.github.io/packages/")))

;; Define packages needed
(setq package-list  '(autopair
                      company
                      elpy
                      fill-column-indicator
                      find-file-in-project
                      magit
                      neotree
                      nlinum
                      yasnippet))

;; Activate all the packages (in particular autoloads)
(package-initialize)

;; Fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; Install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;--------------------;
;;; Setup Packages ;;;
;--------------------;

;; Company-mode
(add-hook 'after-init-hook 'global-company-mode)

;; Fill column indicator
(require 'fill-column-indicator)
(define-globalized-minor-mode
  global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)
(setq-default fill-column 79)

;; Color theme
(add-to-list 'custom-theme-load-path
            "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'light)
(set-terminal-parameter nil 'background-mode 'dark)

;; Ido mode
(require 'ido)
(ido-mode 1)

;; Python mode
(when (require 'elpy nil t)
  (elpy-enable))
(setq elpy-rpc-backend "jedi")
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")

;; Highlight Current Line Settings
(global-hl-line-mode)
(set-face-background hl-line-face "gray13")

;; nlinum Settings
(add-hook 'nlinum-mode-hook
          (lambda ()
            (unless (boundp 'nlinum--width)
              (setq nlinum--width
                    (length (number-to-string
                            (count-lines (point-min) (point-max))))))))
(setq nlinum-format "%d ")
(global-nlinum-mode)

;; Magit settings
(global-set-key (kbd "C-x g") 'magit-status)

;; neotree settings
(require 'neotree)
(setq neo-theme 'ascii)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neo-banner-face ((t :inherit shadow)))
 '(neo-button-face ((t :inherit dired-directory)))
 '(neo-dir-link-face ((t :inherit dired-directory)))
 '(neo-expand-btn-face ((t :inherit button)))
 '(neo-file-link-face ((t :inherit default)))
 '(neo-header-face ((t :inherit shadow)))
 '(neo-root-dir-face ((t :inherit link-visited :underline nil))))
(setq neo-smart-open t)
(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-project-root))
        (file-name (buffer-file-name)))
    (if project-dir
        (progn
          (neotree-dir project-dir)
          (neotree-find file-name))
      (message "Could not find git project root."))))
(global-set-key (kbd "C-c p") 'neotree-project-dir)
(global-set-key (kbd "C-c h") 'neotree-hide)
(define-key neotree-mode-map (kbd "h") #'neotree-enter-horizontal-split)
(define-key neotree-mode-map (kbd "v") #'neotree-enter-vertical-split)
(eval-after-load "neotree"
  '(setq neo-hidden-regexp-list '("__pycache__" "*.pyc"))
  )
(setq neo-show-hidden-files nil)

;------------------;
;; Misc. Settings ;;
;------------------;

;; Commenting Settings
(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    )
  )
(global-set-key (kbd "M-/") 'comment-or-uncomment-line-or-region)
(global-set-key (kbd "C-/") 'comment-or-uncomment-line-or-region)

(tool-bar-mode -1) ;; Disable the toolbar
(menu-bar-mode -1) ;; Disable the menubar
(defalias 'yes-or-no-p 'y-or-n-p) ;; Use 'y' or 'n' for 'yes' or 'no'

;; Marking Text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Keybindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-z") 'undo)

;; Font
(set-default-font "Inconsolata 12")

;; Each line of text gets one line on the screen
(setq-default truncate-lines 1)
(setq truncate-partial-width-windows 1)

;; Always use spaces, not tabs, when indenting
(setq-default indent-tabs-mode nil)

;; Show the current line and column numbers in the stats bar
(line-number-mode 1)
(column-number-mode 1)

;; Don't blink the cursor
(blink-cursor-mode nil)

;; Ensure transient mark mode is enabled
(transient-mark-mode 1)

;; Highlight paretheses when the cursor is next to them
(require 'paren)
(show-paren-mode 1)

;; Disable backup
(setq backup-inhibited t)

;; Disable autosave
(setq auto-save-default nil)
