return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function() require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {

            ["aA"] = { query = "@attribute.outer", desc = "Select outer part of an Attribute" },
            ["iA"] = { query = "@attribute.inner", desc = "Select inner part of an Attribute" },

            ["aB"] = { query = "@block.outer", desc = "Select outer part of a Block" },
            ["iB"] = { query = "@block.inner", desc = "Select inner part of a Block" },

            -- You can use the capture groups defined in textobjects.scm
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an Assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an Assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an Assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an Assignment" },

            ["aC"] = { query = "@comment.outer", desc = "Select outer part of a Comment" },
            ["iC"] = { query = "@comment.inner", desc = "Select inner part of a Comment" },

            ["aD"] = { query = "@conditional.outer", desc = "Select outer part of a Conditional" },
            ["iD"] = { query = "@conditional.inner", desc = "Select inner part of a Conditional" },

            ["aF"] = { query = "@call.outer", desc = "Select outer part of a Function call" },
            ["iF"] = { query = "@call.inner", desc = "Select inner part of a Function call" },

            ["aL"] = { query = "@loop.outer", desc = "Select outer part of a Loop" },
            ["iL"] = { query = "@loop.inner", desc = "Select inner part of a Loop" },

            ["aM"] = { query = "@function.outer", desc = "Select outer part of a Method/Function definition" },
            ["iM"] = { query = "@function.inner", desc = "Select inner part of a Method/Function definition" },

            ["aN"] = { query = "@number.outer", desc = "Select outer part of a Number" },
            ["iN"] = { query = "@number.inner", desc = "Select inner part of a Number" },

            ["aP"] = { query = "@parameter.outer", desc = "Select outer part of a Parameter/Argument" },
            ["iP"] = { query = "@parameter.inner", desc = "Select inner part of a Parameter/Argument" },

            -- works for javascript/typescript files (custom captures I created in after/queries/ecma/textobjects.scm)
            ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
            ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
            ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
            ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

            ["aR"] = { query = "@regex.outer", desc = "Select outer part of a Regex" },
            ["iR"] = { query = "@regex.inner", desc = "Select inner part of a Regex" },

            ["aS"] = { query = "@statement.outer", desc = "Select outer part of a Statement" },
            ["iS"] = { query = "@statement.inner", desc = "Select inner part of a Statement" },

            ["aX"] = { query = "@class.outer", desc = "Select outer part of a Class" },
            ["iX"] = { query = "@class.inner", desc = "Select inner part of a Class" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]b"] = { query = "@block.outer", desc = "Next Block start" },
            ["]f"] = { query = "@call.outer", desc = "Next Function call start" },
            ["]m"] = { query = "@function.outer", desc = "Next Method/Function def start" },
            ["]c"] = { query = "@class.outer", desc = "Next Class start" },
            ["]d"] = { query = "@conditional.outer", desc = "Next Conditional start" },
            ["]l"] = { query = "@loop.outer", desc = "Next Loop start" },

            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next Scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next Fold" },
          },
          goto_next_end = {
            ["]B"] = { query = "@block.outer", desc = "Next Block end" },
            ["]F"] = { query = "@call.outer", desc = "Next Function call end" },
            ["]M"] = { query = "@function.outer", desc = "Next Method/Function def end" },
            ["]C"] = { query = "@class.outer", desc = "Next Class end" },
            ["]D"] = { query = "@conditional.outer", desc = "Next Conditional end" },
            ["]L"] = { query = "@loop.outer", desc = "Next Loop end" },
          },
          goto_previous_start = {
            ["[b"] = { query = "@block.outer", desc = "Previous Block start" },
            ["[f"] = { query = "@call.outer", desc = "Prev Function call start" },
            ["[m"] = { query = "@function.outer", desc = "Prev Method/Function def start" },
            ["[c"] = { query = "@class.outer", desc = "Prev Class start" },
            ["[d"] = { query = "@conditional.outer", desc = "Prev Conditional start" },
            ["[l"] = { query = "@loop.outer", desc = "Prev Loop start" },
          },
          goto_previous_end = {
            ["[B"] = { query = "@block.outer", desc = "Previous Block end" },
            ["[F"] = { query = "@call.outer", desc = "Prev Function call end" },
            ["[M"] = { query = "@function.outer", desc = "Prev Method/Function def end" },
            ["[C"] = { query = "@class.outer", desc = "Prev Class end" },
            ["[D"] = { query = "@conditional.outer", desc = "Prev Conditional end" },
            ["[L"] = { query = "@loop.outer", desc = "Prev Loop end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>xb"] = { query = "@block.outer", desc = "Swap Next Block" },
            ["<leader>xf"] = { query = "@call.outer", desc = "Swap Next Function" },
            ["<leader>xm"] = { query = "@function.outer", desc = "Swap Next Method/Function" },
            ["<leader>xp"] = { query = "@parameter.inner", desc = "Swap Next Parameter" },
            ["<leader>x;"] = { query = "@property.outer", desc = "Swap Next Property" },
          },
          swap_previous = {
            ["<leader>xB"] = { query = "@block.outer", desc = "Swap Previous Block" },
            ["<leader>xF"] = { query = "@call.outer", desc = "Swap Previous Function" },
            ["<leader>xM"] = { query = "@function.outer", desc = "Swap Previous Method/Function" },
            ["<leader>xP"] = { query = "@parameter.inner", desc = "Swap Previous Parameter" },
            ["<leader>x:"] = { query = "@property.outer", desc = "Swap Previous Property" },
          },
        },
        lsp_interop = {
          enable = true,
          border = "single",
          peek_definition_code = {
            ["<leader>xM"] = { query = "@function.outer", desc = "Peek Function Definition" },
            ["<leader>xC"] = { query = "@class.outer", desc = "Peek Class Definition" },
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
