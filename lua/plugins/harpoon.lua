return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    local profile_state_path = vim.fn.stdpath("data") .. "/harpoon-profiles.json"
    local profile_map = {}

    local function read_json_file(path)
      local ok, lines = pcall(vim.fn.readfile, path)
      if not ok or not lines or vim.tbl_isempty(lines) then
        return nil
      end

      local ok_decode, data = pcall(vim.json.decode, table.concat(lines, "\n"))
      if not ok_decode then
        return nil
      end

      return data
    end

    local function write_json_file(path, data)
      local ok_encode, encoded = pcall(vim.json.encode, data)
      if not ok_encode then
        return
      end

      vim.fn.writefile({ encoded }, path)
    end

    local function root_dir()
      return vim.loop.cwd()
    end

    local function current_profile(root)
      root = root or root_dir()
      return profile_map[root] or "default"
    end

    local function persist_profile_map()
      write_json_file(profile_state_path, profile_map)
    end

    local function reload_profile_map()
      local data = read_json_file(profile_state_path)
      if type(data) == "table" then
        profile_map = data
      end
    end

    local function switch_profile(name)
      local root = root_dir()
      if current_profile(root) == name then
        return
      end

      harpoon:sync()
      profile_map[root] = name
      persist_profile_map()
      harpoon:setup()
      vim.notify(("Harpoon profile: %s"):format(name))
    end

    reload_profile_map()

    harpoon:setup({
      settings = {
        key = function()
          local root = root_dir()
          return vim.json.encode({
            root = root,
            profile = current_profile(root),
          })
        end,
      },
    })

    vim.keymap.set("n", "<space>x", function()
      harpoon:list():add()
    end)

    vim.keymap.set("n", "<space>q", function()
      harpoon:list():clear()
    end)

    vim.keymap.set("n", "<space>d", function()
      local list = harpoon:list()
      list:remove()
    end)

    vim.keymap.set("n", "<space>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<space>p0", function()
      switch_profile("default")
    end)

    vim.keymap.set("n", "<space>p1", function()
      switch_profile("1")
    end)

    vim.keymap.set("n", "<space>p2", function()
      switch_profile("2")
    end)

    vim.keymap.set("n", "<space>p3", function()
      switch_profile("3")
    end)

    vim.keymap.set("n", "<space>p4", function()
      switch_profile("4")
    end)

    vim.keymap.set("n", "<space>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<space>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<space>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<space>4", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<space>5", function() harpoon:list():select(5) end)
    vim.keymap.set("n", "<space>6", function() harpoon:list():select(6) end)
    vim.keymap.set("n", "<space>7", function() harpoon:list():select(7) end)
    vim.keymap.set("n", "<space>8", function() harpoon:list():select(8) end)
    vim.keymap.set("n", "<space>9", function() harpoon:list():select(9) end)
    vim.keymap.set("n", "<space>0", function() harpoon:list():select(10) end)
  end,
}
