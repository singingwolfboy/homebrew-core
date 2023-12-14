class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/0a/12/623f37900c1e9725901564819a11bab20ebf6dae5ecf206672a664c38031/b2-3.15.0.tar.gz"
  sha256 "d74736cdd7402f2efe086c618d40bab4c2d0719dd698b7916356cd296ba7032b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e16ce94878fe37e254371e747b03f85fb57904589832349146b2bb5cf49182e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e9d124937bbbe32bb74c643d49613985ae9433a33b62804f234be5722e80030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06b5fce1efbfa6a2a55bbd5256aa4202b4b536d45a8d35833189152ea94a5c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "95492aad479e25653fb6ff977a064ede24ac8d7608b0dfca80fa8eab1f471ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "d946d15942323cc8af1be00c222eb4a82aa2216b9a7c0519f5ca8254e1a06caf"
    sha256 cellar: :any_skip_relocation, monterey:       "ca7f55c97b0d48177f46067897b1b37145ff12cf88f35cdd07edd5f7c642d70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dfd4e59be1f4ab11dde7481a853e8c911035bc519f5b9ffdb19acb77119aa62"
  end

  depends_on "docutils"
  depends_on "python-argcomplete"
  depends_on "python-dateutil"
  depends_on "python-packaging"
  depends_on "python-platformdirs"
  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/69/06/7c30d1502855e69a6fd87c24351b04d6b8d53e76b3c8dc1bf962f7ec61a3/b2sdk-1.28.0.tar.gz"
    sha256 "b5ef69705fbcbab124b031e9040764d890b7e08394ba5f81d3c933a6a920fa0f"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/79/ce/db26f7f8ed4f4b200f34b8401ecaa9cbb0709f3c3822ae0d29a6019ad2a8/phx-class-registry-4.1.0.tar.gz"
    sha256 "6a7fe8568f9000ad1f90c9a81c5cb65ec20ee3b89b2aaab7a67e14dbb67e11d1"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/04/e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5/tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  def install
    virtualenv_install_with_resources

    system bin/"b2", "install-autocomplete", "--shell", "bash"
    bash_completion.install "#{Dir.home}/.bash_completion.d/b2"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    assert_match "-F _python_argcomplete b2",
                 shell_output("bash -c \"source #{bash_completion}/b2 && complete -p b2\"")
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
