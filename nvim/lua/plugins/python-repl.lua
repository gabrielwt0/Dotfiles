-- REPL workflow for Python data science (send lines/selections to a live
-- python3 REPL), mirroring what R.nvim already gives you for R via lang.r.
return {
  {
    "Vigemus/iron.nvim",
    main = "iron.core",
    ft = "python",
    keys = {
      { "<leader>rs", "<cmd>IronRepl<cr>", desc = "REPL: start/focus" },
      { "<leader>rr", "<cmd>IronRestart<cr>", desc = "REPL: restart" },
      { "<leader>rq", "<cmd>IronClose<cr>", desc = "REPL: close" },
    },
    opts = function()
      return {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = { command = { "python3" } },
          },
          -- deferred: iron.view only exists once the plugin is loaded, so
          -- this must live inside opts() rather than a static opts table
          repl_open_cmd = require("iron.view").bottom(0.4),
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rv",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_paragraph = "<leader>rp",
          send_until_cursor = "<leader>ru",
          cr = "<leader>r<cr>",
          interrupt = "<leader>r<c-c>",
          exit = "<leader>rx",
          clear = "<leader>rC",
        },
        ignore_blank_lines = true,
      }
    end,
  },
}
