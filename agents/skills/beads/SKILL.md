---
name: beads
description: Use the bd (Beads) CLI for issue tracking and work management. Use when planning work with epics and tasks, creating or updating issues, finding the next issue to work on, or completing a work session with push and sync.
---

# Instructions for using `bd` (Beads)

**bd** (Beads) is a command-line tool for issue tracking. Run `bd prime` to get detailed instructions how to use Beads.
- When planning work (Beads tasks), do not break out tests as their own tasks. As you apply TDD, you will write tests for every task, anyway.
- As you work through tasks, if you find that additional functionality is needed, add those requirements as new tasks to Beads.

## Creating issues

The simplest way to plan work is to add `epic` and `task` issues.
And you need to create the correct dependencies between issues:
- parent-child: `bd dep add CHILD_ID PARENT_ID --type parent-child`
- blocking issues: `bd dep add BLOCKEE_ID BLOCKER_ID --type blocks`

Use parent-child dependencies for tasks (or epics) that are grouped under a given epic.
Use blocking dependencies for tasks (or epics) that cannot be worked on until the blocker is resolved.

### Issue structure
An issue should describe a [Gherkin](Gherkin-syntax.md) Scenario that explains when it is done.

### Epic structure
An epic should describe a [Gherkin](Gherkin-syntax.md) User Story that explains the need and value of a feature.

## Finding issues to work on

  When you are asked to work on the next ready beads issue, follow these steps to identify the issue, and get it done:
```bash
bd ready # Find available work
bd show <id> # View issue details
bd update <id> --status in_progress # Claim the issue
bd sync # Update remote origin that the issue is in progress
```

An issue is done once you wrote a test to verify it exists, you have written the necessary code to make the test green, and the passing test is equivalent to passing the Gherkin Scenario or Acceptance Criteria of the Issue. If the passing test is not sufficient to resolve the issue, keep iterating in TDD style until it is resolved.

Once you get the issue done, follow these steps to mark it as done:
```bash
git status # check which files were changed and need to be added
git add <changes> # add anything that was worked on
git commit -m "<commit message>" # commit the changes and the beads update
bd close <id> # Once you complete the work
bd sync # Sync with git
```

NEVER "manually" git-add `.beads/issues.jsonl` and commit the issues; That is what `bd sync` is for, and the file only gets tracked on the `beads-sync` branch.

## Completing work

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds (see step 3 below).

**MANDATORY WORKFLOW:**
1. **File issues for remaining work** - Create issues for anything that needs follow-up, such as: `bd create "issue title" -d "issue description"`
2. **Update issue status** - Close finished work, updating in-progress items to closed: `bd close <id>`
3. **PUSH TO REMOTE** - This is MANDATORY:
```bash
git pull --rebase # fix any merge conflicts
git push # mandatory push
git status # MUST show "up to date with origin"
```
4. **Clean up** - Clear stashes, prune remote branches
5. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- Complete work as frequently as possible - ideally after every issue.
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
- NEVER "manually" git-add `.beads/issues.jsonl` and commit the issues; That is what `bd sync` and the `beads-sync` branch is for.
- NEVER create issues purely for testing; Any new capability must be added using TDD.
- Use TDD to work on the tasks, using the following cycle of 3 steps:
	1. Check if a test for the planned functionality already exists; If not, write the test.
	2. Only once you have a failing test, start implementing the minimal code to pass the test.
	3. If the passing tests fulfill all acceptance criteria of the task, you are done. If not, continue the cycle.