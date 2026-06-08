describe("surrealql js/ts injections", function()
  for _, lang in ipairs({ "typescript", "tsx", "javascript" }) do
    it("ships a valid injection query for " .. lang, function()
      local files = vim.api.nvim_get_runtime_file("after/queries/" .. lang .. "/injections.scm", false)
      assert.is_true(#files > 0, "after/queries/" .. lang .. "/injections.scm should be on the runtimepath")

      -- Validate the query parses, but only when the host grammar is present.
      -- CI installs no language parsers, so the parse check is skipped there.
      if not pcall(vim.treesitter.query.parse, lang, "") then
        return
      end

      local src = table.concat(vim.fn.readfile(files[1]), "\n")
      assert.has_no.errors(function()
        vim.treesitter.query.parse(lang, src)
      end)
    end)
  end
end)
