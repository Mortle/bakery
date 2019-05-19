require 'active_support'
require 'active_support/core_ext'
require 'csv'
require 'pry'
require_relative 'core/config.rb'
require_relative 'core/logger.rb'

module Fides
  class Bakery
    include Core::Config
    include Core::Logger
    def initialize
      super
      @stock = CSV.read('stock.csv', headers: true, header_converters: :symbol)
      @orders = CSV.read('order.csv', headers: true, header_converters: :symbol)
    end

    def process
      logger.info 'Bakery -- Start processing'
      @orders.each_with_index do |ord, index|
        logger.info "Bakery -- Processing order №#{index + 1}..."
        raise ArgumentError unless ord[:amount].scan(/\D/).empty? # "x": if x is integer
        packs = @stock.select{ |product| ord[:code] == product[:code] }.map{|p| p[:amount].to_i}
        if packs.empty?
          logger.info "Bakery -- Error at order №#{index + 1}: perhaps no specified product ID"
        else
          output(make_change(ord[:amount].to_i, packs, ord[:code]), ord)
          logger.info "Bakery -- Order №#{index + 1} has been processed successfully!"
        end
      rescue ArgumentError, SystemStackError
        logger.info "Bakery -- Error at order №#{index + 1}: perhaps wrong amount data / amount is too big to be processed"
      end
      logger.info 'Bakery -- End processing'
    end

    def make_change(amount, packs, code)
      packs.sort! { |a, b| b <=> a }
      optimal_change = Hash.new do |hash, key|
      hash[key] = if key < packs.min
        []
      elsif packs.include?(key)
         [key]
      else
         packs.
           reject { |pack| pack > key }.
           inject([]) {|mem, var| mem.any? { |p| p%var == 0 } ? mem : mem + [var]}.
           map { |pack| [pack] + hash[key - pack] }.
           reject { |change| change.sum != key }.
           min { |a, b| a.size <=> b.size } || []
      end
      end
    optimal_change[amount].map{|amount| @stock.find{|p| p[:code] == code && p[:amount].to_i == amount }}
    end

    def output(packs, order)
      puts "#{order.to_a.join(' ')} $#{packs.inject(0.0){|sum, p| sum += p[:cost].to_f}.round(2)}"
      packs.uniq().each{ |pack| puts "  #{packs.count(pack)} x #{pack[:amount]} $#{pack[:cost]}"}
    end

  end
end

bakery = Fides::Bakery.new
bakery.process
