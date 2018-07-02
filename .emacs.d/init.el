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
  (concat-normalize-slashes (at-homedir "/Dropbox/org")
                            suffix))

(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (when (and custom-file (file-exists-p custom-file))
    (load-file custom-file)))

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  :init
  (load-theme 'doom-tomorrow-night))

(use-package nyan-mode
  :demand t
  :init
  (setq nyan-animate-nyancat t
        nyan-wavy-trail t)
  :config
  (nyan-mode 1))

(use-package spaceline
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))


(use-package font-lock+
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

;; Important
;; M-x all-the-icons-install-fonts
;; fc-cache -f -v 
(use-package all-the-icons
  :config
  (add-to-list
   'all-the-icons-mode-icon-alist
   '(package-menu-mode all-the-icons-octicon "package" :v-adjust 0.0)))

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package spaceline-all-the-icons
  :after spaceline
  :preface
   (spaceline-define-segment date
    "The current date."
    (format-time-string "%h %d week %W"))
  :config
  (spaceline-all-the-icons-theme)
  (spaceline-all-the-icons--setup-package-updates)
  (spaceline-all-the-icons--setup-git-ahead)
  (spaceline-all-the-icons--setup-paradox)
  (spaceline-toggle-battery-on)
  (spaceline-toggle-all-the-icons-nyan-cat-on))

(use-package all-the-icons-ivy
  :after ivy projectile
  :custom
  (all-the-icons-ivy-buffer-commands '() "Don't use for buffers.")
  (all-the-icons-ivy-file-commands
   '(counsel-find-file
     counsel-file-jump
     counsel-recentf
     counsel-projectile-find-file
     counsel-projectile-find-dir) "Prettify more commands.")
  :config
  (all-the-icons-ivy-setup))


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
  (set-default-font "PragmataPro 14")
  (tool-bar-mode -1)
  (setq create-lockfiles nil)  
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message nil)
  (setq backup-directory-alist `(("." . "~/.saves")))
  (setq backup-by-copying t)
  (setq warning-minimum-level :emergency)
  (setq default-input-method 'russian-computer)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

(use-package company
  
  :config
  (global-company-mode))

(use-package ivy
  
  :delight ivy-mode
  :config
  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d)"))

(use-package swiper
  
  :bind ("C-s" . swiper)
  :custom
  (swiper-include-line-number-in-search t))

(use-package counsel
  )


(use-package dockerfile-mode
  
  :mode  ("\\Dockerfile" . dockerfile-mode))

(use-package docker-compose-mode
  
  :delight docker-compose-mode)

(use-package projectile
  
  :bind ("C-x j j" . projectile-switch-project)
  :custom
  (projectile-enable-caching t)
  (projectile-require-project-root nil)
  (projectile-completion-system 'ivy)

  :config
  (def-projectile-commander-method ?d
    "Open project root in dired."
    (projectile-dired))
  (def-projectile-commander-method ?g
    "Search in project."
    (counsel-rg))
  (add-to-list 'projectile-other-file-alist '("html" "js"))
  (add-to-list 'projectile-other-file-alist '("js" "html"))
  (setq projectile-switch-project-action 'projectile-commander)
  (projectile-global-mode 1))

(use-package counsel-projectile
  
  :after (counsel projectile)
  :bind ("C-x j j" . 'counsel-projectile-switch-project)
  :config
  (setq projectile-switch-project-action 'counsel-projectile-switch-project))

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

(global-set-key (kbd "C-c I") 'me/find-user-init-file)

(use-package expand-region
  
  :bind
  ("C-+" . er/contract-region)
  ("C-=" . er/expand-region))

(use-package json-mode
  
  :after (json-reformat json-snatcher)
  :mode ("\\.json$" . json-mode))

(use-package google-translate
  
  :bind (("C-c C-t" . google-translate-at-point)
	 ("C-c C-r" . google-translate-at-point-reverse)
	 ("C-c C-S-t" . google-translate-at-point))
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
  (setq tramp-default-method "ssh")
  (setq tramp-ssh-controlmaster-options "")
  (setq tramp-default-proxies-alist nil)
  (add-to-list 'tramp-default-proxies-alist
               '(".*" "\\`.+\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '("10\\.0\\." nil nil))
  (add-to-list 'tramp-default-proxies-alist
               `((regexp-quote ,(system-name)) nil nil)))

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


(use-package emms
  :bind (([f10] . emms))
  :init
  (add-to-list 'load-path "~/.emacs.d/emms/")
    (require 'emms-setup)
    (emms-all)
    (emms-default-players))

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


(use-package org
  :ensure org-plus-contrib
  :bind (("C-c c" . org-capture)
	 ("C-c w" . org-refile)
	 ("C-c y" . org-yank))
  :mode (("\\.org$" . org-mode)
         ("\\.org_archive$" . org-mode))
  :config

  ;; Keyword
  (setq org-todo-keywords '("BACKLOG(b)" "REPEAT(r)" "TODO(t!)" "NEXT(n)" "WAITING(w@/!)"
			    "|" "DONE(d!/@)" "CANCELLED(c@/!)"))
  (setq org-todo-keywords-for-agenda '("BACKLOG(b)" "REPEAT(r)" "TODO(t!)" "NEXT(n)" "WAITING(w@/!)"))
  (setq org-done-keywords-for-agenda '("DONE(d)" "CANCELLED(c)"))

  (setq org-todo-keyword-faces
        '(("TODO" :foreground "red" :weight bold)
          ("NEXT" :foreground "yellow" :weight bold)
	  ("REPEAT" :foreground "purple" :weight bold)
          ("BACKLOG" :foreground "blue" :weight bold)
          ("WAITING" :foreground "magenta" :weight bold)
	  ("DONE" :foreground "forest green" :weight bold)
          ("CANCELLED" :foreground "forest green" :weight bold)))

  (setq org-directory "~/Dropbox/org")
  (setq org-agenda-files '("~/Dropbox/org"))

  (let ((default-directory org-directory))
    (setq org-default-notes-file (expand-file-name "refile.org"))
    (setq org-capture-templates
        (quote (("t" "todo" entry (file org-default-notes-file)
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "respond" entry (file org-default-notes-file)
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                ("n" "note" entry (file org-default-notes-file)
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("h" "REPEAT" entry (file org-default-notes-file)
                 "* REPEAT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: REPEAT\n:END:\n")))))
  (setq org-agenda-dim-blocked-tasks nil)
  (setq org-agenda-compact-blocks t)
  ;; Resume clocking task when emacs restarted
  (org-clock-persistence-insinuate)
  ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
  (setq org-clock-history-length 23)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Change tasks to NEXT when clocking in
  (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)
  (setq org-agenda-start-on-weekday 1)
  
)
 



;; (setq debug-on-error nil)
;; (setq debug-on-quit nil)
