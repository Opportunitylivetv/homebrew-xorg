class Libxcb < Formula
  desc "Interface to the X Window System protocol and replacement for Xlib"
  homepage "https://www.x.org/" ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
  url "https://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2"
  sha256 "4adfb1b7c67e99bc9c2ccb110b2f175686576d2f792c8a71b9c8b19014057b5b"
  revision 1
  # tag "linuxbrew"

  bottle do
    sha256 "7b3d5f6e65b452ddae87aea65b785592775b4c4c54b015835207a0cbefe47986" => :x86_64_linux
  end

  option "without-test", "Skip compile-time tests"
  option "with-python3", "Build with python3 (default version is used otherwise)"
  option "with-static", "Build static libraries (not recommended)"
  option "with-docs", "Generate API documentation"

  depends_on "pkg-config" => :build
  depends_on "linuxbrew/xorg/libxau"
  depends_on "linuxbrew/xorg/xcb-proto" => :build
  depends_on "linuxbrew/xorg/libpthread-stubs" # xcb.pc references pthread-stubs
  depends_on "linuxbrew/xorg/libxdmcp" => :recommended

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "check" => :build if build.with? "test"
  depends_on "libxslt" => [:build, :optional]

  if build.with? "python3"
    depends_on "python3" => :build
  else
    depends_on "python" => :build
  end

  patch :p1 do
    url "https://cgit.freedesktop.org/xcb/libxcb/patch/?id=8740a288ca468433141341347aa115b9544891d3"
    sha256 "aa3bdbf37c951d6b42b6aeb3c182b87065761027b3180b6f381088fdd13809b4"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-xevie
      --enable-xinput
      --enable-xprint
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    ENV["PYTHON"] = "python3" if build.with? "python3"

    # Be explicit about the configure flags
    args << "--enable-static=#{build.with?("static") ? "yes" : "no"}"
    args << "--enable-devel-docs=#{build.with?("docs") ? "yes" : "no"}"
    args << "--with-doxygen=#{build.with?("docs") ? "yes" : "no"}"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
