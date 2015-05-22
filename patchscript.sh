#!/usr/bin/env sh

casa=$1
python=$2

cd $casa/lib

cp -a python2.7/casac.py python2.7/__casac__ $python

for f in lib*.so* ; do
  if [ -h $f ] ; then
    cp -a $f $python/__casac__ # copy symlinks as links
  else
    case $f in
      *_debug.so) ;; # skip -- actually text files
      libgomp.*)
        # somehow patchelf fries this particular file
        cp -a $f $python/__casac__ ;;
      *)
        cp -a $f $python/__casac__
        patchelf --set-rpath '$ORIGIN' $python/__casac__/$f ;;
    esac
  fi
done

cd $python/__casac__ 
# patch rpaths of Python module binary files
for f in _*.so ; do
  patchelf --set-rpath '$ORIGIN' $f
done
