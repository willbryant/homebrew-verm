class Verm < Formula
  homepage "https://github.com/willbryant/verm"
  url "https://github.com/willbryant/verm/archive/0.50.tar.gz"
  sha1 "882072c4eeaa4c2ad42fce8557d2c79d1282eafd"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/willbryant"
    ln_s buildpath, buildpath/"src/github.com/willbryant/verm"
    system "go", "build", "github.com/willbryant/verm"
    bin.install "verm"
    mkdir_p var/"verm"
  end

  test do
    system "make", "test_verm"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/verm</string>
        <string>--data</string>
        <string>#{var}/verm</string>
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
