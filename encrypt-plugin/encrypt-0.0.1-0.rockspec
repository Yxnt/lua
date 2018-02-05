package ="encrypt"
version = '0.0.1-0'

source = {
    url = '...'
}

description ={
    summary       ="json encrypt",
    homepage      ="",
    maintainer    ="yan.dou@zcaifu.com",
    license       ="MIT" 
}

build = {
    type = "builtin",
    modules = {
        ["kong.plugins.encrypt.handler"] = "kong/plugins/encrypt-plugin/handler.lua",
        ["kong.plugins.encrypt.schema"] = "kong/plugins/encrypt-plugin/schema.lua"
    }
}
