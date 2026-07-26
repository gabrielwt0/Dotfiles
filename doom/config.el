;;; config.el -*- lexical-binding: t; -*-
;; ~/.config/doom/config.el

;;; ---------------------------------------------------------------- identidade
(setq user-full-name "Marcos"
      user-mail-address "seu@email.com")

;;; ------------------------------------------------------------------ aparência
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 22))

(setq doom-theme 'doom-nord)          ; combina com a paleta da waybar
(setq display-line-numbers-type 'relative)

;; Transparência leve e sem barra de título (Wayland/Sway)
(add-to-list 'default-frame-alist '(alpha-background . 100))
(setq frame-resize-pixelwise t)

;;; ---------------------------------------------------------------- comportamento
(setq confirm-kill-emacs nil          ; não pergunta ao sair
      delete-by-moving-to-trash t
      truncate-string-ellipsis "…"
      scroll-margin 3
      auto-save-default t
      make-backup-files t
      backup-directory-alist `(("." . ,(expand-file-name "backups" doom-cache-dir))))

;; Idioma do corretor ortográfico
(after! ispell
  (setq ispell-dictionary "pt_BR"))
;; Alterna pt_BR / en_US com SPC t s
(map! :leader :desc "Trocar dicionário" "t s"
      (cmd! (ispell-change-dictionary
             (if (string= ispell-current-dictionary "pt_BR") "en_US" "pt_BR"))))

;;; ============================================================ ORG MODE
(setq org-directory "~/Documents/Faculdade/")

(after! org
  (setq org-agenda-files (list org-directory
                               (concat org-directory "Economia/"))
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

  ;; Estados de tarefa
  (setq org-todo-keywords
        '((sequence "TODO(t)" "FAZENDO(f)" "ESPERA(e)" "|" "FEITO(d)" "CANCELADO(c)")))

  ;; Linguagens executáveis em blocos de código
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python     . t)
     (R          . t)
     (C          . t)
     (java       . t)
     (sql        . t)
     (shell      . t)
     (latex      . t)
     (jupyter    . t)))

  ;; Templates de captura
  (setq org-capture-templates
        '(("t" "Tarefa" entry (file+headline "~/Documents/Faculdade/inbox.org" "Tarefas")
           "* TODO %?\n  %U\n  %a")
          ("n" "Nota" entry (file+headline "~/Documents/Faculdade/inbox.org" "Notas")
           "* %?\n  %U")
          ("e" "Estudo CACD" entry (file+headline "~/Documents/CACD/plano.org" "Sessões")
           "* TODO %?\n  SCHEDULED: %^t")))

  ;; Fórmulas LaTeX maiores no preview
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.6)))

;; Renderiza fórmulas automaticamente ao sair do bloco
(use-package! org-fragtog
  :hook (org-mode . org-fragtog-mode))

;; Marcadores (*negrito*, /itálico/) aparecem só ao editar
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autolinks t))

;; Visual mais limpo
(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star 'replace
        org-modern-table nil))

;;; ============================================================ LATEX / ABNT
(after! tex
  (setq TeX-engine 'luatex                  ; troque para 'pdflatex se preferir
        TeX-save-query nil
        TeX-parse-self t
        TeX-auto-save t
        TeX-command-default "LatexMk")
  ;; Visualiza no pdf-tools, com sincronia reversa
  (setq +latex-viewers '(pdf-tools))
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

(after! latex
  (setq font-latex-fontify-script nil)
  (add-hook 'LaTeX-mode-hook #'visual-line-mode)
  (add-hook 'LaTeX-mode-hook #'flyspell-mode))

;; Bibliografia (ABNT via abntex2 / biblatex-abnt)
(setq! citar-bibliography '("~/Documents/Faculdade/referencias.bib")
       org-cite-global-bibliography '("~/Documents/Faculdade/referencias.bib")
       citar-notes-paths '("~/Documents/Faculdade/notas/"))

;; Classe abnTeX2 disponível na exportação do Org
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

;;; ============================================================ PYTHON
(after! python
  (setq python-shell-interpreter "python3"))

(after! lsp-pyright
  (setq lsp-pyright-typechecking-mode "basic"))

;; Ambientes virtuais por projeto
(after! pyvenv
  (add-hook 'pyvenv-post-activate-hooks
            (lambda () (setq python-shell-interpreter
                             (concat pyvenv-virtual-env "bin/python")))))

;;; ============================================================ R / ESS
(after! ess
  (setq ess-use-flymake nil
        ess-ask-for-ess-directory nil
        ess-eval-visibly 'nowait
        ess-style 'RStudio)
  ;; |> em vez de %>% se preferir: troque a string
  (map! :map ess-r-mode-map
        :i "M--" (cmd! (insert " <- "))
        :i "M-;" (cmd! (insert " |> "))))

;;; ============================================================ SQL / MYSQL
(after! sql
  (setq sql-mysql-options '("--protocol=tcp")
        sql-product 'mysql)
  ;; Conexões salvas — preencha e use com M-x sql-connect
  (setq sql-connection-alist
        '((local-mysql
           (sql-product 'mysql)
           (sql-server "127.0.0.1")
           (sql-port 3306)
           (sql-user "root")
           (sql-database "teste")))))

;; Palavras-chave em maiúsculo automaticamente
(add-hook 'sql-mode-hook #'sqlup-mode)
(add-hook 'sql-interactive-mode-hook #'sqlup-mode)

;;; ============================================================ C / JAVA / C#
(after! lsp-java
  (setq lsp-java-format-settings-url
        "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml"))

(after! cc-mode
  (setq c-basic-offset 4))

;; C# usa o csharp-ls ou omnisharp — instale o dotnet SDK
(after! csharp-mode
  (setq lsp-csharp-server-path nil))   ; deixa o lsp-mode baixar

;;; ============================================================ DATA SCIENCE
;; Notebooks Jupyter dentro do Org (org-babel-jupyter)
(after! jupyter
  (setq jupyter-eval-use-overlays t))

;; CSV alinhado
(use-package! csv-mode
  :mode "\\.csv\\'"
  :config (setq csv-separators '("," ";" "\t")))

;; Quarto (.qmd) — R + Python + Markdown num arquivo só
(use-package! quarto-mode
  :mode (("\\.qmd\\'" . poly-quarto-mode)))

;;; ============================================================ ATALHOS
(map! :leader
      (:prefix ("d" . "dados")
       :desc "Abrir R"            "r" #'R
       :desc "Python REPL"        "p" #'run-python
       :desc "SQL conectar"       "s" #'sql-connect
       :desc "Jupyter REPL"       "j" #'jupyter-run-repl)

      (:prefix ("o" . "abrir")
       :desc "Agenda"             "a" #'org-agenda
       :desc "Capturar"           "c" #'org-capture
       :desc "Terminal (vterm)"   "t" #'+vterm/toggle))

;; Compilar LaTeX com C-c C-a em qualquer modo TeX
(map! :map LaTeX-mode-map
      :localleader
      :desc "Compilar tudo" "a" #'TeX-command-run-all)

;;; --------------------------------------------------------------------- fim
(load! "gcal")
