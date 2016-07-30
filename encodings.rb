class Encodings < Formula
  desc "X.Org Fonts: encodings"
  homepage "http://www.x.org/"
  ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7font.html
  url    "https://www.x.org/pub/individual/font/encodings-1.0.4.tar.bz2"
  mirror "https://xorg.freedesktop.org/archive/individual/font/encodings-1.0.4.tar.bz2"
  mirror "https://ftp.x.org/archive/individual/font/encodings-1.0.4.tar.bz2"
  sha256 "ced6312988a45d23812c2ac708b4595f63fd7a49c4dcd9f66bdcd50d1057d539"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "08ecde6fe4edbf50e67b7c3464f7b55e51d031e73f81ef344f5b38717725043c" => :x86_64_linux
  end

  depends_on "pkg-config" =>  :build
  depends_on "font-util"  =>  :build
  depends_on "mkfontscale" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    prefix.install "README" => "encodings.md"
  end
end
