local M = {}

-- 打开浮动窗口的主函数
function M.open()
  -- 1. 创建一个不可列出 (unlisted) 的临时缓冲区 (scratch buffer)
  -- 参数1: listed (false = 不在 :ls 中显示)
  -- 参数2: scratch (true = 这是一个临时 buffer，没有任何文件关联)
  local buf = vim.api.nvim_create_buf(false, true)

  -- 2. 获取编辑器的大小，用于计算居中位置
  local ui = vim.api.nvim_list_uis()[1]
  local width = 64
  local height = 16
  
  -- 计算起始行列，使窗口居中
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  -- 3. 配置窗口选项
  local opts = {
    relative = "editor", -- 相对于整个编辑器定位
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",   -- 最小化样式（无行号等）
    border = "rounded",  -- 圆角边框 (也可选 "single", "double", "solid" 等)
    title = " 小鹤双拼 (Xiaohe) ", -- 窗口标题 (Neovim 0.9+)
    title_pos = "center"
  }

  -- 4. 打开浮动窗口
  -- 参数1: buffer id
  -- 参数2: enter (true = 焦点立即进入新窗口)
  -- 参数3: config table
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- 5. 设置缓冲区内容
  local lines = {
    " [Q] iu         [W] ei         [E] e          [R] uan",
    " [T] ue         [Y] un         [U] sh / u     [I] ch / i",
    " [O] uo / o     [P] ie",
    "",
    " [A] a          [S] ong/iong   [D] ai         [F] en",
    " [G] eng        [H] ang        [J] an         [K] uai/ing",
    " [L] iang/wang",
    "",
    " [Z] ou         [X] ua/ia      [C] ao         [V] zh / ui",
    " [B] in         [N] iao        [M] ian",
    "",
    " --------------------------------------------------------",
    "  * 零声母：韵母首字母为零声母",
    "  * 按 'q' 关闭此窗口"
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 6. 设置按键映射：在 Normal 模式下按 'q' 关闭窗口
  -- 使用 <cmd>close<CR> 是关闭当前窗口最稳健的方法
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, noremap = true, silent = true })

  -- 7. 设置 Buffer 选项：窗口关闭后自动销毁 Buffer
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  -- 可选：设置一些高亮或选项
  vim.api.nvim_set_option_value('cursorline', true, { win = win })
end

-- 新增：输入全拼 -> 转双拼 -> 调用 flash-zh
function M.input_and_jump()
  vim.ui.input({ prompt = "输入全拼 (空格分隔): " }, function(input)
    if not input or input == "" then return end
    
    -- 1. 转换拼音
    local xiaohe = require("flash_zh_simple.xiaohe")
    local pattern = xiaohe.to_xiaohe(input)
    
    print("转换结果: " .. input .. " -> " .. pattern)

    -- 2. 调用 flash-zh
    -- 尝试加载 flash-zh
    local has_flash_zh, flash_zh = pcall(require, "flash-zh")
    
    -- 如果未找到，尝试将当前目录下的 flash-zh.nvim 加入 rtp (针对开发环境)
    if not has_flash_zh then
      local cwd = vim.fn.getcwd()
      local local_flash_path = cwd .. "/flash-zh.nvim"
      if vim.fn.isdirectory(local_flash_path) == 1 then
        vim.opt.rtp:prepend(local_flash_path)
        has_flash_zh, flash_zh = pcall(require, "flash-zh")
      end
    end

    if has_flash_zh then
      -- 使用 flash-zh 的 jump 接口
      -- 注意：flash-zh 的 jump 封装了 flash.jump，并自动处理模式
      -- 我们传入转换后的双拼码，但 flash-zh 默认是用来接收用户输入的
      -- 如果我们要直接跳转到 pattern，需要构造正确的 search 配置
      
      -- flash-zh 的 jump(opts) 实际上是打开 flash 界面让用户输。
      -- 但如果我们已经有了 text (pattern)，我们希望它直接跳。
      
      -- 查看 flash-zh 源码，它会调用 flash.jump(opts)。
      -- 我们可以直接调用 flash.jump，并复用 flash-zh 的模式。
      
      local flash = require("flash")
      -- 构造 flash-zh 的正则匹配器
      local search_mode = flash_zh.zh_mode -- 纯中文模式
      
      flash.jump({
        search = {
          mode = search_mode,
          text = pattern, -- 传入转换后的双拼码，直接搜索
        },
        label = { after = false, before = true },
        pattern = pattern,
      })
    else
      vim.notify("未找到 flash-zh.nvim，仅显示转换结果。", vim.log.levels.WARN)
    end
  end)
end

return M
