---
paths:
  - "**/*.ts"
---

# TypeScript development rules
These rules describe how you must develop any TypeScript projects.
Use the `pnpm` package and project manager to operate all projects.

If `pnpm` is not available in your node environment, use the following command to install `pnpm` for your node version:
```bash
corepack enable pnpm
```

Once in a dedicated directory, the project can be set up with:
```bash
pnpm init
pnpm add -D typescript
pnpm exec tsc --init
git init -b main
```

## Assumptions
- Source code is in `$CODE/` (e.g., `src/`, `mypack/`, etc.)
- Tests are in `tests/`
- All tools will be run via `pnpm exec` (do not invoke tools directly).

## Required tools
- Prettier for formatting (might be "integrated" into ESLint)
- ESLint (flat config) + `typescript-eslint` for linting
- TypeScript (`tsc`) for type-checking and transpiling
- pnpm audit for dependency check-ups
- Vitest for tests

Set up the project and install the tool-chain into the project with `pnpm`:
```bash
pnpm add -D eslint @eslint/js typescript-eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-security prettier vitest
````

If the project has already been set up, there might be a concurrently-based watcher script ready in `package.json` to run all the tools, such as `pnpm dev` to run all but `pnpm audit` on any file changes. (Remember that prettier formatting can be built into the eslint watcher.)

### Format the code
Let prettier automatically fix as many issues as possible:
```bash
pnpm exec prettier --write "$CODE/**/*.{ts,tsx,js,jsx,json,md,yml,yaml}" "tests/**/*.{ts,tsx,js,jsx,json,md,yml,yaml}"
```

### Lint and auto-fix where possible
Create an `eslint.config.mjs` config file in the root of your project, and populate it with the following code block to ensure strict, stylistic correct code:
```typescript
// @ts-check
import eslint from '@eslint/js';
import { defineConfig } from 'eslint/config';
import tseslint from 'typescript-eslint';
import security from 'eslint-plugin-security';

export default defineConfig(
  eslint.configs.recommended,
  tseslint.configs.strict,
  tseslint.configs.stylistic,
  // Security plugin integration
  {
    files: ['**/*.{js,ts}'],
    plugins: {
      security,
    },
    rules: {
      // Spread the recommended security rules
      ...security.configs.recommended.rules,
    },
  },  
);
```

Now you can use the ESLinter to surface and possibly fix any issues:
```bash
pnpm exec eslint --fix $CODE tests --ext .ts --max-warnings 0
```

### Write type-safe code
Ensure `tsconfig.json` has `"strict": true` and then check for errors by not emitting the JS code:
```bash
pnpm exec tsc -p tsconfig.json --noEmit
```

### Do test-driven development
Write tests before implementation. Follow the [tdd](Tech/Software%20Development/Skills/tdd/SKILL.md) skill guidelines. And run the tests with `vitest`:

```bash
pnpm exec vitest run tests
```

### Audit dependencies
Only needed when you add a new package of once in a while, to ensure no dependencies have known vulnerabilities.
```bash
pnpm audit
```

## Code standards
- Keep functions small, single-purpose, and testable.
- Prefer explicit types at module boundaries and public APIs.
- Prefer clarity in code over comments; only comment when logic is genuinely hard to understand.

### Function Ordering

Main function at top, helpers below in logical order.

### Helper Functions

Use regular functions, not const arrows:

```typescript
function goodHelper(param: string): RVal {
  ...
}

const badHelper = (param: string): RVal => ({...})
```

### Error Handling

- Define custom error types/classes
- Never silently catch errors without handling
- Use specific catch blocks instead of catching all errors
- Log errors with sufficient context for debugging

### Async/Await Patterns

- Prefer async/await over Promise chains
- Always return Promises properly from async functions
- Handle Promise rejections appropriately
- Use Promise.all() for parallel operations when applicable

### Regex Iteration

Prefer `String.matchAll` with `for...of` instead of `RegExp.exec` inside a `while` loop.

```typescript
// Good
for (const match of text.matchAll(regex)) {
  // use match
}

// Avoid
let match: RegExpExecArray | null
while ((match = regex.exec(text)) !== null) {
  // use match
}
```

### Type Annotations

Prefer explicit types for readability:

```typescript
const validIndices: number[] = indices.filter(...)
```

Prefer explicit types instead of `any`.

### Interface Naming

Do not use `I` prefixes for interface names. Prefer descriptive names like `TranslatorService` instead of `ITranslatorService`.

### Logging

Use string interpolation, not object second argument (because the object doesn't appear on CLI logs):

```typescript
// Good
logger.info(`[function] Message ${myVar}: ${otherVar}`)

// Bad
logger.info('[function] Message', { myVar, otherVar })
```

## Code Examples

### Good Type Definition

```typescript
interface UserProfile {
  id: string
  email: string
  displayName: string
  isActive: boolean
  createdAt: Date
}

interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
}
```

### Good Error Handling

```typescript
class ValidationError extends Error {
  constructor(
    message: string,
    public field: string,
  ) {
    super(message)
    this.name = 'ValidationError'
  }
}

try {
  validateInput(input)
} catch (error) {
  if (error instanceof ValidationError) {
    logger.warn(`Validation failed: ${error.field}`)
  } else {
    logger.error(`Unexpected error: ${error}`)
  }
}
```

### Good Async Pattern

```typescript
async function fetchUserData(userId: string): Promise<UserProfile> {
  try {
    const response = await apiClient.get<UserProfile>(`/users/${userId}`)
    return response.data
  } catch (error) {
    logger.error(`Failed to fetch user ${userId}:`, error)
    throw new Error(`Unable to retrieve user data`)
  }
}
```

## Definition of Done
After making a test green and the refactoring is done, ensure all tools pass or fix any issues. Unlike the type checking step instructions above, this time the JS code is emitted to make sure vitest runs on the latest TS code.
```bash
pnpm exec prettier --write "$CODE/**/*.{ts,tsx,js,jsx,json,md,yml,yaml}" "tests/**/*.{ts,tsx,js,jsx,json,md,yml,yaml}"
pnpm exec eslint --fix $CODE tests --ext .ts --max-warnings 0
pnpm exec tsc -p tsconfig.json --build
pnpm audit
pnpm exec vitest run tests
```

### Git pre-commit hooks to test DoD
Set up Husky to manage your git hooks:
```bash
pnpm add -D husky lint-staged
pnpm dlx husky init
```
The `husky init` command creates a `.husky` folder and a sample `pre-commit` hook file, and usually adds `"prepare": "husky"` to your `package.json` so hooks are installed after `pnpm install`.

Add the above DoD steps to the `pre-commit` hook file.

