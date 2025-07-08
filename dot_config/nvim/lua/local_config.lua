--- プロジェクトの設定のハッシュを更新する関数
local function update_project_config_hash(path)
  local data_dir = vim.fn.stdpath("data")
  local project_config_hashes_dir = data_dir .. "/project-config-hashes/"

  local escaped_path = vim.fn.substitute(path, "/", "%", "g")

  local hash_file_path = project_config_hashes_dir .. escaped_path

  -- ハッシュファイルの中身を計算
  local handle = nil
  if vim.fn.isdirectory(path) == 0 then
    handle = io.popen('sha256sum "' .. path .. '" 2>/dev/null')
  else
    handle = io.popen('find "' .. path .. '" -type f -exec sha256sum {} + 2>/dev/null')
  end

  if not handle then
    return
  end

  local hash = handle:read("*a")
  handle:close()

  -- 書き込み
  local file = io.open(hash_file_path, "w")
  if not file then
    vim.fn.mkdir(project_config_hashes_dir, "p")
    file = io.open(hash_file_path, "w")
  end
  if not file then
    return
  end

  file:write(hash)
  file:close()

  return hash_file_path
end

--- プロジェクトの設定を読み込み、信頼できる場合はランタイムパスに追加する関数
local function add_project_runtime()
  local cwd = vim.fn.getcwd()
  local project_nvim = cwd .. "/.nvim"

  if vim.fn.isdirectory(project_nvim) ~= 1 then
    return
  end

  local hash_file_path = update_project_config_hash(project_nvim)
  if not hash_file_path then
    return
  end

  local is_trusted = vim.secure.read(hash_file_path) ~= nil

  if is_trusted then
    vim.opt.rtp:prepend(project_nvim)
    vim.opt.rtp:append(project_nvim .. "/after")
  end
end

add_project_runtime()
