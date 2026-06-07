-- ╔══════════════════════════════════════════════════════════════╗
-- ║  transparent.lua — Neovim transparente (LazyVim)             ║
-- ║  Deja ver el blur de kitty a través del editor. Monochrome.  ║
-- ╠══════════════════════════════════════════════════════════════╣
-- ║  Se carga solo: LazyVim toma todo lua/plugins/*.lua          ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Re-aplica transparencia cada vez que cambia el colorscheme,
      -- así no importa qué tema use LazyVim.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("GlossyTransparent", { clear = true }),
        callback = function()
          local groups = {
            "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
            "SignColumn", "FoldColumn", "LineNr", "CursorLineNr", "EndOfBuffer",
            "MsgArea", "MsgSeparator", "VertSplit", "WinSeparator",
            "StatusLine", "StatusLineNC", "TabLine", "TabLineFill", "TabLineSel",
            "Pmenu", "PmenuSbar", "WhichKeyFloat",
            "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
            "NeoTreeNormal", "NeoTreeNormalNC", "NvimTreeNormal",
          }
          for _, g in ipairs(groups) do
            vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "none" })
          end
          -- Acento monocromático blanco (cursor de línea / selección sutil)
          vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" })
          vim.api.nvim_set_hl(0, "Visual", { bg = "#2a2a2a" })
        end,
      })
      -- Disparalo una vez por si el colorscheme ya estaba puesto.
      pcall(vim.cmd, "doautocmd ColorScheme")
    end,
  },
}
