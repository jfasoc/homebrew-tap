# Agent Instructions: Testing Homebrew Formulae

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

## 3. Python Formula Best Practices

*   **Python Version**: Use the version agreed upon with the user (e.g., `python@3.14`).
*   **Isolation**: Use `Language::Python::Virtualenv` and `virtualenv_install_with_resources`.
*   **Resources**: If the project uses a build-backend like `pdm-backend` or has external dependencies, they must be included as `resource` blocks in the formula for isolated builds.
*   **Component Order**: Place `include Language::Python::Virtualenv` at the very top of the class definition, before `desc`.
*   **Dependencies**: Do not explicitly `depends_on "git"` as it is implicitly provided.

## 4. Verification Checklist

Before calling `submit`:
- [ ] `brew audit --new <formula>` passes without errors.
- [ ] `brew test <formula>` passes.
- [ ] All temporary files (e.g., metadata JSON files) are deleted.
