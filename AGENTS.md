# Agent Instructions: Testing and Creating Homebrew Formulae

This repository is a Homebrew tap. When adding or modifying formulae, you should verify them using `brew` before submitting your changes.

## 1. Setup Homebrew (if not available)

If `brew` is not installed in the sandbox, you can install a local version of Linuxbrew:

```bash
git clone --depth=1 https://github.com/Homebrew/brew "${HOME}/.linuxbrew/Homebrew"
mkdir -p "${HOME}/.linuxbrew/bin"
ln -s "${HOME}/.linuxbrew/Homebrew/bin/brew" "${HOME}/.linuxbrew/bin/brew"
eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
```

## 2. Test the Formula

### Add the local repository as a tap

```bash
brew tap jfasoc/tap .
```

### Run Formula Tests

The `test` block in the formula should be verified to ensure the tool runs correctly in a clean environment:

```bash
brew test jfasoc/tap/git-tools
```

### Run Formula Audit

Check for style violations, missing dependencies, or other structural issues:

```bash
brew audit --new jfasoc/tap/git-tools
```

### Run Formula Style Check

Check for Ruby style violations using RuboCop:

```bash
brew style jfasoc/tap/git-tools
```

### Run Tap Readability Check

Ensure all formulae in the tap can be loaded correctly:

```bash
brew readall jfasoc/tap
```

## 3. Homebrew Formula Best Practices & Learnings

### Python Formulas
*   **Python Version**: Use the version agreed upon with the user (e.g., `python@3.14`). Always prefer specific versioned dependencies like `python@3.14` over a generic `python3` to ensure stability.
*   **Isolation**: Use `Language::Python::Virtualenv` and `virtualenv_install_with_resources`. This ensures the tool runs in its own isolated environment, preventing conflicts with other Python packages.
*   **Build Isolation**: For PEP 517 projects (e.g., PDM, Flit, Poetry), `pip` may attempt to download the build-backend from PyPI during installation. To support offline or sandboxed builds, ensure all build dependencies are included as `resource` blocks.
*   **Resource Blocks**: All external dependencies (including build-backends like `pdm-backend`) must be explicitly defined as `resource` blocks. You can find the URL and SHA256 of these resources on PyPI.

### Component Ordering
Homebrew's `audit` is strict about the order of components within the formula class. The expected order is:
1.  `include` statements (e.g., `include Language::Python::Virtualenv`)
2.  `desc`
3.  `homepage`
4.  `url`
5.  `sha256`
6.  `license`
7.  `depends_on`
8.  `resource` blocks
9.  `def install`
10. `test` block

### Test Block Design
*   **Hermetic Testing**: Tests run in a temporary directory (`mktemp`). Always initialize necessary environments (e.g., `git init`) and configurations (e.g., `git config user.email`) within the `test` block.
*   **Regex Safety**: `assert_match` in Minitest (used by Homebrew) treats the first argument as a regex. Be careful with special characters like parentheses. For example, to match `Regular (A/M/D)`, use a literal substring like `"Regular"` or escape the parentheses.
*   **Verification**: Use `shell_output` to capture the stdout of your command and verify it contains expected values.

### General Tap Structure
*   Formulae should be placed in the `Formula/` directory.
*   Tap names follow the format `user/tap`, where `homebrew-tap` in GitHub corresponds to `user/tap` in `brew tap`.
*   Avoid explicit dependencies on tools that are implicitly provided by the environment, such as `git`.

## 4. Verification Checklist

Before pushing commits or creating a Pull Request:
- [ ] `brew audit --new <formula>` passes without errors.
- [ ] `brew style <formula>` passes.
- [ ] `brew readall <tap>` passes.
- [ ] `brew test <formula>` passes.
- [ ] All temporary files (e.g., metadata JSON files, build artifacts) are deleted.
