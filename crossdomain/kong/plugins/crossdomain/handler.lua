--
-- Created by IntelliJ IDEA.
-- User: Yxn
-- Date: 12/21/17
-- Time: 2:29 PM
-- To change this template use File | Settings | File Templates.
--

local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()


local function set_cross_domain_name(config)
    local domain = config.domain -- replace this
    local domain_reg = string.format(".*%s", domain)
    local schema = ngx.var.scheme -- get schema
    local server_name = ngx.var.server_name -- get request header server name
    local origin_name = ngx.req.get_headers()['Origin'] -- get request header Origin value
    local m_server, err = ngx.re.match(server_name, domain_reg, "i") -- match domain value from request server name
    if origin_name then
        local m_origin, err = ngx.re.match(origin_name, domain_reg, "iu") -- match domain value from request Origin
        if m_origin then
            return origin_name
        end
    elseif m_server then
        local domain = string.format("%s://%s", schema, server_name)
        return domain
    end
end


function CustomHandler:access(config)
    CustomHandler.super.access(self)
    local http_method = ngx.req.get_method() -- get http request method
    ngx.header["Access-Control-Allow-Origin"] = set_cross_domain_name(config) -- add cross domain headers
    if http_method == "OPTIONS" then -- method is OPTIONS
        return ngx.exit(ngx.HTTP_OK) -- set http status code
    end
end


return CustomHandler