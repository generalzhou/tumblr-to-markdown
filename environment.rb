ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'rubygems'

require 'erb'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'tumblr_client'
require 'html2markdown'
require 'haml'
require 'html2markdown'
require 'tumblr_client'
require 'oauth'

APP_ROOT = Pathname.new(File.expand_path('../', __FILE__))

Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'views', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'converter', '*.rb')].each { |file| require file }