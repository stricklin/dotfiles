#!/usr/bin/python

#This file is to set up symlinks to point at the config files
import os

home = os.path.expanduser('~')
pwd  = os.path.dirname(__file__)
symlinks = [".vimrc", ".bashrc"]
hardlinks= [".gitconfig"]
for symlink in symlinks:
	dest = home + '/' + symlink
	src  = pwd  + '/' + symlink
	try:
		os.remove(dest)
	except:
		print dest+ " did not exsist so it wasn't removed"
	#if os.path.exists(dest): #if the file exists, delete it
		#os.remove(dest)
	#print src + " " + dest
	os.symlink(src, dest)    #make the symlink
	print "symlink created " + dest
for hardlink in hardlinks:
	dest = home + '/' + hardlink
	src  = pwd  + '/' + hardlink
	try:
		os.remove(dest)
	except:
		print dest+ " did not exsist so it wasn't removed"
	#if os.path.exists(dest): #if the file exists, delete it
		#os.remove(dest)
	os.link(src, dest)    #make the hardlink
	print "hardlink created " + dest

