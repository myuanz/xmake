--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2018, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        task.lua
--

-- define module
local sandbox_core_base_task = sandbox_core_base_task or {}

-- load modules
local os        = require("base/os")
local io        = require("base/io")
local table     = require("base/table")
local option    = require("base/option")
local string    = require("base/string")
local task      = require("base/task")
local project   = require("project/project")
local raise     = require("sandbox/modules/raise")

-- run the given task
function sandbox_core_base_task.run(taskname, options, ...)

    -- init options
    options = table.wrap(options)

    -- inherit some parent options
    for _, name in ipairs({"file", "project", "backtrace", "verbose", "quiet", "yes", "root", "profile"}) do
        if not options[name] and option.get(name) then
            options[name] = option.get(name)
        end
    end

    -- save the current option and push a new option context
    option.save(taskname)

    -- init the new options
    for name, value in pairs(options) do
        option.set(name, value)
    end

    -- get task instance
    local taskname = option.taskname() or "build"
    local taskinst = project.task(taskname) or task.task(taskname) 
    if not taskinst then
        raise("do unknown task(%s)!", taskname)
    end

    -- run the task
    local ok, errors = taskinst:run(...)
    if not ok then
        raise(errors)
    end

    -- restore the previous option context
    option.restore()
end

-- return module
return sandbox_core_base_task
