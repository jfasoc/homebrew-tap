class GitTools < Formula
  include Language::Python::Virtualenv

  desc "Collection of Git helper tools"
  homepage "https://github.com/jfasoc/git-tools"
  url "https://github.com/jfasoc/git-tools/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "99fe4afa5be0eafe89b1727984d6506f8b11290f1def1e5989f49cb2e76ae405"
  license "MIT"

  head "https://github.com/jfasoc/git-tools.git", branch: "main"

  option "with-completion-branch", "Use the branch with shell completions"

  depends_on "git" => :build
  depends_on "python@3.12"

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/7c/7e/6d441c8739a30820ec59517a88326789c201ae43a344b2ffb02fb2702d8e/pdm_backend-2.4.8.tar.gz"
    sha256 "d8ef85d2c4306ee67195412d701fae9983e84ec6574598e26798ae26b7b3c7e0"
  end

  def install
    ENV["PDM_BUILD_SCM_VERSION"] = version.to_s

    if build.with? "completion-branch"
      # Fetch the completion branch manually
      system "git", "clone", "--depth", "1", "--branch",
             "add-shell-completion-3611108432175409763",
             "https://github.com/jfasoc/git-tools.git", buildpath
    end

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
