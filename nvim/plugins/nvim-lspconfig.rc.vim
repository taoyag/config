lua <<EOF
local nvim_lsp = require('lspconfig')

-- TypeScript
nvim_lsp.tsserver.setup {}

-- Vue
nvim_lsp.vuels.setup {
  init_options = {
    config = {
      css = {},
      emmet = {},
      html = {
        suggest = {}
      },
      javascript = {
        format = {}
      },
      stylusSupremacy = {},
      typescript = {
        format = {}
      },
      vetur = {
        completion = {
          autoImport = true,
          tagCasing = "kebab",
          useScaffoldSnippets = false
        },
        format = {
          defaultFormatter = {
            js = "prettier",
            ts = "prettier",
            html = "prettier",
            css = "prettier",
            scss = "prettier"
          },
          defaultFormatterOptions = {},
          scriptInitialIndent = false,
          styleInitialIndent = false
       },
        useWorkspaceDependencies = true,
        validation = {
          script = true,
          style = true,
          template = true
        }
      }
    }
  }
}

-- PHP
nvim_lsp.intelephense.setup {}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = {
    'javascript',
    'javascriptreact',
    'json',
    'typescript',
    'typescriptreact',
    'vue',
    'css',
    'less',
    'scss',
    'markdown',
    'pandoc'
  },
  init_options = {
    linters = {
      eslint_d = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
      eslint = {
        command = 'eslint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint_d',
      javascriptreact = 'eslint_d',
      typescript = 'eslint_d',
      typescriptreact = 'eslint_d',
      vue = 'eslint_d'
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
        rootPatterns = { '.git' },
      },
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'eslint_d',
      javascriptreact = 'eslint_d',
      json = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'prettier',
      typescriptreact = 'eslint_d',
      vue = 'prettier',
      json = 'prettier',
      markdown = 'prettier'
    }
  }
}

-- TODO Java


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- if client.resolved_capabilities.document_formatting then
  --   vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
  -- end
  --if client.resolved_capabilities.document_formatting then
  --  vim.api.nvim_command [[augroup Format]]
  --  vim.api.nvim_command [[autocmd! * <buffer>]]
  --  vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
  --  vim.api.nvim_command [[augroup END]]
  -- end

end

local protocol = require('vim.lsp.protocol')
protocol.CompletionItemKind = {
  '', -- Text
  '', -- Method
  '', -- Function
  '', -- Constructor
  '', -- Field
  '', -- Variable
  '', -- Class
  'ﰮ', -- Interface
  '', -- Module
  '', -- Property
  '', -- Unit
  '', -- Value
  '', -- Enum
  '', -- Keyword
  '﬌', -- Snippet
  '', -- Color
  '', -- File
  '', -- Reference
  '', -- Folder
  '', -- EnumMember
  '', -- Constant
  '', -- Struct
  '', -- Event
  'ﬦ', -- Operator
  '', -- TypeParameter
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { "tsserver", "vuels", "intelephense", "diagnosticls" }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     }
--   }
-- end


-- local format_async = function(err, _, result, _, bufnr)
--     if err ~= nil or result == nil then return end
--     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         if bufnr == vim.api.nvim_get_current_buf() then
--             vim.api.nvim_command("noautocmd :update")
--         end
--     end
-- end
-- vim.lsp.handlers["textDocument/formatting"] = format_async
EOF


nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>D <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>ac <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

" moved to lspsaga.rc.vvim
" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> <space>a <cmd>lua vim.lsp.buf.show_line_diagnostics()<CR>
" nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>



autocmd BufWritePre *.js lua vim.lsp.buf.formatting_seq_sync(nil, 100)
autocmd BufWritePre *.vue lua vim.lsp.buf.formatting_seq_sync(nil, 500)
autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_seq_sync(nil, 500)
autocmd BufWritePre *.php lua vim.lsp.buf.formatting_seq_sync(nil, 100)
autocmd BufWritePre *.java lua vim.lsp.buf.formatting_seq_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_seq_sync(nil, 100)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_seq_sync(nil, 100)
