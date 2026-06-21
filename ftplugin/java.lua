-- ============================================================================
-- ftplugin/java.lua
-- Neovim runs every  ftplugin/<filetype>.lua  automatically when you open a
-- file of that type. So THIS file runs each time you open a *.java file, and it
-- starts (or re-attaches) the Java language server for that project.
--
-- This is the standard nvim-jdtls setup. It detects your OS at runtime, so the
-- same config works on Linux, macOS, and Windows — nothing is hard-coded.
-- ============================================================================

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return -- nvim-jdtls not installed yet; silently skip
end

-- Where mason installed jdtls.
local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- The Equinox launcher jar (its exact name has a version, so we glob for it).
local launcher = vim.fn.glob(mason_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
  vim.notify("jdtls not installed. Open Neovim and run :Mason, then install 'jdtls'.", vim.log.levels.WARN)
  return
end

-- jdtls ships per-OS config folders. Pick the right one at runtime.
local config_dir = mason_pkg .. "/config_linux"
if vim.fn.has("mac") == 1 then
  config_dir = mason_pkg .. "/config_mac"
elseif vim.fn.has("win32") == 1 then
  config_dir = mason_pkg .. "/config_win"
end

-- Find the project root by looking upward for these marker files.
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

-- jdtls keeps an index/cache per project. Give each project its own folder.
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Pull in blink.cmp completion capabilities (same as our other servers).
local capabilities = require("blink.cmp").get_lsp_capabilities()

local config = {
  -- The command Neovim runs to launch the server. Uses the `java` on your PATH
  -- (you have Java 21 via SDKMAN — jdtls needs Java 17+).
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      format = { enabled = true }, -- jdtls formats Java for us (Eclipse style)
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- decompile .class files
    },
  },
  init_options = { bundles = {} },
}

-- Start the server, or attach to one already running for this project.
jdtls.start_or_attach(config)
