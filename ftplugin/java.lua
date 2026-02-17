local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then
  return
end

local root_markers = { ".git", "gradlew", "mvnw", "pom.xml", "build.gradle", "settings.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspaces/" .. project_name

local mason = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_path = mason .. "/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
  return
end

local bundles = {}
local java_debug = vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
if java_debug ~= "" then
  table.insert(bundles, java_debug)
end

for _, jar in ipairs(vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", 1), "\n")) do
  if jar ~= "" then
    table.insert(bundles, jar)
  end
end

local config = {
  cmd = {
    "jdtls",
    "--java-executable",
    vim.fn.expand("~/.config/bin/jdtls-java"),
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  init_options = { bundles = bundles },
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-1.8", path = "/Library/Java/JavaVirtualMachines/openjdk8-temurin/Contents/Home" },
          { name = "JavaSE-11", path = "/Library/Java/JavaVirtualMachines/openjdk11-temurin/Contents/Home" },
          { name = "JavaSE-21", path = "/opt/local/Library/Java/JavaVirtualMachines/jdk-21-eclipse-temurin.jdk/Contents/Home" },
        },
      },
    },
  },
  on_attach = function(_, bufnr)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    jdtls.setup_dap({ hotcodereplace = "auto" })
    pcall(jdtls.dap.setup_dap_main_class_configs)

    map("<leader>jd", function()
      require("jdtls.dap").test_class()
    end, "Java debug test class")
    map("<leader>jm", function()
      require("jdtls.dap").test_nearest_method()
    end, "Java debug test method")
    map("<leader>jr", function()
      require("jdtls").organize_imports()
    end, "Java organize imports")
  end,
}

jdtls.start_or_attach(config)
