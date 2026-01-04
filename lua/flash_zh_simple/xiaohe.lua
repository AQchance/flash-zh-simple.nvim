local M = {}

-- 小鹤双拼映射表
local map = {
  -- 声母映射 (只有非单字符的需要特殊映射，zh, ch, sh)
  shengmu = {
    ["zh"] = "v",
    ["ch"] = "i",
    ["sh"] = "u",
  },
  -- 韵母映射
  yunmu = {
    ["iu"] = "q",
    ["ei"] = "w",
    ["e"] = "e",
    ["uan"] = "r",
    ["ue"] = "t", ["ve"] = "t",
    ["un"] = "y",
    ["u"] = "u", ["sh"] = "u",
    ["i"] = "i", ["ch"] = "i",
    ["o"] = "o", ["uo"] = "o",
    ["ie"] = "p",
    ["a"] = "a",
    ["ong"] = "s", ["iong"] = "s",
    ["ai"] = "d",
    ["en"] = "f",
    ["eng"] = "g",
    ["ang"] = "h",
    ["an"] = "j",
    ["uai"] = "k", ["ing"] = "k",
    ["iang"] = "l", ["wang"] = "l",
    ["ou"] = "z",
    ["ua"] = "x", ["ia"] = "x",
    ["ao"] = "c",
    ["zh"] = "v", ["ui"] = "v",
    ["in"] = "b",
    ["iao"] = "n",
    ["ian"] = "m",
  }
}

-- 已知的有效声母列表（按长度排序，优先匹配双字符声母）
local valid_shengmu = { "zh", "ch", "sh", "b", "p", "m", "f", "d", "t", "n", "l", "g", "k", "h", "j", "q", "x", "r", "z", "c", "s", "y", "w" }

-- 辅助函数：将单个拼音音节转换为双拼
-- 例如: "zhong" -> "vs", "an" -> "aj"
local function convert_single(pinyin)
  if pinyin == "" then return "" end

  local sm = ""
  local ym = ""

  -- 1. 尝试提取声母
  for _, s in ipairs(valid_shengmu) do
    if vim.startswith(pinyin, s) then
      -- 特殊情况：如果提取的声母会导致剩下的部分不是合法韵母，则可能不是这个声母
      -- 但中文拼音相对规范，贪婪匹配声母通常是正确的 (zh, ch, sh 优先于 z, c, s)
      sm = s
      ym = string.sub(pinyin, #s + 1)
      break
    end
  end

  -- 如果没找到声母，或者声母就是整个字符串（不应该发生，除非只有声母），则认为是零声母
  if sm == "" then
    ym = pinyin
    -- 特殊处理：flash-zh 对于部分零声母韵母，直接使用拼音作为键，而不是小鹤双拼码
    local special_zeros = {
      ["ai"] = true,
      ["an"] = true,
      ["ao"] = true,
      ["ei"] = true,
      ["en"] = true,
      ["ou"] = true,
      ["er"] = true, -- er 在小鹤里也是 er，这里一并处理
    }
    if special_zeros[ym] then
      return ym
    end
  end

  -- 2. 转换声母
  local double_sm = ""
  if sm == "" then
    -- 零声母规则：小鹤双拼中，零声母字的第一个键通常是韵母的首字母
    double_sm = string.sub(ym, 1, 1)
  else
    double_sm = map.shengmu[sm] or sm
  end

  -- 3. 转换韵母
  local double_ym = map.yunmu[ym]
  
  -- 如果找不到韵母映射，可能输入有误或者是单韵母直接映射
  if not double_ym then
    -- 容错：如果是单字母，可能就是它自己
    if #ym == 1 then double_ym = ym end
  end
  
  -- 特殊处理：如果没有韵母（例如用户只输了声母），暂不处理或返回声母
  if ym == "" then return double_sm end

  return double_sm .. (double_ym or "")
end

-- 主转换函数
-- 输入: "wo ai ni" or "zhongguo" (如果是连写的，这里的简单逻辑可能处理不了，建议空格分隔)
function M.to_xiaohe(input_str)
  local result = {}
  -- 简单的按非字母字符分割（支持空格、标点分隔）
  for word in string.gmatch(input_str, "[a-zA-Z]+") do
    table.insert(result, convert_single(string.lower(word)))
  end
  return table.concat(result, "")
end

return M
