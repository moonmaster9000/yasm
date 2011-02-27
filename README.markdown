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


### Side Effects

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


### End states

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
    #==> Yasm::FinalStateException: We're sorry, but the current state `Obliterated` is final. It does not accept any actions. 


### State Timers

When a vending machine vends an item, it takes about 10 seconds for the item to work it's way off the rack and fall to the bottom. We can simulate this
by placing a `minimum` constraint on the `Vending` state. 

    class Vending
      include Yasm::State

      minimum 10.seconds
    end


Now, when we go into the vending state, we won't be able to retrieve our selection until 10 seconds have passed. 

    vending_machine.do! MakeSelection.new(SnickersBar)

    vending_machine.state.value
      #==> Vending

    vending_machine.do! RetrieveSelection
      #==> Yasm::TimeLimitNotYetReached: We're sorry, but the time limit on the state `Vending` has not yet been reached. 

    sleep 10

    vending_machine.do! RetrieveSelection

    vending_machine.state.value
      #==> Waiting

You can also create maximum time limits. For example, suppose we want our vending machine to self destruct, out of frustration, if it goes
an entire minute without any action.

    class Waiting
      include Yasm::State

      maximum 1.minute, :action => :self_destruct
    end

    class SelfDestruct
      include Yasm::Action

      triggers :obliterated

      def execute
        puts "KABOOM!"
      end
    end

Now, if we create a vending machine, then wait at least a minute, next time we try to do something to it, it will execute the `SelfDestruct` action.


    v = VendingMachine.new
    
    sleep 60
    
    v.do! InputMoney.new(10)
      #==> "KABOOM!"
      #==> Yasm::FinalStateException: We're sorry, but the current state `Obliterated` is final. It does not accept any actions. 


## The Lazy Domino Effect

The maximum time limit on a state can cause a domino effect. For example, suppose the start state for your context has a max time limit. And the action that
runs when that time limit is reached transitions to a state with another max time limit. And so on. Now suppose you instantiate your context, and wait a reeeeealy 
long time. Like, long enough to cause a state transition domino effect. Let's model this with a traffic light system: 

    class TrafficLight
      include Yasm::Context

      start :green
    end

    class Green
      include Yasm::State

      maximum 10.seconds, :action => :transition_to_yellow
    end

    class TransitionToYellow
      include Yasm::Action
      
      triggers :yellow

      def execute
        puts "transitioning to yellow."
      end
    end

    class Yellow
      include Yasm::State

      maximum 3.seconds, :action => :transition_to_red
    end

    class TransitionToRed
      include Yasm::Action

      triggers :red
      
      def execute
        puts "transitioning to red."
      end
    end

    class Red
      include Yasm::State

      maximum 13.seconds, :action => :transition_to_green
    end

    class TransitionToGreen
      include Yasm::Action

      triggers :green
      
      def execute
        puts "transitioning to green."
      end
    end

    t = TrafficLight.new

    puts t.state.value
      #==> Green

    sleep 30

    t.state.value
      #==> "transitioning to yellow."
      #==> "transitioning to red."
      #==> "transitioning to green."
      #==> Green 

Notice that this domino effect happened lazily when you call the `do!` method, or the `context.state.value` methods. Quite nice for systems where
you persist your state to a db. 


## Persistence

How do you persist your state to a database? YASM will automatically persist/load your states to/from the database; it supports (or plans to support) the following ORMs:

* couchrest_model (as of version 0.0.4)
* mongoid (coming soon)
* active_record (coming soon)

For example, let's suppose our vending machine context was actually a CouchDB document, modelled with CouchRest::Model:

    class VendingMachine < CouchRest::Model::Base
      include Yasm::Context

      start :waiting
    end

    #.....

By simply mixing Yasm::Context into the document, our states will be automatically persisted to the database and loaded from the database.


## Anonymous and Named States

Up till now, we've been utilizing the anonymous state on our context. In other words, because we didn't wrap our `start :waiting` inside a `state` call, YASM
assumed that we were simply going to be using the anonymous state on our class. Also, when we've called the `do!` method, we've called it directly on our context,
which again assumes that you're attempting to apply an action to the anonymous state on your context. 

What's an example of a named state? Perhaps we'd like to manage the electricity on our vending machine with a state machine. To do so, we'd simply: 

    class VendingMachine
      include Yasm::Context

      start :waiting

      state(:electricity) do
        start :on
      end
    end

    class Waiting;  include Yasm::State; end
    class Vending;  include Yasm::State; end
    class On;       include Yasm::State; end
    class Off;      include Yasm::State; end

    class Unplug
      include Yasm::Action

      triggers :off
    end

    class Plugin
      include Yasm::Action

      triggers :on
    end

    class Select
      include Yasm::Action

      triggers :vending
    end

Now our VendingMachine has two managed states: the anonymous state (that start in the `Waiting` state), and the "electricity" state (that starts in the `On` state).

We can apply actions to each of these states independently: 

    v = VendingMachine.new
    
    puts v.state.value 
      #==> Waiting
    
    puts v.electricity.value
      #==> On
   
    v.do! Select
    
    puts v.state.value 
      #==> Vending
 
    v.electricity.do! Unplug

    puts v.electricity.value
      #==> Off
    
## Action Callbacks

How do you run a method before or after an action is applied to a yasm state within your context? Yasm::Context gives you the following two callback macros for this purpose: 
`before_action` and `after_action`. They each accept two parameters: a symbol representing the method on the context you'd like called, and an options hash, where you 
can specify `:only` or `:except` constraints. 

For example: 

    class Human
      include Yasm::Context

      start :alive
      before_action :weigh_options, :except => :jump_off_building
      after_action :consider_results, :only => :jump_off_building

      private
      def weigh_options
        puts "You could, alternatively, jump off a building."
      end

      def consider_results
        puts "Splendid!"
      end
    end

    class Alive; include Yasm::State; end
    class Dead;  include Yasm::State; end
    
    class GoToWork
      include Yasm::Action
    end
    
    class JumpOffBuilding
      include Yasm::Action
      triggers :dead

      def execute
        puts "Weeeeeee!"
      end
    end

Now, when we apply actions to the anonymous state, before and after actions will run when appropriate:

    you = Human.new

    you.do! GoToWork
      #==> "You could, alternatively, jump off a building."

    you.do! JumpOffBuilding
      #==> "Weeeeeee!"
      #==> "Splendid!"

Just as you can use `before_action` and `after_action` with the anonymous state, you can use it with named states as well:

    class VendingMachine
      include Yasm::Context

      state(:electricity) do
        start :on
        before_action :warn, :only => :unplug
        after_action  :sigh
      end

      private
      def warn
        puts "Wait! Don't unplug me!!!"
      end

      def sigh
        puts "sigh...."
      end
    end

    class On; include Yasm::State; end
    class Off; include Yasm::State; end

    class Unplug
      include Yasm::Action
      triggers :off

      def execute
        puts "unplugging...."
      end
    end

    v = VendingMachine.new

    v.electricity.do! Unplug
      #==> "Wait! Don't unplug me!!!"
      #==> "unplugging...."
      #==> "sigh...."

## PUBLIC DOMAIN

This software is committed to the public domain. No license. No copyright. DO ANYTHING! 
