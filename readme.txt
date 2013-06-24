Use:

  class Person < ActiveRecord::Base
    has_masked_field :ssn
  end

and then in your views, Person.ssn will by default show as '#########'.

You can use ssn_masked to get '#####7890' or ssn_clear for '1234567890'.

The idea is basically to make it so you have to explicitly ask for the full
value, you don't splash it all over people's screens by accident.