package ="crossdomain"
version = '0.0.1-0'

source = {
    url = '...'
}

description ={
    summary       ="crossdomain",
    homepage      ="",
    maintainer    ="yan.dou@zcaifu.com",
    license       ="MIT" 
}

build = {
    type = "builtin",
    modules = {
        ["kong.plugins.crossdomain.handler"] = "kong/plugins/crossdomain/handler.lua",
        ["kong.plugins.crossdomain.schema"] = "kong/plugins/crossdomain/schema.lua"
    }
}
