---
name: refactor
description: Incremental code refactoring using Tidy First? and Clean Code practices. Use when user wants to refactor, tidy, or improve code structure without changing behavior.
---

# Tidy First? Refactoring
Best practices for continual code refactoring sessions.

 Warning: WORK IN PROGRESS skill

See [clean-code](clean-code.md) for code writing and design best practices.
Meanwhile, the [Code Review Pyramid](Code%20Review%20Pyramid.md) contains a hierarchy of questions to ask yourself in code reviews.
Once you have written some code, this document explains how to keep it in shape.

1. Tidy Guard Clauses
	- Reduce `if` condition blocks in functions to `if ...: pass & return`
	- Extract more complex condition blocks into separate functions.
	- Extract complex conditionals into well-named functions to make them more readable.
1. Tidy variable declaration and initialization 
	- Initialization and declaration should not be separated.
	- Variable names should explain intent.
1. Tidy improper use of constants and literals
	- Refactor literals used like constants into actual constants with an intent-revealing name (`one := 1` is not revealing intent).
	- The same constant value might have different intent in different locations, which means they should be treated as two separate constants.
1. Make your parameters explicit
	- Avoid pulling in environment variables deep inside your code.
	- Avoid using associative arrays (maps) to receive parameters.
	- At least extract the function body into a helper that uses explicit parameters, thereby avoiding (implicit) modification of the container while making missing parameters explicit.
1. Break down large or coupled expressions
	- Extract them into functions or...
	- Break them down into steps with named variables.
	- Combine function calls that have temporal coupling (`a()` always needs to be before `b()`) into a single functions `ab()`.
	- Extract lines in a function you need to change into a helper function.
1. Delete Dead Code
	- YAGNI and trust your version control system to hold a memory of the past.
2. Normalize Accidental Asymmetries
	- If one variable or functionality is implemented in many different ways, tidy those asymmetries (one tidying at a time).
3. Beware of Flag Arguments
	-  Boolean flags in arguments are strong code smells that indicate you should break up your function.
4. Review Returning Functions for Side Effects 
	- A function with a return value *should* not call a function that causes a side effect (only has a `void` return type).
	- If you *must* invoke a side effect (e.g., creating a `new` object), make that side effect explicit in the function name (in this example: constructor name).
1. Use adhesion to pile spaghetti code before refactoring into cohesive units
	- Spaghetti code is hard to read due to long and repeated argument lists, repeated code and especially conditionals, unclear helper routines, or shared mutable data structures.
	- Move all that spaghetti together in stepwise changes to one large adhesive pile, which will help you understand it better.
	- Refactor the pile into cohesive, decoupled units once you understand it.
1. Refactor from the Target State Backwards
	- When a new interface would be better, create it but let it use the old implementation. Then, iterate towards the new implementation while delivering working production code at every iteration.
	- When refactoring a function, start with the last line and pretend you had the intermediate results needed.
	- Start with a [failing test first](Canon%20TDD.md).
2. Order Source Code in Files by Reading Order
	- Often, the most critical details end up being written last; Fix that when it happens.
	- Reorder functions and objects to make them easy for a reader to comprehend when reading the file from top to bottom.
	- Resist the temptation to do another refactoring while fixing and testing the new reading order.
	- The correct reading order is context-dependent: primitives typically come before compositions, API before implementation, etc. But use your best judgment to determine what should go first in each case.
3. Co-locate Coupled Code
	- Put code blocks and files that are coupled next to each other.
	- If you must change multiple locations when making a behavior change, collocate those pieces first.
	- Consider decoupling the code if that cost is lower than the cost of the existing coupling.
4. Review Comments
	- Code that "needs" comments to be "clear" or "readable" is a smell.
	- Refactor comments that are incorrect, unclear, or where the connection to the code or its intent isn't obvious.
	- Remove comments that are redundant or obvious from reading the code, including overly excessive use of "banners."
	- Replace comments with intention-revealing variable names where possible.
	- Replace comments by extracting functions and variables with proper names.
	- Remove attribution and commented-out code - that is the job of version control.
	- Don't add public documentation to private or protected code.

Source: [Tidy First?](https://www.goodreads.com/book/show/171691901-tidy-first) by Kent Beck (and some Clean Code aspects from Uncle Bob)