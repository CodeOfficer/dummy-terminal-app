#!/usr/bin/env ruby

$LOAD_PATH << './state_machine/lib'

require 'rubygems'
require 'commander'
require 'state_machine'

#  -----------------------------------------------------------------------------

class Vehicle
  state_machine :initial => :parked do
    event :park do
      transition [:idling, :first_gear] => :parked
    end
    
    event :ignite do
      transition :stalled => same, :parked => :idling
    end
    
    event :idle do
      transition :first_gear => :idling
    end
    
    event :shift_up do
      transition :idling => :first_gear, :first_gear => :second_gear, :second_gear => :third_gear
    end
    
    event :shift_down do
      transition :third_gear => :second_gear, :second_gear => :first_gear
    end
    
    event :crash do
      transition [:first_gear, :second_gear, :third_gear] => :stalled
    end
    
    event :repair do
      transition :stalled => :parked
    end
  end
end

#  -----------------------------------------------------------------------------

program :name, 'Choose Your Own Adventure'
program :version, '1.0.0'
program :description, 'Stupid stateful conversations.'
default_command :foo

command :foo do |c|
  c.syntax = 'foobar foo'
  c.description = 'Displays foo'
  c.when_called do |args, options|
    v = Vehicle.new
    asking = true
    while(asking) do
      choice = choose *(v.state_events << "-quit!")
      if choice == "-quit!"
        asking = false
      else
        eval "v.#{choice}!"
        say "state is now #{v.state}"
      end
    end
  end
end
