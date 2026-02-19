local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then
  return
end

-- For multi-module Gradle projects, prefer the top-level root (settings.gradle, gradlew)
-- over subproject markers (build.gradle) to get full dependency resolution.
local root_dir = require("jdtls.setup").find_root({ "settings.gradle", "settings.gradle.kts", "gradlew", "mvnw", ".git" })
  or require("jdtls.setup").find_root({ "build.gradle", "build.gradle.kts", "pom.xml" })
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
  if jar ~= "" and not vim.endswith(jar, "jacocoagent.jar") and not jar:match("runner%-jar%-with%-dependencies") then
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
      import = {
        gradle = {
          java = {
            home = "/Library/Java/JavaVirtualMachines/openjdk8-temurin/Contents/Home",
          },
        },
      },
      configuration = {
        runtimes = {
          { name = "JavaSE-1.8", path = "/Library/Java/JavaVirtualMachines/openjdk8-temurin/Contents/Home", default = true },
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

    -- DAP setup: nvim-dap may be lazy-loaded, so guard all dap calls
    local ok_dap, _ = pcall(require, "dap")
    if ok_dap then
      pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
      pcall(function()
        require("jdtls.dap").setup_dap_main_class_configs()
      end)
    end

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
