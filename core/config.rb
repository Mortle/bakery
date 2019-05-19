require 'yaml'
require 'csv'
require 'active_support/core_ext/hash/indifferent_access'

module Fides
  module Core
    module Config
      attr_reader :config
      attr_reader :order
      attr_reader :stock

      def initialize(*args)
        super(*args)
        @config = YAML.load_file('config/config.yml').with_indifferent_access
        @stock = CSV.read('stock.csv')
        @order = CSV.read('order.csv', headers: false)
      end
    end
  end
end
