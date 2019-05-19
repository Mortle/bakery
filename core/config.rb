# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

module Core
  module Config
    attr_reader :config

    def initialize(*args)
      super(*args)
      @config = YAML.load_file('config/config.yml').with_indifferent_access
    end
  end
end
