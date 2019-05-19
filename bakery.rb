require 'active_support'
require 'active_support/core_ext'
require 'pry'
require_relative 'core/config.rb'
require_relative 'core/logger.rb'

module Fides
  class Bakery
    include Core::Config
    include Core::Logger

    def process
      logger.info 'Bakery -- Start processing'
      order.each_with_index do |ord, index|
        logger.info "Bakery -- Processing order №#{index + 1}..."
        packs = []
        stock.each do |product|
          packs << product[1].to_i if ord[0] == product[0]
        end
        output make_change(ord[1].to_i, packs), ord
      end
      logger.info 'Bakery -- End processing'
    end

    def make_change(amount, packs)
     packs.sort! { |a, b| b <=> a }
     # memoize solutions
     optimal_change = Hash.new do |hash, key|
       hash[key] = if key < packs.min
         []
       elsif packs.include?(key)
         [key]
       else
         packs.
           # prune unhelpful packs
           reject { |pack| pack > key }.
           # prune packs that are factors of larger packs
           inject([]) {|mem, var| mem.any? {|c| c%var == 0} ? mem : mem+[var]}.
           # recurse
           map { |pack| [pack] + hash[key - pack] }.
           # prune unhelpful solutions
           reject { |change| change.sum != key }.
           # pick the smallest, empty if none
           min { |a, b| a.size <=> b.size } || []
       end
     end
     optimal_change[amount]
    end
  end

  def output(packs, order)
    total_cost = 0.0
    packs.each do |pack|
      stock 
    end
    order.split(" ") + "$" + total_cost
  end

end

bakery = Fides::Bakery.new
bakery.process
binding.pry
