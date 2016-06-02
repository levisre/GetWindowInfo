Program FindWindowInfo;

uses Windows,SysUtils;

{Code by Levis Nickaster}

{$R Maindlg.res}

const
 ID_MAINDLG = 1001;
 ID_HANDLE  = 1002;
 ID_WINNAME = 1003;
 ID_CLASSNAME = 1004;
 ID_HANDLEHEX = 1005;
 szAppName = 'Find Window Info';
 WM_DESTROY          = $0002;
 WM_INITDIALOG       = $0110;
 WM_GETTEXT          = $000D;
 WM_GETTEXTLENGTH    = $000E;
 WM_CLOSE            = $0010;
 WM_TIMER            = $0113;
 WM_HOTKEY           = $0312;

var
  hDlg : DWORD = 0;
  mPos : TPoint;
  wLen : byte;
  dis: boolean;
  whwnd : DWORD = 0;
  hk :DWORD;
  wndName: PChar = nil;
  ClassName : PChar = nil;

function WndFunc(hwnd : HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM) : Integer; stdcall;
begin
case Msg of
 WM_INITDIALOG:
 begin
   SetWindowText(hwnd,szAppName);          //dat ten cua so
   hk := GlobalAddAtom('Man');
   RegisterHotKey(hWnd,hk,0,VK_F6);         //thiet lap phim tat F6 de bat/ tat chuc nang
   SetTimer(hwnd,1,50,nil);                 // Tao lap timer
 end;
 WM_CLOSE:
 begin
  UnregisterHotKey(hwnd,hk);                //Huy hotkey
  EndDialog(hwnd,0);                        //thoat khoi chuong trinh
 end;
 WM_DESTROY:
 begin
   PostQuitMessage(0);
 end;
 WM_TIMER:                                  //xu ly su kien timer
  begin
 FreeMemory(ClassName);                     //giai phong bo nho
  FreeMemory(wndName);
  FreeMemory(@mpos);
  FreeMemory(@whwnd);
  FreeMemory(@Wlen);
  if GetCursorPos(mPos) then                  //lay vi tri con tro chuot
  begin
    whwnd := 0;
   whwnd := WindowFromPoint(mPos);
   SetDlgItemText(hwnd,ID_HANDLE,PChar(IntToStr(whwnd)));
   SetDlgItemText(hwnd,ID_HANDLEHEX,PChar(IntToHex(whwnd,8)));
   wLen := 0;
   wLen := SendMessage(whwnd,WM_GETTEXTLENGTH,0,0);
   if wLen <> 0 then
   begin
     GetMem(wndName,wLen + 1);
    SendMessage(whwnd,WM_GETTEXT,wLen + 1, Integer(wndName));
    SetDlgItemText(hwnd,ID_WINNAME,wndName);
  //  ZeroMemory(wndName,Length(wndname));
   end else
   begin
    SetDlgItemText(hwnd,ID_WINNAME,wndName);
   end;
   GetMem(ClassName,255);
   GetClassName(whwnd,ClassName,255);
   SetDlgItemText(hwnd,ID_CLASSNAME,ClassName);
 //  ZeroMemory(ClassName,Length(ClassName));
  end;

 end;
 WM_HOTKEY:
 begin
    if not dis then KillTimer(hwnd,1)
    else SetTimer(hwnd,1,50,nil);
   if dis then dis := false else dis := true;
 end;
end;
Result := DefWindowProc(hwnd,0,0,0);
end;

begin
 hDlg := DialogBoxParam(HInstance,MAKEINTRESOURCE(ID_MAINDLG),0,@WndFunc,0);
end.




