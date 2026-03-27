local blink = require('blink.cmp')

-- blink.cmp configuration
blink.setup({
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = { enabled = true }
})

local capabilities = blink.get_lsp_capabilities()

-- Helper for Neovim 0.11+ LSP config
local function setup_lsp(name, config)
  config = config or {}
  config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})
  
  -- Use Neovim 0.11+ native config if available, fallback to nvim-lspconfig
  if vim.lsp.config then
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
  else
    require('lspconfig')[name].setup(config)
  end
end

-- Nix (nil)
setup_lsp('nil_ls')

-- Lua
setup_lsp('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enabled = false },
    },
  },
})

-- Python (pyright + ruff)
setup_lsp('pyright')
setup_lsp('ruff')

-- Rust (similar to Helix)
setup_lsp('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { buildScripts = { enable = true }, features = "all" },
      procMacro = { enable = true },
      rustfmt = { rangeFormatting = { enable = true } },
      inlayHints = {
        bindingModeHints = { enable = true },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true },
        closureCaptureHints = { enable = true },
        closureReturnTypeHints = { enable = "always" },
        closureStyle = "impl_fn",
        discriminantHints = { enable = "always" },
        expressionAdjustmentHints = { enable = "always" },
        implicitDrops = { enable = true },
        lifetimeElisionHints = { enable = "always", useParameterNames = true },
        parameterHints = { enable = true },
        reborrowHints = { enable = "always" },
        typeHints = { enable = true },
      },
    },
  },
})

-- Deno
setup_lsp('denols', {
  init_options = {
    enable = true,
    unstable = true,
    inlayHints = {
      functionLikeReturnTypes = { enabled = true },
      parameterNames = { enabled = "literals" },
      propertyDeclarationTypes = { enabled = true },
    },
  },
  root_dir = vim.fs.root(0, {"deno.json", "deno.jsonc"}),
})

-- YAML & TOML
setup_lsp('yamlls')
setup_lsp('taplo')

-- Diagnostic UI
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
