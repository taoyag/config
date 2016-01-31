if v:version < 700 || &cp
  finish
endif
scriptencoding cp932
let g:QFixHowmMenuList = [
 \ '= >>> %menu%',
 \ '��̃t�@�C�������ɃJ�[�\�������킹��<CR>�ŁA�t�@�C���ҏW�\�ł��B',
 \ '�ۑ����Ɏ����������ő}�����ꂽ���Ȃ��ꍇ�� g,w �ŕۑ����ĉ������B',
 \ '',
 \ '-------------------------------------',
 \ '%"q"[�I��] %"i"[�v���r���[] %","[menu�X�V(,)] %"r,"[Menu�ŐV(r,)] %"I"[Help(H)]',
 \ '-------------------------------------',
 \ '%"."[�V�K(c)] %"u"[QMem(u)] %" "[���L(<Space>)] %"A"[���L�ꗗ(A)]',
 \ '%"m"[MRU(m)]  %"o"[�ŋ�(l)] %"O"[�ŋ�(L)] %"a"[�ꗗ(a)] %"ra"[�����ꗗ(ra)]',
 \ '%"s"[�Œ�(s)] %"S"[���K(g)] %"R"[�t�@�C���ꗗ(rA)] %"rr"[�����_��(rr)]',
 \ '%"<Tab>"[�\��(y)] %"t"[todo(t)] %"ry"[�\��ŐV(ry)]  %"rt"[Todo�ŐV(rt)]',
 \ '���r���h (%"rk"[�L�[���[�h(rk)] %"rR"[�����_��(rR)]) %"rN"[���l�[��(rN)]',
 \ '-------------------------------------',
 \ '�{�^���̓J�[�\�������킹��<CR>���_�u���N���b�N�A�V���[�g�J�b�g�L�[�Ŏ��s���܂��B',
 \ 'menu�X�V��menu�ŐV�̍��̓L���b�V���𖳌������ċ����Č������邩�ǂ����ł��B',
 \ '�܂�18<CR> �Ȃ�18�s�ڂɈړ����Ă���<CR>���������̂Ɠ���������s���܂��B',
 \ '���̎�18�s�ڂ� howm:// �Ŏn�܂��Ă���Ȃ�Ή�����t�@�C�����J�����ɂȂ�܂��B',
 \ '',
 \ '-------------------------------------',
 \ '[�\��ETODO]',
 \ '%reminder',
 \ '-------------------------------------',
 \ '�ŋ߂̃���',
 \ '%recent',
 \ '-------------------------------------',
 \ '�����_���Z���N�g',
 \ '%random',
 \ '-------------------------------------',
 \ '',
 \ '* menu�̃I�v�V�����w��',
 \ '  "���j���[��ʂ̃v���r���[("i"��On/Off)',
 \ '  let QFixHowm_MenuPreview = 1',
 \ '  "���j���[��ʂŕ\������ŋ߂̃����̐�',
 \ '  let QFixHowm_MenuRecent = 5',
 \ '',
 \ '���j���[��ʃt�@�C���͉����ɂ����Ă������N�쐬�̑ΏۂɂȂ�̂ŁAWiki�X�^�C�������N�Ȃǂ��`���Ă����ƕ֗���������܂���B',
 \ '���̑��͕��ʂ�howm�t�@�C���Ɠ��l�̋@�\���g�p�\�ł��B',
 \ '']
