-- Okular is the only PDF viewer installed on this KDE machine (vimtex
-- defaults to zathura, which isn't present), wired up via vimtex's
-- "general" viewer method with forward search (source line -> PDF).
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
    end,
  },
}
