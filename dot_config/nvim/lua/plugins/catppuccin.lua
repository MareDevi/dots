return {
  -- Catppuccin 主题核心配置
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- 指定使用 Macchiato 变体
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      -- 详细的插件集成设置
      integrations = {
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        hop = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
          scope_color = "lavender", -- 缩进线颜色
          colored_indent_levels = false,
        },
        leap = true,
        lsp_saga = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = {
          enabled = true,
          indentscope_color = "lavender",
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neogit = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        overseer = true,
        pounce = true,
        rainbow_delimiters = true,
        ["render-markdown"] = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = {
          enabled = true,
        },
        treesitter = true,
        treesitter_context = true,
        ts_context_commentstring = true,
        vim_sneak = true,
        vimwiki = true,
        which_key = true,
        window_picker = true,
      },
    },
  },

  -- 确保 LazyVim 加载 catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },

  -- 为 Lualine 设置主题，建议使用 "auto" 以自动匹配 catppuccin
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "auto"
    end,
  },

  -- 为 Bufferline 显式设置 catppuccin 集成
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if (vim.g.colorscheme or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.special.bufferline").get_theme()
      end
    end,
  },
}
