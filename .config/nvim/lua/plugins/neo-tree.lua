return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = false,
      },
      window = {
        mappings = {
          -- Yazi-style keybindings
          ["."] = "toggle_hidden",       -- yazi: . to toggle hidden files
          ["x"] = "cut_to_clipboard",    -- yazi: x to cut
          ["y"] = "copy_to_clipboard",   -- yazi: y to copy
          ["p"] = "paste_from_clipboard", -- yazi: p to paste
          ["r"] = "rename",              -- yazi: r to rename
          ["d"] = "delete",              -- yazi: d to delete

          -- Disable defaults that conflict
          ["H"] = "none",
        },
      },
    },
  },
}
