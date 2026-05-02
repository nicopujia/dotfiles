local theme = require("config.theme")

return {
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        lazy = not theme.use_light_theme,
        config = function()
            if theme.use_light_theme then
                vim.cmd("colorscheme dayfox")
                theme.apply_light_theme_overrides()
            end
        end,
    },
    {
        "polirritmico/monokai-nightasty.nvim",
        priority = 1000,
        lazy = theme.use_light_theme,
        opts = {
            dark_style_background = "#000000",
        },
        config = function(_, opts)
            vim.o.background = "dark"
            require("monokai-nightasty").load(opts)
        end,
    },
}
