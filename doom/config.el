;;; config.el -*- lexical-binding: t; -*-
;; ~/.config/doom/config.el

;;; ---------------------------------------------------------------- identidade
(setq user-full-name "Marcos"
      user-mail-address "seu@email.com")

;;; ------------------------------------------------------------------ aparência
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 22))

(setq doom-theme 'doom-nord)
(setq display-line-numbers-type 'relative)
(setq frame-resize-pixelwise t)

;;; ---------------------------------------------------------------- comportamento
(setq confirm-kill-emacs nil
      delete-by-moving-to-trash t
      truncate-string-ellipsis "…"
      scroll-margin 3
      auto-save-default t
      make-backup-files t
      backup-directory-alist `(("." . ,(expand-file-name "backups" doom-cache-dir))))

(after! ispell
  (setq ispell-dictionary "pt_BR"))

;;; ============================================================ ATALHOS
;; Definidos ANTES de tudo que possa falhar, para nunca se perderem.

(map! :leader
      (:prefix ("d" . "dados")
       :desc "Abrir R"          "r" #'R
       :desc "Python REPL"      "p" #'run-python
       :desc "SQL conectar"     "s" #'sql-connect)

      (:prefix ("o" . "abrir")
       :desc "Agenda"           "a" #'org-agenda
       :desc "Capturar"         "c" #'org-capture
       :desc "Terminal"         "t" #'+vterm/toggle))

;;; ============================================================ ORG MODE
(setq org-directory "~/Documents/Faculdade/")

(after! org
  (setq org-agenda-files
        (seq-filter #'file-exists-p
                    (list (expand-file-name "inbox.org" org-directory)
                          (expand-file-name "agenda.org" org-directory)))
        org-log-done 'time
        org-hide-emphasis-markers t
        org-startup-indented t
        org-startup-with-inline-images t
        org-image-actual-width '(600)
        org-pretty-entities t
        org-ellipsis " ▾ "
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-edit-src-content-indentation 0
        org-confirm-babel-evaluate nil)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "FAZENDO(f)" "ESPERA(e)" "|" "FEITO(d)" "CANCELADO(c)")))

  (setq org-capture-templates
        `(("t" "Tarefa" entry
           (file+headline ,(expand-file-name "inbox.org" org-directory) "Tarefas")
           "* TODO %?\n  %U\n  %a")
          ("n" "Nota" entry
           (file+headline ,(expand-file-name "inbox.org" org-directory) "Notas")
           "* %?\n  %U")))

  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.6)))

;; Babel: carrega apenas as linguagens realmente disponíveis
(after! org
  (let ((langs '((emacs-lisp . t) (shell . t) (latex . t))))
    (dolist (l '(python R C java sql))
      (when (require (intern (format "ob-%s" l)) nil t)
        (push (cons l t) langs)))
    (org-babel-do-load-languages 'org-babel-load-languages langs)))

;;; ---------------------------------------------------- pacotes opcionais do Org
(use-package! org-fragtog
  :hook (org-mode . org-fragtog-mode))

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autolinks t))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star 'replace
        org-modern-table nil))

;;; ============================================================ LATEX / ABNT
(after! tex
  (setq TeX-engine 'luatex
        TeX-save-query nil
        TeX-parse-self t
        TeX-auto-save t
        TeX-command-default "LatexMk"
        +latex-viewers '(pdf-tools))
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

(after! latex
  (setq font-latex-fontify-script nil)
  (add-hook 'LaTeX-mode-hook #'visual-line-mode)
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  ;; atalho local — dentro do after!, senão o keymap ainda não existe
  (map! :map LaTeX-mode-map
        :localleader
        :desc "Compilar tudo" "a" #'TeX-command-run-all))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("abntex2"
                 "\\documentclass[12pt,openright,oneside,a4paper,brazil]{abntex2}"
                 ("\\chapter{%s}"       . "\\chapter*{%s}")
                 ("\\section{%s}"       . "\\section*{%s}")
                 ("\\subsection{%s}"    . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (setq org-latex-pdf-process
        '("latexmk -shell-escape -bibtex -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f")))

(after! citar
  (setq citar-bibliography '("~/Documents/Faculdade/referencias.bib")))

;;; ============================================================ PYTHON
(after! python
  (setq python-shell-interpreter "python3"))

(after! lsp-pyright
  (setq lsp-pyright-typechecking-mode "basic"))

;;; ============================================================ R / ESS
(after! ess
  (setq ess-use-flymake nil
        ess-ask-for-ess-directory nil
        ess-eval-visibly 'nowait
        ess-style 'RStudio))

(after! ess-r-mode
  (map! :map ess-r-mode-map
        :i "M--" (cmd! (insert " <- "))
        :i "M-;" (cmd! (insert " |> "))))

;;; ============================================================ SQL
(after! sql
  (setq sql-product 'mysql
        sql-mysql-options '("--protocol=tcp"))
  (setq sql-connection-alist
        '((local
           (sql-product 'mysql)
           (sql-server "127.0.0.1")
           (sql-port 3306)
           (sql-user "root")
           (sql-database "teste")))))

(when (require 'sqlup-mode nil t)
  (add-hook 'sql-mode-hook #'sqlup-mode)
  (add-hook 'sql-interactive-mode-hook #'sqlup-mode))

;;; ============================================================ C / JAVA
(after! cc-mode
  (setq c-basic-offset 4))

;;; ============================================================ DADOS
(use-package! csv-mode
  :mode "\\.csv\\'"
  :config (setq csv-separators '("," ";" "\t")))

;;; --------------------------------------------------------------------- fim
