# This script compiles the libdaa library.
# it will execute the libdaa/scripts/make-module script

import argparse
import os
import subprocess


class Compile:

    def __init__(self, initial_path: str):
        self.path = os.path.join(os.getcwd(), initial_path)
        self.script_path = os.path.join(self.path, "scripts", "make-module")

    def _cd_libdaa(self):
        os.chdir(self.path)
        return self

    def compile(self):
        self._cd_libdaa()
        subprocess.Popen(self.script_path).wait()
        return self


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p",
                        "--path",
                        help="Path to the libdaa folder",
                        default="daa/libdaa")
    args = parser.parse_args()
    if not args.path:
        print("No path provided")
        return

    Compile(args.path).compile()


if __name__ == "__main__":
    main()
