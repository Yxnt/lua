--
-- Created by IntelliJ IDEA.
-- User: Yxn
-- Date: 12/21/17
-- Time: 2:29 PM
-- To change this template use File | Settings | File Templates.
--

local BasePlugin = require "kong.plugins.base_plugin"
local CustomHandler = BasePlugin:extend()

local aes = require "resty.aes"
local json = require "cjson.safe"

local function encrypt(encrypts, value)
    local encrypt_str = encrypts:encrypt(value)
    return ngx.encode_base64(encrypt_str)
end

local function decrypt(encrypts, value)
    local secret = ngx.decode_base64(value)
    return encrypts:decrypt(secret)
end

function CustomHandler:access(config)
    CustomHandler.super.access(self)

    local client_method = ngx.req.get_method()
    local client_headers = ngx.req.get_headers()
    local json_match, err = ngx.re.match(client_headers['Accept'], "application/json")

    if client_method == "POST" then -- POST method
        if json_match then -- match json header
            ngx.req.read_body() -- read json body
            local body_json = json.decode(ngx.var.request_body) -- get post args
            for k, v in pairs(body_json) do
                local key_match, err = ngx.re.match(k, '.*_sc', 'i')
                if key_match then -- decrypt base64
                    local aes_128_cbc_with_iv = assert(aes:new(config.key, nil, aes.cipher(128, "cbc"), { iv = config.iv }))
                    body_json[k] = decrypt(aes_128_cbc_with_iv, v)
                end
            end
        end
    end
end

function CustomHandler:body_filter(config)
    CustomHandler.super.body_filter(self)
    local data, eof = ngx.arg[1], ngx.arg[2]
    if string.len(data) > 0 then
        local body_json = json.decode(data)
        if nil == body_json then
            return
        end
        for k, v in pairs(json.decode(data)) do
            local key_match, err = ngx.re.match(k, '.*_sc', 'i')
            if key_match then -- encrypt base64
                local aes_128_cbc_with_iv = assert(aes:new(config.key, nil, aes.cipher(128, "cbc"), { iv = config.iv }))
                data[k] = encrypt(aes_128_cbc_with_iv, v)
            end
        end
        ngx.arg[2] = true
        return
    end
end




return CustomHandler
