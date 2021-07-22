class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://github.com/terrencepreilly/darglint/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "7b38411663b2e5a4f8abbec7762e4e3c0d4550c2fbcbbfa37603b6b585644b60"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end