let g:QFixHowmHelpList = [
 \ '-------------------------------------',
 \ '����ڎ�',
 \ '',
 \ 'howm�̓���L�@<|> $:/howm�̓���L�@<CR>:noh<CR>z<CR>',
 \ 'howm�R�}���h <|> $:/howm�R�}���h<CR>:noh<CR>z<CR>',
 \ 'howm�o�b�t�@���[�J���R�}���h <|> $:/howm�o�b�t�@���[�J��<CR>:noh<CR>z<CR>',
 \ 'grep�R�}���h <|> $:/grep�R�}���h<CR>:noh<CR>z<CR>',
 \ 'Quickfix�E�B���h�E�ł̑��� <|> $:/Quickfix�E�B���h�E�ł̑���<CR>:noh<CR>z<CR>',
 \ '�A�N�V�������b�N <|> $:/�A�N�V�������b�N<CR>:noh<CR>z<CR>',
 \ '�\��ETODO �̏��� <|> $:/�\��ETODO�̏���<CR>:noh<CR>z<CR>',
 \ '�\��ETODO�̌J��Ԃ� <|> $:/�\��ETODO�̌J��Ԃ�<CR>:noh<CR>z<CR>',
 \ '',
 \ '-------------------------------------',
 \ '= howm�̓���L�@',
 \ '',
 \ '�s���� QFixHowm_Title(�f�t�H���g�� = )���g�p����ƃ^�C�g���s�ɂȂ�܂��B',
 \ '',
 \ '== goto�����N >>>',
 \ '>>> �������[�h',
 \ 'goto�����N�ȍ~�̌������[�h���������܂��B',
 \ '�t�@�C����URI���w�肵���ꍇ�́Avim���u���E�U���̓K�؂ȃv���O�����ŊJ����܂��B',
 \ '',
 \ '== come-from�����N <<<',
 \ '<<< come-from�������[�h',
 \ '�w�蕔���������L�[���[�h������܂��B',
 \ '�������ɂ͂��̍s����Ɉ�ԏ�ɕ\�������̂ŁA�L�[���[�h�ɂ��Ă̐��������ȂǂɎg�p���܂��B',
 \ '',
 \ '== Wiki�X�^�C�������N [[ ]]',
 \ '[[�������[�h]]',
 \ '�w�蕔���������L�[���[�h������܂��B',
 \ '',
 \ '== �t�@�C����URL�̃����N [ :]',
 \ '������URI��t�@�C���A�h���X�����̂܂܏����Ǝ����I�Ƀ����N�ɂȂ�܂��B',
 \ '�󔒂���{����܂ޏꍇ�� [c:/temp/�R�s�[ �` 001.jpg:]�̂悤�� [ �� :] �ň͂ނƃ����N�ɂȂ�܂��B',
 \ '',
 \ '== howm://',
 \ 'howm://���g�p�����howm_dir����ɂ��ăt�@�C���w�肪�\�ł��B',
 \ '(��) howm://test.howm �� howm_dir �� c:/temp/howm �̂Ƃ� c:/temp/howm/test.howm �Ƃ��Ĉ����܂��B',
 \ '���l�� rel:// �� QFixHowm_RelPath ����Ɉ����܂��B',
 \ '',
 \ '-------------------------------------',
 \ '= howm�R�}���h',
 \ '���ۂ̃R�}���h�� g,c �̂悤�ɃL�[�}�b�v���[�_�[���t������܂�',
 \ '',
 \ '  ,c       : �V�K�t�@�C�����쐬',
 \ '  ,C       : �V�K�t�@�C�����t�@�C�����w��ō쐬',
 \ '  ,u       : �N�C�b�N�����t�@�C�����J��',
 \ '  ,<Space> : ���L������',
 \ '  ,j       : ���o�b�t�@�̃t�@�C���Ƒ΂ɂȂ� �y�A�����Nhowm�t�@�C�����J��',
 \ '             (���o�b�t�@�� qfixhowm.cpp ��ҏW���Ă����ꍇ qfixhowm.cpp.howm���J���܂�)',
 \ '',
 \ '  ,l       : �ŋߍX�V�����G���g���̌���(�f�t�H���g�ł͉ߋ�5����)',
 \ '  ,L       : �ŋ�"�쐬"�����G���g���̌���(�f�t�H���g����������,l�Ƌ��p)',
 \ '             ���ۂɂ�howm�^�C���X�^���v�̓��t����������',
 \ '  ,m       : howm�t�@�C����p��MRU���X�g',
 \ '  ,rm      : howm��MRU���X�g���瑶�݂��Ȃ��G���g�����폜',
 \ '',
 \ '  ,s       : �G���g���𐳋K�\�����g��Ȃ��Ō���',
 \ '  ,g       : �G���g����grep',
 \ '  ,\g      : �G���g����grep�̐ݒ�ɂ�����炸vimgrep�g�p��grep',
 \ '  ,a       : �S�G���g���ꗗ',
 \ '  ,ra      : �S�G���g���ꗗ(������)',
 \ '  ,A       : ���L�G���g���ꗗ',
 \ '  ,rA      : �S�t�@�C���ꗗ',
 \ '  ,rr      : �����_���\��',
 \ '  ,rR      : �����_���\���p�̃G���g�����X�g�t�@�C�������r���h',
 \ '',
 \ '  ,hf      : ���o�b�t�@�̃t�@�C������p�R�}���h�œ\��t���\�Ȃ悤�ɖ������W�X�^�ɐݒ肷��',
 \ '             �t�@�C�����͉\�Ȃ� howm:// �`���ɕϊ������',
 \ '  ,i       : �T�C�h�o�[���J��',
 \ '  ,k       : �ۑ�����Quickfix�E�B���h�E��ǂݍ���',
 \ '  ,rn      : ���o�b�t�@�̃t�@�C���������l�[��',
 \ '  ,rN      : howm_dir���̃t�@�C�������^�C�g���s���琶�����ă��l�[��',
 \ '             ���s����ƃ��X�g���\�������̂ŁA�m�F�ƕҏW���s������ ! �ňꊇ�ϊ����s��',
 \ '  ,rk      : �����N�L�[���[�h�t�@�C�������r���h',
 \ '',
 \ '== �\��ETODO (�O���[�o��)',
 \ '',
 \ '  ,y       : �\��̕\��',
 \ '  ,t       : TODO�̕\��',
 \ '',
 \ '-------------------------------------',
 \ '= howm�o�b�t�@���[�J���ȃR�}���h',
 \ '',
 \ '  ,w       : howm�^�C���X�^���v��ύX���Ȃ��ŕۑ�',
 \ '',
 \ '  ,d       : ���ݓ��t��}��',
 \ '  ,T       : ���ݎ�����}��',
 \ '',
 \ '  ,n       : ���G���g���̎��ɐV�K�G���g����ǉ�',
 \ '  ,N       : ���o�b�t�@�̍Ō�ɐV�K�G���g����ǉ�',
 \ '  ,p       : ���G���g���̑O�ɐV�K�G���g����ǉ�',
 \ '  ,P       : ���o�b�t�@�̐擪�ɐV�K�G���g����ǉ�',
 \ '',
 \ '  ,o       : �A�E�g���C�����[�h',
 \ '  ,rd      : �\��ETODO�̒�`�s�Ŏ��s����ƁA�w��J�E���g���̗\��ETODO�ɓW�J',
 \ '',
 \ '  ,S       : ���݈ʒu�̃G���g���̍X�V�������X�V',
 \ '  ,W       : ��t�@�C������������A���\���𕪊����ĕۑ��B',
 \ '             �t�@�C���� howm_dir �֍쐬�����B',
 \ '  ,x       : ���݈ʒu�̃G���g�����폜',
 \ '  ,X       : ���݈ʒu�̃G���g����V�K�t�@�C���ֈړ�',
 \ '  ,rs      : ���o�b�t�@�̃G���g����howm�^�C���X�^���v�̐V�������ԂŃ\�[�g',
 \ '  ,rS      : ���o�b�t�@�̃G���g����howm�^�C���X�^���v�̌Â����ԂŃ\�[�g',
 \ '',
 \ '-------------------------------------',
 \ '= grep�R�}���h (�O���[�o��)',
 \ '',
 \ '  ,f       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g���ŌŒ蕶���񌟍�',
 \ '  ,e       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g����grep',
 \ '  ,v       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g����vimgrep',
 \ '  ,b       : ���݊J���Ă���S�Ẵo�b�t�@��Ώۂ�grep',
 \ '',
 \ '  �ċA����',
 \ '  ,rf       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g���ŌŒ蕶���񌟍�',
 \ '  ,re       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g����grep',
 \ '  ,rv       : ���ҏW�o�b�t�@�Ɠ����f�B���N�g����vimgrep',
 \ '',
 \ '  �R�}���h���C��',
 \ '  :Grep ���������� *.txt',
 \ '  (�󔒂��܂ތ��������� "�� ���܂ތ���"�̂悤��""���g�p����)',
 \ '',
 \ '  Grep   ���K�\������',
 \ '  FGrep  �Œ蕶���񌟍�',
 \ '  RGrep  �ċA����',
 \ '  RFGrep �ċA����',
 \ '  BGrep  �o�b�t�@�Ώۂ�vimgrep',
 \ '',
 \ '-------------------------------------',
 \ '= Quickfix�E�B���h�E�ł̑���',
 \ '',
 \ '  <C-w>,   : Quickfix�E�B���h�E�̃I�[�v��/�N���[�Y',
 \ '  <C-w>.   : Quickfix�E�B���h�E�ֈړ�',
 \ '   q       : Quickfix�E�B���h�E�̃N���[�Y',
 \ '',
 \ '  <CR>     : �t�@�C�����J��',
 \ '  <S-CR>   : <CR> �Ƃ͈قȂ���@�Ńt�@�C�����J��',
 \ '',
 \ '   s       : �w�蕶������܂ލs�ɍi�荞��',
 \ '   r       : �w�蕶������܂܂Ȃ��s�ɍi�荞��',
 \ '   u       : �A���h�D',
 \ '   U       : �S�ăA���h�D',
 \ '   S       : �\�[�g�ؑ�',
 \ '   #       : �������ʂ̓���G���g���̂��͈̂�ɂ܂Ƃ߂�B',
 \ '   %       : �������ʂ̃T�}���[���G���g���^�C�g���ɂ���B',
 \ '',
 \ '   J       : �W�����v���Quickfix�E�B���h�E�����/���Ȃ�',
 \ '   i       : �v���r���[�\��ON/OFF',
 \ '   I       : �t�@�C���^�C�v�̃n�C���C�g�\��ON/OFF',
 \ '  <C-h>    : �n�C�X�s�[�h�v���r���[ON/OFF',
 \ '',
 \ '   A       : Quickfix�E�B���h�E��ۑ�',
 \ '   O       : Quickfix�E�B���h�E��ǂݍ���',
 \ '  ,w       : Quickfix�E�B���h�E��ۑ�',
 \ '             �L�[�}�b�v���[�_�[�� g �̏ꍇ�A���ۂ̃R�}���h�� g,w',
 \ '  ,k       : Quickfix�E�B���h�E��ǂݍ��� (�O���[�o���R�}���h)',
 \ '             �L�[�}�b�v���[�_�[�� g �̏ꍇ�A���ۂ̃R�}���h�� g,k',
 \ '',
 \ '   @       : �\����(�I��)�̃t�@�C����A���\��',
 \ '   &       : �\����(�I��)�̃t�@�C�������[�U�[�R�}���h�ŕϊ�',
 \ '             howm2html.vim(HTML�ɕϊ��\��)�Ȃǂ̑Ή��v���O�C�����K�v',
 \ '   !       : �Ή��v���O�C�����L��ꍇ�A�\��ETODO���G�N�X�|�[�g',
 \ '  <F5>     : �����_���\��',
 \ '',
 \ '   R       : (�I�𒆂�)�t�@�C���� howm_dir �ֈړ�',
 \ '   D       : (�I�𒆂�)�t�@�C�����폜',
 \ '   x       : �G���g�����폜',
 \ '   X       : �G���g����V�K�t�@�C���ֈړ�',
 \ '',
 \ '(�L�[�}�b�v���[�_�[�� g �̏ꍇ)',
 \ '  g.       : �\��ETODO�\���ŁA���ݓ��t�̍s�ֈړ�',
 \ '',
 \ '(Quickfix�E�B���h�E�̕ҏW)',
 \ '   dd      : �폜',
 \ '   p       : �\��t��',
 \ '   P       : �\��t��',
 \ '   d       : �폜(�r�W���A�����[�h)',
 \ '',
 \ '-------------------------------------',
 \ '= �A�N�V�������b�N',
 \ '',
 \ '���t�ύX',
 \ '���t�����ɃJ�[�\�������킹��<CR>�������ƁA���t��ύX�ł��܂��B',
 \ '',
 \ '1-31, .      : �w��̓��t�ɕύX(.�Ȃ獡��)',
 \ '0-031,32-999 : �����̓��t�ɓ��͒l�𑫂������t�ɕύX',
 \ 'mmdd         : �ύX������������4���̐��l�œ���',
 \ 'yymmdd       : �ύX�������N������6���̐��l�œ���',
 \ 'yyyymmdd     : �ύX�������N������8���̐��l�œ���',
 \ '',
 \ '{ } �ɃJ�[�\�������킹��<CR>�������ƁA�ȉ��̏��Ƀ��[�v���ĕω����܂��B',
 \ '{ } �� {*} �� {-}',
 \ '',
 \ '{_} �ɃJ�[�\�������킹��<CR>�������ƁA���ݎ����̑Ώ��ϗ\��ɕω����܂��B',
 \ '{_} �� [2009-01-01 01:01].',
 \ '',
 \ '-------------------------------------',
 \ '= �\��ETODO�̏���',
 \ '',
 \ '[2009-01-01]@   �\��',
 \ '[2009-01-01]+7  TODO',
 \ '[2009-01-01]!7  ���ߐ؂�',
 \ '[2009-01-01]-1  ���}�C���_',
 \ '[2009-01-01]~30 ����TODO',
 \ '[2009-01-01]�D   �Ώ���',
 \ '(�L���̌�̐����̓f�t�H���g�l�A�ȗ���)',
 \ '',
 \ '@ �\��',
 \ '���t�����̂܂܁A�D��x�ɂȂ�܂��B',
 \ '',
 \ '! ���ߐ؂� (�f�t�H���g�l 7��)',
 \ '���ߐ؂�7���O(�f�t�H���g�̏ꍇ)����\�������悤�ɂȂ�܂��B',
 \ '�����ʂ�A���ߐ؂��[���ȂǂɎg�p���܂��B',
 \ '',
 \ '+ TODO (�f�t�H���g�l 7��)',
 \ '�w�������7����(�f�t�H���g�̏ꍇ)���炢�܂ł̊ԂɎ��s����������o�^���܂��B',
 \ '',
 \ '- ���}�C���_ (�f�t�H���g�l 1��)',
 \ '�C�ɂȂ邯��ǁA�������ǂ������߂Ă��Ȃ��{�̔������ȂǁA���Ȃ��Ă����܂�Ȃ��悤�Ȋo��������o�^���܂��B',
 \ '�w�������1��(�f�t�H���g�̏ꍇ)�̊Ԃ͗D��x0���ɐݒ肳��A�D��x�������鎖�͂���܂���B',
 \ '',
 \ '~ ����TODO (�f�t�H���g�l 30 ��)',
 \ '�K���ɗD��x���ς��̂ŁA������낤�Ǝv���Ă��鎖�Ȃǂ�o�^���܂��B',
 \ '',
 \ '. �Ώ���',
 \ '�Ώ��ς݂ŕs�v�ɂȂ����\���TODO�Ɏg�p���Ă��������B',
 \ '',
 \ '-------------------------------------',
 \ '= �\��ETODO�̌J��Ԃ�',
 \ '�\��ETODO�̌J��Ԃ��ɂ� @!+-~ ���g���A���l�I�v�V�������w��\�ł��B',
 \ '���t�ȊO�̗\��ETODO�̒�`�����̓A�N�V�������b�N�ɂȂ��Ă��܂��B',
 \ '',
 \ '[2009-01-10]@ 2009�N1��10���͕�����̓�',
 \ '[2009-01-10]@@ 2009�N1��10������A����10���͕�����̓�',
 \ '[2009-01-10]@@@ 2009�N1��10������A���N1��10���͕�����̓�',
 \ '[2009-01-10]@(7) 2009�N1��10������A7��������(���T�y�j��)������̓�',
 \ '',
 \ '�\��ETODO�͎w��j���őO��ɂ��点�܂��B',
 \ '���̂悤��+-��()�̒��̗j���w��q�ŁA���̓����w��j���Ȃ�O��ɂ��炵�܂��B',
 \ '(-Hdy)�Ȃ�x���łȂ����O�̓��ɂȂ�܂��B',
 \ '',
 \ '[2009-01-10]+++(+Mon)',
 \ '[2009-01-10]@(7-Sun)',
 \ '',
 \ '(1*Sat)�̂悤�� * ���g���Ɩ���/���N�̓���j���̗\�肪�g�p�ł��܂��B',
 \ '(3*Wed) �Ȃ��3���j�ł��B',
 \ '',
 \ '[2008-01-10]+++(1*Mon)',
 \ '[2009-01-10]@@(2*Sun)',
 \ '',
 \ '==  �J��Ԃ��\��ETODO�̓W�J',
 \ '�܂��J��Ԃ��\��s�� 3g,rd�̂悤�ɃR�}���h�����s����ƁA�P���\��ɓW�J�ł��܂��B',
 \ '']