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
��J`fpga_run.sh �X�s�H����������$w�*�α�C�c( �V���A`�bF53�a��_��MlCRK�h�5ݿ~���?gܟ�r������(��F�}��|�\|��{=Ǚ�F�`|6�~��]�r�~||�&�t0��"�~g�� UTڳ���l������7��/׽Yp>����T��׸��(넂/,����F�$��P*���Ҩ�c��zt���αQ6�>o29�3�)����u���˔��m4GK;·�,�^�$|B;s��+O����z��h߫�[����j0�ھ���`r�H$u����Yp~y�����Ø(�/�%	ք�%���q�dy>L�d�K-�?�Ǿ�:#��>;H~L�
}v{�!��bd�m�n� C���V'�J,�1�'I�|�ɶ����L>������x+�/;:D���pE�`(<S`
$%���^�o�PL�u��?�
�J�����i�p%�H)�)�@�Dn�M+��M�.2|e�Y0c��k�����#��PZ�BHPjZ��(���#��^�����<��(����O5M�{
��&�RD.���p$�$U�y	�֮w�B�0i䖷.R��u�Vͩx &��2�D3�{/m�m�<�H>��$a"�B�� ��&YX]S� =djDL�І��ëU�T	hO!L*�^��8V�ȼd�O���02b|iTY6N��s^��C���P��S=���ڗ��ͅ���8���<�7��Gڿ��+��ϭ�M�Ub�\h q,idlD�stE�,`�8�DQC�	�lE�@ۢ'׈�5�+�+A7Z�h�d������qҒr�T�Nb�oCmi�o�b�q�55�����������wny�;�_�����<�K�p! �K6�q."�JS�q��P��zu��諽ҸHJ�0��&_����Gt�.��X��'�8~�p�כoXv�kQ�L�,v�7Yc� ]�嘶�ps@7����	�+,^]�О��N�$�6	˄+��<���V
6L�İ&�q���XdN�"+M�ٔ��W�:zQ�/���7���>/Ym�'(r��b�R ̰�\Kth?2h�M�9^5[��"�C����	R���5NJO���41�p�C#��R�w�8|�ƍ��3�	r�R��W�g�eq<�_�ә���H�ܜ��X�g��)B�S�GtS�5�[fN�n�dOtZ͓���l�V�Q\�m���{��ʠU���t˄��R�߅Hy��7J~SC�����"��Yh"���H�ݷ~��o�2O�L���z�e܁� ��T�Ta;�������C-�W�~�-���ƍ1"!��1�2
���FI���;��J`�>���Jӥ(k����*i�)�.|}�}�v�8���|`���]�Œ�J���e:���?\Ka�޾�8sI�8��L���hl�D|v��m~9�W&�����i���]w?W��s3S5'^���w����pT�k�Fޚ��^s���D�����M
�;��%��b`yʨl>�nʫ�B7���K�v��
�%K�.�%�v��
y�:6����p8o��-���n����oh?fFy���Ū�ttV��9p�q��1�' x tONaJ56�<�+D����NBK�ҔcC|M��m���.'=[U�UE)ԕ�G)��l�5le�o=��j�lb�VJ��*L˩�VW����i.ueχ��aw�� ����4��[7�0��W�e�%���£r9@'Ƕ�a���ů�pdƏ�A�6u�)����a^�WCwi���ZsZ���L��X�b@¨�ի��^͈��,_;K�=�z{
�$�q���l���qO	5��Z�2c�%�e�yivvY&L�����1a��^;�!�p��cQ�c��F�Qp����V6B;+�z\�	���a���bw�uk�uˇYО��1Ɏť��9�kv��Tq9������axk����v�of�Ӫ��5搄LX�!��D3���`,k��������~�y)�]�C��^������v?*�z�C 
�bP����دD�v�}��!���+���˓  