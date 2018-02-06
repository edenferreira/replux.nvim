local module = {}

module.find = function (fn, iter)
  if type(iter) == 'table' then
    for _, line in pairs(iter) do
      if fn(line) then
        return line
      end
    end
  end
  return nil
end

module.map = function (fn, iter)
  local result = {}
  local count = 1
  if type(iter) == 'table' then
    for _, line in pairs(iter) do
      result[count] = fn(line)
      count = count + 1
    end
    return result
  elseif type(iter) == 'userdata' then
    for line in iter:lines() do
      result[count] = fn(line)
      count = count + 1
    end
    return result
  end
  return nil
end

module.filter = function (fn, iter)
  local result = {}
  local count = 1

  if type(iter) == 'table' then
    for _, line in pairs(iter) do
      if fn(line) then
        result[count] = line
        count = count + 1
      end
    end
    return result
  end

  return nil
end

module.print_all = function (iter)
  for _, value in pairs(iter) do
    print(value)
  end
end

module.all_runtime_files = function ()
  return vim.api.nvim_list_runtime_paths()
end

module.string_to_lines = function(str)
  lines = {}
  count = 1
  for s in str:gmatch("[^\r\n]+") do
    lines[count] = s
    count = count + 1
  end
  return lines
end

module.all_dev_files = function ()
  local home = os.getenv('HOME')
  return module.string_to_lines(vim.api.nvim_eval('system("find ' .. home .. '/dev")'))
end

module.all_projects = function ()
  local projects = module.filter(function (line)
    return line:find('project.clj')
  end, module.all_dev_files())

  return module.map(function (str)
    return str:sub(1, str:find('/project.clj') - 1)
  end, projects)
end

module.write_lines_to = function (lines, path)
  local file = io.open(path, 'w')
  for _, line in pairs(lines) do
    file:write(line, '\n')
  end
  file:close()
end

module.starts_with = function (str, start)
  return str:sub(1, start:len()) == start
end

module.lines_from = function (file)
  local lines = {}
  local count = 1
  for line in io.lines(file) do
    lines[count] = line
    count = count + 1
  end
  return lines
end

module.path_name = function (path)
  local lines = {}
  local count = 1
  for value in string.gmatch(path, "%w+") do
    lines[count] = value
    count = count + 1
  end
  return lines[count - 1]
end

module.run = function (cmd)
  return io.popen(cmd .. ' 2>&1')
end

module.vim_expand = function (str)
  return vim.api.nvim_eval('expand("' .. str .. '")')
end

return module
