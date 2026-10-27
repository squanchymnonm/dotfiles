-- PHP/Laravel + git, además de los extras de lazyvim.json
return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    keys = {
      { "<leader>L", "", desc = "+laravel" },
      { "<leader>Ll", function() Laravel.pickers.laravel() end, desc = "Laravel: Picker" },
      { "<leader>La", function() Laravel.pickers.artisan() end, desc = "Laravel: Artisan" },
      { "<leader>Lr", function() Laravel.pickers.routes() end, desc = "Laravel: Routes" },
      { "<leader>Lm", function() Laravel.pickers.make() end, desc = "Laravel: Make" },
      { "<leader>Lo", function() Laravel.pickers.resources() end, desc = "Laravel: Resources" },
      { "<leader>Lu", function() Laravel.commands.run("hub") end, desc = "Laravel: Artisan Hub" },
      { "<leader>Le", function() Laravel.commands.run("env:configure") end, desc = "Laravel: Environment" },
      { "<c-g>", function() Laravel.commands.run("view:finder") end, desc = "Laravel: View Finder" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        desc = "Laravel: Go to resource",
      },
    },
    opts = function()
      -- Artisano corre PHP en el contenedor "workspace" de ~/Develop/Artisano/Infra
      local infra = vim.fn.expand("~/Develop/Artisano/Infra")
      local function ws(...)
        return vim.list_extend({
          "docker", "compose", "--project-directory", infra, "-f", infra .. "/docker-compose.yml",
          "exec", "-T", "--user", "www-data", "-w", "/var/www/back", "workspace",
        }, { ... })
      end
      local in_artisano = vim.startswith(vim.fn.getcwd(), vim.fn.expand("~/Develop/Artisano"))
      return {
        features = { pickers = { provider = "snacks" } },
        environments = {
          default = in_artisano and "artisano" or "local",
          definitions = {
            { name = "artisano", map = { php = ws("php"), composer = ws("composer") } },
            { name = "local" },
          },
        },
      }
    end,
  },
  {
    "ricardoramirezr/blade-nav.nvim",
    ft = { "blade", "php" },
    opts = { close_tag_on_complete = true, integrations = { cmp = false } },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "blade-nav" },
        providers = {
          ["blade-nav"] = { name = "blade-nav", module = "blade-nav.integrations.blink" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade" } },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview (cambios / conflictos)" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview historial del archivo" },
    },
  },
}
