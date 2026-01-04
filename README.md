# ⚡ flash-zh-simple.nvim

> 让中文跳转更简单！小鹤双拼辅助工具 & 全拼智能跳转。🚀

**flash-zh-simple.nvim** 是一个为 [flash-zh.nvim](https://github.com/rainerosion/flash-zh.nvim) 打造的轻量级伴侣插件。它专为正在学习或使用**小鹤双拼**的用户设计，让你在 Neovim 中不仅能随时查阅键位，还能用全拼思维实现双拼的高速跳转！

---

## ✨ 功能特性 (Features)

*   🗺️ **小鹤键位速查**: 使用快捷键弹出一个浮动窗口，展示完整的小鹤双拼声韵母映射表。
*   🔄 **全拼 -> 双拼智能跳转**: 想要快速跳转到“中国”但脑子还没转成 `vsgo`？
    *   按下 `<leader>xs`
    *   输入全拼 `zhong guo`
    *   插件自动将其转为小鹤双拼码
    *   直接调用 `flash` 飞过去！⚡️

## 演示

<div align="center">
  <video src="https://github.com/user-attachments/assets/57cfd08f-cba1-4895-be12-0928044aa1a5" 
         controls 
         width="100%" 
         poster="可选封面图链接">
    您的浏览器不支持 HTML5 视频。
  </video>
</div>

## 🔗 依赖 (Dependencies)

在使用本插件之前，请确保你已经安装了以下插件：

1.  🎯 [flash.nvim](https://github.com/folke/flash.nvim) (强大的跳转引擎)
2.  🇨🇳 [flash-zh.nvim](https://github.com/rainerosion/flash-zh.nvim) (Flash 的中文扩展)

## 📦 安装 (Installation)

### 💤 使用 [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "AQchance/flash-zh-simple.nvim",
  dependencies = {
    "folke/flash.nvim",
    "rainzm/flash-zh.nvim",
  },
  event = "VeryLazy",
  -- 默认会自动设置按键映射，无需额外配置
}
```

### 📦 使用 [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "AQchance/flash-zh-simple.nvim",
  requires = {
    "folke/flash.nvim",
    "rainzm/flash-zh.nvim",
  }
}
```

## ⌨️ 按键映射 (Keymaps)

插件开箱即用，默认提供以下快捷键：

| 快捷键 | 命令 | 描述 |
| :--- | :--- | :--- |
| `<leader>xh` | `:XiaoheHelp` | 📖 打开小鹤双拼键位帮助窗口 |
| `<leader>xs` | `:XiaoheSimpleSearch` | 🔍 开启全拼输入跳转模式 |

> **💡 提示**: `<leader>` 通常是空格键 `Space` 或反斜杠 `\`。

如果你想自定义按键，可以在你的配置中重新映射命令：

```lua
-- 例如：用 F1 打开帮助
vim.keymap.set("n", "<F1>", "<cmd>XiaoheHelp<CR>", { desc = "小鹤双拼帮助" })
```

## 感谢
- [flash.nvim](https://github.com/folke/flash.nvim)
- [flash-zh.nvim](https://github.com/rainzm/flash-zh.nvim)
