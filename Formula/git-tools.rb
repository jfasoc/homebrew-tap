class GitTools < Formula
  include Language::Python::Virtualenv

  desc "Collection of Git helper tools"
  homepage "https://github.com/jfasoc/git-tools"
  url "https://github.com/jfasoc/git-tools/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0e32d6262a1ab4b531eeb8edaca1c5e0a5ae9453b8525ddc0d102e27054c2a11"
  license "MIT"

  depends_on "python@3.14"

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/e2/38/d22c1050130b8cdf16fef76c99c59968086802744947f2813d45c69cca52/pdm_backend-2.4.7.tar.gz"
    sha256 "a509d083850378ce919d41e7a2faddfc57a1764d376913c66731125d6b14110f"
  end

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
    assert_match %r{Commit\s+Regular \(A/M/D\)\s+Symlinks \(A/M/D\)}, shell_output("#{bin}/git-commit-stats")
    assert_match "1 /   0 /   0", shell_output("#{bin}/git-commit-stats")
    assert_match "Pack Name", shell_output("#{bin}/git-pack-stats")
    assert_match "Raw Size", shell_output("#{bin}/git-pack-stats")
    assert_match "Ratio", shell_output("#{bin}/git-pack-stats")
  end
end
