
-- Modification of the original script taken from:
-- https://code.google.com/p/farmanager/source/browse/trunk/addons/Macros/View.PgDn.lua

--[[

"�����" ��������� � ������� PgDn. ��� ��������� �������� PgDn �� 
���������� ����� ����� �� ������ ������������ ��� ��������� ������ ����� � 
������������ � ������� ������� ���� Far Manager. 

]]

Macro {
	area = "Viewer QView";
	key = "PgDn";
	description = "Viewer: Smart scrolling using PgDn";
	action = function()
		Keys("PgDn");
		if Object.Eof then
			Keys('End')
		end
	end;
}
