-- lua/plugins/copilot.lua

return {
  'github/copilot.vim',
  -- The 'build' command is crucial for initial setup and authentication with GitHub Copilot.
  -- It will prompt you to log in to your GitHub account the first time you install/run it.
  build = ':Copilot setup',
  -- Use 'VeryLazy' to load the plugin after most other plugins have initialized,
  -- but before you start interacting heavily with buffers. This helps with startup speed.
  event = 'VeryLazy',
  -- Configuration that runs before the plugin is fully loaded.
  init = function()
    -- Disable Copilot's default <Tab> mapping. This is highly recommended to avoid
    -- conflicts with other plugins (like completion engines or snippet managers)
    -- that also use <Tab> for their functionality.
    vim.g.copilot_no_tab_map = true
    -- Tell Copilot that you'll handle all its mappings yourself. This works hand-in-hand
    -- with `copilot_no_tab_map` to give you full control over keybindings.
    vim.g.copilot_assume_mapped = true
    -- (Optional) Only show suggestions for the current buffer. This can be useful
    -- to prevent suggestions from other open files or contexts. Uncomment if desired.
    -- vim.g.copilot_buffer_only = true
  end,
  -- Configuration that runs after the plugin is loaded.
  config = function()
    -- You can add any additional Copilot configuration here if needed.
    -- The plugin provides commands like :Copilot, :CopilotPanel, etc., which you
    -- can call directly or map to keys.
  end,
}