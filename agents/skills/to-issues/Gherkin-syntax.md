# Gherkin syntax
[Cucumber Gherkin reference](https://cucumber.io/docs/gherkin/reference/)

# Features
```
# Feature: title
```
Features are described through one or more (user) stories.

# Stories
```
## Story: title
- AS A persona
- I WANT [TO] need
- SO THAT value
```
For example:
```
- AS A project manager
- I WANT TO generate a project status report
- SO THAT I can share progress with stakeholders
```

User stories are detailed through one or more scenarios.

# Background
To avoid repeating the same `GIVEN` step(s) across all scenarios of a feature, you can define a default background for the whole feature.
```
## Background:
- GIVEN setting
- AND condition
```

# Scenarios
```
### Scenario: title
- GIVEN setting
- WHEN action
- THEN outcome
- AND condition
- BUT negation
```
Your scenarios should describe the intended behavior (**functional requirements**) of the system, not the implementation. In other words, it should describe _what_, not _how_.
For example, for an authentication Scenario, you should write:
```
- WHEN "Bob" logs in
```
Instead of:
```
- GIVEN I visit "/login"
- WHEN I enter "Bob" in the "user name" field
- AND I enter "tester" in the "password" field
- AND I press the "login" button
```
A good question to ask yourself when writing a feature clause is: “Will this wording need to change if the implementation does?”. If the answer is “Yes”, then you should rework it avoiding implementation specific details.

Scenarios should be written in **declarative style**. Declarative style describes the behaviour of the application, rather than the implementation details.  A declarative style helps you focus on the value that the customer is getting, rather than the exact steps they follow to get there. Avoid precise instructions.

Bad example:
```
### Scenario: Free subscribers see only the free articles  
- GIVEN users with a free subscription can access "FreeArticle1" but not "PaidArticle1"  
- WHEN I type "freeFrieda@example.com" in the email field  
- AND I type "validPassword123" in the password field  
- AND I press the "Submit" button  
- THEN I see "FreeArticle1" on the home page  
- AND I do not see "PaidArticle1" on the home page
```
Good example:
```
### Scenario: Free subscribers see only the free articles  
- GIVEN Free Frieda has a free subscription  
- WHEN Free Frieda logs in with her valid credentials  
- THEN she sees a Free article

### Scenario: Subscriber with a paid subscription can access both free and paid articles  
- GIVEN Paid Patty has a basic-level paid subscription  
- WHEN Paid Patty logs in with her valid credentials  
- THEN she sees a Free article
- AND she sees a Paid article
```

## Scenario Outlines with Examples
```
Examples:
| var1 | var2 | ...
| ---- | ---- | ...
| val  | val  | ...
```
Examples are used to set `<vars>` in Scenario **Outlines**:
```
### Scenario Outline: eating
- GIVEN there are `<start>` cucumbers
- WHEN I eat `<eat>` cucumbers
- THEN I should have `<left>` cucumbers

Examples:
| start | eat | left |
| ----- | --- | ---- |
|    12 |   5 |    7 |
|    20 |   5 |   15 |
```

# Comments

```
- GIVEN a blog post named "Random" with Markdown body
  """
  Some Title, Eh?
  ===============
  Here is the first paragraph of my blog post. Lorem ipsum dolor sit amet,
  consectetur adipiscing elit.
  """
```

# Data Tables
```
- GIVEN the following users exist:
  | name   | email              | twitter         |
  | ------ | ------------------ | --------------- |
  | Aslak  | aslak@cucumber.io  | @aslak_hellesoy |
  | Julien | julien@cucumber.io | @jbpros         |
  | Matt   | matt@cucumber.io   | @mattwynne      |
```