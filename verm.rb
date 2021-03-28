class Verm < Formula
  homepage "https://github.com/willbryant/verm"
  url "https://github.com/willbryant/verm/archive/1.5.2.tar.gz"
  sha256 "720b43ff82e6ef78daf4de8b8604827e0bb0abf6294cd25aa37f01e319cc4f8b"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"go"
    mkdir_p buildpath/"go/src/github.com/willbryant"
    ln_s buildpath/"go", buildpath/"go/src/github.com/willbryant/verm"
    system "go", "build", "-ldflags", "-X main.compiled_version=#{version} -X main.compiled_root_data_directory=#{var/'verm'}", "github.com/willbryant/verm"
    bin.install "verm"
    mkdir_p var/"verm"
  end

  test do
    system "make", "test_verm"
  end

  plist_options :manual => "verm"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/verm</string>
        <string>-listen</string>
        <string>localhost</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/verm.err</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/verm.log</string>
    </dict>
    </plist>
    EOS
  end
end
