class Mta < Formula
  desc "NYC subway arrivals and route planner for the terminal"
  homepage "https://github.com/itsashishupadhyay/NYC_MTA_Timetable"
  url "https://github.com/itsashishupadhyay/NYC_MTA_Timetable/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"
  head "https://github.com/itsashishupadhyay/NYC_MTA_Timetable.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DMTA_DATADIR=#{pkgshare}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mta --version")
    assert_match "NYC subway", shell_output("#{bin}/mta --help")
  end
end
