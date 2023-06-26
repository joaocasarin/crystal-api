# About Application.cr File
#
# This is Amber application main entry point. This file is responsible for loading
# initializers, classes, and all application related code in order to have
# Amber::Server boot up.
#
# > We recommend not modifying the order of the requires since the order will
# affect the behavior of the application.

require "amber"
require "./settings"
require "./logger"
require "./database"

# uncomment these 4 lines to enable plugins
# require "../plugins/plugins"

# Start Generator Dependencies: Don't modify.
require "../src/models/**"
# End Generator Dependencies

require "../src/utils/**"
include GlobalTypes
include Utils
require "../src/controllers/**"
require "./routes"
