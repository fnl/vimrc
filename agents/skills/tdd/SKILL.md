---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# Test-Driven Development (TDD)

## Philosophy

Use TDD cycles as your standard workflow to write code.

Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test *imagined* behavior, not *actual* behavior
- You end up testing the *shape* of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via on tracer bullet at a time. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### 1. Planning

When exploring the codebase, use the project's domain glossary so that test names and interface vocabulary match the project's language, and respect ADRs in the area you're touching.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](interface-design.md)
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Tracer Bullet

Write exactly ONE behavior or acceptance criteria that confirms ONE thing about the system.

```
RED:   Write behavior test for core acceptance criteria → tracer bullet fails
GREEN: Write minimal tests and code in red-green loop → tracer bullet passes
```

This is your tracer bullet - it is designed so that when it passes, it proves that particular path works end-to-end.

Typically, the tracer bullet will be a [Gherkin](Tech/Software%20Development/Skills/to-prd/Gherkin-syntax.md) **Scenario** using a GIVEN-WHEN-THEN structure.

### 3. Red-Green Testing Loop

For each functionality or aspect needed to make your tracer bullet green:

```
RED:   Write next test → test fails
GREEN: Minimal code to pass → test passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior
- With as few assertions as possible
- Do not add code that is not covered by the test

If you discover the need to validate additional behavior, track those findings as new issues on the issue tracker (see the `to-issue` skill on how to write issues).
Don't just copy the expected values by running the test without understanding them.

### 4. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication (DRY code)
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

### 5. Commit

**Commit** all the changes you made once a test is green and the code is refactored.

Then keep working out and implementing every acceptance/behavior test on your list one-by-one as your tracer bullets.

## Checklist Per Red/Green Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

## Testing rules

- ONLY ASSERT WHAT THE TEST OR SCENARIO CLAIMS TO VALIDATE.
- IDEAL TESTS HAVE EXACTLY ONE ASSERTION, no less and no more.
  - For example, if you are testing an HTTP endpoint is returning content type JSON, don't also assert the status code.
- Test the behavior of the public interface only: exported functions, methods, HTTP handlers, or CLI commands, not private helpers.
- Only write just enough code to make the the test or scenario pass.
- Use descriptive names and simple language so anyone can understand the intent without reading the code.
- Tests must be independent of each other and test business rules and requirements, not implementation logic.
- Mock external dependencies, not internal logic, and focus on behavior not implementation.
- Tests should run in milliseconds, to keep the test suite fast.
  - Tests over a few dozen milliseconds should be set aside and not run every time (e.g., end-to-end integration and acceptance tests that get run only before frequent deployments).
- If you add new tests, review how redundant the setup is with other tests, and clean up the code.
  - Only worry about the concrete aspects under test and keep test code DRY.
