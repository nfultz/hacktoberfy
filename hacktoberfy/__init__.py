# -*- coding: utf-8 -*-

"""Flit Boilerplate contains all the boilerplate you need to create a Python Flit package."""
import argparse

from . import hacktoberfy


__author__ = 'Neal Fultz'
__version__ = '0.1.0'
def main():
    """Main hacktoberfy entrypoint"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '-v', action='version',
            version='%(prog)s {}'.format(__version__))
