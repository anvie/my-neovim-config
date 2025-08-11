return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = true,
          autostart = true,
        },
        jinja_lsp = {
          filetypes = { "jinja", "html" },
        },
      },
    },
  },
}
