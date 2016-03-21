note
	description: "Summary description for {CONTROLLER_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTROLLER_TEST
inherit
	ES_TEST
create make

feature -- Feature under test

controller: ELEVATOR_CONTROL
model: ELEVATOR_MODEL

feature -- Creation

make
  -- Defines the test cases to use
  do
    add_boolean_case (agent test_boolean)
    add_violation_case(agent test_precondition)
    add_boolean_case(agent test_precondition_bool)
-- The following case succeeds only if the pre-condition
-- fails and it has the tag "non-negative".  The test fails.
-- Change the tag to "valid_bounds" and the test succeeds.
--
  add_violation_case_with_tag("valid_bounds", agent test_precondition)
  end

test_boolean : BOOLEAN
  do
    comment("test_boolean case")
    Result := true
  end

test_precondition
  local array : ARRAY[STRING]
  do
    comment("test_violation")
    create array.make_filled("", 5, 1)
  end

test_precondition_bool : BOOLEAN
  local array : ARRAY[STRING]
  do
    comment("test_violation boolean version")
    if not Result then create array.make_filled("", 5, 1) end
    rescue
      Result := true
      retry
  end

end
