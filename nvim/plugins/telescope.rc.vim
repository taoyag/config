lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      }
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF


nnoremap [Telescope] <Nop>
nmap f [Telescope]

nnoremap [Telescope]f <cmd>Telescope find_files<CR>
nnoremap [Telescope]p <cmd>Telescope find_files<CR>
nnoremap [Telescope]e <cmd>Telescope file_browser<CR>
nnoremap [Telescope]gr <cmd>Telescope live_grep<CR>
nnoremap [Telescope]b <cmd>Telescope buffers<CR>
nnoremap [Telescope]n <cmd>Telescope buffers<CR>
nnoremap [Telescope]gf <cmd>Telescope git_files<CR>
nnoremap [Telescope]gc <cmd>Telescope git_bcommits<CR>
nnoremap [Telescope]gC <cmd>Telescope git_commits<CR>
nnoremap [Telescope]gb <cmd>Telescope git_branches<CR>
nnoremap [Telescope]h <cmd>Telescope oldfiles<CR>
nnoremap [Telescope]m <cmd>Telescope keymaps<CR>

nnoremap <silent> <C-n> <cmd>Telescope buffers<CR>
nnoremap <silent> <C-f> <cmd>Telescope find_files<CR>
