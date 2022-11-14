# This script compiles the libdaa library.
# it will execute the libdaa/scripts/make-module script

import os
import subprocess
import sys


class Compile:

    def __init__(self):
        self.path = os.path.dirname(os.path.realpath(__file__))
        self.libdaa_path = os.path.join(self.path, "libdaa")
        self.libdaa_make_module_path = "./scripts/make-module"

    def _cd_libdaa(self):
        os.chdir(self.libdaa_path)
        return self

    def compile(self):
        self._cd_libdaa()
        print(os.listdir("scripts"))
        # subprocess.run([self.libdaa_make_module_path])
        return self


def main():
    Compile().compile()
