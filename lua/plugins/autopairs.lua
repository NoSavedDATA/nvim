return {
  "jiangmiao/auto-pairs",
  init = function()
    -- disable aggressive mappings
    vim.g.AutoPairsMapCh = 0
    vim.g.AutoPairsMapBS = 0
    vim.g.AutoPairsMapCR = 0
    vim.g.AutoPairsShortcutJump = ""

    -- IMPORTANT: do NOT let auto-pairs interfere with paste
    vim.g.AutoPairsFlyMode = 0
    vim.g.AutoPairsShortcutToggle = ""
  end,
}
