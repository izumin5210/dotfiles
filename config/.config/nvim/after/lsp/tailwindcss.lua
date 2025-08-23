---@type vim.lsp.Config
local config = {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          -- https://github.com/paolotiu/tailwind-intellisense-regex-list
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          "(?:enter|leave)(?:From|To)?=\\s*(?:\"|')([^(?:\"|')]*)",

          -- https://cva.style/docs/getting-started/installation#intellisense
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },

          -- shadcn/ui's `cn` helper
          -- https://github.com/shadcn-ui/ui/blob/shadcn-ui%400.9.3/packages/shadcn/src/utils/templates.ts#L1-L7
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
}

return config
