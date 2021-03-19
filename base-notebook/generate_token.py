#!/usr/bin/env sh
import IPython as IPython

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument("-p",
        "--password",
        dest="password",
        help="The password you want to use for authentication.",
        required=True)
    args = parser.parse_args()

    hash = IPython.lib.passwd(args.password)
    print(hash)