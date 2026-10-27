-- PHP/Laravel + git, además de los extras de lazyvim.json

-- PHP no está instalado local: cada proyecto lo corre en Docker.
-- Artisano: contenedor "workspace" de ~/Develop/Artisano/Infra, con Back montado en /var/www/back
local artisano = {
  infra = vim.fn.expand("~/Develop/Artisano/Infra"),
  back = vim.fn.expand("~/Develop/Artisano/Back"),
}
function artisano.exec(...)
  local infra = artisano.infra
  return vim.list_extend({
    "docker", "compose", "--project-directory", infra,
    "-f", infra .. "/docker-compose.yml", "-f", infra .. "/docker-compose.dev.yml",
    "exec", "-T", "--user", "www-data", "-w", "/var/www/back", "workspace",
  }, { ... })
end

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
      local ws = artisano.exec
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
    -- formateo PHP con Pint dentro del contenedor (en vez de php-cs-fixer local)
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.php = { "pint_artisano" }
      opts.formatters.pint_artisano = {
        command = "docker",
        args = function(_, ctx)
          local file = "/var/www/back" .. ctx.filename:sub(#artisano.back + 1)
          return vim.list_slice(artisano.exec("vendor/bin/pint", "--quiet", file), 2)
        end,
        stdin = false,
        condition = function(_, ctx)
          return vim.startswith(ctx.filename, artisano.back .. "/")
        end,
      }
    end,
  },
  {
    -- phpcs necesita PHP local; los errores ya los marca intelephense
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.php = nil
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
