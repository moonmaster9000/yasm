# YASM - Yet Another State Machine

Pronounced "yaz-um."


## Install?

    $ gem install yasm

## Why?

In a state machine, there are states, contexts, and actions. Actions have side-effects, conditional logic, etc. States have various allowable actions. 
Contexts can support various states. All beg to be defined in classes. The other ruby state machines out there are great. But they all have hashitis. 
Classes and mixins are the cure.

## How?

Let's create a state machine for a vending machine. What does a vending machine do? It lets you input money and make a selection. When you make a selection, 
it vends the selection. Let's start off with a really simple model of this: 

    class VendingMachine
      include Yasm::Context

      start :waiting
    end

    class Waiting; include Yasm::State; end

    class Vending; include Yasm::State; end

So far, we've created a context (a thing that has state), given it a start state, and then defined a couple of states (Waiting, Vending).

So, how do we use this vending machine? We'll need to create some actions first:

    class InputMoney
      include Yasm::Action
    end
    
    class MakeSelection
      include Yasm::Action
      
      triggers :vending
    end

    class RetrieveSelection
      include Yasm::Action
      
      triggers :waiting
    end

And now we can run a simulation:
    
    vending_machine = VendingMachine.new
    
    vending_machine.state.value 
      #==> Waiting
    
    vending_machine.do! InputMoney
    
    vending_machine.state.value 
      #==> Waiting
    
    vending_machine.do! MakeSelection
    
    vending_machine.state.value 
      #==> Vending

    vending_machine.do! RetrieveSelection
    
    vending_machine.state.value 
      #==> Waiting

There's some problems, though. Our simple state machine is a little too simple; someone could make a selection without inputing any money. 
We need a way to limit the actions that can be applied to our vending machine based on it's current state. How do we do that? Let's redefine
our states, using the actions macro:

    class Waiting
      include Yasm::State

      actions :input_money, :make_selection
    end

    class Vending
      include Yasm::State
      
      actions :retrieve_selection
    end

Now, when the vending machine is in the `Waiting` state, the only actions we can apply to it are `InputMoney` and `MakeSelection`. If we try to apply
invalid actions to the context, `Yasm` will raise an exception. 

    vending_machine.state.value 
      #==> Waiting

    vending_machine.do! RetrieveSelection
      #==> InvalidActionException: We're sorry, but the action `RetrieveSelection` 
           is not possible given the current state `Waiting`.

    vending_machine.do! InputMoney

    vending_machine.state.value 
      #==> Waiting

## Side Effects

How can we take our simulation farther? A real vending machine would verify that when you make a selection, 
you actually have input enough money to pay for that selection. How can we model this? 

For starters, we'll need to add a property to our `VendingMachine` 
that lets us keep track of how much money was input. We'll also need to initialize our `InputMoney` actions with an amount.

    class VendingMachine
      include Yasm::Context
      start :waiting

      attr_accessor :amount_input

      def initialize
        @amount_input = 0
      end
    end 

    class InputMoney
      include Yasm::Action

      def initialize(amount_input)
        @amount_input = amount_input
      end

      def execute
        context.amount_input += @amount_input
      end
    end

Notice I defined the `execute` method on the action. This is the method that gets run whenever an action gets applied to a state container 
(e.g., `vending_machine.do! InputMoney`). This is where you create side effects. 

Now we can try out adding money into our vending machine: 
    
    vending_machine.amount_input
      # ==> 0

    vending_machine.do! InputMoney.new(10)

    vending_machine.amount_input
      # ==> 10

As for verifying that we have input enough money to pay for the selection we've chosen, we'll need to create an item, then add that to our `MakeSelection` class:

    class SnickersBar
      def self.price; 30; end
    end

    class MakeSelection
      include Yasm::Action

      def initialize(selection)
        @selection = selection
      end

      def execute
        if context.amount_input >= @selection.price
          trigger Vending
        else
          raise "We're sorry, but you have not input enough money for a #{@selection}"
        end
      end
    end

Notice that we called the `trigger` method inside the `execute` method instead of calling the `triggers` macro on the action. This way,
we can conditionally move to the next logical state only when our conditions have been met (in this case, that we've input enough money to
pay for our selection). 

    v = VendingMachine.new

    v.amount_input 
      #==> 0

    v.do! MakeSelection.new(SnickersBar)
      #==> RuntimeError: We're sorry, but you have not input enough money for a SnickersBar

    v.do! InputMoney.new(10)

    v.do! MakeSelection.new(SnickersBar)
      #==> RuntimeError: We're sorry, but you have not input enough money for a SnickersBar

    v.do! InputMoney.new(20)

    v.do! MakeSelection.new(SnickersBar)
    
    v.state.value 
      #==> Vending

    v.do! RetrieveSelection

    v.state.value
      #==> Waiting


## End states

Sometimes, a state is final. Like, what if, out of frustration, you threw the vending machine off the top of a 10 story building? It's probably not going
to work again after that. You can use the `final!` macro on a state to denote that this is the end.

    class TossOffBuilding
      include Yasm::Action

      triggers :obliterated
    end

    class Obliterated
      include Yasm::State

      final!
    end

    vending_machine = VendingMachine.new
    
    vending_machine.do! TossOffBuilding

    vending_machine.do! MakeSelection.new(SnickersBar)
    #==> FinalStateException: We're sorry, but the current state `Obliterated` is final. It does not accept any actions 



## PUBLIC DOMAIN

This software is committed to the public domain. No license. No copyright. DO ANYTHING! 
