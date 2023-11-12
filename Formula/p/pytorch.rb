class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v2.1.0",
      revision: "7bcf7da3a268b435777fe87c7794c382f444e86d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bec1303428ad034638ade339956e37683e883a5eca3a6af17e781d2b69b4d78"
    sha256 cellar: :any,                 arm64_ventura:  "477961da7dab586ac1cc53c91024555c9059df30f594503e41e62a0e4621b654"
    sha256 cellar: :any,                 arm64_monterey: "3eb7b182f37d94524955d9a691a0c03083ec923bd92fd6f93dc24ec744ddbfee"
    sha256 cellar: :any,                 sonoma:         "d97326372aa3d2141e33013c61ac4f291c8869b8e3cde5f4c8d881e5e19486a1"
    sha256 cellar: :any,                 ventura:        "a824aa555970306289a16f86df3b7e2aa1515466fdd12c5c2879419ddb79fb4e"
    sha256 cellar: :any,                 monterey:       "4e506c98b4ec7956f2e326d34d6366b9c67c1e6814aab6e5bc4ba8fa875705cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cfcaad8452954edbea234fe912679b60db82507dd1d0dbcf214524c9078bf1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on xcode: :build
  depends_on "eigen"
  depends_on "libuv"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-filelock"
  depends_on "python-jinja"
  depends_on "python-networkx"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{lib}\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    inreplace "torch/utils/cpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      args = %W[
        -GNinja
        -DBLAS=OpenBLAS
        -DBUILD_CUSTOM_PROTOBUF=OFF
        -DBUILD_PYTHON=ON
        -DCMAKE_CXX_COMPILER=#{ENV.cxx}
        -DCMAKE_C_COMPILER=#{ENV.cc}
        -DPYTHON_EXECUTABLE=#{python_exe}
        -DUSE_CUDA=OFF
        -DUSE_DISTRIBUTED=ON
        -DUSE_METAL=OFF
        -DUSE_MKLDNN=OFF
        -DUSE_NNPACK=OFF
        -DUSE_OPENMP=ON
        -DUSE_SYSTEM_EIGEN_INSTALL=ON
        -DUSE_SYSTEM_PYBIND11=ON
      ]
      args << "-DUSE_MPS=ON" if OS.mac?

      rm_rf "build" # remove prior build, if it exists
      system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"torchrun" => "torchrun-#{pyversion}"
    end
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that the `torch` Python module is available
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", <<~EOS
        import torch
        t = torch.rand(5, 3)
        assert isinstance(t, torch.Tensor), "not a tensor"
        assert torch.distributed.is_available(), "torch.distributed is unavailable"
      EOS

      next unless OS.mac?

      # test that we have the MPS backend
      system python_exe, "-c", <<~EOS
        import torch
        assert torch.backends.mps.is_built(), "MPS backend is not built"
      EOS
    end
  end
end
