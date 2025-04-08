#!/usr/bin/env rake
# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"
require "rspec/core/rake_task"
Bundler::GemHelper.install_tasks

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")
