class JupyterAi < Formula
  include Language::Python::Virtualenv

  desc "Generative AI for Jupyter"
  homepage "https://jupyter-ai.readthedocs.io"
  url "https://files.pythonhosted.org/packages/d9/1d/e6351a165b99f5f6cee3137a72b2c3c04249c55a1465f12efb91c5ca6bc0/jupyter_ai-2.0.0.tar.gz"
  sha256 "74265d4e7bfa7eeee1bf806384f38b6b6588388e25b97348337de670ed7b55f5"
  license "BSD-3-Clause"

  depends_on "hatch" => :build
  depends_on "jupyterlab"
  depends_on "python@3.11"

  uses_from_macos "expect" => :test

  resource "ai21" do
    url "https://files.pythonhosted.org/packages/47/98/ca3569dc5d518eb6f94f248716c903900ba6acc88c4f1e2ec665f845e454/ai21-1.2.4.tar.gz"
    sha256 "78a3ba4e8fae4f71cd670c9dd82168737155a01161907cfd6b2907239d36faff"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/40/f8/1cce08b0f4cb7ac5b428d5db18f862ed9f1c1d460a4f79820bd7ec73d897/anthropic-0.3.8.tar.gz"
    sha256 "6651099807456c3b95b3879f5ad7d00f7e7e4f7649a2394d18032ab8be54ef16"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2d/ae/7a28ce6d8eb6b4e5ae1c7cf302179a6ef78c11f7a54e818df5dd7b237724/boto3-1.26.73.tar.gz"
    sha256 "bd92def38355ea055c6c29bd599832878eecc19cad21dab34ade38280e1b403b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e8/0a/bc0b30cc6c97072c350276d7b99b16100d1c6743942e8880af237344d914/botocore-1.29.73.tar.gz"
    sha256 "a9f0e006b3342424d59d5e23dc1ca0c6972c909a727dcd0811c9b20966d4adf8"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/ed/b9/c1e1c193812c4b8480d13590d75e470d9c562354204cf83191a56958483c/cohere-4.19.2.tar.gz"
    sha256 "a0b0fa698b3d3983fb328bb90d68fcf08faaa2268f3772ebc6bfea6ba55acf27"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/89/ee/84bbd0161090f0f24e8a2ac175e6b6a936289ee02e9d5da414ce14d3d332/openai-0.27.8.tar.gz"
    sha256 "2483095c7db1eee274cebac79e315a986c4e55207bb4fa7b82d185b3a2ed9536"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    site_packages = Language::Python.site_packages(python3)
    %w[jupyterlab].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    venv.pip_install resources

    hatch = Formula["hatch"].opt_bin/"hatch"
    system hatch, "build", "-t", "wheel"
    venv.pip_install_and_link Dir["dist/*.whl"].first
  end

  test do

  end
end
