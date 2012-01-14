# no-factory

## Why another factory library?

Good question, there are stacks.

This was born out of a project that had pretty compilicated model
relationships that needed to be built and accessed when writing tests.
Initially we used FactoryGirl on the project, which is usually really
good, but we hit a bit of a wall. The object graphs we needed to build
in the tests involved multiple, multi-parent hierarchies and associations
between nodes in these heirarchies. FactoryGirl didn't handle these associations very well at all. It would create multiple instances of objects
where we only wanted one and repeatedly building the heirarchies was very slow.
On top of that, even when we didn't need the heirarchies saved to the database,
using Factory.build, the associated objects were saved to the DB. So, Factory.build only saved us a single DB write.

This got me thinking about a wider question, i.e. do we really need a 
DSL and big library for defining the creation of test objects?  Is Factory.define really that much better than Class.new? Probably not.

A combination of Module methods and constructors should be able to acheive
the same ends with much less overhead and give more control over object 
construction back to the programmer.

## How to use it.

NoFactory provides a minimal factory implementation. At this point, all it does is provide a factories helper in your specs. To use it define a module
somewhere in your specs, spec/support/factories is probably a good place.
Add methods to the module to create the objects you want. Like this:

	module PersonFactory
		def person
			Person.new(
				name: "First"
			)
		end

		def other_person
			Person.new(
				name: "Other"
			)
		end
	end

Include NoFactory in your spec_helper:

	RSpec.configure do |config|
	  include NoFactory
	end

Then, in a spec, include the module using the factory helper.
This will put the module methods in the scope of your spec
and give you additional methods, your module methods with a !,
that will call save! on the objects returned by the module methods.

	describe Person
		factory :person

		let(:transient_person) { person  }
		let(:persisted_person) { person! }
	end

If you want to make `module_method!` call something else you can do
that too, using the `:on_bang` option to factory, e.g. this will call
the `bang!` method on the returned object when the method is called
with a `!`:

	describe Person
		factory :person, :on_bang => :bang!

		let(:transient_person) { person  }
		let(:persisted_person) { person! }
	end

The whole thing is pretty simple, you might like it, or not. No doubt
the implementation is verging on trivial but I think the important part
is about questioning what factories actually need to be.

## Contributing to mini-factories
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Sean Geoghegan. See LICENSE.txt for
further details.

