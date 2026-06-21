-- ============================================================================
-- java.lua — Java support via nvim-jdtls.
--
-- Java's language server (jdtls / "Eclipse JDT Language Server") needs more
-- careful, PER-PROJECT startup than other servers, so we use the dedicated
-- nvim-jdtls plugin. This file only REGISTERS the plugin and makes sure mason
-- downloaded jdtls (handled in lsp.lua's ensure_installed).
--
-- The ACTUAL startup logic lives in  ftplugin/java.lua  — Neovim runs that
-- file automatically every time you open a *.java buffer.
-- ============================================================================

return {
  "mfussenegger/nvim-jdtls",
  ft = "java", -- only load this plugin when a Java file is opened
  dependencies = { "saghen/blink.cmp" },
}
