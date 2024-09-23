---@param filenames string[]
---@param extensions string[]
---@return string[]
local function all_filenames(filenames, extensions)
  local combined = {}
  for _, filename in ipairs(filenames) do
    for _, extension in ipairs(extensions) do
      table.insert(combined, filename .. "." .. extension)
    end
  end
  return combined
end

---@param cosmicconfig_names string[]
---@return string[]
local function all_cosmicconfig_filenames(cosmicconfig_names)
  local rc_exts = {
    "json",
    "yaml",
    "yml",
    "ts",
    "js",
    "cjs",
    "mjs",
    "cts",
    "mts",
  }
  local config_exts = {
    "ts",
    "js",
    "cjs",
    "mjs",
    "cts",
    "mts",
  }
  ---@type string[]
  local combined = {}
  for _, name in ipairs(cosmicconfig_names) do
    table.insert(combined, name .. "rc")
    table.insert(combined, "." .. name .. "rc")
    for _, ext in ipairs(rc_exts) do
      table.insert(combined, name .. "rc." .. ext)
      table.insert(combined, "." .. name .. "rc." .. ext)
    end
    for _, ext in ipairs(config_exts) do
      table.insert(combined, name .. ".config." .. ext)
    end
  end
  return combined
end

---@type string[]
local generic_filenames = {
  -- Lua
  "init.lua",
  -- Go
  "main.go",
  "server.go",
  -- JavaScript
  "index.vue",
  "package.json",
  "tsconfig.json",
  -- GraphQL
  "schema.graphql",
  -- GitHub Actions
  "action.yml",
  "action.yaml",
  -- Common
  "README.md",
  ".gitignore",
}

vim.list_extend(
  generic_filenames,
  all_filenames({
    "index",
    "main",
    "util",
    "utils",
    "codegen",
    -- Next.js
    -- https://nextjs.org/docs/getting-started/project-structure#app-routing-conventions
    "layout",
    "page",
    "loading",
    "not-found",
    "error",
    "global-error",
    "route",
    "template",
    "default",
  }, {
    "js",
    "jsx",
    "ts",
    "tsx",
    "cjs",
    "mjs",
    "cts",
    "mts",
  })
)

vim.list_extend(
  generic_filenames,
  all_cosmicconfig_filenames({
    "eslint",
    "jest",
    "next",
    "prettier",
    "vite",
    "vitest",
  })
)

---@type table<string, boolean>
local generic_filename_hash = {}

for _, filename in ipairs(generic_filenames) do
  generic_filename_hash[filename] = true
end

---@type table<string, boolean>
local generic_dirname_hash = {
  src = true,
  app = true,
  pages = true,
  [".config"] = true,
  [".storybook"] = true,
}

---@param filename string
---@return boolean
local function is_generic_filename(filename)
  return generic_filename_hash[filename] == true
end

---@param filename string
---@return boolean
local function is_generic_dirname(filename)
  return generic_dirname_hash[filename] == true
end

---@param fullpath string
---@return string, string|nil
local function _get_display_filename_and_dirname(fullpath)
  local filepath = vim.fn.fnamemodify(fullpath, ":.")
  local filename = vim.fn.fnamemodify(filepath, ":t")

  if filename == "" then
    return "[No Name]", nil
  end

  if not is_generic_filename(filename) then
    return filename, nil
  end

  local dirpath = filepath
  local display_dir = nil

  for _ = 1, 3 do
    dirpath = vim.fs.dirname(dirpath)
    local dirname = vim.fs.basename(dirpath)
    if dirname == "." then
      break
    end
    display_dir = dirname .. (display_dir and "/" .. display_dir or "")
    if not is_generic_dirname(dirname) then
      break
    end
  end

  return filename, display_dir
end

---@type table<string, { filename: string, dirname: string | nil}>
local cache = {}

---@param buf number
---@return string, string|nil
local function get_display_filename_and_dirname(buf)
  local fullpath = vim.api.nvim_buf_get_name(buf)
  if cache[fullpath] then
    return cache[fullpath].filename, cache[fullpath].dirname
  end

  local filename, dirname = _get_display_filename_and_dirname(fullpath)
  cache[fullpath] = { filename = filename, dirname = dirname }
  return filename, dirname
end

return get_display_filename_and_dirname
