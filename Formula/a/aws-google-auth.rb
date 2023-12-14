class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://files.pythonhosted.org/packages/32/4c/3a1dd1781c9d3bb4a85921b3d3e6e32fc0f0bad61ace6a8e1bd1a59c5ba0/aws-google-auth-0.0.38.tar.gz"
  sha256 "7a044636df2f0ce6ceb01f8f57aba0b6a79ae58a91bef788b0ccc6474914e8ee"
  license "MIT"
  revision 8
  head "https://github.com/cevoaustralia/aws-google-auth.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cab988a28c7f4b89345c94e14817edce836d857c1c8b2626648ba628b79d28a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6600562da29af345ac983454c838c37263cfe6061aa59b2be95062704e974d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55b85436c2ef4bd7a15775d20723242e9fe82f546e56dad98489d4dd7d462df"
    sha256 cellar: :any_skip_relocation, sonoma:         "da8e029980da2e1eec5b2025c16a9306c5671e3bc26d4c8fb303b43ef1969dec"
    sha256 cellar: :any_skip_relocation, ventura:        "28818f276d339655e71fddcab24d87ef321d574715cf5fde5b54dac899d6643b"
    sha256 cellar: :any_skip_relocation, monterey:       "69837678c48131b581457e65649bd10b9325601660731cfe1610a527eed166e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b02955f390c24d9eddb0587169c8d6f5e95b6402e028ccdc3701c3011feb8a"
  end

  depends_on "keyring"
  depends_on "pillow"
  depends_on "python-boto3"
  depends_on "python-dateutil"
  depends_on "python-filelock"
  depends_on "python-lxml"
  depends_on "python-requests"
  depends_on "python-tabulate"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cffi"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/a6/97/c7344bed881cc6f78b6231262436eb0c72615011fab4786d23d676ab77b0/keyrings.alt-5.0.0.tar.gz"
    sha256 "9d446cb47bbcea90ffa2ecc3e8003acf41573fc201bf44b4bf13bd0e11484828"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    auth_process = IO.popen "#{bin}/aws-google-auth"
    sleep 10
    Process.kill "TERM", auth_process.pid
    assert_match "AWS Region:", auth_process.read
  end
end
