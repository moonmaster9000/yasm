$LOAD_PATH.unshift './lib'
require 'yasm'
# 
# class VendingMachine
#   include Yasm::Context
#   
#   # start Waiting
#   # 
#   # state :status do
#   #   start Waiting
#   # end
#   # 
#   attr_accessor :money
#   def initialize
#     @money = 0
#   end
# end
# 
# class Waiting
#   include Yasm::State
# 
#   actions InputMoney
# end
# 
# class Vending
#   include Yasm::State
# end
# 
# class NotAState
# end
# 
# class InputMoney
#   include Yasm::Action
# end
# 
# class Vend
#   include Yasm::Action
#   triggers Vending
# 
#   def initialize(item)
#     @item = item
#   end
#   
#   def execute
#     puts "Vending #{@item}"
#     context.do! Refund if context.money > 0
#   end
# end
# 
# class Refund
#   include Yasm::Action
# 
#   triggers Waiting
# 
#   def execute
#     puts "Refunding #{context.money}"
#     context.money = 0
#   end
# end
# 
# class MakeSelection
#   include Yasm::Action
#   
#   def initialize(selection)
#     @selection = selection
#   end
# 
#   def execute
#     if context.money >= selection.price
#       trigger Vending
#       context.money -= selection.price
#       context.do! Vend.new(selection)
#     else
#       puts "You must enter more money."
#     end
#   end
# end
# 
# class NotAnAction
# end
