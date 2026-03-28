class GitTools < Formula
  include Language::Python::Virtualenv

  desc "Collection of Git helper tools"
  homepage "https://github.com/jfasoc/git-tools"

  option "with-completion-branch", "Use the branch with shell completions"

  if build.with? "completion-branch"
    url "https://github.com/jfasoc/git-tools.git", branch: "add-shell-completion-3611108432175409763"
    version "0.0.1-completion"
  else
    url "https://github.com/jfasoc/git-tools/archive/refs/tags/v0.0.1.tar.gz"
    sha256 "b0e5903ec323649f3e692e66b4771308b0880e664e7c3c0d423ceaf0bb05eac7"
  end

  license "MIT"

  head "https://github.com/jfasoc/git-tools.git", branch: "main"

  depends_on "python@3.14"

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/e2/38/d22c1050130b8cdf16fef76c99c59968086802744947f2813d45c69cca52/pdm_backend-2.4.7.tar.gz"
    sha256 "a509d083850378ce919d41e7a2faddfc57a1764d376913c66731125d6b14110f"
  end

  def install
    virtualenv_install_with_resources

    if File.directory?("completions")
      bash_completion.install "completions/git-tools.bash" if File.exist?("completions/git-tools.bash")
      zsh_completion.install "completions/git-tools.zsh" => "_git-tools" if File.exist?("completions/git-tools.zsh")
    end
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    touch "test.txt"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    assert_match %r{Commit\s+Regular \(A/M/D\)\s+Symlinks \(A/M/D\)}, shell_output("#{bin}/git-commit-stats")
    assert_match "1 /   0 /   0", shell_output("#{bin}/git-commit-stats")
  end
end
