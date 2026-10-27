-- "Projects" del dashboard: cada repo git dentro de ~/Develop (incluye anidados, ej. Artisano/Back)
local root = vim.fn.expand("~/Develop")

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        projects = {
          dev = { root },
          patterns = { ".git" },
          max_depth = 3,
          recent = false,
          -- nombre relativo a ~/Develop: "Artisano/Back" en vez de "Back"
          format = function(item)
            local name = item.file:gsub("^" .. vim.pesc(root) .. "/", "")
            return { { "󰉋 ", "Directory" }, { name, "SnacksPickerFile" } }
          end,
        },
      },
    },
  },
}
