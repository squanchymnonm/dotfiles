-- "Projects" del dashboard: todas las carpetas dentro de ~/Develop
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local root = vim.fn.expand("~/Develop")
    local projects = {}
    for name, type in vim.fs.dir(root) do
      if type == "directory" then
        table.insert(projects, root .. "/" .. name)
      end
    end
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.projects = { projects = projects, dev = { root }, max_depth = 1, recent = false }
  end,
}
