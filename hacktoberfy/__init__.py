# -*- coding: utf-8 -*-

"""Flit Boilerplate contains all the boilerplate you need to create a Python Flit package."""

from github import Github

__author__ = 'Neal Fultz'
__version__ = '0.1.0'

class Hacktoberfy:

    def __init__(self, token):
        self.gh = Github(token)

    def add_topic(self, topic='hacktoberfest'):
        for r in self.gh.get_user().get_repos(type='owner'):
            if not r.fork and not r.private:
                t = r.get_topics()
                if topic not in t:
                    print(r)
                    t.append(topic)
                    r.replace_topics(t)

    def rm_topic(self, topic='hacktoberfest'):
        for r in self.gh.get_user().get_repos(type='owner'):
            if not r.fork and not r.private:
                t = r.get_topics()
                if topic in t:
                    print(r)
                    t.remove(topic)
                    r.replace_topics(t)
