---
name: git
description: Use when committing code, dealing with pre-commit hook failures, or when markdown file changes appear alongside code changes.
---

# Instructions for working with git

- If there are pre-commit hooks, and your commit fails due to them, don't try to "amend" the next commit (because no commit yet was made).
- When you see git changes to Markdown files while working on code changes, expect the human operator is working on those documents. Ignore and maintain those changes, do not try to revert or undo them.
