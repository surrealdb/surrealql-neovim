local M = {}

local REPO = "surrealdb/surrealql-language-server"

local PLATFORM_BINARIES = {
  ["linux-x86_64"]  = "surrealql-language-server-linux-amd64",
  ["linux-aarch64"] = "surrealql-language-server-linux-arm64",
  ["darwin-arm64"]  = "surrealql-language-server-macos-arm64",
  ["windows-x86_64"] = "surrealql-language-server-windows-amd64.exe",
}

local function platform_key()
  local uname = vim.uv.os_uname()
  local sys = uname.sysname:lower()
  local arch = uname.machine:lower()

  if sys:find("linux") then
    if arch == "x86_64" or arch == "amd64" then return "linux-x86_64" end
    if arch == "aarch64" or arch == "arm64" then return "linux-aarch64" end
  elseif sys:find("darwin") then
    if arch == "arm64" then return "darwin-arm64" end
  elseif sys:find("windows") then
    return "windows-x86_64"
  end
  return nil
end

function M.bin_path()
  local name = "surrealql-language-server"
  if vim.uv.os_uname().sysname:lower():find("windows") then
    name = name .. ".exe"
  end
  return vim.fn.stdpath("data") .. "/surrealql/bin/" .. name
end

function M.is_installed()
  local managed = M.bin_path()
  if vim.fn.executable(managed) == 1 then
    return true, managed
  end
  if vim.fn.executable("surreal-language-server") == 1 then
    return true, "surreal-language-server"
  end
  return false, nil
end

local function download(filename, on_done)
  local url = "https://github.com/" .. REPO .. "/releases/latest/download/" .. filename
  local dest = M.bin_path()
  vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")

  vim.notify("[surrealql] Downloading language server...", vim.log.levels.INFO)

  vim.system({ "curl", "-fsSL", "-o", dest, url }, {}, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify("[surrealql] Download failed: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
        on_done(false)
      end)
      return
    end
    vim.uv.fs_chmod(dest, 493) -- 0755
    vim.schedule(function()
      vim.notify("[surrealql] Language server installed.", vim.log.levels.INFO)
      on_done(true, dest)
    end)
  end)
end

local function cargo_install(on_done)
  if vim.fn.executable("cargo") == 0 then
    vim.notify(
      "[surrealql] No prebuilt binary for this platform and cargo not found. Install Rust to build from source.",
      vim.log.levels.ERROR
    )
    on_done(false)
    return
  end

  vim.notify("[surrealql] Building language server via cargo (this may take a while)...", vim.log.levels.INFO)

  vim.system({ "cargo", "install", "surrealql-language-server" }, {}, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify("[surrealql] cargo install failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
        on_done(false)
      end)
      return
    end
    vim.schedule(function()
      vim.notify("[surrealql] Language server installed via cargo.", vim.log.levels.INFO)
      on_done(true, "surreal-language-server")
    end)
  end)
end

function M.install(on_done)
  on_done = on_done or function() end

  local ok, _ = M.is_installed()
  if ok then
    vim.notify("[surrealql] Language server is already installed.", vim.log.levels.INFO)
    on_done(true)
    return
  end

  local key = platform_key()
  local filename = key and PLATFORM_BINARIES[key]

  if filename then
    download(filename, on_done)
  else
    cargo_install(on_done)
  end
end

return M
