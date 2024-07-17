vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
            -- you can also put keymaps in here
        end,
        settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
            },
        },
    },
    -- DAP configuration
    dap = { },
}
