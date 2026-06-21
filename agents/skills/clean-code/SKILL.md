---
name: clean-code
description: Guidelines for writing clean, maintainable, and unit-tested code. Use this when writing, reviewing, or refactoring code to ensure adherence to best practices.
---

# Follow best practices of software development

Refer to [Domain Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design) to understand the basics of modeling software according to the business domain.
The practice of [eXtreme Programming (XP)](https://en.wikipedia.org/wiki/Extreme_programming) can help you create higher quality software. 
Establish the goals and requirements of a project using [Gherkin-syntax](Tech/Software%20Development/Skills/to-prd/Gherkin-syntax.md) before starting to work on it with the GRILL-ME SKILL and automate these requirements as executable acceptance tests.
Always use the [tdd](Tech/Software%20Development/Skills/tdd/SKILL.md) skill taught by XP when writing new code.
Refer to the [debugging](debugging-rules.md) skill when resolving bugs and issues in software. 
Finally, apply the [refactoring](Tech/Software%20Development/Skills/refactor/SKILL.md) skill for code review and refactoring best practices.

### CC1. Adopt Test Driven Development
- Apply successive refinements and make your [TDD loops](Canon%20TDD.md) as small and *fast* as possible; Iterate frequently.
- Keep the [test heuristics](https://www.ministryoftesting.com/insights/test-heuristics-cheat-sheet) in mind and test all boundary conditions (such as the max. and min. input values).
- Neither running the build or the tests should require more than one step/command.
- Separate testing, construction, and usage via [Factories](Factory%20Method.md) and [Dependency Injection](https://en.m.wikipedia.org/wiki/Dependency_injection).
- Never implement more than the simplest thing that can possibly work.

### CC2. Write Effective, Efficient, and Simple Code
- What is the (business) target the code (change) is supposed to solve? Does this solve it, *and no more?*
- Is the implementation easy to understand, and does it have reasonable space and time requirements?
- Use code comments to explain intent, clarify, warn, and amplify the importance of some local piece of code only.
- Break down large statements with multiple Boolean operators into readable flags.

### CC3. Apply the Single Responsibility & Open-Closed Principles
- Do the functions and classes have [exactly one responsibility (SRP)](https://en.m.wikipedia.org/wiki/Single_responsibility_principle)?
- Are the functions and classes properly [open for likely extensions but closed for change (OCP)](https://en.m.wikipedia.org/wiki/Open–closed_principle)?

### CC4. Apply the Interface Segregation & Dependency Inversion Principles
- Are all interfaces as tightly defined as they reasonably can be?
	- Is any code [depending on an interface but not using all its capabilities (ISP)](https://en.m.wikipedia.org/wiki/Interface_segregation_principle)?
- [Add dependencies on abstract interfaces (DIP)](https://en.m.wikipedia.org/wiki/Dependency_inversion_principle), not concrete classes.

### CC5. Obey the Law of Demeter
- No unit should depend on more than the direct references it manipulates.
- Does every method/function use (1) only its own variables and routines and (2) only those variables, objects, and routines that were directly passed to it or created by it?
	- No code should use any other variables/methods/functions to *avoid "train wrecks".*
- This rule applies equally to functional modules, objection-oriented classes, and *data structures/data transfer objects/value objects* (which have no functions).

### CC6. Separate Data Structures from Business Rules
- Active Records, Java Beans, Python data classes, etc., should be pure data structures treated as value objects. Mixing them with business logic is a design smell.

### CC7. Pick Meaningful Names
- Pick class, function, and variable names that are easily understood by the domain expert.
- Names should be *descriptive* and *reveal intent*, follow the domain-specific terminology of the business, and be reflective of any applied computer science concepts.
- Prefer explicit over short but ambiguous names: `renamePageAndOptionallyAllReferences` is preferable to a plain `doRename`. 
- Names should reveal side effects, including the construction of objects.
- Consider the right level of abstraction: `Modem.connect` might be better than `Modem.dial`.
- Classes are nouns (or noun phrases), and methods are verbs (or verb phrases). 
- Avoid disinformation, including acronyms and common abbreviations (`a`, `i`, `num`, `idx`, `count`, etc., except for obvious uses such as loop counters)
- Use the same words for one concept (but also not for more than one!) and the same spelling/casing rules everywhere to increase consistency.
- Avoid affixes that encode type system information; They only add noise.
- Add context to increase coherence. E.g., `addressStreet`, `addressCity`, `addressState` avoids having to comprehend an isolated reference to `state` (What sense of state is meant?) But avoid obvious context (Prefixing GSD to every variable of your "Gas Station Deluxe" application is a waste.)
- Avoid naming by the negation, that is, names with "not" in them.

### CC8. Write Clear Functions
- Boolean flag arguments are code smells that indicate you should break up your functions.
- Prefer single argument functions because `writeField(stream, name)` and `assertEquals(expected, actual, message)` can cause confusions:
	- When a function needs more than two arguments, you probably should break it up or create a (value) object (or data structure).
	- Encode the argument order in the name of functions with higher cardinality than one (`assertExpectedEqualsActualOrMessage(expected, actual, message)` is clearer than the above example).
- Functions that return nothing (`void,` `never`) can have side effects, but functions that return values should not (a.k.a. **command-query separation**); If they need to, make that side effect explicit in the function name (`createOrReturnX` over `getX`).
- Refactor duplication and repetition ("DRY code") unless that would seriously reduce comprehensiveness.
- Introduce explanatory variables to increase comprehensibility.
- Make temporal coupling explicit via some kind of dependency. For example, `var a = c.first(); var b = c.second(a); return c.thrid(b);` if preferable to `c.first(); c.second(); c.third();` as the order is made explicit.

### CC9. Object-oriented Code Basics
 - Avoid having side effects or calling static functions in the constructor.
 - Maximize cohesion by having a small number of instance variables that ideally should all be used by every method; That will reduce the overall size of a class, improve the design, and make the codebase easier to comprehend.
 - Maximize isolation by relying on interface abstractions instead of concrete implementations; That will also increase testability.
 - Apply dependency inversion by designing a layered architecture around your business entities to avoid your business logic getting coupled to any other layer; That will also ensure scalability.

Source: [Clean Code](https://www.goodreads.com/book/show/3735293-clean-code) by Robert C. Martin (and some Kent Beck XP advice)