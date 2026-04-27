class Mta < Formula
  desc "NYC subway arrivals and route planner for the terminal"
  homepage "https://github.com/itsashishupadhyay/NYC_MTA_Timetable"
  url "https://github.com/itsashishupadhyay/NYC_MTA_Timetable/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "02b55241b6dd5a78fb7439add4c8463f7ba00f3684452dc7ac11bab21879b86d"
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
