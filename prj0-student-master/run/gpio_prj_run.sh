#!/bin/sh
skip=44

tab='	'
nl='
'
IFS=" $tab$nl"

umask=`umask`
umask 77

gztmpdir=
trap 'res=$?
  test -n "$gztmpdir" && rm -fr "$gztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

if type mktemp >/dev/null 2>&1; then
  gztmpdir=`mktemp -dt`
else
  gztmpdir=/tmp/gztmp$$; mkdir $gztmpdir
fi || { (exit 127); exit 127; }

gztmp=$gztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$gztmp" && rm -r "$gztmp";;
*/*) gztmp=$gztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `echo X | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | gzip -cd > "$gztmp"; then
  umask $umask
  chmod 700 "$gztmp"
  (sleep 5; rm -fr "$gztmpdir") 2>/dev/null &
  "$gztmp" ${1+"$@"}; res=$?
else
  echo >&2 "Cannot decompress $0"
  (exit 127); res=127
fi; exit $res
�.o8`gpio_prj_run.sh �QMk�0>�_�.����uZk���(K��m�2ٿ_����0�������表�A�� ����U4c�1��T߄�Thm�Y�����W�a-��8bJB����~��~Ru���9Ó��cF&�c�}F�c���Ä��Lo!Η��K�\�'y��d�a��\ka��<��-g���G
xm��^*[��Y.�KQ�Y�0B�3��H����5 ��caܐ�=F��#δ+��|8Z4x)6�Ku�����}�΋�����R�H�)s�ZdT�b��ExpP�A�ji �*+!�4��]������02�����YR�  