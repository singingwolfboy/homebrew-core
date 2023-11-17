class PythonContourpy < Formula
  desc "Python library for calculating contours of 2D quadrilateral grids"
  homepage "https://github.com/contourpy/contourpy"
  url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
  sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  license "BSD-3-Clause"

  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on "python-build" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "numpy"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "build", "--no-isolation", "--skip-dependency-check", "--wheel"
      system python_exe, "-m", "pip", "install", *std_pip_args, Dir["dist/contourpy-*.whl"].first
      rm_rf "dist"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import contourpy"
    end
  end
end
