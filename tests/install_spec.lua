describe("surrealql.install", function()
  local install

  before_each(function()
    package.loaded["surrealql.install"] = nil
    install = require("surrealql.install")
  end)

  describe("bin_path", function()
    it("returns a path inside stdpath data", function()
      local path = install.bin_path()
      assert.truthy(path:find(vim.fn.stdpath("data"), 1, true))
    end)

    it("contains the binary name", function()
      local path = install.bin_path()
      assert.truthy(path:find("surrealql-language-server", 1, true))
    end)
  end)

  describe("is_installed", function()
    it("returns false when binary is absent from managed path and PATH", function()
      local orig = vim.fn.executable
      vim.fn.executable = function() return 0 end
      local ok, bin = install.is_installed()
      vim.fn.executable = orig
      assert.is_false(ok)
      assert.is_nil(bin)
    end)

    it("returns true and managed path when managed binary exists", function()
      local managed = install.bin_path()
      local orig = vim.fn.executable
      vim.fn.executable = function(p) return p == managed and 1 or 0 end
      local ok, bin = install.is_installed()
      vim.fn.executable = orig
      assert.is_true(ok)
      assert.equals(managed, bin)
    end)

    it("falls back to system PATH when managed binary is absent", function()
      local managed = install.bin_path()
      local orig = vim.fn.executable
      vim.fn.executable = function(p)
        if p == managed then return 0 end
        if p == "surreal-language-server" then return 1 end
        return 0
      end
      local ok, bin = install.is_installed()
      vim.fn.executable = orig
      assert.is_true(ok)
      assert.equals("surreal-language-server", bin)
    end)
  end)

  describe("install", function()
    it("skips download when already installed", function()
      local notified = false
      local orig_notify = vim.notify
      vim.notify = function(msg)
        if msg:find("already installed") then notified = true end
      end

      local orig = vim.fn.executable
      vim.fn.executable = function() return 1 end

      install.install(function() end)

      vim.fn.executable = orig
      vim.notify = orig_notify
      assert.is_true(notified)
    end)

    it("calls on_done(false) when curl fails and no cargo", function()
      local orig_executable = vim.fn.executable
      vim.fn.executable = function() return 0 end

      local orig_system = vim.system
      vim.system = function(cmd, _, cb)
        cb({ code = 1, stderr = "connection refused" })
      end

      local orig_schedule = vim.schedule
      vim.schedule = function(f) f() end

      local result = nil
      install.install(function(ok) result = ok end)

      vim.fn.executable = orig_executable
      vim.system = orig_system
      vim.schedule = orig_schedule
      assert.is_false(result)
    end)
  end)
end)
