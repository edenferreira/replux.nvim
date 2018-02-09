local utils = require('utils')
local module = {}

local function default_cache_dir()
  local plugin_dir = utils.find(function (plugin)
    return plugin:find('replux')
  end,
  utils.all_runtime_files())

  return plugin_dir .. 'cache'
end

module.options = {
  ['cache_dir'] = default_cache_dir()
}

local function projects_from_cache()
  local cache_file = module.options.cache_dir .. '/repls_cache'
  local success, result = pcall(utils.lines_from, cache_file)
  if success then return result end
  return nil
end

local function all_projects()
  local cache = projects_from_cache()
  if cache then
    return cache
  else
    return utils.all_projects()
  end
end

local function find_project(path)
  return utils.find(function (proj)
    return utils.starts_with(path, proj)
  end, all_projects())
end

module.create_cache = function ()
  local projects = utils.all_projects()
  io.popen('mkdir -p ' .. module.options.cache_dir):read('*a')
  local cache_file = module.options.cache_dir .. '/repls_cache'
  utils.write_lines_to(projects, cache_file)
  return 'cache created in ' .. cache_file
end

module.start_from = function ()
  local path = utils.vim_expand('%:p')
  local project = find_project(path)
  if project then
    local name = utils.path_name(project)
    local cmd = 'tmux new-session -d -s ' .. name .. ' -c ' .. project .. ' lein repl'
    utils.run(cmd)
    return name .. ' started'
  else
    return 'project not found for the path ' .. path
  end
end

module.kill_by_name = function (name)
  local cmd = 'tmux kill-session -t ' .. name
  utils.run(cmd)
  return name .. ' killed'
end

module.kill_from = function ()
  local path = utils.vim_expand('%:p')
  local project = find_project(path)
  if project then
    local name = utils.path_name(project)
    local cmd = 'tmux kill-session -t ' .. name
    utils.run(cmd)
    return name .. ' killed'
  else
    return ' project not found for the path ' .. path
  end
end

module.restart_from = function ()
  module.kill_from()
  module.start_from()
  local path = utils.vim_expand('%:p')
  local project = find_project(path)
  if project then
    local name = utils.path_name(project)
    return name .. ' restarted'
  else
    return 'project not found for the path ' .. path
  end
end

module.ls = function ()
  local cmd = 'tmux ls'
  local result = utils.run(cmd)
  return utils.map(function (line)
    return line:match('(%a+):')
  end, result)
end

module.kill_all = function ()
  for _, name in pairs(module.ls()) do
    module.kill_by_name(name)
  end
end

return module
