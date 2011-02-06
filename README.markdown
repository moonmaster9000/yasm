# YASM - Yet Another State Machine

Pronounced "yaz-um."

## Why?

In a state machine, there are states, contexts, and actions. Actions have side-effects, conditional logic, etc. States have various allowable actions. 
Contexts can support various states. All beg to be defined in classes. The other ruby state machines out there are great. But they all have hashitis. 
Classes and mixins are the cure.

## How?

Let's create a state machine for a vending machine. What does a vending machine do? It lets you input money and make a selection. When you make a selection, 
it vends the selection. Let's start off with a really simple model of this: 

    class VendingMachine
      include Yasm::Context

      start Waiting
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
      
      triggers Vending
    end

    class RetrieveSelection
      include Yasm::Action
      
      triggers Waiting
    end

And now we can run a simulation:
    
    # Create our vending machine
    vending_machine = VendingMachine.new
    puts vending_machine.state.value #==> Waiting
    
    # Input money into our vending machine
    vending_machine.do! InputMoney
    puts vending_machine.state.value #==> Waiting
    
    # Make a selection
    vending_machine.do! MakeSelection
    puts vending_machine.state.value #==> Vending

    # Retrieve our selection
    vending_machine.do! RetrieveSelection
    puts vending_machine.state.value #==> Waiting

There's some problems, though. Our simple state machine is a little too simple; someone could make a selection without inputing any money. 
We need a way to limit the actions that can be applied to our vending machine based on it's current state. How do we do that? Let's redefine
our states, using the actions macro:

    class Waiting
      include Yasm::State

      actions InputMoney, MakeSelection
    end

    class Vending
      include Yasm::State
      
      actions RetrieveSelection
    end

Now, when the vending machine is in the `Waiting` state, the only actions we can apply to it are `InputMoney` and `MakeSelection`.

...more coming soon...

## PUBLIC DOMAIN

This software is committed to the public domain. No license. No copyright. 
