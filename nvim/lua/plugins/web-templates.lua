-- HTML/CSS/Jinja support for Flask templates (no dedicated LazyVim extra for
-- plain html/css — lang.typescript/tailwind only cover JS-framework tooling).
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "html-lsp", "css-lsp", "emmet-language-server" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = { filetypes = { "html", "htmldjango" } },
        cssls = {},
        emmet_ls = {
          filetypes = { "html", "htmldjango", "css", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "html", "css", "htmldjango" } },
  },
}
