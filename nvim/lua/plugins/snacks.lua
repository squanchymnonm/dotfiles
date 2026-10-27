-- "Projects" del dashboard: cada repo git dentro de ~/Develop (incluye anidados, ej. Artisano/Back)
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        projects = { dev = { "~/Develop" }, patterns = { ".git" }, max_depth = 3, recent = false },
      },
    },
  },
}
