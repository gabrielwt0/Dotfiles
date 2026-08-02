;;; init.el -*- lexical-binding: t; -*-
;; ~/.config/doom/init.el
;; Depois de editar: doom sync && doom doctor

(doom! :input

       :completion
       (company +childframe)     ; autocompletar inline (popup company-box)

       :ui
       doom
       dashboard
       hl-todo
       indent-guides
       (ligatures +extra)
       modeline
       ophints
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces
       zen                       ; modo escrita sem distração

       :editor
       ;;(evil +everything)        ; teclas vim; remova se preferir teclas emacs
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       snippets
       word-wrap

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       syntax
       (spell +aspell +everywhere)
       grammar

       :tools
       biblio                    ; bibliografia / citações
       (debugger +lsp)
       direnv
       (docker +lsp)
       (eval +overlay)
       (lookup +dictionary +docsets)
       (lsp +peek)
       (magit +forge)
       make
       pdf
       tree-sitter

       :os
       (tty +osc)

       :lang
       (cc +lsp +tree-sitter)              ; C / C++
       (csharp +lsp +dotnet)               ; C#
       data                                ; csv, xml, formatos tabulares
       emacs-lisp
       (ess +lsp +tree-sitter)             ; R / Julia / Stata
       (java +lsp +tree-sitter)
       (json +lsp)
       (latex +latexmk +cdlatex +fold +lsp)
       (markdown +grip)
       (org +pretty +dragndrop +noter +jupyter +present +roam)
       (python +lsp +pyright +pyenv +tree-sitter)
       (sh +lsp +tree-sitter)
       (sql +lsp)
       (web +lsp +html)
       yaml

       :config
       (default +bindings +smartparens))
