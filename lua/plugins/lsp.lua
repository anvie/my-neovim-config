return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = true,
          autostart = true,
        },
      },
    },
  },
}
