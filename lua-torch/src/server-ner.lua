--
-- Created by IntelliJ IDEA.
-- User: phuongnm
-- Date: 11/9/16
-- Time: 2:37 PM
-- To change this template use File | Settings | File Templates.
--

--[[
A simple todo-list server example.
This example requires the restserver-xavante rock to run.
A fun example session:

curl -v -H "Content-Type: text/plain" -X POST -d 'tôi đi ăn cơm ở Hà_Nội với em  Quang_BD' http://localhost:18081/nerLua/data
curl localhost:8080/todo
curl -v -H "Content-Type: application/json" -X POST -d '{ "task": "Clean bedroom" }' http://localhost:8080/todo
curl -v localhost:8080/todo
curl -v -H "Content-Type: application/json" -X POST -d '{ "task": "Groceries" }' http://localhost:8080/todo
curl -v localhost:8080/todo
curl -v localhost:8080/todo/2/status
curl -v localhost:8080/todo/2/done
curl -v localhost:8080/todo/2/status
curl -v localhost:8080/todo/9/status
curl -v -H "Content-Type: application/json" -X DELETE http://localhost:8080/todo/2
curl -v localhost:8080/todo
]]


local restserver = require("restserver")
require "Main"

-- Process Deeplearning
-- dofile('ner.lua')

-- Bien luu tru data server
local todo_list = {[1]="Server waiting request ..."}
local next_id = 0

-- resource service
local server = restserver:new():port(18081)
server:add_resource("modelLua", {

    {
        method = "GET",
        path = "/",
        produces = "application/json",
        handler = function()
            return restserver.response():status(200):entity(todo_list)
        end,
    },
   
    {
      method = "POST",
      path = "/",
      consumes = "application/json",
      produces = "application/json",
      input_schema = {
         data = { type = "string" },
      },
      handler = function(task_submission)
        print ("dfdf")
         print("Received task: " .. task_submission.data)
         if (next_id == nil) then next_id = 0 end 
         next_id = next_id + 1
         task_submission.id = next_id
         task_submission.done = false
         table.insert(todo_list, task_submission)
         local result = {
            id = task_submission.id,
            test = "mot ngay deptr"
         }
         return restserver.response():status(200):entity(result)
      end,
   },

    {
        method = "POST",
        path = "/data",
        consumes = "text/plain",
        produces = "text/plain",
        handler = function(task_submission)
            --print("Received task: " .. task_submission)
            todo_list[1] = "Server processing request ..."

            -- xu ly ner
            -- local result = nerProcessFeatures(task_submission)
            print (task_submission)
            
            result =  evalXX(task_submission)-- "luaProcessed(" .. task_submission .. ")"
            print (result)
            
            todo_list[1] = "Server waiting request ..."
            return restserver.response():status(200):entity(result)
        end,
    },

})

-- This loads the restserver.xavante plugin
server:enable("restserver.xavante"):start()



