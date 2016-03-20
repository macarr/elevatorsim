note
	description: "Summary description for {TEST_SUITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SUITE
inherit ES_SUITE

create make

feature {NONE} -- Creation

make
  do
    add_test(create {MODEL_TEST}.make)
    add_test(create {CONTROLLER_TEST}.make)
    show_browser
    run_espec
 end

end
