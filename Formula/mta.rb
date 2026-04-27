class Mta < Formula
  desc "NYC subway arrivals and route planner for the terminal"
  homepage "https://github.com/itsashishupadhyay/NYC_MTA_Timetable"
  url "https://github.com/itsashishupadhyay/NYC_MTA_Timetable/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "1d7de1a3619091ca395b621b13749b709eac926d3948c31864176ec24835d894"
  license "MIT"
  head "https://github.com/itsashishupadhyay/NYC_MTA_Timetable.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "curl"

  def install
    # Regenerate gtfs-realtime.pb.{h,cc} against Homebrew's protobuf so the
    # binary's ABI matches the libprotobuf it links against. The shipped
    # generated files were produced against an older protobuf and break on
    # newer majors (Homebrew tracks latest).
    system Formula["protobuf"].opt_bin/"protoc",
           "--cpp_out=.", "gtfs-realtime.proto"
    mv "gtfs-realtime.pb.h", "include/gtfs-realtime.pb.h"
    mv "gtfs-realtime.pb.cc", "source/gtfs-realtime.pb.cc"

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
