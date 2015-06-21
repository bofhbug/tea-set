-- http://forum.farmanager.com/viewtopic.php?p=126589#p126589
-----------------------------------------------------------------------------------------
-- Panel.VisualCompare, v1.3, (c) 2014, LanKing.  
-- ��������� ������ � ������� ������� Visual Compare � ���������� Branch ������� 
 
-- ������ �������� ����������� ������� ������� �� AleXH, ������������� LanKing
-- ��������� ��������� ����, ��������� �������������� ������� � ���������� �� ����������  
-- � ���������� ����� �������������� ��������� SimSU (�����������)


-- �������� ������:
-- 1. �� �������� ������ �������� 2 ����� ��� 2 ���������� - �������� ��
-- 2. �� ����� ������� �������� �� 1 ����� - �������� ��
-- 3. ���� ������: ������ �� ����� ������� �� ������: ���� ���� �� ����������, �������� ��; 
-- 4. ���� � ���������� ������ ���� ���������� -- ��������� ���� �������;

-- ����� ���� ���������� �������� ���� � �����, ��� ����������: ����� �������� ��������� 
-- �� ������ � ������������ ������������ ������� Visual Compare
 
-----------------------------------------------------------------------------------------


---- �����������
_G.far.lang=far.lang or win.GetEnv("farlang")

-- ���������� ����� / Buildin laguages
local function Messages()

    if far.lang=="Russian" then return{
    	Description="Visual Compare: ��������� 2 ���������� ������ �� �������� ������; 1 �� �������� � 1 �� ���������; ���� ��� �������� �� �������� � �� ���������";
      	MsgSameFiles="Visual Compare: ���������� ���������� �������.";
      	MsgStandartDlg = '��������� ����������� ������ ���������?';
      	MsgDifferent="Visual Compare: ���������� �������� ���� � �����";
    }
    else return{
    	Description="Visual Compare: 2 selected files on active panel OR 1 selected file on active panel and 1 selected file on passive panel or current files on both panels";
      	MsgSameFiles="Visual Compare: Objects are equal.";
      	MsgStandartDlg = 'Start standart compare dialog?';
      	MsgDifferent="Visual Compare: Can't compare file and folder";
    }
    end;
end;

local M=Messages();


local VisComp = "AF4DAB38-C00A-4653-900E-7A8230308010"

Macro {
 description=M.Description; area="Shell Tree"; key="Ctrl/";
action = function()

  -- Can't compare file and folder message 
  local function badattr(f1, f2)
    if msgbox(M.MsgDifferent, "\n"..f1.."\n"..f2.."\n\n"..M.MsgStandartDlg.."\n\n", 0x00040000)==1 then Plugin.Menu(VisComp) end;
  	return false;
  end;

  local AP,PP,AC,PC,fn,attrChecked = APanel.Path0,PPanel.Path0,APanel.Current,PPanel.Current,"",false

  -- 2 files on active panel
  if APanel.SelCount == 2 then
    PP,AC,PC = AP,panel.GetSelectedPanelItem(nil,1,1),panel.GetSelectedPanelItem(nil,1,2)
    
    if mf.index(AC.FileAttributes, 'd')~=mf.index(PC.FileAttributes, 'd') then return badattr(AC.FileName,PC.FileName,true); end;
    AC,PC,attrChecked = AC.FileName,PC.FileName,true

  -- selected one file on active and one on passive
  elseif APanel.SelCount == 1 and PPanel.SelCount == 1 then
    AC,PC = panel.GetSelectedPanelItem(nil,1,1),panel.GetSelectedPanelItem(nil,0,1)

    if mf.index(AC.FileAttributes, 'd')~=mf.index(PC.FileAttributes, 'd') then return badattr(AC.FileName,PC.FileName,true); end;
    AC,PC,attrChecked = AC.FileName,PC.FileName,true

  end
  
  if AC:match("^[A-Z]:") then AP=AC elseif AP == "" then AP="\\" elseif AC ~= ".." then AP=AP.."\\"..AC end
  if PC:match("^[A-Z]:") then PP=PC elseif PP == "" then PP="\\" elseif PC ~= ".." then PP=PP.."\\"..PC end -- ��� ����� ���� ������� ��� ..

  if (not attrChecked and not APanel.Folder==PPanel.Folder) then return badattr(AP, PP); end;
  
  if AP == PP then
    if msgbox(M.MsgSameFiles, "\n"..AP.."\n\n"..M.MsgStandartDlg.."\n\n", 0x00040000)==1 then Plugin.Menu(VisComp) end;
  else
    if (APanel.SelCount ~= 2 and not APanel.Left) then fn=PP..'" "'..AP else fn=AP..'" "'..PP end
    Plugin.Command(VisComp,'"'..fn..'"')
  end
end
}