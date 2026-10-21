class Windowwheel < Formula
  desc "Arrange macOS windows into predefined layouts with a radial menu"
  homepage "https://github.com/limburgmoritz-gh/windowwheel"
  url "https://github.com/limburgmoritz-gh/windowwheel/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c2a679ad0d1b0ef290ba895b0756e55e6d3a8e36f066862c15b3c1d2b81e33da"
  license "MIT"

  depends_on macos: :sonoma
  depends_on "python@3.14"

  def install
    system Formula["python@3.14"].opt_bin/"python3.14", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", buildpath
    bin.install_symlink libexec/"bin/windowwheel"
  end

  service do
    run opt_bin/"windowwheel"
    keep_alive successful_exit: false
    process_type :interactive
    environment_variables PYTHONUNBUFFERED: "1"
    log_path var/"log/windowwheel.log"
    error_log_path var/"log/windowwheel.log"
  end

  def caveats
    <<~EOS
      WindowWheel starten (und ab jetzt bei jeder Anmeldung automatisch):
        brew services start windowwheel

      macOS fragt danach nach zwei Berechtigungen für "Python"
      (Systemeinstellungen › Datenschutz & Sicherheit):
        1. Bedienungshilfen – für Tastenkombination und Fenster verschieben
        2. Bildschirmaufnahme – für die Vorschaubilder, danach einmal:
             brew services restart windowwheel

      Usage: hold ⌥ and press ⇥ (configurable in Settings).
    EOS
  end

  test do
    system libexec/"bin/python", "-c", "import windowwheel"
  end
end
