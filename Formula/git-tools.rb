class GitTools < Formula
  desc "Collection of Git helper tools"
  homepage "https://github.com/jfasoc/git-tools"
  url "https://github.com/jfasoc/git-tools/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "b0e5903ec323649f3e692e66b4771308b0880e664e7c3c0d423ceaf0bb05eac7"
  license "MIT"

  include Language::Python::Virtualenv

  depends_on "git"
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    touch "test.txt"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    assert_match "Initial commit", shell_output("#{bin}/git-commit-stats")
  end
end
