;; (setq debug-on-error t)
;; (setq debug-on-quit t)

(setq message-log-max t)
 
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/"))

(setq package-archive-priorities
      '(("melpa-stable" . 5)
        ("melpa" . 10)))

(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (setq use-package-always-ensure t))

(use-package quelpa)
(use-package quelpa-use-package
  :custom
  (quelpa-use-package-inhibit-loading-quelpa
   t "Improve startup performance"))

(setq home-directory (getenv "HOME"))
(defun at-homedir (&optional suffix)
  (concat-normalize-slashes home-directory suffix))

(defun at-org-dir (&optional suffix)
  (concat-normalize-slashes (at-homedir "/org")
                            suffix))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package racket-mode
  :ensure t
  :mode "\\.rkt\\'"
  :config
  (setq tab-always-indent 'complete)
  (add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
  (add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable))

(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (when (and custom-file (file-exists-p custom-file))
    (load-file custom-file)))

;; Security
(use-package auth-source
  :ensure t
  :custom
  (auth-sources '("~/.authinfo")))

(use-package real-auto-save
  :ensure t
  :init
  (add-hook 'restclient-mode-hook 'real-auto-save-mode)
  (add-hook 'markdown-mode 'real-auto-save-mode)
  (add-hook 'apib-mode 'real-auto-save-mode)
  (add-hook 'org-mode-hook 'real-auto-save-mode)
  (add-hook 'prog-mode-hook 'real-auto-save-mode)
  :config
  (setq real-auto-save-interval 10))

(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  :config
  (which-key-setup-side-window-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.05)
  :diminish which-key-mode
  )


(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  :init
  (load-theme 'doom-one))

(use-package spaceline
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))

(use-package dashboard
  
  :config
  (dashboard-setup-startup-hook)
  :custom
  (initial-buffer-choice '(lambda ()
                            (setq initial-buffer-choice nil)
                            (get-buffer "*dashboard*")))
  (dashboard-items '((recents  . 5)
                     (bookmarks . 5)
                     (projects . 5)
                     ;; (agenda . 5)
                     (registers . 5))))

;; Editor

(use-package region-bindings-mode
  
  :config
  (setq region-bindings-mode-disable-predicates '((lambda () buffer-read-only)))
  (region-bindings-mode-enable))

(use-package multiple-cursors
  
  :after (region-bindings-mode)
  :bind (("C-r" . mc/edit-lines)
	 (:map region-bindings-mode-map
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-o" . mc/mark-all-like-this)
         ("C-{" . mc/edit-beginnings-of-lines)
         ("C-}" . mc/edit-ends-of-lines)
         ("M-+" . mc/mark-more-like-this-extended)
         ("C-c a" . mc/mark-all-in-region)
         ("C-c d" . mc/mark-all-like-this-in-defun)
         ("C-c D" . mc/mark-all-like-this-dwim)
         ("`" . mc/sort-regions)
         ("C-+" . mc/insert-numbers)))
  :config
  (use-package mc-extras
    
    :after (multiple-cursors region-bindings-mode)
    :bind (:map region-bindings-mode-map 
           ("M-." . mc/mark-next-sexps)
           ("M-," . mc/mark-previous-sexps)
           ("C-|" . mc/move-to-column)
           ("C-." . mc/remove-current-cursor)))
  (use-package mc-cycle-cursors
    
    :bind (:map mc/keymap
           ("C-n" . mc/cycle-forward)
           ("C-p" . mc/cycle-backward))))

;; Windows
(use-package winum
  
  :bind (("M-0" . winum-select-window-0-or-10)
	 ("M-1" . winum-select-window-1)
	 ("M-2" . winum-select-window-2)
	 ("M-3" . winum-select-window-3)
	 ("M-4" . winum-select-window-4)
	 ("M-5" . winum-select-window-5)
	 ("M-6" . winum-select-window-6)
	 ("M-7" . winum-select-window-7)
	 ("M-8" . winum-select-window-8)
	 ("M-9" . winum-select-window-9))
  :delight winum-mode
  :config
  (winum-mode))

(use-package reverse-im
  
  :config
  (reverse-im-activate "russian-computer"))

(use-package emacs
  :config
  (fset 'yes-or-no-p 'y-or-n-p)
  (set-default-font "Monoid 12")
  (tool-bar-mode -1)
  (setq create-lockfiles nil)  
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message nil)
  (setq backup-directory-alist `(("." . "~/.saves")))
  (setq backup-by-copying t)
  (setq warning-minimum-level :emergency)
  (setq default-input-method 'russian-computer)

  ;; For mac
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)
  
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(use-package company
  :init (global-company-mode)
  :config
   (define-key company-mode-map (kbd "M-j") 'company-select-next)
   (define-key company-mode-map (kbd "M-k") 'company-select-previous)
   (use-package company-anaconda
    :ensure t
    :init (add-to-list 'company-backends 'company-anaconda))
   )

(use-package yasnippet
  :ensure t
  :after (org)
  :config
  (yas-global-mode 1)
  (defun my-org-mode-hook ()
    (yas-minor-mode))
  (add-hook 'org-mode-hook #'my-org-mode-hook)
)

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet
  )

(use-package auto-yasnippet
  :ensure t
  :after yasnippet
  :commands
  (aya-create
   aya-expand
   aya-open-line))

(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas)
          (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(use-package ivy
  :delight ivy-mode
  :config
  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-height 10)
  (ivy-count-format "(%d/%d)"))

(use-package swiper  
  :bind ("C-s" . swiper)
  :custom
  (swiper-include-line-number-in-search t))

(use-package counsel
  )

(use-package docker :ensure t)

(use-package dockerfile-mode
  :mode  ("\\Dockerfile" . dockerfile-mode))

(use-package docker-compose-mode
  
  :delight docker-compose-mode)

(use-package projectile
  :custom
  (projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (add-to-list 'projectile-other-file-alist '("html" "js"))
  (add-to-list 'projectile-other-file-alist '("js" "html"))
  (projectile-mode))

(use-package counsel-projectile
  :after counsel projectile
  :config
  (counsel-projectile-mode))

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)

(use-package ace-window
  
  :bind ("M-o" . ace-window)
  :custom
  (aw-background nil)
  (aw-leading-char-style 'char)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Use home row for selecting.")
  (aw-scope 'global "Highlight all frames."))

(use-package ace-jump-mode
  
  :bind (("C-c SPC" . ace-jump-mode)))

(use-package golden-ratio
  
  :after (ace-window winum)
  :delight golden-ratio-mode
  :config
  (add-to-list 'golden-ratio-extra-commands  '(ace-window
					       ace-delete-window
					       ace-select-window
					       ace-swap-window
					       ace-maximize-window
					       winum-select-window-0-or-10
					       winum-select-window-1
					       winum-select-window-2
					       winum-select-window-3
					       winum-select-window-4
					       winum-select-window-5
					       winum-select-window-6
					       winum-select-window-7
					       winum-select-window-8
					       winum-select-window-9))
  :init
  (golden-ratio-mode 1))


(use-package markdown-mode
  
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package apib-mode
  
  :mode (("\\.apib\\'" . apib-mode)))

(use-package restclient
  )

(use-package restart-emacs
	     
	     :config
	     (global-set-key (kbd "C-x C-c") 'restart-emacs))

(defun me/find-user-init-file ()
  "Edit the `user-init-file', in another window"
  (interactive)
  (find-file-other-window user-init-file))

(defun me/reload-init-file ()
  "Reload 'user-init-file'"
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c I") 'me/find-user-init-file)
(global-set-key (kbd "C-c r") 'me/reload-init-file)

(use-package expand-region
  
  :bind
  ("C-+" . er/contract-region)
  ("C-=" . er/expand-region))

(use-package json-mode
  
  :after (json-reformat json-snatcher)
  :mode ("\\.json$" . json-mode))

;; (use-package multitran
;;   :ensure t)

(use-package google-translate
  
  :bind (("C-x C-t" . google-translate-at-point)
	 ("C-x C-r" . google-translate-at-point-reverse))
  :custom
  (google-translate-default-source-language "en")
  (google-translate-default-target-language "ru")
  :init
  (use-package google-translate-default-ui :ensure nil))


;; GC tweaks

(setq gc-cons-percentage 0.3)

(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda ()
                               (setq gc-cons-threshold 800000)))

(add-hook 'minibuffer-setup-hook (lambda () (setq gc-cons-threshold most-positive-fixnum)))
(add-hook 'minibuffer-exit-hook (lambda () (setq gc-cons-threshold 800000)))

(add-hook 'focus-out-hook #'garbage-collect)

;; UI

(use-package battery
  :ensure t
  :config
  (display-battery-mode 1))

(use-package nginx-mode
  
  :mode ("\\.nginx'" . nginx-mode))

(use-package paradox
  :init
  (setq paradox-github-token t)
  (setq paradox-execute-asynchronously t)
  (setq paradox-automatically-star t))

(use-package scroll-bar
  :ensure nil
  :config
  (scroll-bar-mode -1)
  (when (>= emacs-major-version 25)
    (horizontal-scroll-bar-mode -1)))


(use-package time
  :config
  (display-time)
  :custom
  (display-time-day-and-date t)
  ;; (display-time-form-list (list 'time 'load))
  (display-time-world-list
   '(("Europe/Moscow" "Moscow")))
  (display-time-mail-file t)
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  (display-time-string-forms '( day " " monthname " (" dayname ") " 24-hours ":" minutes)))

;; Save history

(use-package savehist
  :config
  (savehist-mode t)
  :custom
  (savehist-save-minibuffer-history t)
  (savehist-autosave-interval 60)
  (history-length 10000)
  (history-delete-duplicates t)
  (savehist-additional-variables
        '(kill-ring
          search-ring
          regexp-search-ring)))

;; Recent file

(use-package recentf
  :no-require t
  :defer 1
  :config
  (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
  (recentf-mode t)
  :custom
  (recentf-max-saved-items 250)
  (recentf-max-menu-items 15))

;; Backup

(use-package backup-each-save
  :hook (after-save-hook . backup-each-save))

(use-package backup-walker
  :commands backup-walker-start)


(use-package tramp
  :config
  (setq tramp-verbose 0)
  (setq tramp-default-method "ssh")
  (setq tramp-ssh-controlmaster-options "")
  (setq tramp-default-proxies-alist nil))

(use-package magit
  
  :custom
  (magit-completing-read-function 'ivy-completing-read "Force Ivy usage.")
  (magit-stage-all-confirm nil)
  (magit-unstage-all-confirm nil)
  :bind
  (:prefix-map magit-prefix-map
               :prefix "C-c m"
               (("a" . magit-stage-file) ; the closest analog to git add
                ("b" . magit-blame)
                ("B" . magit-branch)
                ("c" . magit-checkout)
                ("C" . magit-commit)
                ("d" . magit-diff)
                ("D" . magit-discard)
                ("f" . magit-fetch)
                ("g" . vc-git-grep)
                ("G" . magit-gitignore)
                ("i" . magit-init)
                ("l" . magit-log)
                ("m" . magit)
                ("M" . magit-merge)
                ("n" . magit-notes-edit)
                ("p" . magit-pull)
                ("P" . magit-push)
                ("r" . magit-reset)
                ("R" . magit-rebase)
                ("s" . magit-status)
                ("S" . magit-stash)
                ("t" . magit-tag)
                ("T" . magit-tag-delete)
                ("u" . magit-unstage)
                ("U" . magit-update-index))))

(use-package git-timemachine
  
  :bind ("C-c t" . git-timemachine))

(use-package magithub
  
  :after magit
  :custom
  (magithub-clone-default-directory "~/projects/")
  :config
  (magithub-feature-autoinject t))

(use-package git-gutter
  :delight
  :config
  (global-git-gutter-mode t))

(use-package tiny
  :config
  (tiny-setup-default))

;; elisp
(use-package edebug-x)

(use-package elisp-slime-nav
  :delight elisp-slime-nav-mode
  :hook ((emacs-lisp-mode-hook ielm-mode-hook) . elisp-slime-nav-mode))

(use-package elisp-mode
  :ensure nil
  :hook ((emacs-lisp-mode-hook . (lambda ()
                                   (auto-fill-mode 1)
                                   (setq indent-tabs-mode nil)
                                   (setq comment-start ";;")
                                   (turn-on-eldoc-mode)))
         (emacs-lisp-mode-hook . common-hooks/prog-helpers)
         (emacs-lisp-mode-hook . common-hooks/newline-hook)))
(use-package company-elisp
  :ensure nil
  :after (elisp-mode company)
  :config
  (add-to-list 'company-backends 'company-elisp))

(add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)

(use-package paren
  :defer 2
  :custom
  (show-paren-delay 0)
  :config
  (show-paren-mode t))

(use-package flycheck
  :ensure t)


(use-package smartparens
  :ensure t
  :config
  (add-hook 'lisp-mode-hook 'smartparens-mode)
  (add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
  (add-hook 'json-mode-hook 'smartparens-mode)
  (add-hook 'js2-mode-hook 'smartparens-mode))

(use-package docker-tramp :ensure t)

(use-package epa
  :after (epg)
  :config
  (epa-file-enable)
  :custom
  (epa-pinetry-mode 'loopback))

(use-package org
  :ensure org-plus-contrib
  :bind (("C-c c" . org-capture)
	 ("C-c w" . org-refile)
	 ("<f12>" . org-agenda)
	 ("C-c k s" . org-agenda-columns)
	 ("C-c k q" . org-agenda-quit)
	 ("C-c y" . org-yank))
  :mode (("\\.org$" . org-mode)
         ("\\.org_archive$" . org-mode))
  :config

  ;; Common settings
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org"))

  ;; Speed Commands
  (setq org-use-speed-commands t)
  (add-to-list 'org-speed-commands-user '("x" org-todo "DONE"))
  (add-to-list 'org-speed-commands-user '("ч" org-todo "DONE"))
  (add-to-list 'org-speed-commands-user '("t" org-todo "TODO"))
  (add-to-list 'org-speed-commands-user '("е" org-todo "TODO"))
  (add-to-list 'org-speed-commands-user '("w" org-todo "WAITING"))
  (add-to-list 'org-speed-commands-user '("ц" org-todo "WAITING"))
  (add-to-list 'org-speed-commands-user '("s" call-interactively 'org-schedule))
  (add-to-list 'org-speed-commands-user '("ы" call-interactively 'org-schedule))
  (add-to-list 'org-speed-commands-user '("d" call-interactively 'org-deadline))
  (add-to-list 'org-speed-commands-user '("в" call-interactively 'org-deadline))
  (add-to-list 'org-speed-commands-user '("i" call-interactively 'org-clock-in))
  (add-to-list 'org-speed-commands-user '("ш" call-interactively 'org-clock-in))
  (add-to-list 'org-speed-commands-user '("o" call-interactively 'org-clock-out))
  (add-to-list 'org-speed-commands-user '("щ" call-interactively 'org-clock-out))
  (add-to-list 'org-speed-commands-user '("$" call-interactively 'org-archive-subtree))

  ;; Keyword
  (setq org-todo-keywords '("REPEAT(r)" "BACKLOG(b!)" "TODO(t!)" "NEXT(n)" "WAITING(w@/!)"
			    "|" "DONE(d!/@)" "CANCELLED(c@/!)"))
  (setq org-todo-keywords-for-agenda '("REPEAT(r)" "TODO(t!)" "BACKLOG(b!)" "NEXT(n)" "WAITING(w@/!)"))
  (setq org-done-keywords-for-agenda '("DONE(d)" "CANCELLED(c)"))

  (setq org-todo-keyword-faces
        '(("TODO" :foreground "red" :weight bold)
          ("NEXT" :foreground "yellow" :weight bold)
	  ("REPEAT" :foreground "purple" :weight bold)
          ("BACKLOG" :foreground "blue" :weight bold)
          ("WAITING" :foreground "magenta" :weight bold)
	  ("DONE" :foreground "forest green" :weight bold)
          ("CANCELLED" :foreground "forest green" :weight bold)))

  (let ((default-directory org-directory))
    (setq org-default-notes-file (expand-file-name "refile.org"))
    (setq org-capture-templates
        (quote (("t" "todo" entry (file org-default-notes-file)
		 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
		("b" "backlog" entry (file org-default-notes-file)
		 "* BACKLOG %?\n%U\n%a\n" :clock-in t :clock-resume t)
		("i" "idea" entry (file "ideas.org.gpg")
		 "* %? :IDEA:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("n" "note" entry (file org-default-notes-file)
		 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
		("w" "Goals of the WEEK" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/goals-of-week") :clock-in t :clock-resume t)
		("W" "Summary of the WEEK" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/summary-of-week") :clock-in t :clock-resume t)
		("m" "Goals of the MONTH" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/goals-of-month") :clock-in t :clock-resume t)
		("M" "Summary of the MONTH" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/summary-of-month") :clock-in t :clock-resume t)
		("d" "Goals of the DAY" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/goals-of-day") :clock-in t :clock-resume t)
		("D" "Summary of the DAY" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/summary-of-day") :clock-in t :clock-resume t)
		("y" "Goals of the YEAR" entry (file+datetree "~/org/diary.org.gpg")
		 (file "~/org/templates/goals-of-year") :clock-in t :clock-resume t)
		("s" "Sprint" entry (file+datetree "~/org/lognex.org.gpg")
		 (file "~/org/templates/mc") :clock-in t :clock-resume t)
                ("h" "REPEAT" entry (file org-default-notes-file)
                 "* REPEAT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: REPEAT\n:END:\n")))))

  ;; Refile
  (setq org-refile-targets '((org-agenda-files :maxlevel . 4)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-outline-path 'file)
  (setq org-completion-use-ido t)
  (setq org-outline-path-complete-in-steps nil)

  ;; Agenda
  (setq org-agenda-dim-blocked-tasks nil)
  (setq org-agenda-compact-blocks t)
  (setq org-agenda-start-on-weekday 1)
  (unless (string-match-p "\\.gpg" org-agenda-file-regexp)
  (setq org-agenda-file-regexp
        (replace-regexp-in-string "\\\\\\.org" "\\\\.org\\\\(\\\\.gpg\\\\)?"
                                  org-agenda-file-regexp)))
  ;; Calendar
  (setq calendar-date-style 'european)

  ;; Clocking
  (org-clock-persistence-insinuate)
  (setq org-clock-in-resume t)
  (setq org-clock-in-switch-to-state 'me/clock-in)
  (setq org-clock-persist t)
  (setq org-clock-out-when-done t)
  (setq org-clock-out-remove-zero-time-clocks t)
  (defun bh/remove-empty-drawer-on-clock-out ()
   (interactive)
   (save-excursion
     (beginning-of-line 0)
     (org-remove-empty-drawer-at (point))))

  (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
  (setq org-clock-into-drawer t)
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  (setq org-clock-history-length 23)
  (setq org-clock-report-include-clocking-task t)

  ;; Nice tweaks
  (setq org-blank-before-new-entry (quote ((heading) (plain-list-item))))
  (setq org-enforce-todo-dependencies t)
  (setq org-log-done (quote time))
  (setq org-log-redeadline (quote time))
  (setq org-log-reschedule (quote time))

  ;; Custom functions
  (defun me/clock-in(kw)
    "Switch task to NEXT from TODO when clocking in. Skip caphure"
    (if (not (bound-and-true-p org-capture-mode))
	"NEXT")
    )
  )

  (use-package org-super-agenda
    :ensure t
    :after org
    :config
    (org-super-agenda-mode)
    (defun pep-org-skip-subtree-if-category (category)
      "Skip an agenda entry if it has a CATEGORY property equal to category."
      (let ((subtree-end (save-excursion (org-end-of-subtree t))))
	(if (string= (org-entry-get nil "CATEGORY") category)
            subtree-end
	  nil)))

    (setq org-columns-default-format "%40ITEM %TODO %3PRIORITY %10TAGS %17Effort(Estimated Effort){:} %12CLOCKSUM")
    
    (setq org-agenda-custom-commands
          '(("p" "Personal agenda"
	     (
	      (agenda "-CATEGORY=\"WORK\"" (
					    (org-agenda-start-on-weekday nil)
					    (org-deadline-warning-days 5)
					    (org-agenda-start-with-log-mode t)
					    (org-agenda-span 7)))
	      (tags-todo "-CATEGORY=\"WORK\"" (
					       (org-agenda-overriding-header "\nTasks by Context\n------------------")
					       (org-super-agenda-groups '(
									  (:todo "NEXT"
										 :name "In Progress")
									  (:name "Important"
										 :priority>= "B")
									  (:name "Low Priority"
										 :priority "C")
									  (:name "Due today"
										 :scheduled today
										 :deadline today)
									  (:name "Overdue"
										 :scheduled past
										 :deadline past)
									  (:name "Due soon"
										 :scheduled future
										 :deadline future)
									  (:name "Waiting..."
										 :todo "WAITING"
										 :order 98)
									  (:discard (:anything t))
									  ))))
	      ))
	    ("b" "Backlog"
	     ((tags-todo "-BIRTH&-CATEGORY=\"WORK\"&EFFORT=>\"0:05\"" (
;;			   (org-agenda-prefix-format "  %?-12t% s")
			   (org-super-agenda-groups '((:auto-category t)))
			   ))))
	    ("5" "Quick tasks" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT>=\"0:05\"&EFFORT<=\"0:15\"" ((org-super-agenda-groups '((:auto-category t)))))
	    ("1" "Up to an hour" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT>\"0:15\"&EFFORT<=\"1:0\"" ((org-super-agenda-groups '((:auto-category t)))))
	    ("2" "Up to two hours" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT>\"1:00\"&EFFORT<\"2:0\"" ((org-super-agenda-groups '((:auto-category t)))))
	    ("6" "Up to six hours" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT>=\"2:00\"&EFFORT<\"6:0\"" ((org-super-agenda-groups '((:auto-category t)))))
	    ("8" "More than six hours" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT>=\"6:00\"" ((org-super-agenda-groups '((:auto-category t)))))
	    ("w" "Week Review" tags "CATEGORY=\"DAY_REVIEW\"" (
							       (org-agenda-prefix-format "  %?-12t% s")
							       (org-agenda-sorting-strategy '(timestamp-down))))
	    ("m" "Month Review" tags "CATEGORY=\"WEEK_REVIEW\"" (
								 (org-agenda-prefix-format "  %?-12t% s")
								 (org-agenda-sorting-strategy '(timestamp-down))))
	    ("y" "Year Review" tags "CATEGORY=\"MONTH_REVIEW\"" (
								 (org-agenda-prefix-format "  %?-12t% s")
							       (org-agenda-sorting-strategy '(timestamp-down))))
	    ("l" "Books and courses" tags-todo "BOOK|COURSE" (
							      (org-super-agenda-groups '((:auto-category t)))
							      (org-agenda-prefix-format "  %?-12t% s"))
	     )
            ("0" "Unestimated tasks" tags-todo "-BOOK&-COURSE&-BIRTH&EFFORT=\"\"" ((org-super-agenda-groups '((:auto-category t)))))

	    )
	  )
    )

(use-package org-brain
  :bind (("C-c b v" . org-brain-visualize)
         ("C-c b i" . org-id-get-create)
         :map org-brain-visualize-mode-map
         ("+" . org-brain-new-child)
         ("L" . org-brain-cliplink-resource))
  :config
  (setq org-id-track-globally t
        org-brain-visualize-default-choices 'all
        org-brain-show-text t
        org-brain-title-max-length 0
        org-brain-visualize-one-child-per-line t)

  (defun org-brain-cliplink-resource ()
  "Add a URL from the clipboard as an org-brain resource.
Suggest the URL title as a description for resource."
  (interactive)
  (let ((url (org-cliplink-clipboard-content)))
    (org-brain-add-resource
     url
     (org-cliplink-retrieve-title-synchronously url)
     t)))

  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates))


(use-package link-hint
  :after org-brain
  :bind (:map org-brain-visualize-mode-map
              ("." . link-hint-open-link)))

(use-package org-alert
  :ensure t
  :config
  (setq alert-default-style 'osx-notifier
	org-alert-interval 3600)
  (org-alert-enable))

(use-package ox-minutes
  :ensure t
  :after org)

(use-package ox-tufte
  :ensure t
  :after org)

(use-package ox-gfm
  :ensure t
  :after org)

(use-package org-kanban
  :ensure t
  :after org)

(use-package org-cliplink
  :ensure t
  :commands (org-cliplink-clipboard-content))


(modify-coding-system-alist 'file "\\.txt\\'" 'windows-1251)

(server-start)

(when (featurep 'ns)
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))

  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
        (ns-raise-emacs))))

  (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)

  (when (display-graphic-p)
    (ns-raise-emacs)))

(use-package avy
  :ensure t
  :config
  (avy-setup-default))

(use-package ox-hugo
  :ensure t           
  :after ox)
