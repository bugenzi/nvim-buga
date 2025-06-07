-- lua/plugins/telescope-enhanced.lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<C-f>",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Search in files",
    },
  },
}
