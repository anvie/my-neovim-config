-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim.cmd([[
--     call plug#begin()
--
--     Plug 'famiu/bufdelete.nvim'
--     Plug 'neoclide/coc.nvim', {'branch': 'release'}
--
--     call plug#end()
-- ]])

vim.cmd([[

nnoremap zz :wall<cr>
nnoremap gs :Neotree reveal<cr>
nnoremap tt :Telescope<cr>

]])

vim.keymap.set("n", "<S-C>", ":Bdelete<CR>")
vim.keymap.set("n", "<\\>", ":Neotree<CR>")

vim.keymap.set("v", "<S-C>", ":Bdelete<CR>")

vim.keymap.set("n", "<leader>a", ":lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<leader>v", ":vsplit | lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<leader>s", ":belowright split | lua vim.lsp.buf.definition()<CR>")

-- To appropriately highlight codefences for Deno js and ts files.
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

-- Removed redundant commented-out LSP configuration for denols
local nvim_lsp = require("lspconfig")
nvim_lsp.denols.setup({
  cmd = { "deno", "lsp" },
  on_attach = on_attach,
  file_types = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  code_action_handler = true,
})

nvim_lsp.vtsls.setup({
  on_attach = ...,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
})

-- nvim_lsp.denols.setup({
--   cmd = { "deno", "lsp" },
--   on_attach = function(client, bufnr) end,
--   file_types = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
--
--   -- on_attach = on_attach,
--   root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
--
--   settings = {
--     deno = {
--       enable = true,
--       suggest = {
--         imports = {
--           hosts = {
--             ["https://deno.land"] = true,
--           },
--         },
--       },
--     },
--   },
-- })

-- nvim_lsp.ts_ls.setup({
--   on_attach = on_attach,
--   root_dir = nvim_lsp.util.root_pattern("package.json"),
--   single_file_support = false,
-- })

nvim_lsp.ts_ls.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>ro", function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.fn.expand("%:p") },
      })
    end, { buffer = bufnr, remap = false })
  end,
  root_dir = function(filename, bufnr)
    local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.json")(filename)
    if denoRootDir then
      -- print('this seems to be a deno project; returning nil so that tsserver does not attach');
      return nil
      -- else
      -- print('this seems to be a ts project; return root dir based on package.json')
    end

    return lspconfig.util.root_pattern("package.json")(filename)
  end,
  single_file_support = false,
})

require("deno-nvim").setup({
  server = {
    on_attach = ...,
    capabilites = ...,
  },
  -- if you're using dap to debug (see the README for more info)
  dap = {
    adapter = ...,
  },
})

-- Configure neo-tree
local neo_tree = require("neo-tree")
neo_tree.setup({
  filesystem = {
    filtered_items = {
      hide_by_name = {
        "node_modules",
      },
    },
  },
})

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "target",
    },
  },
})

require("copilot").setup({
  suggestion_interval = 2000,
})

-- require("avante").setup({
--   provider = "openai",
--   -- api_key_name = "OPENAI_API_KEY",
--   -- openai = {
--   --   endpoint = "https://api.openai.com/v1/chat/completions",
--   --   model = "gpt-4o",
--   --   temperature = 0,
--   --   max_tokens = 4096,
--   -- }, --- this function below will be used to parse in cURL arguments.
--   -- parse_curl_args = function(opts, code_opts)
--   --   return {
--   --     url = opts.endpoint,
--   --     headers = {
--   --       ["Accept"] = "application/json",
--   --       ["Content-Type"] = "application/json",
--   --       ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
--   --     },
--   --     body = {
--   --       model = opts.model,
--   --       messages = require("avante.providers").openai.parse_message(code_opts), -- you can make your own message, but this is very advanced
--   --       temperature = 0,
--   --       max_tokens = 8192,
--   --       stream = true, -- this will be set by default.
--   --     },
--   --   }
--   -- end,
--   -- -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
--   -- parse_response_data = function(data_stream, event_state, opts)
--   --   require("avante.providers").openai.parse_response(data_stream, event_state, opts)
--   -- end,
-- })

-- require("conform").setup({
--
-- })
--
