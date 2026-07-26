;; -*- no-byte-compile: t; -*-
;; ~/.config/doom/packages.el
;; Depois de editar: doom sync

;;; Org ---------------------------------------------------------------
(package! org-modern)      ; visual limpo de headings, listas e tabelas
(package! org-appear)      ; mostra marcadores só ao editar
(package! org-fragtog)     ; renderiza LaTeX automaticamente
(package! org-download)    ; cola imagens do clipboard direto no Org

;;; Escrita / acadêmico -----------------------------------------------
(package! citar)           ; citações com bibliografia
(package! citar-org-roam)
(package! writegood-mode)  ; aponta voz passiva, clichês

;;; Dados / estatística ------------------------------------------------
(package! csv-mode)
(package! quarto-mode)     ; arquivos .qmd (R + Python + Markdown)
(package! ess-view-data)   ; visualiza data.frames do R em buffer

;;; SQL ----------------------------------------------------------------
(package! sqlup-mode)      ; palavras-chave em maiúsculo
(package! sql-indent)
(package! ejc-sql)         ; conexões JDBC (MySQL, Postgres) com autocompletar

;;; Utilidades ---------------------------------------------------------
(package! rainbow-mode)    ; mostra cores hex no próprio texto
(package! keycast)         ; exibe teclas pressionadas (útil para gravar tela)
