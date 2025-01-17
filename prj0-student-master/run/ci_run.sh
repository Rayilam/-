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
��I`ci_run.sh �R�n�0=��bJsm=��V� !!��H=T(�$vb��-�l��_� %+)�<��f�ͻ����i��"d�ؤ��r����(��L8���$�i��j��F��!c3Zϧ�t�<I������0Bf��t2��w��4�h-��t�5�̄C�0��UHfDQ2��>�̵����[�KK��k���cw������B�!��W,���I�B2âpU8ie�S�!>�����Y�W���`y��75F�!�xB4��9�<������a@���$���cC8� ���(��P�mT�q��/#:M�d
MAr}1O�]6�${��ۦ�*EN��}���n���=���wLv�9:�+�H؆{�Ӓ9V\ѥw[��!,q_�UgQ��*�t�����$z
vx�ȟ �n�?��{�����G��"����  