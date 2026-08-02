-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-register the ferro project's MariaDB connection with vim-dadbod-ui
-- (lang.sql extra), read from its .env so the password never lands in this
-- (git-tracked) config. Silently does nothing on machines without ~/dev/ferro.
do
  local env_path = vim.fn.expand("~/dev/ferro/.env")
  if vim.uv.fs_stat(env_path) then
    local db = {}
    for line in io.lines(env_path) do
      local k, v = line:match("^(%u+)=(.*)$")
      if k then
        db[k] = v
      end
    end
    if db.DB_USER and db.DB_PASSWORD and db.DB_HOST and db.DB_NAME then
      vim.g.dbs = vim.g.dbs or {}
      table.insert(vim.g.dbs, {
        name = "ferro",
        url = ("mysql://%s:%s@%s/%s"):format(db.DB_USER, db.DB_PASSWORD, db.DB_HOST, db.DB_NAME),
      })
    end
  end
end
