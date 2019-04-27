RELEASE = false

DEBUG = not RELEASE
DEBUG_BUFFER = ""

CONFIG = {
    renderer = {
        filter = {
            up = "nearest",
            down = "nearest"
        },

        scale = 3,
    },

    window = {
        icon = nil,
        fullscreen = false
    },

    debug = {

    }
}

Lume = require 'libs.lume'
Hsluv = require 'libs.hsluv'
State = require 'libs.state'
Signal = require 'libs.signal'
Inspect = require 'libs.inspect'
Tween = require 'libs.tween'