local ascii = {
    [[                        .,,cc,,,.                                ]],
    [[                   ,c$$$$$$$$$$$$cc,                             ]],
    [[                ,c$$$$$$$$$$??""??$?? ..                         ]],
    [[             ,z$$$$$$$$$$$P xdMMbx  nMMMMMb                      ]],
    [[            r")$$$$??$$$$" dMMMMMMb "MMMMMMb                     ]],
    [[          r",d$$$$$>;$$$$ dMMMMMMMMb MMMMMMM.                    ]],
    [[         d'z$$$$$$$>'"""" 4MMMMMMMMM MMMMMMM>                    ]],
    [[        d'z$$$$$$$$h $$$$r`MMMMMMMMM "MMMMMM                     ]],
    [[        P $$$$$$$$$$.`$$$$.'"MMMMMP',c,"""'..                    ]],
    [[       d',$$$$$$$$$$$.`$$$$$c,`""_,c$$$$$$$$h                    ]],
    [[       $ $$$$$$$$$$$$$.`$$$$$$$$$$$"     "$$$h                   ]],
    [[      ,$ $$$$$$$$$$$$$$ $$$$$$$$$$%       `$$$L                  ]],
    [[      d$c`?$$$$$$$$$$P'z$$$$$$$$$$c       ,$$$$.                 ]],
    [[      $$$cc,"""""""".zd$$$$$$$$$$$$c,  .,c$$$$$F                 ]],
    [[     ,$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$                 ]],
    [[     d$$$$$$$$$$$$$$$$c`?$$$$$$$$$$$$$$$$$$$$$$$                 ]],
    [[     ?$$$$$$$$$."$$$$$$c,`..`?$$$$$$$$$$$$$$$$$$.                ]],
    [[     <$$$$$$$$$$. ?$$$$$$$$$h $$$$$$$$$$$$$$$$$$>                ]],
    [[      $$$$$$$$$$$h."$$$$$$$$P $$$$$$$$$$$$$$$$$$>                ]],
    [[      `$$$$$$$$$$$$ $$$$$$$",d$$$$$$$$$$$$$$$$$$>                ]],
    [[       $$$$$$$$$$$$c`""""',c$$$$$$$$$$$$$$$$$$$$'                ]],
    [[       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F                 ]],
    [[        "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'                  ]],
    [[        ."?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P'                   ]],
    [[     ,c$$c,`?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"  THE TIME HE WASTES ]],
    [[   z$$$$$P"   ""??$$$$$$$$$$$$$$$$$$$$$$$"  IN RICING NVIM IS    ]],
    [[,c$$$$$P"          .`""????????$$$$$$$$$$c  DRIVING ME CRAZY.    ]],
    [[`"""              ,$$$L.        "?$$$$$$$$$.   WHAT'S THE MATTER ]],
    [[               ,cd$$$$$$$$$hc,    ?$$$$$$$$$c    WITH HIM ?????? ]],
    [[              `$$$$$$$$$$$$$$$.    ?$$$$$$$$$h                   ]],
    [[               `?$$$$$$$$$$$$P      ?$$$$$$$$$                   ]],
    [[                 `?$$$$$$$$$P        ?$$$$$$$$$$$$hc             ]],
    [[                   "?$$$$$$"         <$$$$$$$$$$$$$$r            ]],
    [[                     `""""           <$$$$$$$$$$$$$$F            ]],
    [[                                      $$$$$$$$$$$$$F             ]],
    [[                                      `?$$$$$$$$P"               ]],
    [[                                        "????""                  ]],
}

local M = function()
    -- dynamic header padding
    local fn = vim.fn
    local marginTopPercent = 0.2
    local headerPadding = fn.max({
        2,
        fn.floor(fn.winheight(0) * marginTopPercent),
    })

    -- button generator
    local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
            position = "center",
            text = txt,
            shortcut = sc,
            cursor = 5,
            width = 36,
            align_shortcut = "right",
            hl = "AlphaButtons",
        }

        if keybind then
            opts.keymap = {
                "n",
                sc_,
                keybind,
                { noremap = true, silent = true },
            }
        end

        return {
            type = "button",
            val = txt,
            on_press = function()
                local key = vim.api.nvim_replace_termcodes(
                    sc_,
                    true,
                    false,
                    true
                )
                vim.api.nvim_feedkeys(key, "normal", false)
            end,
            opts = opts,
        }
    end

    return {
        headerPaddingTop = { type = "padding", val = headerPadding },
        header = {
            val = ascii,
        },
        buttons = {
            val = {
                button(
                    "Alt o",
                    "  Open folder  ",
                    ":Telescope file_browser prompt_title=Open\\ folder<CR>"
                ),
                button(
                    "Alt p",
                    "  Open file  ",
                    ":Telescope find_files prompt_title=Open\\ file hidden=true<CR>"
                ),
                button("Alt r", "  Recent folders  ", ":SearchSession<CR>"),
            },
        },
    }
end

return M
