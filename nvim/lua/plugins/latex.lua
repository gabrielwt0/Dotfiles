-- zathura has first-class vimtex support: automatic forward search
-- (jump to PDF line on save/view) *and* inverse search (ctrl+click in
-- the PDF jumps back to the source line) with no manual viewer config
-- needed, unlike the general/okular method this replaced.
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
}
