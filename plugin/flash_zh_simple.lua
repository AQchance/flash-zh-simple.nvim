-- 确保不重复加载
if vim.g.loaded_flash_zh_simple == 1 then
  return
end
vim.g.loaded_flash_zh_simple = 1

-- 1. 定义命令 :XiaoheHelp
vim.api.nvim_create_user_command("XiaoheHelp", function()
  require("flash_zh_simple").open()
end, {})

-- 2. 定义命令 :XiaoheSimpleSearch
vim.api.nvim_create_user_command("XiaoheSimpleSearch", function()
  require("flash_zh_simple").input_and_jump()
end, {})

-- 3. 设置键位映射
-- 注意：这里使用 vim.keymap.set，默认在 Normal 模式下生效
-- 用户可以在自己的配置中覆盖这些映射，或者我们可以检查是否已被占用（这里简化处理，直接设置）

vim.keymap.set("n", "<leader>xh", "<cmd>XiaoheHelp<CR>", { desc = "Open Xiaohe Pinyin Help" })
vim.keymap.set("n", "<leader>xs", "<cmd>XiaoheSimpleSearch<CR>", { desc = "Search with Xiaohe Pinyin" })